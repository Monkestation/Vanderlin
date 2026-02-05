/mob
	var/datum/skill_holder/skills

/mob/proc/ensure_skills()
	RETURN_TYPE(/datum/skill_holder)
	if(!skills)
		skills = new /datum/skill_holder()
		skills.set_current(src)
	return skills

/// Make a mob an apprentice to the skill_holder
/mob/proc/make_apprentice(mob/youngling)
	return ensure_skills().make_apprentice(youngling)

/// Adjust the experience of the apprentices
/mob/proc/adjust_apprentice_exp(skill, amt, silent)
	return ensure_skills().adjust_apprentice_exp(skill, amt, silent)

/// Return the max amount of apprentices of the skill_holder
/mob/proc/return_max_apprentices()
	return ensure_skills().max_apprentices

/// Return the list of apprentices from the skill_holder
/mob/proc/return_apprentices()
	return ensure_skills().apprentices

/mob/proc/is_apprentice()
	return ensure_skills().apprentice

/// Return the apprentice name from the skill_holder
/mob/proc/return_apprentice_name()
	return ensure_skills().apprentice_name

/mob/proc/set_max_apprentices(max_apprentices)
	ensure_skills().max_apprentices = max_apprentices

/mob/proc/set_apprentice_name(apprentice_name)
	ensure_skills().apprentice_name = apprentice_name

/mob/proc/set_apprentice_training_skills(list/trainable_skills = list())
	ensure_skills().apprentice_training_skills = trainable_skills

/// Get the exp modifier for the skill
/mob/proc/get_learning_boon(skill)
	return ensure_skills().get_learning_boon(skill)

/// Print all skill levels
/mob/proc/print_levels()
	return ensure_skills().print_levels(src)

/mob/proc/get_skill_parry_modifier(skill)
	return ensure_skills().get_skill_parry_modifier(skill)

/// Get the current level of the skill
/mob/proc/get_skill_level(skill, return_decimal)
	return ensure_skills().get_skill_level(skill, return_decimal)

/mob/proc/has_skill(skill)
	return ensure_skills().has_skill(skill)

/mob/proc/get_skill_speed_modifier(skill)
	return ensure_skills().get_skill_speed_modifier(skill)

/mob/proc/adjust_experience(skill, amt, silent=FALSE, check_apprentice=TRUE)
	if(HAS_TRAIT(src, TRAIT_NO_EXPERIENCE))
		return FALSE
	return ensure_skills().adjust_experience(skill, amt, silent, check_apprentice)

/mob/proc/get_inspirational_bonus()
	return 0

/mob/living/carbon/get_inspirational_bonus()
	var/bonus = 0
	for(var/datum/stress_event/event in stressors)
		bonus += event.quality_modifier
	return bonus

/**
 * adjusts the skill level
 * Vars:
 ** skill - associated skill type to change
 ** amt - how much to change the skill
 ** silent - wether the player will be notified about their skill change or not
*/
/mob/proc/adjust_skillrank(skill, amt, silent=FALSE)
	return ensure_skills().adjust_skillrank(skill, amt, silent)

/mob/proc/return_our_apprentice_name()
	return ensure_skills().our_apprentice_name

/**
 * increases the skill level up to a certain maximum
 * Vars:
 ** skill - associated skill to change
 ** amt - how much to change the skill
 ** max - maximum amount up to which the skill will be changed
*/
/mob/proc/clamped_adjust_skillrank(skill, amt, max, silent=FALSE)
	return ensure_skills().clamped_adjust_skillrank(skill, amt, max, silent)

/**
 * sets the skill level to a specific amount
 * Vars:
 ** skill - associated skill
 ** level - which level to set the skill to
 ** silent - do we notify the player of this change?
*/
/mob/proc/set_skillrank(skill, level, silent=TRUE)
	return ensure_skills().set_skillrank(skill, level, silent)

/**
 * purges all skill levels back down to 0
 * Vars:
 ** silent - do we notify the player of this change?
*/
/mob/proc/purge_all_skills(silent=TRUE)
	return ensure_skills().purge_all_skills(silent)

/// Get the experience multiplier for a specific skill
/mob/proc/get_skill_exp_multiplier(skill)
	return ensure_skills().get_skill_exp_multiplier(skill)

/// Set the experience multiplier for a specific skill
/mob/proc/set_skill_exp_multiplier(skill, multiplier)
	return ensure_skills().set_skill_exp_multiplier(skill, multiplier)

/// Adjust the experience multiplier for a specific skill
/mob/proc/adjust_skill_exp_multiplier(skill, amount)
	return ensure_skills().adjust_skill_exp_multiplier(skill, amount)

/// Remove the experience multiplier for a specific skill (reset to default)
/mob/proc/remove_skill_exp_multiplier(skill)
	return ensure_skills().remove_skill_exp_multiplier(skill)

/// Get all skills that have custom multipliers
/mob/proc/get_all_skill_multipliers()
	return ensure_skills().get_all_skill_multipliers()

/datum/skill_holder
	///our current host
	var/mob/living/current
	///Assoc list of skill typepath - level. Levels can be decimals rounded to the nearest 0.1
	var/list/known_skills = list()
	///Assoc list of skill typepath - exp
	var/list/skill_experience = list()
	///assoc list of skill typepath - base multiplier
	var/list/exp_multiplier = list()
	/// is this mind an apprentice of someone?
	var/apprentice = FALSE
	/// the maximum amount of apprentices this mind can have
	var/max_apprentices = 0
	var/apprentice_name

	var/list/apprentices = list()
	/// Associative list of skill typepath - additive multiplier to apprentice xp gain
	var/list/apprentice_training_skills = list()
	var/our_apprentice_name

/datum/skill_holder/New()
	. = ..()
	for(var/datum/skill/skill as anything in SSskills.all_skills)
		skill_experience |= skill
		skill_experience[skill] = 0

/datum/skill_holder/Destroy(force, ...)
	set_current(null)
	. = ..()

/datum/skill_holder/proc/set_current(mob/incoming)
	if(current)
		UnregisterSignal(current, COMSIG_MOB_MIND_TRANSFERRED_OUT_OF)
		current.skills = null
	current = incoming
	if(current)
		current.skills = src
		RegisterSignal(current, COMSIG_MOB_MIND_TRANSFERRED_OUT_OF, PROC_REF(upon_mind_transfer))

/datum/skill_holder/proc/upon_mind_transfer(mob/living/source_old_mob, mob/living/new_mob)
	SIGNAL_HANDLER
	set_current(new_mob)

/**
 * Offer apprenticeship to a youngling
 * Vars:
 ** youngling - the mob apprenticeship was offered to
*/
/datum/skill_holder/proc/make_apprentice(mob/living/youngling)
	if(isnull(youngling))
		CRASH("make_apprentice was called without an argument!")
	if(youngling?.ensure_skills().apprentice)
		return
	if(length(apprentices) >= max_apprentices)
		return
	if(current.stat >= UNCONSCIOUS || youngling.stat >= UNCONSCIOUS)
		return

	var/choice = input(youngling, "Do you wish to become [current.name]'s apprentice?") as anything in list("Yes", "No")
	if(length(apprentices) >= max_apprentices)
		return
	if(current.stat >= UNCONSCIOUS || youngling.stat >= UNCONSCIOUS)
		return
	if(choice != "Yes")
		to_chat(current, span_warning("[youngling] has rejected your apprenticeship!"))
		return
	apprentices |= WEAKREF(youngling)
	youngling.ensure_skills().apprentice = TRUE

	var/datum/job/job = SSjob.GetJob(current:job)
	var/title = "[job.get_informed_title(youngling)] Apprentice"
	if(apprentice_name) //Needed for advclassses
		title = apprentice_name
	youngling.ensure_skills().our_apprentice_name = "[current.real_name]'s [title]"
	to_chat(current, span_notice("[youngling.real_name] has become your apprentice."))
	SEND_SIGNAL(current, COMSIG_APPRENTICE_MADE, youngling)

/datum/skill_holder/proc/print_levels(user)
	var/list/shown_skills = list()
	for(var/skill_type in known_skills)
		var/skill_level_rounded = floor(known_skills[skill_type])
		if(skill_level_rounded) //Do we actually have a level in this?
			shown_skills[GetSkillRef(skill_type)] = skill_level_rounded
	if(!length(shown_skills))
		to_chat(user, span_warning("I don't have any skills."))
		return
	var/msg = ""
	msg += span_info("*---------*\n")
	for(var/datum/skill/skill_ref as anything in shown_skills)
		var/skill_level_name = SSskills.level_names[shown_skills[skill_ref]]
		var/skill_link = "<a href='byond://?src=[REF(skill_ref)];action=examine'>?</a>"
		msg += "[skill_ref] - [skill_level_name] [skill_link]\n"
	to_chat(user, msg)

/**
 * Get a bonus multiplier dependant on age to apply to exp gains.
 * Vars:
 ** skill - associated skill
*/
/datum/skill_holder/proc/get_learning_boon(skill)
	var/boon = 1 // Can't teach an old dog new tricks. Most old jobs start with higher skill too.
	boon += get_skill_level(skill) / 20
	if(HAS_TRAIT(current, TRAIT_TUTELAGE)) //5% boost for being a good teacher
		boon += 0.05
	if(!ishuman(current))
		return boon
	var/mob/living/carbon/human/H = current
	if(H.age == AGE_OLD)
		boon -= 0.2
	else if(H.age == AGE_CHILD)
		boon += 0.2
	return boon

/**
 * Gets the parry modifier of the associated weapon skill
 * Vars:
 ** skill - the skill typepath
*/
/datum/skill_holder/proc/get_skill_parry_modifier(skill)
	var/datum/skill/combat/skill_ref = GetSkillRef(skill)
	return skill_ref.get_skill_parry_modifier(known_skills[skill] || SKILL_LEVEL_NONE)

/**
 * Gets the skill level of a mind
 * Vars:
 ** skill - the skill typepath
*/
/datum/skill_holder/proc/get_skill_level(skill, return_decimal)
	if(!GetSkillRef(skill))
		// CRASH("get_skill_level was called without a skill argument!")
		return SKILL_LEVEL_NONE
	if(!has_skill(skill))
		return SKILL_LEVEL_NONE
	return return_decimal ? known_skills[skill] : floor(known_skills[skill])

/**
 * Returns boolean for presence of skill
 * Vars:
 ** skill - the skill reference or typepath
 */
/datum/skill_holder/proc/has_skill(skill)
	if(istype(skill, /datum/skill))
		var/datum/skill/skill_ref = skill
		skill = skill_ref.type
	if(!(skill in known_skills))
		return FALSE
	return TRUE

/**
 * Gets the skill's singleton and returns the result of its get_skill_speed_modifier
 * Vars:
 ** skill - the skill typepath
*/
/datum/skill_holder/proc/get_skill_speed_modifier(skill)
	var/datum/skill/skill_ref = GetSkillRef(skill)
	return skill_ref.get_skill_speed_modifier(known_skills[skill] || SKILL_LEVEL_NONE)

/**
 * Adjusts experience. Sends COMSIG_SKILL_RANK_CHANGE as well as records round statistics.
 * Vars:
 ** skill - associated skill typepath
 ** amt - amount of experience to grant
 ** silent - wether the player will be notified about their skill change or not
 ** check_apprentice - wether or not to give experience to your apprentice as well
*/
/datum/skill_holder/proc/adjust_experience(skill, amt, silent = FALSE, check_apprentice = TRUE)
	var/datum/skill/skill_ref = GetSkillRef(skill)
	if(!skill_ref)
		return

	amt *= GLOB.adjust_experience_modifier
	amt *= current.get_skill_exp_multiplier(skill)

	skill_experience[skill] = max(0, skill_experience[skill] + amt)
	var/old_level_rounded = get_skill_level(skill)
	var/had_skill_before = has_skill(skill)
	switch(skill_experience[skill])
		if(SKILL_EXP_LEGENDARY to INFINITY)
			known_skills[skill] = SKILL_LEVEL_LEGENDARY
		if(SKILL_EXP_MASTER to SKILL_EXP_LEGENDARY)
			known_skills[skill] = SKILL_LEVEL_MASTER + round((skill_experience[skill] - SKILL_EXP_MASTER) / (SKILL_EXP_LEGENDARY - SKILL_EXP_MASTER), 0.1)
		if(SKILL_EXP_EXPERT to SKILL_EXP_MASTER)
			known_skills[skill] = SKILL_LEVEL_EXPERT + round((skill_experience[skill] - SKILL_EXP_EXPERT) / (SKILL_EXP_MASTER - SKILL_EXP_EXPERT), 0.1)
		if(SKILL_EXP_JOURNEYMAN to SKILL_EXP_EXPERT)
			known_skills[skill] = SKILL_LEVEL_JOURNEYMAN + round((skill_experience[skill] - SKILL_EXP_JOURNEYMAN) / (SKILL_EXP_EXPERT - SKILL_EXP_JOURNEYMAN), 0.1)
		if(SKILL_EXP_APPRENTICE to SKILL_EXP_JOURNEYMAN)
			known_skills[skill] = SKILL_LEVEL_APPRENTICE + round((skill_experience[skill] - SKILL_EXP_APPRENTICE) / (SKILL_EXP_JOURNEYMAN - SKILL_EXP_APPRENTICE), 0.1)
		if(SKILL_EXP_NOVICE to SKILL_EXP_APPRENTICE)
			known_skills[skill] = SKILL_LEVEL_NOVICE + round((skill_experience[skill] - SKILL_EXP_NOVICE) / (SKILL_EXP_APPRENTICE - SKILL_EXP_NOVICE), 0.1)
		if(SKILL_EXP_NONE to SKILL_EXP_NOVICE)
			known_skills[skill] = SKILL_LEVEL_NONE + round((skill_experience[skill] - SKILL_EXP_NONE) / (SKILL_EXP_NOVICE - SKILL_EXP_NONE), 0.1)

	if(check_apprentice)
		adjust_apprentice_exp(skill, amt, silent)

	var/new_level_rounded = get_skill_level(skill)
	if(had_skill_before && old_level_rounded == new_level_rounded)
		return
	// This occurs when adding a new skill to known_skills at SKILL_LEVEL_NONE
	if(old_level_rounded == SKILL_LEVEL_NONE && new_level_rounded == SKILL_LEVEL_NONE)
		return
	SEND_SIGNAL(current, COMSIG_SKILL_RANK_CHANGE, skill_ref, new_level_rounded, old_level_rounded)
	// Give spellpoints if the skill is arcane
	if(skill == /datum/skill/magic/arcane && new_level_rounded > old_level_rounded)
		current?.adjust_spell_points(new_level_rounded - old_level_rounded)
	if(silent)
		return
	if(new_level_rounded >= old_level_rounded)
		to_chat(current, span_nicegreen("My proficiency in [skill_ref.name] grows to [SSskills.level_names[new_level_rounded]]!"))
		record_round_statistic(STATS_SKILLS_LEARNED)
		if(ispath(skill, /datum/skill/combat))
			record_round_statistic(STATS_COMBAT_SKILLS)
		if(ispath(skill, /datum/skill/craft))
			record_round_statistic(STATS_CRAFT_SKILLS)
		if(skill == /datum/skill/misc/reading && old_level_rounded == SKILL_LEVEL_NONE && current.is_literate())
			record_round_statistic(STATS_LITERACY_TAUGHT)
	else
		var/new_level_name = new_level_rounded ? SSskills.level_names[new_level_rounded] : span_info("None")
		to_chat(current, span_warning("My [skill_ref.name] has weakened to [new_level_name]!"))

/**
 * Adjusts the skill level. Essentially a convenient way to call adjust_experience(check_apprentice = FALSE)
 * Vars:
 ** skill - associated skill to change
 ** amt - how much to change the skill
 ** silent - wether the player will be notified about their skill change or not
*/
/datum/skill_holder/proc/adjust_skillrank(skill, amt, silent = FALSE)
	if(!amt)
		return
	if(!GetSkillRef(skill))
		CRASH("adjust_skillrank was called without a specified skill!")
	/// The skill we are changing
	var/old_level = get_skill_level(skill, TRUE)
	var/target_level = clamp(old_level + amt, SKILL_LEVEL_NONE, SKILL_LEVEL_LEGENDARY)
	if(has_skill(skill) && old_level == target_level)
		return
	/// How much experience the mob gets at the end
	var/experience_change = 0
	var/current_experience = skill_experience[skill]

	var/remainder = target_level %% 1 // See DM documentation on why %% is used instead of %
	switch(target_level)
		if(SKILL_LEVEL_LEGENDARY to INFINITY)
			experience_change = SKILL_EXP_LEGENDARY - current_experience
		if(SKILL_LEVEL_MASTER to SKILL_LEVEL_LEGENDARY)
			experience_change = SKILL_EXP_MASTER - current_experience
			experience_change += (SKILL_EXP_LEGENDARY - SKILL_EXP_MASTER) * remainder
		if(SKILL_LEVEL_EXPERT to SKILL_LEVEL_MASTER)
			experience_change = SKILL_EXP_EXPERT - current_experience
			experience_change += (SKILL_EXP_MASTER - SKILL_EXP_EXPERT) * remainder
		if(SKILL_LEVEL_JOURNEYMAN to SKILL_LEVEL_EXPERT)
			experience_change = SKILL_EXP_JOURNEYMAN - current_experience
			experience_change += (SKILL_EXP_EXPERT - SKILL_EXP_JOURNEYMAN) * remainder
		if(SKILL_LEVEL_APPRENTICE to SKILL_LEVEL_JOURNEYMAN)
			experience_change = SKILL_EXP_APPRENTICE - current_experience
			experience_change += (SKILL_EXP_JOURNEYMAN - SKILL_EXP_APPRENTICE) * remainder
		if(SKILL_LEVEL_NOVICE to SKILL_LEVEL_APPRENTICE)
			experience_change = SKILL_EXP_NOVICE - current_experience
			experience_change += (SKILL_EXP_APPRENTICE - SKILL_EXP_NOVICE) * remainder
		if(SKILL_LEVEL_NONE to SKILL_LEVEL_NOVICE)
			experience_change = SKILL_EXP_NONE - current_experience
			experience_change += (SKILL_EXP_NOVICE - SKILL_EXP_NONE) * remainder

	adjust_experience(skill, experience_change, silent, check_apprentice = FALSE)

/**
 * increases the skill level up to a certain maximum
 * Vars:
 ** skill - associated skill to change
 ** amt - how much to change the skill
 ** max - maximum amount up to which the skill will be changed
*/
/datum/skill_holder/proc/clamped_adjust_skillrank(skill, amt, max, silent)
	var/skill_difference = max - get_skill_level(skill, TRUE)
	if(skill_difference <= 0)
		return
	var/amount_to_adjust_by = min(skill_difference, amt)  // Changed max to amt
	adjust_skillrank(skill, amount_to_adjust_by, silent)

/**
 * sets the skill level to a specific amount
 * Vars:
 ** skill - associated skill
 ** level - which level to set the skill to
 ** silent - do we notify the player of this change?
*/
/datum/skill_holder/proc/set_skillrank(skill, level, silent = TRUE)
	if(!skill)
		CRASH("set_skillrank was called without a skill argument!")

	var/skill_difference = level - get_skill_level(skill, TRUE)
	adjust_skillrank(skill, skill_difference, silent)

/**
 * purges all skill levels back down to 0
 * Vars:
 ** silent - do we notify the player of this change?
*/
/datum/skill_holder/proc/purge_all_skills(silent = TRUE)
	known_skills = list()
	for(var/skill in skill_experience)
		skill_experience[skill] = 0
	if(!silent)
		to_chat(current, span_boldwarning("I forget all my skills!"))

/datum/skill_holder/proc/adjust_apprentice_exp(skill, amt, silent)
	if(!length(apprentices))
		return

	var/multiplier = 0
	if(HAS_TRAIT(current, TRAIT_TUTELAGE)) //Base 50% of your xp is given to nearby apprentice
		multiplier += 0.15
	var/tutor_skill_level = get_skill_level(skill)
	var/list/surroundings = view(7, current)
	var/taught_apprentice = FALSE
	for(var/datum/weakref/apprentice_ref as anything in apprentices)
		var/mob/living/apprentice = apprentice_ref.resolve()
		if(!istype(apprentice))
			continue
		if(!(apprentice in surroundings))
			continue
		if(skill in apprentice_training_skills)
			multiplier += apprentice_training_skills[skill]
		if(apprentice.get_skill_level(skill) < tutor_skill_level)
			multiplier += 0.25 //this means a base 35% of your xp is also given to nearby apprentices plus skill modifiers.
		var/apprentice_amt = amt * (0.1 + multiplier)
		if(apprentice.mind.add_sleep_experience(skill, apprentice_amt, FALSE, FALSE))
			taught_apprentice = TRUE
			SEND_SIGNAL(current, COMSIG_TAUGHT_APPRENTICE, apprentice, skill, apprentice_amt)

	if(taught_apprentice)
		current.add_stress(/datum/stress_event/apprentice_making_me_proud)

/**
 * Get the experience multiplier for a specific skill
 * Vars:
 ** skill - the skill typepath to check
 * Returns: The multiplier (default 1.0 if none set)
 */
/datum/skill_holder/proc/get_skill_exp_multiplier(skill)
	if(!GetSkillRef(skill))
		CRASH("adjust_skillrank was called without a specified skill!")

	var/base_multiplier = 1.0
	if(exp_multiplier[skill])
		base_multiplier = exp_multiplier[skill]

	if(current.has_quirk(/datum/quirk/boon/quick_learner))
		base_multiplier += 0.2

	return base_multiplier

/**
 * Set the experience multiplier for a specific skill
 * Vars:
 ** skill - the skill typepath to modify
 ** multiplier - the multiplier value (1.0 = normal, 2.0 = double xp, 0.5 = half xp)
 */
/datum/skill_holder/proc/set_skill_exp_multiplier(skill, multiplier)
	if(!GetSkillRef(skill))
		CRASH("set_skill_exp_multiplier was called without a skill argument!")

	exp_multiplier[skill] = max(0, multiplier) // Prevent negative multipliers
	return multiplier

/**
 * Adjust the experience multiplier for a specific skill by an amount
 * Vars:
 ** skill - the skill typepath to modify
 ** amount - how much to adjust the multiplier by (can be negative)
 */
/datum/skill_holder/proc/adjust_skill_exp_multiplier(skill, amount)
	if(!GetSkillRef(skill))
		CRASH("adjust_skill_exp_multiplier was called without a skill argument!")

	var/current_multiplier = get_skill_exp_multiplier(skill)
	var/new_multiplier = max(0, current_multiplier + amount) // Prevent negative multipliers
	exp_multiplier[skill] = new_multiplier
	return new_multiplier

/**
 * Remove the experience multiplier for a specific skill (resets to default 1.0)
 * Vars:
 ** skill - the skill typepath to reset
 */
/datum/skill_holder/proc/remove_skill_exp_multiplier(skill)
	if(!GetSkillRef(skill))
		CRASH("remove_skill_exp_multiplier was called without a skill argument!")

	exp_multiplier -= skill
	return TRUE

/**
 * Get all skills that have custom multipliers set
 * Returns: Associative list of skill = multiplier
 */
/datum/skill_holder/proc/get_all_skill_multipliers()
	return exp_multiplier.Copy()
