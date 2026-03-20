// This is stupid and inefficient and should be defines, but i don't want to type every argument out, every time
/mob/proc/diceroll(requirement = 0, crit = 10, dice_num = 3, dice_sides = 6, count_modifiers = TRUE, context = DICE_CONTEXT_DEFAULT, return_flags = RETURN_DICE_SUCCESS)
	return attributes ? attributes.diceroll(requirement, crit, dice_num, dice_sides, count_modifiers, context, return_flags) : DICE_FAILURE

/mob/proc/attribute_probability(modifier = ATTRIBUTE_MIDDLING, base_prob = 50, delta_value = ATTRIBUTE_MIDDLING, increment = 5)
	return attributes ? attributes.attribute_probability(modifier, base_prob, delta_value, increment) : base_prob

/**
 *
 * Example (unchanged call site):
 *   blade.clamped_adjust_skill_level(/datum/attribute/skill/combat/swords, 20, 40)
 *   -> raises skill by up to 20, capped at level 40 (expert)
 */
/mob/proc/clamped_adjust_skill_level(skill_type, amt, max, silent = FALSE)
	attributes?.adjust_skill_level(skill_type, amt, max, silent)

/mob/proc/get_skill_exp_multiplier(skill_type)
	return attributes?.get_skill_xp_multiplier(skill_type)

/mob/proc/set_skill_exp_multiplier(skill_type, multiplier)
	attributes?.set_skill_xp_multiplier(skill_type, multiplier)

/mob/proc/adjust_skill_exp_multiplier(skill_type, amount)
	attributes?.adjust_skill_xp_multiplier(skill_type, amount)

/mob/proc/remove_skill_exp_multiplier(skill_type)
	attributes?.remove_skill_xp_multiplier(skill_type)

/**
 * Returns the raw XP accumulated toward a skill (useful for UI/debug).
 */
/mob/proc/get_skill_xp(skill_type)
	return attributes?.get_skill_xp(skill_type)

/**
 * Returns the learning boon multiplier for a skill (age/trait modifier).
 * Multiply your XP grant by this if you want age to affect training speed.
 */
/mob/proc/get_learning_boon(skill_type)
	return attributes?.get_learning_boon(skill_type)

/**
 * Prints all current skill levels to the mob's chat.
 */
/mob/proc/print_skill_levels()
	attributes?.print_skills(src)

/**
 * Awards XP toward a skill, converting it into level gains automatically.
 * This is the standard call site for in-game skill training.
 *
 * Arguments:
 *   skill_type       - typepath of the /datum/attribute/skill
 *   amount           - XP to award
 *   silent           - suppress level-up messages
 *   check_apprentice - share XP with nearby apprentices
 */
/mob/proc/adjust_experience(skill_type, amount, silent = FALSE, check_apprentice = TRUE)
	if(HAS_TRAIT(src, TRAIT_NO_EXPERIENCE))
		return FALSE
	return attributes?.adjust_experience(skill_type, amount, silent, check_apprentice)

/**
 * Adjusts a skill by a delta in the new 0-60 range, with an optional cap.
 *
 * Arguments:
 *   skill_type - typepath of the skill
 *   delta      - levels to add or remove (e.g. +5, -10)
 *   max_level  - optional ceiling in 0-60 range; null = no cap
 *   silent     - suppress messages
 */
/mob/proc/adjust_skill_level(skill_type, delta, max_level = null, silent = FALSE)
	attributes?.adjust_skill_level(skill_type, delta, max_level, silent)

/**
 * Wipes all skill levels and XP back to zero.
 */
/mob/proc/purge_all_skills(silent = TRUE)
	attributes?.purge_all_skills(silent)
