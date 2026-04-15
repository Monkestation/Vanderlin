/datum/surgery_step
	/// Name of the surgery step
	var/name
	/// Description of the surgery step
	var/desc
	/// Typepaths or tool behaviors that can be used to perform this surgery step, associated to success chance
	var/list/implements = list()
	// the current type of implement used. This has to be stored, as the actual typepath of the tool may not match the list type.
	var/implement_type = null
	/// Does the surgery step accept open hand? If true, ignores implements. Compatible with accept_any_item.
	var/accept_hand = FALSE
	/// Does the surgery step accept any item? If true, ignores implements. Compatible with accept_hand.
	var/accept_any_item = FALSE
	/// How long does the step take for someone with average skill and an average tool?
	var/time = 1 SECONDS
	/// If the step is repeatable
	var/repeatable = FALSE

	/**
	 * list of chems needed to complete the step.
	 * Even on success, the step will have no effect if there aren't the chems required in the mob.
	 */
	var/list/chems_needed
	/// Any chem on the list required, or all of them?
	var/require_all_chems = TRUE

	/// Sound played when the step is started
	var/preop_sound = null
	/// Sound played if the step succeeded
	var/success_sound = null
	//Sound played if the step fails
	var/failure_sound = null

	/// Requirement threshold for the diceroll as a baseline
	var/dice_requirement = 25
	/// Crit window for the diceroll
	var/dice_crit = 8
	/// Number of dice rolled
	var/dice_num = 3
	/// Sides per die
	var/dice_sides = 20

/// Check if this tool is valid for our implements
/// Returns the key or null
/datum/surgery_step/proc/is_implement(mob/living/user, obj/item/tool)
	if(accept_hand)
		if(!tool)
			return TOOL_HAND

	if(accept_any_item)
		if(tool && tool_check(user, tool))
			return /obj/item
	else if(tool)
		for(var/key in implements)
			var/match = FALSE

			if(ispath(key) && istype(tool, key))
				match = TRUE
			else if(tool.tool_behaviour == key)
				match = TRUE

			if(match)
				implement_type = key
				if(tool_check(user, tool))
					return key

/datum/surgery_step/proc/try_op(mob/living/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, try_to_fail = FALSE)
	var/implement_key = is_implement(user, tool)

	if(implement_key)
		implement_type = implement_key
		if(target_zone == surgery.location)
			if(get_location_accessible(target, target_zone) || (surgery.surgery_flags & SURGERY_IGNORE_CLOTHES))
				initiate(user, target, target_zone, tool, surgery, try_to_fail)
			else
				to_chat(user, span_warning("You need to expose [target]'s [parse_zone(target_zone)] to perform surgery on it!"))
			return TRUE //returns TRUE so we don't stab the guy in the dick or wherever.

	if(repeatable)
		var/datum/surgery_step/next_step = surgery.get_surgery_next_step()
		if(next_step)
			surgery.status++
			if(next_step.try_op(user, target, user.zone_selected, user.get_active_held_item(), surgery))
				return TRUE
			else
				surgery.status--

	return FALSE

/datum/surgery_step/proc/initiate(mob/living/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, try_to_fail = FALSE)
	var/interaction_key = DOAFTER_SOURCE_SURGERY
	if(DOING_INTERACTION(user, DOAFTER_SOURCE_SURGERY))
		user.balloon_alert(user, "already doing surgery!")
		return FALSE

	if(!chem_check(target))
		user.balloon_alert(user, "missing [LOWER_TEXT(get_chem_list())]!")
		return FALSE

	var/preop_result = preop(user, target, target_zone, tool, surgery)
	if(preop_result == SURGERY_STEP_FAIL)
		return FALSE

	play_preop_sound(user, target, target_zone, tool, surgery) // Here because most steps overwrite preop

	surgery.step_in_progress = TRUE

	var/overall_mod = (get_location_modifier(target) * get_skill_modifier(user, surgery))
	var/modded_time = time * overall_mod

	if(!do_after(user, modded_time, target, interaction_key = interaction_key))
		return FALSE

	var/roll_result = NONE
	var/roll_requirement = 0

	var/advance = FALSE
	if(!chem_check(target) || try_to_fail)
		if(failure(user, target, target_zone, tool, surgery))
			play_failure_sound(user, target, target_zone, tool, surgery)
			if(!try_to_fail)
				display_roll(user, "Chemical failure", null)
			else
				display_roll(user, "Intentional failure", null)
			advance = TRUE
	else
		roll_requirement = get_roll_requirement(user, target, tool, surgery)
		roll_result = user.diceroll(
			requirement = roll_requirement,
			crit = dice_crit,
			dice_num = dice_num,
			dice_sides = dice_sides,
		)

	var/was_critical = (roll_result == DICE_CRIT_FAILURE) || (roll_result = DICE_CRIT_SUCCESS)

	switch(roll_result)
		if(DICE_FAILURE, DICE_CRIT_FAILURE)
			if(failure(user, target, target_zone, tool, surgery))
				play_failure_sound(user, target, target_zone, tool, surgery)
				display_roll(user, "[was_critical ? "CRIT " : ""]FAILURE", roll_requirement)
				advance = TRUE
			if(was_critical)
				crit_failure(user, target, target_zone, tool, surgery)
		if(DICE_SUCCESS, DICE_CRIT_SUCCESS)
			if(success(user, target, target_zone, tool, surgery))
				play_success_sound(user, target, target_zone, tool, surgery)
				display_roll(user, "[was_critical ? "CRIT " : ""]SUCCESS", roll_requirement)
				advance = TRUE
			if(was_critical)
				crit_success(user, target, target_zone, tool, surgery)

	if(advance && !repeatable)
		if(advance_surgery(user, surgery))
			return

	surgery.step_in_progress = FALSE

	return advance

/// Advance the current surgery to the next step, return TRUE if complete
/datum/surgery_step/proc/advance_surgery(mob/living/user, datum/surgery/surgery)
	surgery.status++
	surgery.step_in_progress = FALSE
	user.mind?.add_sleep_experience(surgery.skill_used, GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE) * 0.4)
	if(surgery.status > length(surgery.steps))
		surgery.complete(user)
		return TRUE
	return FALSE

/// Run fail checks and display pre operation results
/datum/surgery_step/proc/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("You begin to perform surgery on [target]..."),
		span_notice("[user] begins to perform surgery on [target]."),
		span_notice("[user] begins to perform surgery on [target]."),
	)

/// Play the pre operation sound
/datum/surgery_step/proc/play_preop_sound(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/sound_file_use
	if(islist(preop_sound))
		for(var/typepath in preop_sound)//iterate and assign subtype to a list, works best if list is arranged from subtype first and parent last
			if(istype(tool, typepath))
				sound_file_use = preop_sound[typepath]
				break
	else
		sound_file_use = preop_sound
	if(!sound_file_use)
		return

	playsound(target, sound_file_use, 75, TRUE, falloff_exponent = 12, falloff_distance = 1)

/// When we don't fuck up the surgery
/datum/surgery_step/proc/success(mob/living/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = TRUE)
	SEND_SIGNAL(user, COMSIG_MOB_SURGERY_STEP_SUCCESS, src, target, target_zone, tool, surgery, default_display_results)

	if(default_display_results)
		display_results(
			user,
			target,
			span_notice("You succeed."),
			span_notice("[user] succeeds!"),
			span_notice("[user] finishes."),
		)

	if(ishuman(user))
		var/mob/living/carbon/human/surgeon = user
		surgeon.add_blood_DNA(target.get_blood_dna_list(), ITEM_SLOT_GLOVES)
	else
		user.add_mob_blood(target)

	return TRUE

/// When we roll good and succeed very well
/datum/surgery_step/proc/crit_success(mob/living/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	return

// Sound when we don't fuck up
/datum/surgery_step/proc/play_success_sound(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(!success_sound)
		return
	playsound(target, success_sound, 75, TRUE, falloff_exponent = 12, falloff_distance = 1)

/**
 * When fail_prob triggers, we fail.
 *
 * We can either cancel the next step with FALSE, or do something negative and return TRUE.
 */
/datum/surgery_step/proc/failure(mob/living/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_warning("You screw up!"),
		span_warning("[user] screws up!"),
		span_notice("[user] finishes."),
		target_detailed = TRUE, // By default the patient will notice if the wrong thing has been cut
	)

	return FALSE

/datum/surgery_step/proc/crit_failure(mob/living/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	return

/// Sound when we fuck up
/datum/surgery_step/proc/play_failure_sound(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(!failure_sound)
		return
	playsound(target, failure_sound, 75, TRUE, falloff_exponent = 12, falloff_distance = 1)

/// Replaces visible_message during operations so only people looking over the surgeon can see them.
/datum/surgery_step/proc/display_results(mob/user, mob/living/target, self_message, detailed_message, vague_message, target_detailed = FALSE)
	user.visible_message(detailed_message, self_message, vision_distance = 1, ignored_mobs = target_detailed ? null : target)
	if(target_detailed)
		return

	var/you_feel = pick("a brief pain", "your body tense up", "an unnerving sensation")
	if(!vague_message)
		if(detailed_message)
			stack_trace("DIDN'T GET PASSED A VAGUE MESSAGE.")
			vague_message = detailed_message
		else
			stack_trace("NO MESSAGES TO SEND TO TARGET!")
			vague_message = span_notice("You feel [you_feel] as you are operated on.")
	target.show_message(vague_message, MSG_VISUAL, span_notice("You feel [you_feel] as you are operated on."))

/// Get required roll for success
/datum/surgery_step/proc/get_roll_requirement(mob/living/user, mob/living/target, obj/item/tool, datum/surgery/surgery)
	var/requirement = dice_requirement

	if(surgery.skill_used)
		var/skill_level = GET_MOB_SKILL_VALUE(user, surgery.skill_used) || 0
		var/skill_delta = (skill_level - surgery.skill_median) * 0.5
		requirement += skill_delta

	if(implements)
		var/implement_type = is_implement(user, tool)
		if(implement_type)
			var/tool_chance = implements[implement_type] || 0
			requirement += round((100 - tool_chance) / 100 * 6, 1)

	var/loc_mod = get_location_modifier(target)
	requirement += round((loc_mod - 1) * 8, 1)

	var/overseer_bonus = get_overseer_bonus(user, surgery)
	if(overseer_bonus > 0)
		requirement += overseer_bonus
		to_chat(user, span_notice("You feel more confident with an experienced eye watching over you."))

	return FLOOR(clamp(requirement, dice_num, dice_num * dice_sides), 1)

/// Display roll to the surgeon
/datum/surgery_step/proc/display_roll(mob/living/user, result_label, requirement)
	if(!user.client?.prefs.showrolls)
		return
	if(requirement != null)
		to_chat(user, span_warning("[result_label] (requirement was [requirement]/[dice_num * dice_sides])"))
	else
		to_chat(user, span_warning("[result_label]"))

/// Get a bonus if someone better than us is watching the surgery
/datum/surgery_step/proc/get_overseer_bonus(mob/living/user, datum/surgery/surgery)
	var/best_bonus = 0
	var/datum/attribute/skill/skill_used = surgery.skill_used
	var/our_skill = GET_MOB_SKILL_VALUE(user, skill_used)
	for(var/mob/living/carbon/human/nearby in oview(3, user))
		if(nearby == user)
			continue
		if(nearby.stat != CONSCIOUS)
			continue
		var/overseer_skill = GET_MOB_SKILL_VALUE(nearby, skill_used)
		if(overseer_skill <= surgery.skill_median)
			continue
		if(overseer_skill <= our_skill)
			continue
		var/bonus = (overseer_skill - surgery.skill_median) * 0.25
		if(bonus > best_bonus)
			best_bonus = bonus

	return best_bonus

/// Get an overall mod from the surgery skill requirements
/datum/surgery_step/proc/get_skill_modifier(mob/living/user, datum/surgery/surgery)
	var/datum/attribute/skill/skill_used = surgery.skill_used
	if(!skill_used)
		return 1
	var/skill_level = GET_MOB_SKILL_VALUE_OLD(user, skill_used)

	var/difference = surgery.skill_median - skill_level

	if(difference == 0)
		return 1

	if(difference > 0)
		return (1 - (0.15 * difference))

	if(difference < 0)
		return (1 + (0.1 * difference))

	return 1

/// Get an overall mod from location
/datum/surgery_step/proc/get_location_modifier(mob/living/target)
	var/static/list/modifiers = zebra_typecacheof(list(
		/obj/structure/table = 0.8,
		/obj/structure/table/optable = 1,
		/obj/structure/bed = 0.7,
	))

	var/modifier = 0.5
	for(var/obj/thingy in get_turf(target))
		modifier = max(modifier, modifiers[thingy.type])

	return modifier

/// Check if this tool can be used using implement_type
/datum/surgery_step/proc/tool_check(mob/user, obj/item/tool)
	return TRUE

/// Check if required chems are there
/datum/surgery_step/proc/chem_check(mob/living/target)
	if(!length(chems_needed))
		return TRUE

	if(require_all_chems)
		. = TRUE
		for(var/reagent in chems_needed)
			if(!target.reagents.has_reagent(reagent))
				return FALSE
	else
		. = FALSE
		for(var/reagent in chems_needed)
			if(target.reagents.has_reagent(reagent))
				return TRUE

/datum/surgery_step/proc/get_chem_list()
	if(!length(chems_needed))
		return

	var/list/chems = list()
	for(var/reagent in chems_needed)
		var/datum/reagent/temp = GLOB.chemical_reagents_list[reagent]
		if(temp)
			var/chemname = temp.name
			chems += chemname
	return english_list(chems, and_text = require_all_chems ? " and " : " or ")
