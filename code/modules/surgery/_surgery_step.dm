/datum/surgery_step
	/// Name of the surgery step
	var/name
	/// Description of the surgery step
	var/desc
	/// Typepaths or tool behaviors that can be used to perform this surgery step, associated to success chance
	var/list/implements = list()
	/// Typepaths or tool behaviors that can be used to perform this surgery step, associated to speed modification
	var/list/implements_speed = list()
	/// Does the surgery step accept open hand? If true, ignores implements. Compatible with accept_any_item.
	var/accept_hand = FALSE
	/// Does the surgery step accept any item? If true, ignores implements. Compatible with accept_hand.
	var/accept_any_item = FALSE

	/// Best case scenario time for this step
	var/minimum_time = 10
	/// Worst case scenario time for this step
	var/maximum_time = 20
	/// Random surgery flags that mostly indicate additional requirements
	var/surgery_flags = SURGERY_BLOODY | SURGERY_INCISED
	/// Random surgery flags blocking certain flags
	var/surgery_flags_blocked = NONE
	/// Intents that can be used to perform this surgery step
	var/list/possible_intents
	/// Body zones this surgery can be performed on, set to null for everywhere
	var/list/possible_locs
	/// Does this step require a non-missing bodypart? Incompatible with requires_missing_bodypart
	var/requires_bodypart = TRUE
	/// Does this step require the bodypart to be missing? (Limb attachment)
	var/requires_missing_bodypart = FALSE
	/// If true, this surgery step cannot be done on pseudo limbs (like chainsaw arms)
	var/requires_real_bodypart = TRUE
	/// What type of bodypart we require, in case requires_bodypart
	var/requires_bodypart_type = BODYPART_ORGANIC
	/// Some surgeries require specific organs to be present in the patient
	var/list/required_organs
	/**
	 * list of chems needed to complete the step.
	 * Even on success, the step will have no effect if there aren't the chems required in the mob.
	 */
	var/list/chems_needed
	/// Any chem on the list required, or all of them?
	var/require_all_chems = TRUE
	/// This surgery ignores clothes on the targeted bodypart
	var/ignore_clothes = FALSE
	/// Does the patient need to be lying down?
	var/lying_required = FALSE
	/// Does this step allow self surgery?
	var/self_operable = TRUE
	/// Acceptable mob types for this surgery
	var/list/target_mobtypes = list(/mob/living/carbon, /mob/living/simple_animal)

	/// Skill used to perform this surgery step
	var/datum/attribute/skill/skill_used = /datum/attribute/skill/misc/medicine
	/// Necessary skill MINIMUM to perform this surgery step, of skill_used
	var/skill_min = SKILL_LEVEL_NOVICE
	/// Skill median used to apply success and speed bonuses
	var/skill_median = SKILL_LEVEL_JOURNEYMAN

	/// Requirement threshold for the diceroll as a baseline
	var/dice_requirement = 25
	/// Crit window for the diceroll
	var/dice_crit = 8
	/// Number of dice rolled
	var/dice_num = 3
	/// Sides per die
	var/dice_sides = 20

	/**
	 * type; doesn't show up if this type exists.
	 * Set to /datum/surgery_step if you want to hide a "base" surgery  (useful for typing parents IE healing.dm just make sure to null it out again)
	 */
	var/replaced_by
	/// Repeatable surgery steps will repeat until failure
	var/repeating = FALSE
	var/preop_sound //Sound played when the step is started
	var/success_sound //Sound played if the step succeeded
	var/failure_sound //Sound played if the step fails

/datum/surgery_step/proc/can_do_step(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, try_to_fail = FALSE)
	if(!user || !target)
		return FALSE
	if(!user.Adjacent(target))
		return FALSE
	if(!tool_check(user, tool))
		return FALSE
	if(!validate_user(user, target, target_zone, intent))
		return FALSE
	if(!validate_target(user, target, target_zone, intent))
		return FALSE

	return TRUE

/datum/surgery_step/proc/validate_user(mob/user, mob/living/target, target_zone, datum/intent/intent)
	SHOULD_CALL_PARENT(TRUE)
	if(possible_locs && !(target_zone in possible_locs))
		return FALSE
	if(possible_intents)
		var/found_intent = FALSE
		for(var/possible_intent in possible_intents)
			if(istype(intent, possible_intent))
				found_intent = TRUE
				break
		if(!found_intent)
			return FALSE
	if(skill_used && skill_min && (GET_MOB_SKILL_VALUE(user, skill_used) < skill_min))
		return FALSE
	return TRUE

/datum/surgery_step/proc/validate_target(mob/user, mob/living/target, target_zone, datum/intent/intent)
	SHOULD_CALL_PARENT(TRUE)
	if(!self_operable && (user == target))
		return FALSE

	if(target_mobtypes)
		var/valid_mobtype = FALSE
		for(var/mobtype in target_mobtypes)
			if(istype(target, mobtype))
				valid_mobtype = TRUE
				break
		if(!valid_mobtype)
			return FALSE

	if(lying_required && target.body_position != LYING_DOWN)
		return FALSE

	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		var/obj/item/bodypart/bodypart = carbon_target.get_bodypart(check_zone(target_zone))
		if(!validate_bodypart(user, target, bodypart, target_zone))
			return FALSE
		for(var/required_organ in required_organs)
			var/obj/item/organ/organ = carbon_target.getorganslot(required_organ)
			if(!organ)
				return FALSE

	//no surgeries in the same body zone
	if(target_zone && LAZYACCESS(target.surgeries, target_zone))
		return FALSE

	return TRUE

/datum/surgery_step/proc/validate_bodypart(mob/user, mob/living/carbon/target, obj/item/bodypart/bodypart, target_zone)
	SHOULD_CALL_PARENT(TRUE)
	if(requires_bodypart && !bodypart)
		return FALSE
	else if(!requires_bodypart)
		if(requires_missing_bodypart && bodypart)
			return FALSE
		return TRUE

	if(requires_bodypart_type && (bodypart.status != requires_bodypart_type))
		return FALSE

	var/bodypart_flags = bodypart.get_surgery_flags()
	if((surgery_flags & bodypart_flags) != surgery_flags)
		return FALSE
	if((surgery_flags_blocked & bodypart_flags))
		return FALSE

	/*
	if(user == target)
		var/obj/item/bodypart/active_hand = user.get_active_hand()
		if(active_hand)
			var/static/list/r_hand_zones = list(BODY_ZONE_R_ARM, BODY_ZONE_PRECISE_R_HAND)
			var/static/list/l_hand_zones = list(BODY_ZONE_L_ARM, BODY_ZONE_PRECISE_L_HAND)
			if((active_hand?.body_zone in r_hand_zones) && (bodypart.body_zone in r_hand_zones))
				return FALSE
			if((active_hand?.body_zone in l_hand_zones) && (bodypart.body_zone in l_hand_zones))
				return FALSE
	*/

	if(!ignore_clothes && !get_location_accessible(target, target_zone || bodypart.body_zone))
		return FALSE

	return TRUE

/datum/surgery_step/proc/tool_check(mob/user, obj/item/tool)
	SHOULD_CALL_PARENT(TRUE)
	var/implement_type = FALSE
	if(accept_hand && (!tool))
		implement_type = TOOL_HAND

	if(tool)
		for(var/key in implements)
			if(ispath(key) && istype(tool, key))
				implement_type = key
				break
			if(tool.tool_behaviour == key)
				implement_type = key
				break
			if((key == TOOL_SHARP) && tool.get_sharpness())
				implement_type = key
				break
			if((key == TOOL_HOT) && (tool.get_temperature() >= 100+T0C))
				implement_type = key
				break

		if(!implement_type && accept_any_item)
			implement_type = TOOL_NONE

	return implement_type

/datum/surgery_step/proc/chem_check(mob/living/target)
	if(!LAZYLEN(chems_needed))
		return TRUE

	if(require_all_chems)
		for(var/reagent_needed in chems_needed)
			if(!target.has_reagent(reagent_needed))
				return FALSE
		return TRUE

	for(var/reagent_needed in chems_needed)
		if(target.has_reagent(reagent_needed))
			return TRUE

	return FALSE

/// Returns a string of the chemicals needed for this surgery step
/datum/surgery_step/proc/get_chem_string()
	if(!LAZYLEN(chems_needed))
		return
	var/list/chems = list()
	for(var/R in chems_needed)
		var/datum/reagent/temp = GLOB.chemical_reagents_list[R]
		if(temp)
			var/chemname = temp.name
			chems += chemname
	return english_list(chems, and_text = require_all_chems ? " and " : " or ")

/datum/surgery_step/proc/try_op(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, try_to_fail = FALSE)
	if(!can_do_step(user, target, target_zone, tool, intent, try_to_fail))
		return FALSE

	initiate(user, target, target_zone, tool, intent, try_to_fail)
	return TRUE	//returns TRUE so we don't stab the guy in the dick or wherever.

/datum/surgery_step/proc/initiate(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, try_to_fail = FALSE)
	LAZYSET(target.surgeries, target_zone, src)
	//var/obj/item/bodypart/affecting = target.get_bodypart(target_zone)
	if(!preop(user, target, target_zone, tool, intent))
		LAZYREMOVE(target.surgeries, target_zone)
		return FALSE

	play_preop_sound(user, target, target_zone, tool)

	var/speed_mod = get_speed_modifier(user, target, target_zone, tool, intent)

	var/modded_min = round(minimum_time * speed_mod, 1)
	var/modded_max = round(maximum_time * speed_mod, 1)
	var/final_time = rand(modded_min, modded_max)

	if(!do_after(user, final_time, target))
		LAZYREMOVE(target.surgeries, target_zone)
		return FALSE

	LAZYREMOVE(target.surgeries, target_zone)

	var/roll_result = DICE_FAILURE
	var/roll_requirement
	if(!try_to_fail)
		roll_requirement = get_roll_requirement(user, target, target_zone, tool, intent)
		roll_result = user.diceroll(
			requirement = roll_requirement,
			crit = dice_crit,
			dice_num = dice_num,
			dice_sides = dice_sides,
		)

	var/chem_ok = chem_check(target)

	//spread_germs_to_bodypart(affecting, user, tool)

	switch(roll_result)
		if(DICE_CRIT_SUCCESS)
			if(!chem_ok)
				// chems missing: degrade to normal failure path even on crit
				if(failure(user, target, target_zone, tool, intent))
					play_failure_sound(user, target, target_zone, tool)
					display_roll(user, "CRIT SUCCESS (chem fail)", roll_requirement)
					if(repeating && can_do_step(user, target, target_zone, tool, intent, try_to_fail))
						initiate(user, target, target_zone, tool, intent, try_to_fail)
				return FALSE
			if(crit_success(user, target, target_zone, tool, intent))
				add_surgery_xp(user)
				play_success_sound(user, target, target_zone, tool)
				display_roll(user, "CRIT SUCCESS", roll_requirement)
				if(repeating && can_do_step(user, target, target_zone, tool, intent, try_to_fail))
					initiate(user, target, target_zone, tool, intent, try_to_fail)
				return TRUE
			return FALSE

		if(DICE_SUCCESS)
			if(!chem_ok)
				if(failure(user, target, target_zone, tool, intent))
					play_failure_sound(user, target, target_zone, tool)
					display_roll(user, "SUCCESS (chem fail)", roll_requirement)
					if(repeating && can_do_step(user, target, target_zone, tool, intent, try_to_fail))
						initiate(user, target, target_zone, tool, intent, try_to_fail)
				return FALSE
			if(success(user, target, target_zone, tool, intent))
				add_surgery_xp(user)
				play_success_sound(user, target, target_zone, tool)
				display_roll(user, "SUCCESS", roll_requirement)
				if(repeating && can_do_step(user, target, target_zone, tool, intent, try_to_fail))
					initiate(user, target, target_zone, tool, intent, try_to_fail)
				return TRUE
			return FALSE

		if(DICE_CRIT_FAILURE)
			if(crit_failure(user, target, target_zone, tool, intent))
				play_failure_sound(user, target, target_zone, tool)
				display_roll(user, "CRIT FAILURE", roll_requirement)
				if(repeating && can_do_step(user, target, target_zone, tool, intent, try_to_fail))
					initiate(user, target, target_zone, tool, intent, try_to_fail)
			return FALSE

		else // DICE_FAILURE or try_to_fail
			if(failure(user, target, target_zone, tool, intent))
				play_failure_sound(user, target, target_zone, tool)
				display_roll(user, try_to_fail ? "INTENTIONAL FAIL" : "FAILURE", try_to_fail ? null : roll_requirement)
				if(repeating && can_do_step(user, target, target_zone, tool, intent, try_to_fail))
					initiate(user, target, target_zone, tool, intent, try_to_fail)
			return FALSE

/datum/surgery_step/proc/get_roll_requirement(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/requirement = dice_requirement

	if(skill_used)
		var/skill_level = GET_MOB_SKILL_VALUE(user, skill_used) || 0
		var/skill_delta = (skill_level - skill_median) * 0.5
		requirement += skill_delta

	if(implements)
		var/implement_type = tool_check(user, tool)
		if(implement_type)
			var/tool_chance = implements[implement_type] || 100
			requirement += round((100 - tool_chance) / 100 * 6, 1)

	var/loc_mod = get_location_modifier(target)
	requirement += round((loc_mod - 1) * 8, 1)

	var/overseer_bonus = get_overseer_bonus(user, target, target_zone)
	requirement += overseer_bonus
	if(overseer_bonus > 0)
		to_chat(user, span_notice("You feel more confident with an experienced eye watching over you."))

	return FLOOR(clamp(requirement, dice_num, dice_num * dice_sides), 1)

/datum/surgery_step/proc/get_overseer_bonus(mob/user, mob/living/target, target_zone)
	var/best_bonus = 0
	for(var/mob/living/carbon/human/nearby in view(3, user))
		if(nearby == user)
			continue
		if(nearby.stat != CONSCIOUS)
			continue
		var/overseer_skill = GET_MOB_SKILL_VALUE(nearby, /datum/attribute/skill/misc/medicine)
		if(overseer_skill <= skill_median)
			continue
		if(overseer_skill <= GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/misc/medicine))
			continue
		var/bonus = (overseer_skill - skill_median) * 0.25
		if(bonus > best_bonus)
			best_bonus = bonus
	return best_bonus

/datum/surgery_step/proc/add_surgery_xp(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/doctor = user
	user.mind.add_sleep_experience(/datum/attribute/skill/misc/medicine, GET_MOB_ATTRIBUTE_VALUE(doctor, STAT_INTELLIGENCE) * (skill_min / 3))

/datum/surgery_step/proc/display_roll(mob/user, result_label, requirement)
	if(!user.client?.prefs.showrolls)
		return
	if(requirement != null)
		to_chat(user, span_warning("[result_label] (requirement was [requirement]/[dice_num * dice_sides])"))
	else
		to_chat(user, span_warning("[result_label]"))

/datum/surgery_step/proc/crit_success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	return success(user, target, target_zone, tool, intent)

/datum/surgery_step/proc/crit_failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	return failure(user, target, target_zone, tool, intent)

/datum/surgery_step/proc/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, "<span class='notice'>I begin to perform surgery on [target]...</span>",
		"<span class='notice'>[user] begins to perform surgery on [target].</span>",
		"<span class='notice'>[user] begins to perform surgery on [target].</span>")
	return TRUE

/datum/surgery_step/proc/play_preop_sound(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(!preop_sound)
		return
	var/sound_file_use
	if(islist(preop_sound))
		for(var/typepath in preop_sound)//iterate and assign subtype to a list, works best if list is arranged from subtype first and parent last
			if(istype(tool, typepath))
				sound_file_use = preop_sound[typepath]
				break
	else
		sound_file_use = preop_sound
	playsound(target, sound_file_use, 75, TRUE, -2)

/datum/surgery_step/proc/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, "<span class='notice'>I succeed.</span>",
		"<span class='notice'>[user] succeeds!</span>",
		"<span class='notice'>[user] finishes.</span>")
	return TRUE

/datum/surgery_step/proc/play_success_sound(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(!success_sound)
		return
	playsound(target, success_sound, 75, TRUE, -2)

/datum/surgery_step/proc/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, success_prob)
	display_results(user, target, "<span class='warning'>I screw up!</span>",
		"<span class='warning'>[user] screws up!</span>",
		"<span class='notice'>[user] finishes.</span>", TRUE) //By default the patient will notice if the wrong thing has been cut
	return TRUE

/datum/surgery_step/proc/play_failure_sound(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(!failure_sound)
		return
	playsound(target, failure_sound, 75, TRUE, -2)

/// Replaces visible_message during operations so only people looking over the surgeon can tell what they're doing, allowing for shenanigans.
/datum/surgery_step/proc/display_results(mob/user, mob/living/carbon/target, self_message, detailed_message, vague_message, target_detailed = FALSE)
	var/list/detailed_mobs = get_hearers_in_view(1, user) //Only the surgeon and people looking over his shoulder can see the operation clearly
	if(!target_detailed)
		detailed_mobs -= target //The patient can't see well what's going on, unless it's something like getting cut
	user.visible_message(detailed_message, self_message, vision_distance = 1, ignored_mobs = target_detailed ? null : target)
	user.visible_message(vague_message, "", ignored_mobs = detailed_mobs)
	return TRUE

/datum/surgery_step/proc/get_speed_modifier(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/speed_mod = 1
	if(tool)
		speed_mod *= tool.toolspeed
	if(implements_speed)
		var/implement_type = tool_check(user, tool)
		if(implement_type)
			speed_mod *= implements_speed[implement_type] || 1
	speed_mod *= get_location_modifier(target)

	return speed_mod

/datum/surgery_step/proc/get_location_modifier(mob/living/target)
	var/turf/patient_turf = get_turf(target)
	var/is_lying = (target.body_position == LYING_DOWN)
	if(!is_lying)
		return 0.6
	if(locate(/obj/structure/table/optable) in patient_turf)
		return 1.1
	if(locate(/obj/structure/bed) in patient_turf)
		return 1
	else if(locate(/obj/structure/table) in patient_turf)
		return 0.8
	return 0.7
	/*
	if(locate(/obj/structure/table/optable) in patient_turf)
		return 1
	else if(locate(/obj/machinery/stasis) in patient_turf)
		return 0.9
	else if(locate(/obj/structure/table) in patient_turf)
		return 0.8
	else if(locate(/obj/structure/bed) in patient_turf)
		return 0.7
	return 0.5
	*/
