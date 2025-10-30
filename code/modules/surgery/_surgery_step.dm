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
	/// Silicons will ignore the probability of success and always succeed
	var/silicons_obey_prob = FALSE

	/// How long does the step take for someone with average skill and an average tool?
	var/time = 1 SECONDS
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
	var/datum/skill/skill_used = /datum/skill/misc/medicine
	/// Necessary skill MINIMUM to perform this surgery step, of skill_used
	var/skill_min = SKILL_LEVEL_NOVICE
	/// Skill median used to apply success and speed bonuses
	var/skill_median = SKILL_LEVEL_JOURNEYMAN
	/// Modifiers to success chance when you're above the median
	var/list/skill_bonuses = list(
		1 = 0.2,
		2 = 0.4,
		3 = 0.6,
		4 = 0.8,
		5 = 1,
		6 = 2,
	)
	/// Modifiers to success chance when you're below the median
	var/list/skill_maluses = list(
		1 = -0.2,
		2 = -0.4,
		3 = -0.6,
		4 = -0.8,
		5 = -1,
		6 = -2,
	)

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
	if(skill_used && skill_min && (user.get_skill_level(skill_used) < skill_min))
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
			if(!target.reagents.has_reagent(reagent_needed))
				return FALSE
		return TRUE

	for(var/reagent_needed in chems_needed)
		if(target.reagents.has_reagent(reagent_needed))
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
	if(!preop(user, target, target_zone, tool, intent))
		LAZYREMOVE(target.surgeries, target_zone)
		return FALSE

	play_preop_sound(user, target, target_zone, tool) // Here because most steps overwrite preop

	var/speed_mod = get_speed_modifier(user, target, target_zone, tool, intent)
	var/success_prob = max(get_success_probability(user, target, target_zone, tool, intent), 0)

	var/modded_time = round(time * speed_mod, 1)
	if(!do_after(user, modded_time, target))
		LAZYREMOVE(target.surgeries, target_zone)
		return FALSE

	LAZYREMOVE(target.surgeries, target_zone)
	var/success = !try_to_fail && (prob(success_prob)) && chem_check(target)
	if(success && success(user, target, target_zone, tool, intent))
		if(ishuman(user))
			var/mob/living/carbon/human/doctor = user
			user.mind.add_sleep_experience(/datum/skill/misc/medicine, doctor.STAINT * (skill_min/3))
		play_success_sound(user, target, target_zone, tool)
		if(repeating && can_do_step(user, target, target_zone, tool, intent, try_to_fail))
			initiate(user, target, target_zone, tool, intent, try_to_fail)
		return TRUE
	else if(failure(user, target, target_zone, tool, intent, success_prob))
		play_failure_sound(user, target, target_zone, tool)
		if(user.client?.prefs.showrolls)
			if(try_to_fail)
				to_chat(user, span_warning("Intentional surgery fail, the chance to succeed was [success_prob]%"))
			else
				to_chat(user, span_warning("Surgery fail, the chance to succeed was [success_prob]%"))
		if(repeating && can_do_step(user, target, target_zone, tool, intent, try_to_fail))
			initiate(user, target, target_zone, tool, intent, try_to_fail)
		return FALSE

	return FALSE

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
	playsound(get_turf(target), sound_file_use, 75, TRUE, -2)

/datum/surgery_step/proc/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, "<span class='notice'>I succeed.</span>",
		"<span class='notice'>[user] succeeds!</span>",
		"<span class='notice'>[user] finishes.</span>")
	return TRUE

/datum/surgery_step/proc/play_success_sound(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(!success_sound)
		return
	playsound(get_turf(target), success_sound, 75, TRUE, -2)

/datum/surgery_step/proc/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, success_prob)
	display_results(user, target, "<span class='warning'>I screw up!</span>",
		"<span class='warning'>[user] screws up!</span>",
		"<span class='notice'>[user] finishes.</span>", TRUE) //By default the patient will notice if the wrong thing has been cut
	return TRUE

/datum/surgery_step/proc/play_failure_sound(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(!failure_sound)
		return
	playsound(get_turf(target), failure_sound, 75, TRUE, -2)

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

/datum/surgery_step/proc/get_success_probability(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/success_prob = 100
	if(implements)
		var/implement_type = tool_check(user, tool)
		if(implement_type)
			success_prob *= (implements[implement_type]/100) || 1
	success_prob *= get_location_modifier(target)
	success_prob *= get_skill_modifier(user, target, target_zone, tool, intent)

	return success_prob

/datum/surgery_step/proc/get_skill_modifier(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	if(!skill_used)
		return 1
	var/modifier = 1
	var/skill_level = user.get_skill_level(skill_used) || 0
	var/skill_difference = skill_level - skill_median
	if((skill_difference > 0) && length(skill_bonuses))
		skill_difference = clamp(abs(skill_difference), 0, skill_bonuses.len)
		modifier += skill_bonuses[skill_difference]
	else if((skill_difference < 0) && length(skill_maluses))
		skill_difference = clamp(abs(skill_difference), 0, skill_maluses.len)
		modifier += skill_maluses[skill_difference]
	return max(modifier, 0)

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
