/datum/disease
	var/name = "A disease"
	var/desc = ""
	var/spread_text = ""
	var/cure_text = ""

	// Stages
	/// Current stage
	var/stage = 1
	/// Max stages
	var/max_stages = 0
	/// The probability of this infection advancing a stage every second the cure is not present.
	var/stage_prob = 2
	/// How long this infection incubates (non-visible) before revealing itself
	var/incubation_time
	/// Has the disease hit its limit?
	var/stage_peaked = FALSE
	/// How many cycles has the disease been at its peak?
	var/peaked_cycles = 0
	/// How many cycles do we need to have been active after hitting our max stage to start rolling back?
	var/cycles_to_beat = 0
	/// Number of cycles we've prevented symptoms from appearing
	var/symptom_offsets = 0
	/// Number of cycles we've benefited from chemical or other non-resting symptom protection
	var/chemical_offsets = 0

	// Flags see _DEFINES/disease.dm
	/// Flags effecting how this disease can be detected
	var/visibility_flags = NONE
	/// Flags for disease behaviour
	var/disease_flags = CURABLE | CAN_CARRY | CAN_RESIST
	/// Methods of spread of this disease
	var/spread_flags = DISEASE_SPREAD_AIRBORNE | DISEASE_SPREAD_CONTACT_FLUIDS | DISEASE_SPREAD_CONTACT_SKIN

	/// Typecache of viable mob types
	var/list/viable_mobtypes = list(/mob/living/carbon/human)
	/// List of cures if the disease has the CURABLE flag, these are reagent ids
	var/list/reagent_cures = list()
	/// If the disease requires all reagent cures
	var/needs_all_reagent_cures = FALSE

	/// The probability of spreading through the air every second
	var/infectivity = 41
	/// The probability of this infection being cured every second the cure is present
	var/cure_chance = 4

	/// Current holder of this disease
	var/mob/living/carbon/affected_mob = null
	/// Is the host a carrier
	var/carrier = FALSE
	/// Does it skip species disease immunity check? Some things may diseases and not viruses
	var/bypasses_immunity = FALSE
	/// Severity of the disease
	var/severity = DISEASE_SEVERITY_NONTHREAT
	/// If the disease requires an organ for the effects to function, robotic organs are immune to disease unless inorganic biology symptom is present
	var/obj/item/organ/required_organ = null
	/// Mob bioflags viable to spread to
	var/infectable_biotypes = MOB_ORGANIC
	/// Process on dead hosts
	var/process_dead = FALSE
	/// Modifier to spreading chance
	var/spreading_modifier = 1
	/// List of humors associated with this disease
	var/list/humors = list()

/datum/disease/New()
	viable_mobtypes = typecacheof(viable_mobtypes)

/datum/disease/Destroy()
	. = ..()
	if(affected_mob)
		remove_disease()

/// Returns a string for admin logging uses, should describe the disease in detail
/datum/disease/proc/admin_details()
	return "[name] : [type]"

/datum/disease/proc/is_same(datum/disease/disease)
	return istype(disease, type)

/datum/disease/proc/get_disease_id()
	return "[type]"

/// Check if its possible to infect this host
/datum/disease/proc/can_infect(mob/living/infectee)
	if(infectee.stat == DEAD && !process_dead)
		return FALSE

	if(!is_viable_mobtype(infectee))
		return FALSE

	if(infectee.has_disease(src))
		return FALSE

	if(get_disease_id() in infectee.disease_resistances)
		return FALSE

	if(!(infectable_biotypes & infectee.mob_biotypes))
		return FALSE

	if(required_organ && !has_required_infectious_organ(infectee, required_organ))
		return FALSE

	return TRUE

// Infect a host with our disease
/datum/disease/proc/infect(mob/living/infectee)
	LAZYADD(infectee.diseases, src)
	affected_mob = infectee

	log_virus("[key_name(infectee)] was infected by disease: [admin_details()] at [loc_name(get_turf(infectee))]")

	after_add()

	register_disease_signals()

	return TRUE

/datum/disease/proc/after_add()
	return

/datum/disease/proc/cure(add_resistance = TRUE, force = FALSE)
	if(!force && disease_flags & UNCURABLE) //aw man :(
		return

	if(affected_mob)
		if(add_resistance && (disease_flags & CAN_RESIST))
			LAZYOR(affected_mob.disease_resistances, get_disease_id())

		if(affected_mob.ckey)
			log_virus("[key_name(affected_mob)] was cured of disease: [admin_details()] at [loc_name(get_turf(affected_mob))]")

	qdel(src)

/datum/disease/proc/remove_disease()
	unregister_disease_signals()
	LAZYREMOVE(affected_mob.diseases, src) //remove the datum from the list
	affected_mob = null

/// Updates the spread flags set, ensuring signals are updated as necessary
/datum/disease/proc/update_spread_flags(new_flags)
	if(spread_flags == new_flags)
		return

	spread_flags = new_flags
	unregister_disease_signals()
	register_disease_signals()

/// Register any relevant signals for the disease
/datum/disease/proc/register_disease_signals()
	if(QDELETED(affected_mob))
		return

	if(spread_flags & DISEASE_SPREAD_AIRBORNE)
		RegisterSignal(affected_mob, COMSIG_CARBON_PRE_BREATHE, PROC_REF(on_breath))

/// Unregister any relevant signals for the disease
/datum/disease/proc/unregister_disease_signals()
	if(QDELETED(affected_mob))
		return

	UnregisterSignal(affected_mob, COMSIG_CARBON_PRE_BREATHE)

///Proc to process the disease and decide on whether to advance, cure or make the symptoms appear. Returns a boolean on whether to continue acting on the symptoms or not.
/datum/disease/proc/stage_act()
	var/slowdown = HAS_TRAIT(affected_mob, TRAIT_HALE) ? 0.5 : 1
	var/recovery_prob = 0
	var/cure_mod
	var/bad_immune = HAS_TRAIT(affected_mob, TRAIT_WASTING_SICKNESS) ? 2 : 1

	if(required_organ && !has_required_infectious_organ(affected_mob, required_organ))
		cure(add_resistance = FALSE)
		return FALSE

	if(has_cure())
		cure_mod = cure_chance / bad_immune
		if(disease_flags & CHRONIC && prob(cure_mod))
			update_stage(1)
			to_chat(affected_mob, span_notice("Your chronic illness is alleviated a little, though it can't be cured!"))
			return
		if(disease_flags & CURABLE && prob(cure_mod))
			if(disease_flags & INCREMENTAL_CURE)
				if(!update_stage(stage - 1))
					return FALSE
			cure()
			return FALSE

	stage_peaked = (stage == max_stages)

	if(prob(stage_prob * slowdown * bad_immune))
		update_stage(min(stage + 1, max_stages))

	if(!(disease_flags & CHRONIC) && disease_flags & CURABLE && bypasses_immunity != TRUE)
		switch(severity)
			if(DISEASE_SEVERITY_POSITIVE) //good viruses don't go anywhere after hitting max stage - you can try to get rid of them by sleeping earlier
				cycles_to_beat = max(DISEASE_RECOVERY_SCALING, DISEASE_CYCLES_POSITIVE) //because of the way we later check for recovery_prob, we need to floor this at least equal to the scaling to avoid infinitely getting less likely to cure
				if(((HAS_TRAIT(affected_mob, TRAIT_NOHUNGER)) || ((affected_mob.nutrition > NUTRITION_LEVEL_STARVING) && (affected_mob.satiety >= 0))) && slowdown == 1) //any sort of malnourishment/immunosuppressant opens you to losing a good disease
					return TRUE
			if(DISEASE_SEVERITY_NONTHREAT)
				cycles_to_beat = max(DISEASE_RECOVERY_SCALING, DISEASE_CYCLES_NONTHREAT)
			if(DISEASE_SEVERITY_MINOR)
				cycles_to_beat = max(DISEASE_RECOVERY_SCALING, DISEASE_CYCLES_MINOR)
			if(DISEASE_SEVERITY_MEDIUM)
				cycles_to_beat = max(DISEASE_RECOVERY_SCALING, DISEASE_CYCLES_MEDIUM)
			if(DISEASE_SEVERITY_DANGEROUS)
				cycles_to_beat = max(DISEASE_RECOVERY_SCALING, DISEASE_CYCLES_DANGEROUS)
			if(DISEASE_SEVERITY_HARMFUL)
				cycles_to_beat = max(DISEASE_RECOVERY_SCALING, DISEASE_CYCLES_HARMFUL)
			if(DISEASE_SEVERITY_BIOHAZARD)
				cycles_to_beat = max(DISEASE_RECOVERY_SCALING, DISEASE_CYCLES_BIOHAZARD)
			else
				cycles_to_beat = max(DISEASE_RECOVERY_SCALING, DISEASE_CYCLES_NONTHREAT)

		peaked_cycles += stage / max_stages //every cycle we spend sick counts towards eventually curing the disease, faster at higher stages
		recovery_prob += DISEASE_RECOVERY_CONSTANT + (peaked_cycles / (cycles_to_beat / DISEASE_RECOVERY_SCALING)) //more severe viruses are beaten back more aggressively after the peak

		if(length(humors))
			recovery_prob *= tally_humor_modifiers()

		if(stage_peaked)
			recovery_prob *= DISEASE_PEAKED_RECOVERY_MULTIPLIER

		if(slowdown != 1) //using spaceacillin can help get them over the finish line to kill a disease with decreasing effect over time
			recovery_prob += clamp((((1 - slowdown) * (DISEASE_SLOWDOWN_RECOVERY_BONUS * 2)) * ((DISEASE_SLOWDOWN_RECOVERY_BONUS_DURATION - chemical_offsets) / DISEASE_SLOWDOWN_RECOVERY_BONUS_DURATION)), 0, DISEASE_SLOWDOWN_RECOVERY_BONUS)
			chemical_offsets = min(chemical_offsets + 1, DISEASE_SLOWDOWN_RECOVERY_BONUS_DURATION)

		if(!HAS_TRAIT(affected_mob, TRAIT_NOHUNGER))
			if(affected_mob.satiety < 0 || affected_mob.nutrition < NUTRITION_LEVEL_STARVING) //being malnourished makes it a lot harder to defeat your illness
				recovery_prob -= DISEASE_MALNUTRITION_RECOVERY_PENALTY
			else if(affected_mob.satiety >= 0)
				recovery_prob += round((DISEASE_SATIETY_RECOVERY_MULTIPLIER * (affected_mob.satiety/MAX_SATIETY)), 0.1)

		switch(affected_mob.stress)
			if(-INFINITY to STRESS_VGOOD)
				recovery_prob += 0.4
			if(STRESS_VGOOD to STRESS_GOOD)
				recovery_prob += 0.2
			if(STRESS_BAD to STRESS_VBAD)
				recovery_prob += -0.2
			if(STRESS_VBAD to INFINITY)
				recovery_prob += -0.4

		if((HAS_TRAIT(affected_mob, TRAIT_NOHUNGER) || !(affected_mob.satiety < 0 || affected_mob.nutrition < NUTRITION_LEVEL_STARVING)) && HAS_TRAIT(affected_mob, TRAIT_KNOCKEDOUT)) //resting starved won't help, but resting helps
			var/turf/rest_turf = get_turf(affected_mob)

			if(rest_turf.get_lumcount() <= LIGHTING_TILE_IS_DARK)
				recovery_prob += DISEASE_GOOD_SLEEPING_RECOVERY_BONUS

			// sleeping in silence is always better
			if(HAS_TRAIT(affected_mob, TRAIT_DEAF))
				recovery_prob += DISEASE_GOOD_SLEEPING_RECOVERY_BONUS

			var/atom/movable/buckled = affected_mob.buckled
			if(buckled)
				recovery_prob += DISEASE_GOOD_SLEEPING_RECOVERY_BONUS * (1 + buckled.sleepy)
			else if(locate(/obj/structure/table) in rest_turf)
				recovery_prob += (DISEASE_GOOD_SLEEPING_RECOVERY_BONUS / 2)

			// don't forget the bedsheet
			if(locate(/obj/item/bedsheet) in rest_turf)
				recovery_prob += DISEASE_GOOD_SLEEPING_RECOVERY_BONUS

			recovery_prob *= DISEASE_SLEEPING_RECOVERY_MULTIPLIER //any form of sleeping magnifies all effects a little bit

		recovery_prob = clamp(recovery_prob / bad_immune, 0, 100)

		if(recovery_prob && prob(recovery_prob))
			if(stage == 1 && prob(cure_chance * DISEASE_FINAL_CURE_CHANCE_MULTIPLIER)) //if we reduce FROM stage == 1, cure the disease - after defeating its cure_chance in a final battle
				if(HAS_TRAIT(affected_mob, TRAIT_NOHUNGER) || (affected_mob.satiety < 0 || affected_mob.nutrition < NUTRITION_LEVEL_STARVING))
					cure(add_resistance = TRUE) //stay fed and cure it at any point, you're immune
					return FALSE
				else if(stage_peaked == FALSE) //if you didn't ride out the disease from its peak, if you're malnourished when it cures, you don't get resistance
					cure(add_resistance = FALSE)
					return FALSE
				else if(prob(50)) //if you rode it out from the peak, challenge cure_chance on if you get resistance or not
					cure(add_resistance = TRUE)
					return FALSE

			update_stage(max(stage - 1, 1))

		if(HAS_TRAIT(affected_mob, TRAIT_KNOCKEDOUT) || slowdown != 1) //sleeping and using spaceacillin lets us nosell applicable disease symptoms firing with decreasing effectiveness over time
			if(prob(100 - min((100 * (symptom_offsets / DISEASE_SYMPTOM_OFFSET_DURATION)), 100 - cure_chance * DISEASE_FINAL_CURE_CHANCE_MULTIPLIER))) //viruses with higher cure_chance will ultimately be more possible to offset symptoms on
				symptom_offsets = min(symptom_offsets + 1, DISEASE_SYMPTOM_OFFSET_DURATION)
				return FALSE

	return !carrier

/// Update stage, returns current stage or STAGE_CURED if cured
/datum/disease/proc/update_stage(new_stage)
	stage = new_stage

	stage_peaked = (new_stage == max_stages)

	if(stage <= 0)
		cure()
		return DISEASE_STAGE_CURED

	return stage

/datum/disease/proc/has_cure()
	if(!(disease_flags & (CURABLE | CHRONIC)))
		return FALSE

	var/cures_expected = length(reagent_cures)

	for(var/C_id in reagent_cures)
		if(!affected_mob.reagents.has_reagent(reagent = C_id, check_subtypes = TRUE))
			cures_expected--

	if(!cures_expected || (needs_all_reagent_cures && cures_expected < length(reagent_cures)))
		return FALSE

	return TRUE

/**
 * Handles performing a spread-via-air
 *
 * Checks for stuff like "is our mouth covered" for you
 *
 * * spread_range - How far the disease can spread
 * * force_spread - If TRUE, the disease will spread regardless of the spread_flags
 * * require_facing - If TRUE, the disease will only spread if the source mob is facing the target mob
 */
/datum/disease/proc/airborne_spread(spread_range = 2, force_spread = TRUE, require_facing = FALSE)
	if(isnull(affected_mob))
		return FALSE
	if(!(spread_flags & DISEASE_SPREAD_AIRBORNE) && !force_spread)
		return FALSE
	if(affected_mob.can_spread_airborne_diseases())
		return FALSE
	if(!has_required_infectious_organ(affected_mob, ORGAN_SLOT_LUNGS)) //also if you lack lungs
		return FALSE
	if(HAS_TRAIT(affected_mob, TRAIT_HALE) || (affected_mob.satiety > 0 && prob(affected_mob.satiety / 2))) //being full or on spaceacillin makes you less likely to spread a disease
		return FALSE
	var/turf/mob_loc = affected_mob.loc
	if(!istype(mob_loc))
		return FALSE
	for(var/mob/living/carbon/to_infect in oview(spread_range, affected_mob))
		var/turf/infect_loc = to_infect.loc
		if(!istype(infect_loc))
			continue
		if(require_facing && !is_source_facing_target(affected_mob, to_infect))
			continue
		to_infect.contract_airborne_disease(src)

	return TRUE

/**
 * Checks the given typepath against the list of viable mobtypes.
 *
 * Returns TRUE if the mob_type path is derived from of any entry in the viable_mobtypes list.
 * Returns FALSE otherwise.
 *
 * Arguments:
 * * mob_type - Type path to check against the viable_mobtypes list.
 */
/datum/disease/proc/is_viable_mobtype(mob/living/infectee)
	return viable_mobtypes[infectee.type]

/// Checks if the mob has the required organ and it's not robotic or affected by inorganic biology
/datum/disease/proc/has_required_infectious_organ(mob/living/carbon/target, required_organ_slot)
	if(!iscarbon(target))
		return FALSE

	var/obj/item/organ/target_organ = target.getorganslot(required_organ_slot)

	if(!istype(target_organ))
		return FALSE

	return TRUE

/// Handles spreading via air when our mob breathes
/datum/disease/proc/on_breath(datum/source)
	SIGNAL_HANDLER

	if(prob(infectivity * 4))
		airborne_spread()

/datum/disease/proc/tally_humor_modifiers()
	if(!length(humors))
		return 1

	var/multipler = 1

	for(var/humor in humors)
		var/datum/humor/real_humor = GLOB.humor_instances[humor]
		multipler *= real_humor.get_humor_modifier()

	return multipler

//Use this to compare severities
/proc/get_disease_severity_value(severity)
	switch(severity)
		if(DISEASE_SEVERITY_POSITIVE)
			return 1
		if(DISEASE_SEVERITY_NONTHREAT)
			return 2
		if(DISEASE_SEVERITY_MINOR)
			return 3
		if(DISEASE_SEVERITY_MEDIUM)
			return 4
		if(DISEASE_SEVERITY_HARMFUL)
			return 5
		if(DISEASE_SEVERITY_DANGEROUS)
			return 6
		if(DISEASE_SEVERITY_BIOHAZARD)
			return 7
