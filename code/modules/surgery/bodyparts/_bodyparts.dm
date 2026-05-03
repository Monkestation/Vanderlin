
/obj/item/bodypart
	name = "limb"
	desc = ""
	force = 3
	throwforce = 3
	w_class = WEIGHT_CLASS_SMALL
//	sellprice = 5
	icon = 'icons/mob/human_parts.dmi'
	icon_state = ""
	layer = BELOW_MOB_LAYER //so it isn't hidden behind objects when on the floor

	germ_level = GERM_LEVEL_STERILE

	var/disinfects_in
	var/mob/living/carbon/owner
	var/mob/living/carbon/original_owner
	/// a cache of the original owner's DNA unique identifier. only gets updated from shit like changeling absorb so it carries between owners
	var/fingerprint
	var/status = BODYPART_ORGANIC

	var/static_icon = FALSE
	var/body_zone //BODY_ZONE_CHEST, BODY_ZONE_L_ARM, etc , used for def_zone
	var/aux_zone // used for hands
	var/aux_layer
	var/body_part = 0 //bitflag used to check which clothes cover this bodypart
	var/held_index = 0 //are we a hand? if so, which one!

	/// Needs to get processed on next life() tick
	var/needs_processing = FALSE

	// Cavity item + organ stuff
	/// Maximum item size to be inserted in the cavity
	var/max_cavity_item_size = WEIGHT_CLASS_NORMAL
	/// Maximum combined volume of organs and cavity items (item volume is w_class)
	var/max_cavity_volume = 2.5

	/// If disabled, limb is as good as missing
	var/bodypart_disabled = BODYPART_NOT_DISABLED
	/// Controls whether bodypart_disabled makes sense or not for this limb.
	var/can_be_disabled = FALSE
	var/body_damage_coeff = 1 //Multiplier of the limb's damage that gets applied to the mob
	var/brutestate = 0
	var/burnstate = 0
	var/brute_dam = 0
	var/burn_dam = 0
	var/max_damage = 0

	/// Our current stored wound damage multiplier
	var/damage_multiplier = 1

	/// How efficient this limb is at performing... whatever it performs
	var/limb_efficiency = 100

	var/cremation_progress = 0 //Gradually increases while burning when at full damage, destroys the limb when at 100

	var/brute_reduction = 0 //Subtracted to brute damage taken
	var/burn_reduction = 0	//Subtracted to burn damage taken

	//Coloring and proper item icon update
	var/skin_tone = ""
	var/body_gender = ""
	var/species_id = ""
	var/should_draw_gender = FALSE
	var/should_draw_greyscale = FALSE
	var/species_color = ""
	var/mutation_color = ""
	var/no_update = 0
	var/species_icon = ""
	var/should_render = TRUE

	var/animal_origin = 0 //for nonhuman bodypart (e.g. monkey)
	var/dismemberable = 1 //whether it can be dismembered with a weapon.
	// var/disableable = 1
	var/food_type = null

	var/px_x = 0
	var/px_y = 0

	var/species_flags_list = list()
	var/dmg_overlay_type //the type of damage overlay (if any) to use when this bodypart is bruised/burned.

	//Damage messages used by help_shake_act()
	var/heavy_brute_msg = "MANGLED"
	var/medium_brute_msg = "battered"
	var/light_brute_msg = "bruised"
	var/no_brute_msg = "unbruised"

	var/heavy_burn_msg = "CHARRED"
	var/medium_burn_msg = "peeling"
	var/light_burn_msg = "blistered"
	var/no_burn_msg = "unburned"

	var/add_extra = FALSE

	var/offset

	var/last_disable = 0
	var/last_crit = 0

	var/list/subtargets = list()		//these are subtargets that can be attacked with weapons (crits)
	var/list/grabtargets = list()		//these are subtargets that can be grabbed

	var/skeletonized = FALSE

	var/fingers = TRUE

	/// Visual markings to be rendered alongside the bodypart
	var/list/markings
	var/list/aux_markings
	/// Visual features of the bodypart, such as hair and accessories
	var/list/bodypart_features

	/// Non-organ and non-limb items currently inserted inside this limb
	var/list/obj/item/cavity_items

	grid_width = 32
	grid_height = 64

	resistance_flags = FLAMMABLE

	var/wound_icon_state

	var/punch_modifier = 1 // for modifying arm punching damage
	var/acid_damage_intensity = 0

	/// How damaged the limb needs to be to start taking internal organ damage
	var/organ_damage_requirement
	/// How much damage an attack needs to do, at the very least, to damage internal organs
	var/organ_damage_hit_minimum

	/// artery organ base type
	var/artery_type = /obj/item/organ/artery

	/// General bodypart flags, such as - is it necrotic, does it leave stumps behind, etc
	var/limb_flags = BODYPART_HAS_ARTERY

	/// Multiplier of the limb's pain damage that gets applied to the mob
	var/pain_damage_coeff = 1
	/// How much pain this limb is feeling
	var/pain_dam = 0
	/// Subtracted to pain the limb feels
	var/pain_reduction = 0
	/// Multiplier for incoming pain damage
	var/incoming_pain_mult = 1
	/// Amount of pain damage we heal per on_life() tick
	var/pain_heal_tick = 1
	/// How much we multiply pain_heal_tick by if the owner is lying down
	var/pain_heal_rest_multiplier = 3
	/// Point at which the limb is disabled due to pain
	var/pain_disability_threshold
	/// Maximum amount of pain this limb can feel at once
	var/max_pain_damage

	/// This stupid variable is used by two game mechanics - Brain spilling, gut spilling
	var/spilled = FALSE
	/// Represents the icon we use when spilled == TRUE
	var/spilled_overlay = "brain_busted"

	/// How many injuries we have in this bodypart - NOT always equal to the length of injuries list!
	var/number_injuries = 0
	/// The (Bay-style) wound datums currently afflicting this bodypart
	var/list/datum/injury/injuries
	/// The last injury to have afflicted this bodypart
	var/datum/injury/last_injury

/obj/item/bodypart/Initialize()
	. = ..()
	create_base_organs()
	if(isnull(max_pain_damage))
		max_pain_damage = max_damage * 1.5
	if(isnull(organ_damage_requirement))
		organ_damage_requirement = max_damage * 0.2
	if(isnull(organ_damage_hit_minimum))
		organ_damage_hit_minimum = ORGAN_MINIMUM_DAMAGE

	if(can_be_disabled)
		RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS), PROC_REF(on_paralysis_trait_gain))
		RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS), PROC_REF(on_paralysis_trait_loss))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_ROTTEN), PROC_REF(on_rotten_trait_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_ROTTEN), PROC_REF(on_rotten_trait_loss))
	update_HP()

/obj/item/bodypart/Destroy()
	if(owner)
		owner.remove_bodypart(src)
		set_owner(null)
	for(var/obj/item/I as anything in embedded_objects)
		remove_embedded_object(I)
	for(var/datum/wound/wound as anything in wounds)
		qdel(wound)
	for(var/injury in injuries)
		qdel(injury) // injuries is a lazylist, and each injury removes itself from it on deletion.
	if(LAZYLEN(injuries))
		stack_trace("[type] qdeleted with [LAZYLEN(injuries)] uncleared injuries!")
		injuries.Cut()
	if(bandage)
		QDEL_NULL(bandage)

	embedded_objects = null
	original_owner = null
	return ..()

/obj/item/bodypart/proc/create_artery()
	if(ispath(artery_type))
		var/obj/item/organ/artery = new artery_type(src)
		if(owner)
			artery.Insert(owner)
	if(islist(artery_type))
		for(var/artery_path in artery_type)
			var/obj/item/organ/artery = new artery_path(src)
			if(owner)
				artery.Insert(owner)

/obj/item/bodypart/proc/is_robotic_limb()
	return (status == BODYPART_ROBOTIC)

/obj/item/bodypart/proc/is_dead()
	return (limb_flags & BODYPART_DEAD)

/obj/item/bodypart/proc/is_deformed()
	return (limb_flags & BODYPART_DEFORMED)

/obj/item/bodypart/proc/remove_chronic()
	if(owner)
		UnregisterSignal(owner, list(COMSIG_LIVING_LIFE))

///you might wonder why this isn't in life? this saves a metric ton of time since its situational as hell
/obj/item/bodypart/proc/update_chronic()
	if(owner)
		if(CHECK_BITFIELD(limb_flags, BODYPART_CHRONIC_FRACTURE|BODYPART_CHRONIC_ARTHRITIS|BODYPART_CHRONIC_MIGRAINE))
			RegisterSignal(owner, COMSIG_LIVING_LIFE, PROC_REF(on_owner_life), override = TRUE)
	update_wounds()
	update_pain_coeff()

/obj/item/bodypart/proc/on_owner_life()
	if(CHECK_BITFIELD(limb_flags, BODYPART_CHRONIC_FRACTURE))
		on_chronic_fracture_life()
	if(CHECK_BITFIELD(limb_flags, BODYPART_CHRONIC_ARTHRITIS))
		on_arthritis_life()
	if(CHECK_BITFIELD(limb_flags, BODYPART_CHRONIC_MIGRAINE))
		on_migraine_life()

/obj/item/bodypart/proc/on_chronic_fracture_life()
	if(!prob(2))
		return
	if(owner.encumbrance >= ENCUMBRANCE_HEAVY)
		var/pain_amount = rand(8, 15)
		if(owner.encumbrance >= ENCUMBRANCE_EXTREME)
			pain_amount = rand(15, 25)
			to_chat(owner, span_warning("Your heavy gear puts severe strain on your [name]!"))
		else
			to_chat(owner, span_warning("The weight of your equipment aggravates your chronic [name] pain!"))
		add_pain(pain_amount)

/obj/item/bodypart/proc/on_arthritis_life()
	if(prob(2))
		add_pain(rand(7, 14))
		var/pain_msg = pick("Your [name] throbs with arthritic pain!",
							"A sharp ache shoots through your [name]!",
							"Your [name] feels stiff and painful!")
		to_chat(owner, span_warning(pain_msg))

	if(prob(1) && owner.loc)
		if(SSParticleWeather.runningWeather && SSParticleWeather.runningWeather.can_weather(owner))
			add_pain(rand(5, 10))
			to_chat(owner, span_warning("The weather makes your arthritis act up."))

/obj/item/bodypart/proc/on_migraine_life()
	if(prob(2))
		add_pain(rand(25, 40))

		if(prob(30))
			owner.set_eye_blur_if_lower(rand(6 SECONDS, 12 SECONDS))
			to_chat(owner, span_boldwarning("A severe migraine strikes! Your vision blurs and your head pounds!"))
		else
			to_chat(owner, span_warning("A migraine headache begins to build."))

	if(prob(1))
		if(pain_dam > 20 && owner.loc?.luminosity > 2)
			add_pain(rand(5, 10))
			to_chat(owner, span_warning("The flickering flames make your migraine worse!"))

/obj/item/bodypart/proc/update_pain_coeff()
	var/pain_power = initial(pain_damage_coeff)
	if(BODYPART_CHRONIC_NERVE_DAMAGE in limb_flags)
		pain_power += 0.25
	pain_damage_coeff = pain_power

/// Can this bodypart rot or get infected?
/obj/item/bodypart/proc/can_decay()
	if(isreagentcontainer(loc))
		return FALSE /// preserving ah.
	check_cold()
	if(CHECK_BITFIELD(limb_flags, BODYPART_FROZEN|BODYPART_DEAD|BODYPART_NO_INFECTION))
		return FALSE
	return TRUE

/obj/item/bodypart/proc/check_cold()
	var/local_temp
	if(!owner)
		//Only concern is adding an organ to a freezer when the area around it is cold.
		if(isturf(loc))
			var/turf/turf_loc = loc
			local_temp = turf_loc?.return_temperature()
		else if(ismob(loc))
			var/mob/holder = loc
			var/turf/turf_loc = holder.loc
			local_temp = turf_loc?.return_temperature()
	else
		local_temp = owner.bodytemperature

	// Shouldn't happen but just in case
	if(isnull(local_temp))
		return (limb_flags & BODYPART_FROZEN)
	//you get some leeway...
	if(local_temp < 15)
		limb_flags |= BODYPART_FROZEN
		return (limb_flags & BODYPART_FROZEN)

	limb_flags &= ~BODYPART_FROZEN
	return (limb_flags & BODYPART_FROZEN)

/**
 * update_wounds() is called whenever a wound is gained or lost on this bodypart, as well as if there's a change of some kind on a bone wound possibly changing disabled status
 *
 * Covers tabulating the damage multipliers we have from wounds (burn specifically), as well as deleting our gauze wrapping if we don't have any wounds that can use bandaging
 *
 * Arguments:
 * * replaced- If true, this is being called from the remove_wound() of a wound that's being replaced, so the bandage that already existed is still relevant, but the new wound hasn't been added yet
 */
/obj/item/bodypart/proc/update_wounds(replaced = FALSE)
	var/dam_mul = initial(damage_multiplier)

	if(BODYPART_CHRONIC_SCAR in limb_flags)
		dam_mul += 0.20
	// we can (normally) only have one wound per type, but remember there's multiple types (smites like :B:loodless can generate multiple cuts on a limb)
	for(var/datum/wound/iter_wound as anything in wounds)
		dam_mul *= iter_wound.damage_multiplier_penalty

	damage_multiplier = dam_mul


/obj/item/bodypart/proc/kill_limb()
	if(!can_decay())
		return
	var/already_rot = HAS_TRAIT_FROM(src, TRAIT_ROTTEN, GERM_LEVEL_TRAIT)
	if(!already_rot)
		ADD_TRAIT(src, TRAIT_ROTTEN, GERM_LEVEL_TRAIT)
	if(owner && !already_rot)
		owner.update_body()
	else
		update_icon_dropped()

/obj/item/bodypart/proc/revive_limb()
	var/already_rot = HAS_TRAIT_FROM(src, TRAIT_ROTTEN, GERM_LEVEL_TRAIT)
	if(already_rot)
		REMOVE_TRAIT(src, TRAIT_ROTTEN, GERM_LEVEL_TRAIT)
	if(owner && already_rot)
		owner.update_body()
	else
		update_icon_dropped()

/// Adding/removing germs
/obj/item/bodypart/adjust_germ_level(add_germs, minimum_germs = 0, maximum_germs = GERM_LEVEL_MAXIMUM)
	. = ..()
	if(germ_level >= INFECTION_LEVEL_THREE && !CHECK_BITFIELD(limb_flags, BODYPART_DEAD))
		kill_limb()
		if(owner && owner.stat < DEAD)
			to_chat(owner, span_userdanger("I can't feel my [name] anymore..."))
	consider_processing()

///Called when TRAIT_ROTTEN is added to the limb.
/obj/item/bodypart/proc/on_rotten_trait_gain(obj/item/bodypart/source)
	SIGNAL_HANDLER

	germ_level = INFECTION_LEVEL_THREE
	limb_flags |= BODYPART_DEAD
	update_limb(!owner, owner)
	update_limb_efficiency()

///Called when TRAIT_ROTTEN is removed from the limb.
/obj/item/bodypart/proc/on_rotten_trait_loss(obj/item/bodypart/source)
	SIGNAL_HANDLER

	limb_flags &= ~BODYPART_DEAD
	update_limb(!owner, owner)
	update_limb_efficiency()

/// Return TRUE to get whatever mob this is in to update health.
/obj/item/bodypart/proc/on_life(delta_time, times_fired)
	if(pain_heal_tick && (pain_dam >= DAMAGE_PRECISION))
		var/multiplier = 1
		if(owner.body_position == LYING_DOWN)
			multiplier *= pain_heal_rest_multiplier
		remove_pain(amount = (pain_heal_tick * multiplier * (0.5 * delta_time)), updating_health = FALSE)
	if(can_decay())
		if(germ_level || (getorganslotefficiency(ORGAN_SLOT_ARTERY) < ORGAN_FAILING_EFFICIENCY))
			update_germs(delta_time, times_fired)
	if(number_injuries)
		update_injuries(delta_time, times_fired)

/// Check if we need to run on_life()
/obj/item/bodypart/proc/consider_processing()
	. = FALSE
	//else if.. else if.. so on.
	if(pain_dam >= DAMAGE_PRECISION)
		. = TRUE
	else if(number_injuries)
		. = TRUE
	else if(can_decay() && germ_level)
		. = TRUE
	else if(getorganslotefficiency(ORGAN_SLOT_ARTERY) < ORGAN_FAILING_EFFICIENCY)
		. = TRUE
	needs_processing = .


/// Proc for damaging organs inside a limb based on damage values
/obj/item/bodypart/proc/damage_internal_organs(wounding_type = WOUND_BLUNT, amount = 0, organ_bonus = 0, bare_organ_bonus = 0, forced = FALSE, wound_messages = TRUE)
	. = FALSE
	if(organ_bonus == CANT_ORGAN)
		return
	var/list/internal_organs = list()
	internal_organs |= get_organs()
	//damaging face organs = also damaging head organs
	var/list/extra_parts = list()
	if(body_zone == BODY_ZONE_HEAD)
		extra_parts |= owner.get_bodypart(BODY_ZONE_PRECISE_L_EYE)
		extra_parts |= owner.get_bodypart(BODY_ZONE_PRECISE_R_EYE)
	for(var/obj/item/bodypart/extra_part in extra_parts)
		internal_organs |= extra_part.get_organs()
	for(var/obj/item/organ/organ as anything in internal_organs)
		internal_organs -= organ
		if(!istype(organ))
			continue
		if(organ.damage < organ.maxHealth && \
			(organ.organ_volume * 10 >= 1) && \
			!CHECK_BITFIELD(organ.organ_flags, ORGAN_NO_VIOLENT_DAMAGE))
			// Multiply by 10 because pickweight doesn't play nice with decimals
			internal_organs[organ] = CEILING(organ.organ_volume * 10, 1)
	if(!LAZYLEN(internal_organs))
		return

	if(ishuman(owner) && bare_organ_bonus)
		var/mob/living/carbon/human/human_owner = owner
		for(var/obj/item/clothing/clothes_check as anything in human_owner.clothingonpart(src))
			if(clothes_check.armor.getRating(WOUND))
				bare_organ_bonus = 0
				break

	var/cur_damage = brute_dam+burn_dam
	var/damage_amt = amount+organ_bonus+bare_organ_bonus
	var/organ_damage_minimum = organ_damage_hit_minimum
	var/organ_damaged_required = organ_damage_requirement
	switch(wounding_type)
		// Piercing damage is more likely to damage internal organs
		if(WOUND_PIERCE)
			organ_damage_minimum *= 0.5
		// Slashing damage is *slightly* more likely to damage internal organs
		if(WOUND_SLASH)
			organ_damage_minimum *= 0.75
		// Burn damage is unlikely to damage organs
		if(WOUND_BURN)
			organ_damage_minimum *= 1.5
		// Organ damage minimum is assumed to be the case for blunt anyway
		else
			organ_damage_hit_minimum *= 1

	// Wounds can alter our odds of harming organs
	for(var/datum/wound/oof as anything in wounds)
		damage_amt += oof.organ_damage_increase
		organ_damage_minimum = max(1, organ_damage_minimum - oof.organ_minimum_reduction)
		organ_damaged_required = max(1, organ_damaged_required - oof.organ_required_reduction)

	// Set this to the maximum considered amount if we exceed it
	damage_amt = min(MAX_CONSIDERED_ORGAN_DAMAGE_ROLL, CEILING(damage_amt, 1))
	organ_damaged_required = CEILING(organ_damaged_required, 1)
	organ_damage_minimum = CEILING(organ_damage_minimum, 1)
	// We haven't hit one or more of the tresholds
	if(!forced && (!(cur_damage >= organ_damaged_required) || !(damage_amt >= organ_damage_minimum)))
		return FALSE

	var/organ_hit_chance = 30 * (damage_amt/organ_damage_minimum)
	// Bones getting in the way aaaaah
	var/modifier = 1

	organ_hit_chance *= modifier
	organ_hit_chance = clamp(CEILING(organ_hit_chance, 1), 0, 100)
	if(!prob(organ_hit_chance) && !forced)
		return FALSE

	var/obj/item/organ/victim = pickweight(internal_organs)
	damage_amt = max(0, CEILING((damage_amt * victim.internal_damage_modifier) - victim.internal_damage_reduction, 1))
	if(damage_amt >= 1)
		victim.applyOrganDamage(damage_amt)
	if(owner)
		if(damage_amt >= 15)
			owner.custom_pain("<b>MY [uppertext(victim.name)] HURTS!</b>", rand(25, 35), affecting = src, nopainloss = TRUE)
	return TRUE

/// Creates an injury on the bodypart
/obj/item/bodypart/proc/create_injury(injury_type = WOUND_BLUNT, damage = 0, surgical = FALSE, wound_messages = TRUE)
	. = FALSE
	if(!surgical)
		var/can_inflict = max_damage - get_damage()
		damage = min(can_inflict, damage)

	if(damage <= 0)
		return

	// First check whether we can widen an existing wound
	if(damage >= 5 && !surgical && length(injuries) && prob(clamp(50 + (number_injuries-1 * 10), 50, 90)))
		// Piercing injuries cannot "open" into one
		// Small ass damage should create a new wound entirely
		var/list/compatible_injuries = list()
		for(var/thing in injuries)
			var/datum/injury/candidate_for_widening = thing
			if(candidate_for_widening.can_worsen(injury_type, damage))
				compatible_injuries |= candidate_for_widening
		if(length(compatible_injuries))
			var/datum/injury/compatible_injury = pick(compatible_injuries)
			compatible_injury.open_injury(damage)
			last_injury = compatible_injury
			. = compatible_injury

	// Creating NEW injury
	if(!.)
		var/new_injury_type = get_injury_type(injury_type, damage)
		if(new_injury_type)
			var/datum/injury/new_injury = new new_injury_type()
			// Check whether we can add the wound to an existing wound
			if(surgical)
				new_injury.autoheal_cutoff = 0
				new_injury.injury_flags |= INJURY_SURGICAL
			else
				for(var/datum/injury/other in injuries)
					if(other.can_merge(new_injury))
						other.merge_injury(new_injury)
						return other
			// Apply the injury
			new_injury.apply_injury(damage, src)
			last_injury = new_injury
			. = new_injury

/// Deal with injury healing and other updates
/obj/item/bodypart/proc/update_injuries(delta_time, times_fired)
	var/toxins = 0
	if(owner)
		toxins = owner.get_chem_effect(CE_TOXIN)
		//the dylovenal is mightier than the cyanide
		if(owner?.get_chem_effect(CE_ANTITOX) >= 10)
			toxins = 0
		//broken heart
		if(owner?.getorganslotefficiency(ORGAN_SLOT_HEART) < ORGAN_FAILING_EFFICIENCY)
			toxins = max(toxins, 1)
	for(var/datum/injury/injury as anything in injuries)
		if(injury.damage <= 0)
			qdel(injury)
			continue

		// Slow healing
		var/heal_amt = 0

		if(!toxins && injury.can_autoheal())
			heal_amt += (GET_MOB_ATTRIBUTE_VALUE(owner, STAT_ENDURANCE) * 0.01)
			if(owner?.IsSleeping())
				heal_amt *= 4

		if(heal_amt)
			injury.heal_damage(heal_amt * (0.5 * delta_time))

		// Bleeding
		if(owner)
			injury.bleed_timer = max(0, injury.bleed_timer - (0.5 * delta_time))

	// Sync the limb's damage with its injuries
	update_damages()
	// Also update efficiency
	update_limb_efficiency()
	owner.update_damage_overlays()

/// Updates brute_damn and burn_damn from injuries
/obj/item/bodypart/proc/update_damages()
	number_injuries = 0
	brute_dam = 0
	burn_dam = 0
	for(var/datum/injury/injury as anything in injuries)
		if(injury.damage <= 0)
			continue

		if(injury.damage_type == WOUND_BURN)
			burn_dam += injury.damage
		else
			brute_dam += injury.damage

		number_injuries += injury.amount

/// General handling of infections
/obj/item/bodypart/proc/update_germs(delta_time, times_fired)
	//Cryo stops germs from moving and doing their bad stuffs
	if(owner.bodytemperature <= -15)
		return
	handle_germ_sync(delta_time, times_fired)
	handle_germ_effects(delta_time, times_fired)
	handle_antibiotics(delta_time, times_fired)

/// Try to sync wound/inuries etc with our germ level
/obj/item/bodypart/proc/handle_germ_sync(delta_time, times_fired)
	// If we have no wounds, nor injuries, nor germ level, no point in trying to update
	if(!length(wounds) && !length(injuries) && (germ_level <= 0))
		return

	var/turf/open/floor/open_turf = get_turf(owner)
	var/owner_germ_level = 2*owner.germ_level
	for(var/obj/item/embeddies in embedded_objects)
		owner_germ_level += (embeddies.germ_level/20)

	// Open injuries can become infected, regardless of antibiotics
	if(istype(open_turf))
		for(var/datum/injury/injury as anything in injuries)
			if(injury.infection_check(delta_time, times_fired) && (max(open_turf.germ_level, owner_germ_level) > injury.germ_level))
				injury.adjust_germ_level(injury.infection_rate * (0.5 * delta_time))

	// If we have sufficient antibiotics, then skip over this stuff, the infection is going away
	var/antibiotics = owner.get_antibiotics()
	if(antibiotics >= 10)
		return

	for(var/datum/injury/injury as anything in injuries)
		//Infected injuries raise the bodypart's germ level
		if(injury.germ_level > germ_level || DT_PROB(CEILING(min(injury.germ_level/5, 40)/2, 1), delta_time))
			adjust_germ_level(injury.infection_rate * (0.5 * delta_time))
			break	//limit increase to a maximum of one injury infection increase per 2 seconds


/// Handle infection effects
/obj/item/bodypart/proc/handle_germ_effects(delta_time, times_fired)
	var/immunity = owner.virus_immunity()
	var/immunity_weakness = owner.immunity_weakness()
	var/antibiotics = owner.get_antibiotics()
	var/arterial_efficiency = getorganslotefficiency(ORGAN_SLOT_ARTERY)

	// Being properly oxygenated
	if(!artery_needed() || (arterial_efficiency >= ORGAN_FAILING_EFFICIENCY))
		if(germ_level > 0 && (germ_level < INFECTION_LEVEL_ONE/2) && DT_PROB(immunity*0.3, delta_time))
			adjust_germ_level(-1 * (0.5 * delta_time))
			return
	// Dry gangrene
	else
		adjust_germ_level(1 * (0.5 * delta_time))

	if(germ_level >= INFECTION_LEVEL_ONE/2)
		//Warn the user that they're a bit fucked
		if(germ_level <= INFECTION_LEVEL_ONE && (owner.stat < DEAD) && DT_PROB(2, delta_time))
			owner.custom_pain("My [src.name] feels a bit warm and swollen...", 6, FALSE, src)
		//Aiming for germ level to go from ambient to INFECTION_LEVEL_TWO in an average of 15 minutes, when immunity is full.
		if(antibiotics < 5 && DT_PROB(FLOOR(germ_level/6 * immunity_weakness * 0.005, 1), delta_time))
			if(immunity > 0)
				//Immunity starts at 100. This doubles infection rate at 50% immunity. Rounded to nearest whole.
				adjust_germ_level(clamp(FLOOR(1/immunity, 1), 1, 10) * (0.5 * delta_time))
			else
				//Will only trigger if immunity has hit zero. Once it does, 10x infection rate.
				adjust_germ_level(10 * (0.5 * delta_time))

	if(germ_level >= INFECTION_LEVEL_ONE && (antibiotics < 20))
		if(DT_PROB(3, delta_time) && (owner.stat < DEAD) && germ_level <= INFECTION_LEVEL_TWO)
			owner.custom_pain("My [src.name] feels hotter than normal...", 12, FALSE, src)
		var/fever_temperature = (BODYTEMP_HEAT_DAMAGE_LIMIT - BODYTEMP_NORMAL - 5) * min(germ_level/INFECTION_LEVEL_TWO, 1) + BODYTEMP_NORMAL
		owner.adjust_bodytemperature(clamp((fever_temperature - 2)/BODYTEMP_COLD_DIVISOR + 1, 0, fever_temperature - owner.bodytemperature))

	// Spread the infection to internal organs, child and parent bodyparts
	if(germ_level >= INFECTION_LEVEL_TWO && antibiotics < 25)
		// Chance to cause pain, while also informing the owner
		if(owner && (owner.stat < DEAD) && DT_PROB(4, delta_time))
			owner.custom_pain("My [src.name] starts leaking some pus...", 16, FALSE, src)

		// Make internal organs become infected one at a time instead of all at once
		var/obj/item/organ/target_organ
		var/obj/item/organ/organ
		var/list/candidate_organs = list()
		for(var/thing in get_organs())
			organ = thing
			if(organ.germ_level <= germ_level)
				candidate_organs |= organ
		if(length(candidate_organs))
			target_organ = pick(candidate_organs)

		// Infect the target organ
		if(target_organ)
			target_organ.adjust_germ_level(1 * (0.5 * delta_time))

		// Spread the infection to child and parent organs
		var/zones = list()
		zones |= body_zone
		if(LAZYLEN(zones))
			for(var/zone in zones)
				var/obj/item/bodypart/bodypart = owner.get_bodypart(zone)
				if(bodypart && (bodypart.germ_level < germ_level))
					if(bodypart.germ_level < INFECTION_LEVEL_TWO || DT_PROB(15, delta_time))
						bodypart.adjust_germ_level(1 * (0.5 * delta_time))

/// Handle the antibiotic chem effect
/obj/item/bodypart/proc/handle_antibiotics(delta_time, times_fired)
	if(!owner || (owner.stat >= DEAD) || (germ_level <= 0))
		return

	var/antibiotics = owner.get_antibiotics()
	if(antibiotics <= 0)
		return

	if((germ_level < INFECTION_LEVEL_ONE) && (antibiotics >= 20))
		if(getorganslotefficiency(ORGAN_SLOT_ARTERY) >= ORGAN_FAILING_EFFICIENCY)
			set_germ_level(0) //cure instantly
	else
		adjust_germ_level(-antibiotics * SANITIZATION_ANTIBIOTIC * (0.5 * delta_time))	//at germ_level == 500 and 50 antibiotic, this should cure the infection in 5 minutes
		if(owner?.body_position == LYING_DOWN)
			adjust_germ_level(-SANITIZATION_LYING * (0.5 * delta_time))

/obj/item/bodypart/proc/create_base_organs()
	if(CHECK_BITFIELD(limb_flags, BODYPART_HAS_ARTERY))
		create_artery()

/obj/item/bodypart/attack(mob/living/carbon/C, mob/user, list/modifiers)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		if(HAS_TRAIT(C, TRAIT_LIMBATTACHMENT))
			if(!H.get_bodypart(body_zone) && !animal_origin)
				if(H == user)
					H.visible_message("<span class='warning'>[H] jams [src] into [H.p_their()] empty socket!</span>",\
					"<span class='notice'>I force [src] into my empty socket, and it locks into place!</span>")
				else
					H.visible_message("<span class='warning'>[user] jams [src] into [H]'s empty socket!</span>",\
					"<span class='notice'>[user] forces [src] into my empty socket, and it locks into place!</span>")
				user.temporarilyRemoveItemFromInventory(src, TRUE)
				attach_limb(C)
				return
	return ..()

/obj/item/bodypart/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(status != BODYPART_ROBOTIC)
		playsound(src, 'sound/blank.ogg', 50, TRUE, -1)
	pixel_x = base_pixel_x + rand(-3, 3)
	pixel_y = base_pixel_y + rand(-3, 3)
	if(!skeletonized)
		var/bloodcolor = COLOR_BLOOD
		if(owner)
			bloodcolor = owner.get_blood_type().color
		else if(original_owner)
			bloodcolor = original_owner.get_blood_type()?.color || COLOR_BLOOD
		new /obj/effect/decal/cleanable/blood/splatter(get_turf(src), bloodcolor)

//empties the bodypart from its organs and other things inside it
/obj/item/bodypart/proc/drop_organs(mob/user, violent_removal)
	var/turf/T = get_turf(src)
	if(status != BODYPART_ROBOTIC)
		playsound(T, 'sound/blank.ogg', 50, TRUE, -1)
	for(var/obj/item/I in src)
		I.forceMove(T)
	for(var/atom/movable/item as anything in cavity_items)
		item.forceMove(drop_location())
		cavity_items -= item

/obj/item/bodypart/proc/skeletonize(lethal = TRUE)
	if(bandage)
		remove_bandage()
	for(var/obj/item/I in embedded_objects)
		remove_embedded_object(I)
	for(var/obj/item/I in src) //dust organs
		qdel(I)
	skeletonized = TRUE

/obj/item/bodypart/chest/skeletonize(lethal = TRUE)
	. = ..()
	if(lethal && owner && !(NOBLOOD in owner.dna?.species?.species_traits))
		owner.death()

/obj/item/bodypart/proc/update_HP()
	if(!is_organic_limb() || !owner)
		return
	var/old_max_damage = max_damage
	var/new_max_damage = initial(max_damage) * max(1, (GET_MOB_ATTRIBUTE_VALUE(owner, STAT_CONSTITUTION) / 10))
	if(new_max_damage != old_max_damage)
		max_damage = new_max_damage


/// Returns whether or not the bodypart can feel pain
/obj/item/bodypart/proc/can_feel_pain()
	. = FALSE
	/*
	if(CHECK_BITFIELD(limb_flags, BODYPART_CUT_AWAY|BODYPART_DEAD))
		return
	*/
	if(HAS_TRAIT(src, TRAIT_ROTTEN))
		return
	if(HAS_TRAIT(src, TRAIT_NOPAIN))
		return
	return owner?.can_feel_pain()

/// Add pain_dam to a bodypart
/obj/item/bodypart/proc/add_pain(amount = 0, updating_health = TRUE, required_status = null)
	if(required_status && (status != required_status))
		return
	if(!can_feel_pain())
		return
	var/can_inflict = max_pain_damage - pain_dam
	amount *= CONFIG_GET(number/damage_multiplier)
	amount -= owner.get_chem_effect(CE_PAINKILLER)/PAINKILLER_DIVISOR
	amount = min(can_inflict, amount)
	pain_dam = round(pain_dam + max(amount, 0), DAMAGE_PRECISION)
	if(updating_health)
		owner.update_shock()
	if(can_be_disabled)
		update_disabled()
	return TRUE

/// Remove pain_dam from a bodypart
/obj/item/bodypart/proc/remove_pain(amount = 0, updating_health = TRUE, required_status = null)
	if(required_status && (status != required_status))
		return
	if(amount > pain_dam)
		amount = pain_dam
	pain_dam = FLOOR(pain_dam - max(abs(amount), 0), DAMAGE_PRECISION)
	if(updating_health)
		owner?.update_shock()
	if(can_be_disabled)
		update_disabled()
	return TRUE

/// Make total pain equal amount
/obj/item/bodypart/proc/set_pain(amount = 0, updating_health = TRUE, required_status = null)
	if(required_status && (status != required_status))
		return
	var/diff = amount - pain_dam
	if(diff >= 0)
		return add_pain(abs(diff), updating_health, required_status)
	else
		return remove_pain(abs(diff), updating_health, required_status)

/// Returns how much pain we are dealing with right now, taking other damage types into account
/obj/item/bodypart/proc/get_shock(painkiller_included = FALSE, nerve_included = TRUE)
	if(!can_feel_pain())
		return 0
	//Multiply our total pain damage by this
	var/multiplier = 1
	if(LAZYLEN(grabbedby))
		//Being grasped lowers the pain just a bit
		multiplier *= 0.75
	if(multiplier <= 0)
		return 0
	var/constant_pain = 0
	constant_pain += SHOCK_MOD_BRUTE * brute_dam
	constant_pain += SHOCK_MOD_BURN * burn_dam
	var/datum/wound/wound
	for(var/thing in wounds)
		wound = thing
		constant_pain += wound.woundpain
	var/obj/item/organ/organ
	for(var/thing in get_organs())
		organ = thing
		constant_pain += organ.get_shock(FALSE)
	var/obj/item/item
	for(var/thing in embedded_objects)
		item = thing
		constant_pain += 3 * item.w_class
	if(painkiller_included)
		constant_pain -= owner.get_chem_effect(CE_PAINKILLER)/PAINKILLER_DIVISOR
	return clamp(FLOOR((pain_dam + constant_pain) * multiplier, DAMAGE_PRECISION), 0, max_pain_damage)

//Applies brute and burn damage to the organ. Returns 1 if the damage-icon states changed at all.
//Damage will not exceed max_damage using this proc
//Cannot apply negative damage
/obj/item/bodypart/proc/receive_damage(brute = 0, burn = 0, blocked = 0, updating_health = TRUE, required_status = null, flashes = TRUE)
	update_HP()
	var/hit_percent = (100-blocked)/100
	if((!brute && !burn) || hit_percent <= 0)
		return FALSE
	if(owner && (owner.status_flags & GODMODE))
		return FALSE	//godmode

	if(required_status && (status != required_status))
		return FALSE

	var/dmg_mlt = CONFIG_GET(number/damage_multiplier) * hit_percent
	brute = round(max(brute * dmg_mlt * damage_multiplier, 0),DAMAGE_PRECISION)
	burn = round(max(burn * dmg_mlt * damage_multiplier, 0),DAMAGE_PRECISION)
	brute = max(0, brute - brute_reduction)
	burn = max(0, burn - burn_reduction)

	if(!brute && !burn)
		return FALSE

	var/owner_endurance = GET_MOB_ATTRIBUTE_VALUE(owner, STAT_ENDURANCE)

	// We get the pain values before we scale damage down
	// Pain does not care about your feelings, nor if your limb was already damaged
	// to it's maximum
	var/painkiller_mod = owner?.get_chem_effect(CE_PAINKILLER)/PAINKILLER_DIVISOR
	var/pain = min((SHOCK_MOD_BRUTE * brute) + (SHOCK_MOD_BURN * burn) - painkiller_mod, max_pain_damage-pain_dam)

	//cap at maxdamage
	if(brute_dam + brute > max_damage)
		set_brute_dam(max_damage)
	else
		set_brute_dam(brute_dam + brute)
	if(burn_dam + burn > max_damage)
		set_burn_dam(max_damage)
	else
		set_burn_dam(burn_dam + burn)

	if(owner && flashes)
		if((brute + burn) < 10)
			owner.flash_fullscreen("redflash1")
		else if((brute + burn) < 20)
			owner.flash_fullscreen("redflash2")
		else if((brute + burn) >= 20)
			owner.flash_fullscreen("redflash3")

	// Now we add pain proper
	if(owner && pain && add_pain(pain, FALSE))
		if(prob(pain*0.5))
			INVOKE_ASYNC(owner, TYPE_PROC_REF(/mob/living, emote), "scream")
		//owner.flash_pain(pain)
		var/shock_penalty = min(SHOCK_PENALTY_CAP, FLOOR(pain/owner_endurance, 1))
		if(shock_penalty)
			owner.update_shock_penalty(shock_penalty)


	if(owner)
		if(can_be_disabled)
			update_disabled()
		update_limb_efficiency()
		if(updating_health)
			owner.updatehealth()

			if(get_shock(FALSE, TRUE) >= DAMAGE_PRECISION)
				owner.update_shock()
				. = TRUE

	update_damages()
	consider_processing()
	return update_bodypart_damage_state() || .

//Heals brute and burn damage for the organ. Returns 1 if the damage-icon states changed at all.
//Damage cannot go below zero.
//Cannot remove negative damage (i.e. apply damage)
/obj/item/bodypart/proc/heal_damage(brute, burn, required_status, updating_health = TRUE, true_heal = FALSE)
	update_HP()
	if(required_status && (status != required_status)) //So we can only heal certain kinds of limbs, ie robotic vs organic.
		return


	for(var/thing in injuries)
		if((brute <= 0) && (burn <= 0))
			break
		var/datum/injury/injury = thing
		var/list/heal_list = list(WOUND_SLASH, WOUND_PIERCE, WOUND_BLUNT, WOUND_INTERNAL_BRUISE)
		if(true_heal)
			heal_list |= list(WOUND_BITE, WOUND_BLUNT, WOUND_DIVINE, WOUND_LASH)
		if(injury.damage_type in heal_list)
			brute = injury.heal_damage(brute)
		else if(injury.damage_type == WOUND_BURN)
			burn = injury.heal_damage(burn)

	update_damages()

	if(brute)
		set_brute_dam(round(max(brute_dam - brute, 0), DAMAGE_PRECISION))
	if(burn)
		set_burn_dam(round(max(burn_dam - burn, 0), DAMAGE_PRECISION))

	update_damages()

	if(owner)
		update_limb_efficiency()
		if(can_be_disabled)
			update_disabled()
		if(updating_health)
			owner.updatehealth()
	consider_processing()
	return update_bodypart_damage_state()

///Proc to hook behavior associated to the change of the brute_dam variable's value.
/obj/item/bodypart/proc/set_brute_dam(new_value)
	if(brute_dam == new_value)
		return
	. = brute_dam
	brute_dam = new_value

///Proc to hook behavior associated to the change of the burn_dam variable's value.
/obj/item/bodypart/proc/set_burn_dam(new_value)
	if(burn_dam == new_value)
		return
	. = burn_dam
	burn_dam = new_value

//Returns total damage.
/obj/item/bodypart/proc/get_damage()
	return brute_dam + burn_dam

//Checks disabled status thresholds
/obj/item/bodypart/proc/update_disabled()
	update_HP()
	if(!owner)
		return
	if(!can_be_disabled)
		set_disabled(FALSE)
		CRASH("update_disabled called with can_be_disabled false")

	//yes this does mean vampires can use rotten limbs
	if((HAS_TRAIT(src, TRAIT_ROTTEN) || skeletonized) && !(owner.mob_biotypes & MOB_UNDEAD))
		return set_disabled(BODYPART_DISABLED_ROT)
	for(var/datum/wound/ouchie as anything in wounds)
		if(!ouchie.disabling)
			continue
		return set_disabled(BODYPART_DISABLED_WOUND)
	if(HAS_TRAIT(owner, TRAIT_PARALYSIS) || HAS_TRAIT(src, TRAIT_PARALYSIS))
		return set_disabled(BODYPART_DISABLED_PARALYSIS)
	var/surgery_flags = get_surgery_flags()
	if(surgery_flags & SURGERY_CLAMPED)
		return set_disabled(BODYPART_DISABLED_CLAMPED)
	var/total_dam = get_damage()
	if((total_dam >= max_damage) || (HAS_TRAIT(owner, TRAIT_EASYLIMBDISABLE) && (total_dam >= (max_damage * 0.6))))
		return set_disabled(BODYPART_DISABLED_DAMAGE)
	return set_disabled(BODYPART_NOT_DISABLED)

/obj/item/bodypart/proc/set_disabled(new_disabled)
	if(bodypart_disabled == new_disabled)
		return
	. = bodypart_disabled
	bodypart_disabled = new_disabled

	if(!owner)
		return

	last_disable = world.time
	if(owner)
		owner.update_health_hud() //update the healthdoll
		owner.update_body()

/obj/item/bodypart/proc/reset_fingerprint()
	if(status != BODYPART_ORGANIC)
		fingerprint = null
		return
	if(owner?.dna?.unique_identity)
		fingerprint = md5(owner.dna.unique_identity)
	if(owner?.dna?.species)
		food_type = owner.dna.species.meat

///Proc to change the value of the `owner` variable and react to the event of its change.
/obj/item/bodypart/proc/set_owner(mob/living/carbon/new_owner)
	SHOULD_CALL_PARENT(TRUE)

	if(owner == new_owner)
		return FALSE //`null` is a valid option, so we need to use a num var to make it clear no change was made.
	var/mob/living/carbon/old_owner = owner
	owner = new_owner
	var/needs_update_disabled = FALSE //Only really relevant if there's an owner
	if(old_owner)
		if(initial(can_be_disabled))
			if(HAS_TRAIT(old_owner, TRAIT_NOLIMBDISABLE))
				if(!owner || !HAS_TRAIT(owner, TRAIT_NOLIMBDISABLE))
					set_can_be_disabled(initial(can_be_disabled))
					needs_update_disabled = TRUE
			UnregisterSignal(old_owner, list(
				SIGNAL_REMOVETRAIT(TRAIT_NOLIMBDISABLE),
				SIGNAL_ADDTRAIT(TRAIT_NOLIMBDISABLE),
				SIGNAL_ADDTRAIT(TRAIT_PARALYSIS),
				SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS),
				))
	if(owner)
		if(initial(can_be_disabled))
			if(HAS_TRAIT(owner, TRAIT_NOLIMBDISABLE)) // owner is new_owner, don't listen to owner TRAIT_PARALYSIS signals if TRAIT_NOLIMBDISABLE
				set_can_be_disabled(FALSE)
				needs_update_disabled = FALSE
			else
				RegisterSignal(new_owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS), PROC_REF(on_paralysis_trait_gain))
				RegisterSignal(new_owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS), PROC_REF(on_paralysis_trait_loss))
			RegisterSignal(new_owner, SIGNAL_REMOVETRAIT(TRAIT_NOLIMBDISABLE), PROC_REF(on_owner_nolimbdisable_trait_loss))
			RegisterSignal(new_owner, SIGNAL_ADDTRAIT(TRAIT_NOLIMBDISABLE), PROC_REF(on_owner_nolimbdisable_trait_gain))

		if(needs_update_disabled)
			update_disabled()

	return old_owner

///Proc to change the value of the `can_be_disabled` variable and react to the event of its change.
/obj/item/bodypart/proc/set_can_be_disabled(new_can_be_disabled)
	if(can_be_disabled == new_can_be_disabled)
		return
	. = can_be_disabled
	can_be_disabled = new_can_be_disabled
	if(can_be_disabled)
		if(owner)
			if(HAS_TRAIT(owner, TRAIT_NOLIMBDISABLE))
				CRASH("set_can_be_disabled to TRUE with for limb whose owner has TRAIT_NOLIMBDISABLE")
			RegisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS), PROC_REF(on_paralysis_trait_gain))
			RegisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS), PROC_REF(on_paralysis_trait_loss))
		update_disabled()
	else if(.)
		if(owner)
			UnregisterSignal(owner, list(
				SIGNAL_ADDTRAIT(TRAIT_PARALYSIS),
				SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS),
				))
		set_disabled(FALSE)

//Updates limb efficiency based on tendons, nerves and arteries
/obj/item/bodypart/proc/update_limb_efficiency()
	var/divisor = 0
	limb_efficiency = 0
	if(divisor)
		limb_efficiency /= divisor
	// no tendon, nerve nor artery!
	else
		limb_efficiency = 100
	// wounds decrease limb efficiency
	for(var/datum/wound/hurty as anything in wounds)
		limb_efficiency -= hurty.limb_efficiency_reduction
	limb_efficiency = max(0, CEILING(limb_efficiency, 1))


///Called when TRAIT_PARALYSIS is added to the limb.
/obj/item/bodypart/proc/on_paralysis_trait_gain(obj/item/bodypart/source)
	SIGNAL_HANDLER
	if(can_be_disabled)
		set_disabled(TRUE)

///Called when TRAIT_PARALYSIS is removed from the limb.
/obj/item/bodypart/proc/on_paralysis_trait_loss(obj/item/bodypart/source)
	SIGNAL_HANDLER
	if(can_be_disabled)
		update_disabled()

///Called when TRAIT_NOLIMBDISABLE is added to the owner.
/obj/item/bodypart/proc/on_owner_nolimbdisable_trait_gain(mob/living/carbon/source)
	SIGNAL_HANDLER
	set_can_be_disabled(FALSE)

///Called when TRAIT_NOLIMBDISABLE is removed from the owner.
/obj/item/bodypart/proc/on_owner_nolimbdisable_trait_loss(mob/living/carbon/source)
	SIGNAL_HANDLER
	set_can_be_disabled(initial(can_be_disabled))

//Updates an organ's brute/burn states for use by update_damage_overlays()
//Returns 1 if we need to update overlays. 0 otherwise.
/obj/item/bodypart/proc/update_bodypart_damage_state()
	var/tbrute	= round( (brute_dam/max_damage)*3, 1 )
	var/tburn	= round( (burn_dam/max_damage)*3, 1 )
	if((tbrute != brutestate) || (tburn != burnstate))
		brutestate = tbrute
		burnstate = tburn
		return TRUE
	return FALSE

//Change organ status
/obj/item/bodypart/proc/change_bodypart_status(new_limb_status, heal_limb, change_icon_to_default)
	status = new_limb_status
	if(heal_limb)
		burn_dam = 0
		brute_dam = 0
		brutestate = 0
		burnstate = 0

	if(change_icon_to_default)
		if(status == BODYPART_ORGANIC)
			icon = species_icon

	if(owner)
		owner.updatehealth()
		owner.update_body() //if our head becomes robotic, we remove the lizard horns and human hair.
		owner.update_damage_overlays()

/obj/item/bodypart/proc/is_organic_limb()
	return (status == BODYPART_ORGANIC)

//we inform the bodypart of the changes that happened to the owner, or give it the informations from a source mob.
/obj/item/bodypart/proc/update_limb(dropping_limb, mob/living/carbon/source)
	var/mob/living/carbon/C
	if(!should_render)
		return
	if(source)
		C = source
		if(!original_owner)
			original_owner = source
	else if(original_owner && owner != original_owner) //Foreign limb
		no_update = TRUE
	else
		C = owner
		no_update = FALSE

	if(C && HAS_TRAIT(C, TRAIT_HUSK) && is_organic_limb())
		species_id = "husk" //overrides species_id
		dmg_overlay_type = "" //no damage overlay shown when husked
		should_draw_gender = FALSE
		should_draw_greyscale = FALSE
		no_update = TRUE

	if(no_update)
		return

	if(!animal_origin)
		var/mob/living/carbon/human/H = C
		should_draw_greyscale = FALSE
		if(!H.dna?.species)
			return
		var/datum/species/S = H.dna.species
		species_id = S.limbs_id
		if(H.gender == MALE)
			species_icon = S.limbs_icon_m
		else
			species_icon = S.limbs_icon_f
		if(H.age == AGE_CHILD)
			species_icon = S.child_icon
		species_flags_list = H.dna.species.species_traits


		if(S.use_skintones)
			skin_tone = H.skin_tone
			should_draw_greyscale = TRUE
		else
			skin_tone = ""

		body_gender = H.gender
		should_draw_gender = S.sexes

		species_color = ""

		mutation_color = ""

		dmg_overlay_type = S.damage_overlay_type

	else if(animal_origin == MONKEY_BODYPART) //currently monkeys are the only non human mob to have damage overlays.
		dmg_overlay_type = animal_origin

	if(status == BODYPART_ROBOTIC)
		dmg_overlay_type = "robotic"

	if(dropping_limb)
		no_update = TRUE //when attached, the limb won't be affected by the appearance changes of its mob owner.

//to update the bodypart's icon when not attached to a mob
/obj/item/bodypart/proc/update_icon_dropped()
	cut_overlays()
	var/list/standing = get_limb_icon(1)
	if(!standing.len)
		icon_state = initial(icon_state)//no overlays found, we default back to initial icon.
		return
	for(var/image/I in standing)
		I.pixel_x = px_x
		I.pixel_y = px_y
	add_overlay(standing)

//Gives you a proper icon appearance for the dismembered limb
/obj/item/bodypart/proc/get_limb_icon(dropped, hideaux = FALSE)
	if(!should_render)
		return
	icon_state = "" //to erase the default sprite, we're building the visual aspects of the bodypart through overlays alone.

	. = list()
	var/icon_gender = (body_gender == FEMALE) ? "f" : "m" //gender of the icon, if applicable

	var/image_dir = 0
	if(dropped && !skeletonized)
		if(static_icon)
			icon = initial(icon)
			icon_state = initial(icon_state)
			return
		image_dir = SOUTH
		if(dmg_overlay_type)
			if(brutestate)
				var/image/brute_image = image('icons/mob/dam_mob.dmi', "[dmg_overlay_type]_[body_zone]_[brutestate]0_[icon_gender]", -DAMAGE_LAYER, image_dir)
				if(owner)
					owner.get_blood_type().color
				else if(original_owner)
					original_owner.get_blood_type().color
				else
					brute_image.color = COLOR_BLOOD
				. += brute_image
			if(burnstate)
				. += image('icons/mob/dam_mob.dmi', "[dmg_overlay_type]_[body_zone]_0[burnstate]_[icon_gender]", -DAMAGE_LAYER, image_dir)

	var/mutable_appearance/limb = mutable_appearance(layer = -BODYPARTS_LAYER)
	if(wound_icon_state)
		limb.filters += alpha_mask_filter(icon=icon('icons/effects/wounds.dmi', "[wound_icon_state]_flesh"), flags = MASK_INVERSE)
	if(acid_damage_intensity)
		limb.filters += alpha_mask_filter(icon=icon('icons/effects/wounds.dmi', "[body_zone]_acid[acid_damage_intensity]_flesh"), flags = MASK_INVERSE)
	limb.dir = image_dir
	var/image/aux

	. += limb

	if(animal_origin)
		if(is_organic_limb())
			limb.icon = 'icons/mob/animal_parts.dmi'
			if(species_id == "husk")
				limb.icon_state = "[animal_origin]_husk_[body_zone]"
			else
				limb.icon_state = "[animal_origin]_[body_zone]"
		return

//	if((body_zone != BODY_ZONE_HEAD && body_zone != BODY_ZONE_CHEST))
//		should_draw_gender = FALSE
	should_draw_gender = TRUE

	var/skel = skeletonized ? "_s" : ""

	if(is_organic_limb() || (species_id == SPEC_ID_AUTOMATON && species_icon))//fuck this stupid rendering system
		if(should_draw_greyscale)
			limb.icon = species_icon
			limb.icon_state = "[body_zone][skel]"
			if(wound_icon_state || acid_damage_intensity)
				var/mutable_appearance/skeleton = mutable_appearance(layer = -(BODY_LAYER))
				skeleton.icon = species_icon
				skeleton.icon_state = "[body_zone]_s"
				if(wound_icon_state)
					skeleton.filters += alpha_mask_filter(icon=icon('icons/effects/wounds.dmi', wound_icon_state))
				if(acid_damage_intensity)
					skeleton.filters += alpha_mask_filter(icon=icon('icons/effects/wounds.dmi', "[body_zone]_acid[acid_damage_intensity]"))
				skeleton.dir = image_dir
				. += skeleton
		else
			limb.icon = 'icons/mob/human_parts.dmi'
			if(should_draw_gender)
				limb.icon_state = "[species_id]_[body_zone]_[icon_gender]"
			else
				limb.icon_state = "[species_id]_[body_zone]"
		if(aux_zone && !hideaux)
			aux = image(limb.icon, "[aux_zone][skel]", -(aux_layer), image_dir)
			. += aux
			if(wound_icon_state || acid_damage_intensity)
				var/mutable_appearance/skeleton = mutable_appearance(layer = -(aux_layer))
				skeleton.icon = species_icon
				skeleton.icon_state = "[aux_zone]_s"
				if(wound_icon_state)
					skeleton.filters += alpha_mask_filter(icon=icon('icons/effects/wounds.dmi', wound_icon_state))
				if(acid_damage_intensity)
					skeleton.filters += alpha_mask_filter(icon=icon('icons/effects/wounds.dmi', "[aux_zone]_acid[acid_damage_intensity]"))
				skeleton.dir = image_dir
				. += skeleton
		if(blocks_emissive != EMISSIVE_BLOCK_NONE && !istype(owner, /mob/living/carbon/human/dummy))
			var/mutable_appearance/limb_em_block = mutable_appearance(limb.icon, limb.icon_state, plane = EMISSIVE_PLANE, appearance_flags = KEEP_APART)
			limb_em_block.dir = image_dir
			limb_em_block.color = GLOB.em_block_color
			limb.overlays += limb_em_block

			if(aux_zone && !hideaux)
				var/mutable_appearance/aux_em_block = mutable_appearance(aux.icon, aux.icon_state, plane = EMISSIVE_PLANE, appearance_flags = KEEP_APART)
				aux_em_block.dir = image_dir
				aux_em_block.color = GLOB.em_block_color
				aux.overlays += aux_em_block


	else
		limb.icon = species_icon
		limb.icon_state = "pr_[body_zone]"
		if(aux_zone)
			if(!hideaux)
				aux = image(limb.icon, "pr_[aux_zone]", -aux_layer, image_dir)
				. += aux
		return

	var/draw_organ_features = TRUE
	var/draw_bodypart_features = TRUE
	if(owner && owner.dna)
		var/datum/species/owner_species = owner.dna.species
		if(NO_ORGAN_FEATURES in owner_species.species_traits)
			draw_organ_features = FALSE
		if(NO_BODYPART_FEATURES in owner_species.species_traits)
			draw_bodypart_features = FALSE

	if(!skeletonized && draw_organ_features)
		for(var/obj/item/organ/organ as anything in get_organs())
			if(!organ.is_visible())
				continue
			var/mutable_appearance/organ_appearance = organ.get_bodypart_overlay(src)
			if(organ_appearance)
				. += organ_appearance

	// Feature overlays
	if(draw_bodypart_features)
		for(var/datum/bodypart_feature/feature as anything in bodypart_features)
			var/overlays = feature.get_bodypart_overlay(src)
			if(!overlays)
				continue
			. += overlays

	if(should_draw_greyscale && !skeletonized)
		var/draw_color =  mutation_color || species_color || skin_tone
		if(HAS_TRAIT(src, TRAIT_ROTTEN) || (owner && HAS_TRAIT(owner, TRAIT_ROTMAN)))
			draw_color = SKIN_COLOR_ROT
		if(draw_color)
			limb.color = "#[draw_color]"
			if(aux_zone && !hideaux)
				aux.color = "#[draw_color]"

///since organs aren't actually stored in the bodypart themselves while attached to a person, we have to query the owner for what we should have
/obj/item/bodypart/proc/get_organs()
	if(!owner)
		. = list()
		for(var/thing in contents)
			if(isorgan(thing))
				. |= thing
		return

	return LAZYACCESS(owner.organs_by_zone, body_zone)

/obj/item/bodypart/deconstruct(disassembled = TRUE)
	drop_organs()
	return ..()


/**
 * Get a random organ object from the bodypart matching the passed in typepath
 *
 * Arguments:
 * * typepath The typepath of the organ to get
 */
/obj/item/bodypart/proc/getorgan(typepath)
	if(owner)
		for(var/thing in shuffle(owner.getorganszone(body_zone)))
			if(istype(thing, typepath))
				return thing
	else
		var/list/organs = list()
		for(var/thing in src)
			if(istype(thing, typepath))
				organs |= thing
		if(length(organs))
			return pick(organs)

/**
 * Get a list of organ objects from the bodypart matching the passed in typepath
 *
 * Arguments:
 * * typepath The typepath of the organ to get
 */
/obj/item/bodypart/proc/getorganlist(typepath)
	var/list/organs = list()
	if(owner)
		for(var/thing in owner.getorganszone(body_zone))
			if(istype(thing, typepath))
				organs |= thing
	else
		for(var/thing in src)
			if(istype(thing, typepath))
				organs |= thing
	return organs

/**
 * Returns a random organ out of all organs in specified slot inside of the bodypart
 *
 * Arguments:
 * * slot Slot to get the organ from
 */
/obj/item/bodypart/proc/getorganslot(slot)
	if(owner)
		for(var/thing in shuffle(owner.getorganslotlist(slot)))
			var/obj/item/organ/organ = thing
			if(organ.current_zone == body_zone)
				return organ
	else
		var/list/organs = list()
		for(var/obj/item/organ/organ in src)
			if(slot in organ.organ_efficiency)
				organs |= organ
		if(length(organs))
			return pick(shuffle(organs))

/**
 * Returns a list of all organs in the specified slot inside this limb, if there are any
 *
 * Arguments:
 * * slot Slot to get the list
 */
/obj/item/bodypart/proc/getorganslotlist(slot)
	var/list/organs = list()
	if(owner)
		var/obj/item/organ/organ
		for(var/thing in owner.getorganslotlist(slot))
			organ = thing
			if(check_zone(organ.current_zone) == body_zone)
				organs |= organ
	else
		for(var/obj/item/organ/organ in src)
			if(slot in organ.organ_efficiency)
				organs |= organ
	return organs

/**
 * Returns the organ efficiency in a specific limb
 * Arguments:
 * * slot Slot to get the efficiency from
 */
/obj/item/bodypart/proc/getorganslotefficiency(slot)
	if(owner)
		return owner.getorganslotefficiencyzone(slot, body_zone)
	else
		. = null
		for(var/obj/item/organ/organ in src)
			. += organ.get_slot_efficiency(slot)

/// Returns the volume of organs and cavity items for the organ storage component to use
/obj/item/bodypart/proc/get_cavity_volume()
	. = 0
	for(var/obj/item/organ/organ as anything in get_organs())
		. += organ.organ_volume
	for(var/obj/item/item as anything in cavity_items)
		. += item.w_class


/obj/item/bodypart/proc/artery_needed()
	return CHECK_BITFIELD(limb_flags, BODYPART_HAS_ARTERY)

/obj/item/bodypart/proc/no_artery()
	return (!getorganslot(ORGAN_SLOT_ARTERY))

/obj/item/bodypart/proc/artery_missing()
	return (artery_needed() && no_artery())

/obj/item/bodypart/proc/is_artery_torn()
	. = FALSE
	for(var/obj/item/organ/artery/artery as anything in getorganslotlist(ORGAN_SLOT_ARTERY))
		if(artery.damage)
			return TRUE

/obj/item/bodypart/proc/is_artery_dissected()
	. = FALSE
	for(var/obj/item/organ/artery/artery as anything in getorganslotlist(ORGAN_SLOT_ARTERY))
		if(artery.is_broken())
			return TRUE

/obj/item/bodypart/proc/get_incision(strict = FALSE, ignore_gauze = FALSE)
	if(ignore_gauze && (bandage))
		return
	var/datum/wound/incision
	for(var/datum/wound/slash/slash in wounds)
		if(slash.is_sewn())
			continue
		incision = slash
		break

	if(!incision)
		var/datum/injury/internal_incision
		for(var/datum/injury/slash/slash in injuries)
			if(slash.is_bandaged() || slash.current_stage > slash.max_bleeding_stage) // Shit's unusable
				continue
			if(strict && !slash.is_surgical()) //We don't need dirty ones
				continue
			if(!internal_incision)
				internal_incision = slash
				continue
			if(slash.is_surgical() && internal_incision.is_surgical()) //If they're both dirty or both are surgical, just get bigger one
				if(slash.damage > internal_incision.damage)
					internal_incision = slash
					break
			else if(slash.is_surgical()) //otherwise surgical one takes priority
				internal_incision = slash
				break
		return internal_incision
	return incision


/obj/item/bodypart/proc/is_bandaged()
	. = TRUE
	for(var/datum/injury/injury in injuries)
		if(!injury.is_bandaged())
			return FALSE

/obj/item/bodypart/proc/is_salved()
	. = TRUE
	for(var/datum/injury/injury in injuries)
		if(!injury.is_salved())
			return FALSE

/obj/item/bodypart/proc/is_disinfected()
	. = TRUE
	for(var/datum/injury/injury in injuries)
		if(!injury.is_disinfected())
			return FALSE


/obj/item/bodypart/proc/is_clamped()
	. = TRUE
	for(var/datum/injury/injury in injuries)
		if(!injury.is_clamped())
			return FALSE

/obj/item/bodypart/proc/clamp_limb()
	for(var/datum/injury/injury as anything in injuries)
		injury.clamp_injury()

/obj/item/bodypart/proc/unclamp_limb()
	for(var/datum/injury/injury as anything in injuries)
		injury.unclamp_injury()

/obj/item/bodypart/proc/suture_limb()
	for(var/datum/injury/injury as anything in injuries)
		injury.suture_injury()

/obj/item/bodypart/proc/unsuture_limb()
	for(var/datum/injury/injury as anything in injuries)
		injury.unsuture_injury()

/obj/item/bodypart/proc/salve_limb()
	for(var/datum/injury/injury as anything in injuries)
		injury.salve_injury()

/obj/item/bodypart/proc/unsalve_limb()
	for(var/datum/injury/injury as anything in injuries)
		injury.unsalve_injury()

/obj/item/bodypart/proc/disinfect_limb(time)
	for(var/datum/injury/injury as anything in injuries)
		injury.disinfect_injury()
	if(time)
		disinfects_in = addtimer(CALLBACK(src, PROC_REF(undisinfect_limb)), time, TIMER_STOPPABLE)

/obj/item/bodypart/proc/undisinfect_limb()
	for(var/datum/injury/injury as anything in injuries)
		injury.undisinfect_injury()

/obj/item/bodypart/proc/bandage_limb()
	for(var/datum/injury/injury as anything in injuries)
		injury.bandage_injury()

/obj/item/bodypart/proc/unbandage_limb()
	for(var/datum/injury/injury as anything in injuries)
		injury.unbandage_injury()
