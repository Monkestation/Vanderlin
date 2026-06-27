/// Allow brute healing operation
#define BRUTE_SURGERY (1<<0)
/// Allow burn healing operation
#define BURN_SURGERY (1<<1)
/// Allow combo healing operation
#define COMBO_SURGERY (1<<2)

/datum/surgery_operation/basic/tend_wounds
	name = "Tend Wounds"
	desc = "Perform superficial wound care on a patient's bruises and burns."
	operation_flags = OPERATION_LOOPING | OPERATION_IGNORE_CLOTHES

	implements = list(
		TOOL_SUTURE = 1,
		TOOL_HEMOSTAT = 1.25,
		TOOL_IMPROVISED_HEMOSTAT = 1.40,
		/obj/item/natural/feather = 1.8,
	)

	time = 2.5 SECONDS

	skill_min = SKILL_LEVEL_NOVICE
	skill_median = SKILL_LEVEL_JOURNEYMAN

	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

	required_biotype = MOB_ORGANIC|MOB_HUMANOID

	any_surgery_states_required = ALL_SURGERY_SKIN_STATES|SURGERY_VESSELS_CLAMPED

	/// Radial slice datums for every healing option we can provide
	VAR_PRIVATE/list/cached_healing_options

	/// Bitflag of which healing types this operation can perform
	var/can_heal = BRUTE_SURGERY | BURN_SURGERY
	/// Flat amount of healing done per operation
	var/healing_amount = 5
	/// The amount of damage healed scales based on how much damage the patient has times this multiplier
	var/healing_multiplier = 0.07

/datum/surgery_operation/basic/tend_wounds/all_required_strings()
	return ..() + list("the patient must have brute or burn damage")

/datum/surgery_operation/basic/tend_wounds/state_check(mob/living/patient)
	if(!iscarbon(patient))
		return patient.getBruteLoss() > 0 || patient.getFireLoss() > 0

	var/mob/living/carbon/carbon_patient = patient
	for(var/datum/injury/injury as anything in carbon_patient.all_injuries)
		if(injury.required_status != required_bodytype)
			continue
		if(!injury.can_heal() || injury.is_surgical())
			continue
		if(injury.damage_type & BRUTE_WOUND_TYPES|FIRE_WOUND_TYPES)
			return TRUE

	return FALSE

/datum/surgery_operation/basic/tend_wounds/get_default_radial_image()
	return image(/obj/item/natural/cloth)

/datum/surgery_operation/basic/tend_wounds/proc/check_for_injuries(mob/living/carbon/patient, brute_check, burn_check)
	if(!istype(patient))
		return (brute_check && patient.getBruteLoss() > 0 || burn_check && patient.getFireLoss() > 0)
	var/brute_found = FALSE
	var/burn_found = FALSE
	var/mob/living/carbon/carbon_patient = patient
	for(var/datum/injury/injury as anything in carbon_patient.all_injuries)
		if((!brute_check || brute_found) && (!burn_check || burn_found))
			break
		if(injury.required_status != required_bodytype)
			continue
		if(!injury.can_heal() || injury.is_surgical())
			continue
		if(brute_check && injury.damage_type & BRUTE_WOUND_TYPES)
			brute_found = TRUE
		if(burn_check && injury.damage_type & FIRE_WOUND_TYPES)
			burn_found = TRUE
	return (brute_check && brute_found) || (burn_check && burn_found)

/datum/surgery_operation/basic/tend_wounds/get_radial_options(mob/living/patient, obj/item/tool, operating_zone)
	var/list/options = list()

	if(can_heal & COMBO_SURGERY)
		var/datum/radial_menu_choice/all_healing = LAZYACCESS(cached_healing_options, "[COMBO_SURGERY]")
		if(!all_healing)
			all_healing = new()
			all_healing.image = image(/obj/item/natural/cloth/bandage)
			all_healing.name = "Advanced Tend Bruises and Burns"
			all_healing.info = "Heal a patient's superficial bruises, cuts, and burns."
			LAZYSET(cached_healing_options, "[COMBO_SURGERY]", all_healing)

		options[all_healing] = list(
			"[OPERATION_ACTION]" = "heal",
			"[OPERATION_BRUTE_HEAL]" = healing_amount,
			"[OPERATION_BURN_HEAL]" = healing_amount,
			"[OPERATION_BRUTE_MULTIPLIER]" = healing_multiplier,
			"[OPERATION_BURN_MULTIPLIER]" = healing_multiplier,
		)

	if((can_heal & BRUTE_SURGERY) && check_for_injuries(patient, TRUE, FALSE))
		var/datum/radial_menu_choice/brute_healing = LAZYACCESS(cached_healing_options, "[BRUTE_SURGERY]")
		if(!brute_healing)
			brute_healing = new()
			brute_healing.image = image(/obj/item/needle)
			brute_healing.name = "Tend Bruises"
			brute_healing.info = "Heal a patient's superficial bruises and cuts."
			LAZYSET(cached_healing_options, "[BRUTE_SURGERY]", brute_healing)

		options[brute_healing] = list(
			"[OPERATION_ACTION]" = "heal",
			"[OPERATION_BRUTE_HEAL]" = healing_amount,
			"[OPERATION_BRUTE_MULTIPLIER]" = healing_multiplier,
		)

	if((can_heal & BURN_SURGERY) && check_for_injuries(patient, FALSE, TRUE))
		var/datum/radial_menu_choice/burn_healing = LAZYACCESS(cached_healing_options, "[BURN_SURGERY]")
		if(!burn_healing)
			burn_healing = new()
			burn_healing.image = image(/obj/item/natural/cloth)
			burn_healing.name = "Tend Burns"
			burn_healing.info = "Heal a patient's superficial burns."
			LAZYSET(cached_healing_options, "[BURN_SURGERY]", burn_healing)

		options[burn_healing] = list(
			"[OPERATION_ACTION]" = "heal",
			"[OPERATION_BURN_HEAL]" = healing_amount,
			"[OPERATION_BURN_MULTIPLIER]" = healing_multiplier,
		)

	return options

/datum/surgery_operation/basic/tend_wounds/can_loop(mob/living/patient, mob/living/operating_on, mob/living/surgeon, tool, list/operation_args)
	. = ..()
	if(!.)
		return FALSE

	var/brute_heal = operation_args[OPERATION_BRUTE_HEAL] > 0
	var/burn_heal = operation_args[OPERATION_BURN_HEAL] > 0
	if(!iscarbon(patient))
		return (brute_heal && patient.getBruteLoss() > 0) || (burn_heal && patient.getFireLoss() > 0)

	return check_for_injuries(patient, brute_heal, burn_heal)

/datum/surgery_operation/basic/tend_wounds/on_preop(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	var/woundtype
	var/brute_heal = operation_args[OPERATION_BRUTE_HEAL] > 0
	var/burn_heal = operation_args[OPERATION_BURN_HEAL] > 0
	if(brute_heal && burn_heal)
		woundtype = "wounds"
	else if(brute_heal)
		woundtype = "bruises"
	else //why are you trying to 0,0...?
		woundtype = "burns"
	display_results(
		surgeon,
		patient,
		span_notice("You attempt to patch some of [patient]'s [woundtype]."),
		span_notice("[surgeon] attempts to patch some of [patient]'s [woundtype]."),
		span_notice("[surgeon] attempts to patch some of [patient]'s [woundtype]."),
	)
	display_pain(patient, "My [woundtype] sting like hell!")

#define CONDITIONAL_DAMAGE_MESSAGE(brute, burn, combo_msg, brute_msg, burn_msg) "[(brute > 0 && burn > 0) ? combo_msg : (brute > 0 ? brute_msg : burn_msg)]"

/// Returns a string letting the surgeon know roughly how much longer the surgery is estimated to take at the going rate
/datum/surgery_operation/basic/tend_wounds/proc/get_progress(mob/living/surgeon, mob/living/patient, brute_healed, burn_healed)
	var/estimated_remaining_steps = 0
	if(brute_healed > 0)
		estimated_remaining_steps = max(0, (patient.getBruteLoss() / brute_healed))
	if(burn_healed > 0)
		estimated_remaining_steps = max(estimated_remaining_steps, (patient.getFireLoss() / burn_healed)) // whichever is higher between brute or burn steps

	var/progress_text

	switch(estimated_remaining_steps)
		if(-INFINITY to 1)
			return
		if(1 to 3)
			progress_text += ", finishing up the last few [CONDITIONAL_DAMAGE_MESSAGE(brute_healed, burn_healed, "signs of damage", "scrapes", "burn marks")]"
		if(3 to 6)
			progress_text += ", counting down the last few [CONDITIONAL_DAMAGE_MESSAGE(brute_healed, burn_healed, "patches of trauma", "bruises", "blisters")] left to treat"
		if(6 to 9)
			progress_text += ", continuing to plug away at [patient.p_their()] extensive [CONDITIONAL_DAMAGE_MESSAGE(brute_healed, burn_healed, "injuries", "rupturing", "roasting")]"
		if(9 to 12)
			progress_text += ", steadying yourself for the long surgery ahead"
		if(12 to 15)
			progress_text += ", though [patient.p_they()] still look[patient.p_s()] more like [CONDITIONAL_DAMAGE_MESSAGE(brute_healed, burn_healed, "smooshed baby food", "ground beef", "burnt steak")] than a person"
		if(15 to INFINITY)
			progress_text += ", though you feel like you're barely making a dent in treating [patient.p_their()] [CONDITIONAL_DAMAGE_MESSAGE(brute_healed, burn_healed, "broken", "pulped", "charred")] body"

	return progress_text

#undef CONDITIONAL_DAMAGE_MESSAGE

/datum/surgery_operation/basic/tend_wounds/on_success(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	var/user_msg = "You succeed in fixing some of [patient]'s wounds" //no period, add initial space to "addons"
	var/target_msg = "[surgeon] fixes some of [patient]'s wounds" //see above

	var/brute_healed = operation_args[OPERATION_BRUTE_HEAL]
	var/burn_healed = operation_args[OPERATION_BURN_HEAL]

	var/dead_multiplier = patient.stat == DEAD ? 0.5 : 1.0
	var/accessibility_modifier = 1.0
	if(!patient.is_location_accessible(BODY_ZONE_CHEST, IGNORED_OPERATION_CLOTHING_SLOTS))
		accessibility_modifier = 0.55
		user_msg += " as best as you can while [patient.p_they()] [patient.p_have()] clothing on"
		target_msg += " as best as [surgeon.p_they()] can while [patient.p_they()] [patient.p_have()] clothing on"

	var/skill_modifier = 1.0
	switch(GET_MOB_SKILL_VALUE(surgeon, skill_used))
		if(SKILL_LEVEL_JOURNEYMAN)
			skill_modifier = 1.1
		if(SKILL_LEVEL_EXPERT)
			skill_modifier = 1.3
		if(SKILL_LEVEL_MASTER)
			skill_modifier = 1.4
		if(SKILL_LEVEL_LEGENDARY)
			skill_modifier = 1.5

	var/brute_multiplier = operation_args[OPERATION_BRUTE_MULTIPLIER] * dead_multiplier * accessibility_modifier * skill_modifier
	var/burn_multiplier = operation_args[OPERATION_BURN_MULTIPLIER] * dead_multiplier * accessibility_modifier * skill_modifier

	brute_healed += round(patient.getBruteLoss() * brute_multiplier, DAMAGE_PRECISION)
	burn_healed += round(patient.getFireLoss() * burn_multiplier, DAMAGE_PRECISION)

	if(!iscarbon(patient))
		patient.heal_bodypart_damage(brute_healed, burn_healed, required_status = required_bodytype)
	else
		var/brute_heal_left = brute_healed
		var/burn_heal_left = burn_healed
		var/mob/living/carbon/carbon_patient = patient
		for(var/datum/injury/injury as anything in carbon_patient.all_injuries)
			if(brute_heal_left <= 0 && burn_heal_left <= 0)
				break
			if(injury.required_status != required_bodytype)
				continue
			if(!injury.can_heal() || injury.is_surgical())
				continue

			// Use injury.heal_damage() instead of heal_bodypart_damage() to return the amount of healing left over
			if(brute_heal_left && injury.damage_type & BRUTE_WOUND_TYPES)
				brute_heal_left = injury.heal_damage(brute_heal_left, TRUE, TRUE)
			if(burn_heal_left && injury.damage_type & FIRE_WOUND_TYPES)
				burn_heal_left = injury.heal_damage(burn_heal_left, TRUE, TRUE)

	SEND_SIGNAL(surgeon, COMSIG_LIVING_HEALED_OTHER, brute_healed + burn_healed)
	user_msg += get_progress(surgeon, patient, brute_healed, burn_healed)

	display_results(
		surgeon,
		patient,
		span_notice("[user_msg]."),
		span_notice("[target_msg]."),
		span_notice("[target_msg]."),
	)

/datum/surgery_operation/basic/tend_wounds/on_failure(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		patient,
		span_warning("You screwed up!"),
		span_warning("[surgeon] screws up!"),
		span_notice("[surgeon] fixes some of [patient]'s wounds."),
		target_detailed = TRUE,
	)

	var/brute_dealt = operation_args[OPERATION_BRUTE_HEAL] * 0.8
	var/burn_dealt = operation_args[OPERATION_BURN_HEAL] * 0.8
	var/brute_multiplier = operation_args[OPERATION_BRUTE_MULTIPLIER] * 0.5
	var/burn_multiplier = operation_args[OPERATION_BURN_MULTIPLIER] * 0.5

	brute_dealt += round(patient.getBruteLoss() * brute_multiplier, DAMAGE_PRECISION)
	burn_dealt += round(patient.getFireLoss() * burn_multiplier, DAMAGE_PRECISION)

	if(!iscarbon(patient))
		patient.take_bodypart_damage(brute_dealt, burn_dealt)
		return

	var/mob/living/carbon/carbon_patient = patient
	var/list/obj/item/bodypart/parts = carbon_patient.get_damageable_bodyparts(required_bodytype)
	if(!length(parts))
		return

	var/obj/item/bodypart/picked = pick(parts)
	picked.bodypart_attacked_by(BCLASS_CUT, burn_dealt + brute_dealt, surgeon, modifiers = list(CRIT_MOD_CHANCE = -100))

/datum/surgery_operation/basic/tend_wounds/combo
	name = "Advanced Tend Wounds"

	time = 1 SECONDS

	skill_min = SKILL_LEVEL_JOURNEYMAN
	skill_median = SKILL_LEVEL_EXPERT

	can_heal = COMBO_SURGERY
	healing_amount = 3

#undef BRUTE_SURGERY
#undef BURN_SURGERY
#undef COMBO_SURGERY
