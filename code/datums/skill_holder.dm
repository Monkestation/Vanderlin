/mob
	var/datum/skill_holder/skills

/mob/proc/ensure_skills()
	RETURN_TYPE(/datum/skill_holder)
	if(!skills)
		skills = new /datum/skill_holder()
		skills.set_current(src)
	return skills

/mob/proc/make_apprentice(mob/youngling)
	return ensure_skills().make_apprentice(youngling)

/mob/proc/get_learning_boon(skill)
	return ensure_skills().get_learning_boon(skill)

/mob/proc/return_apprentices()
	return ensure_skills().apprentices

/mob/proc/is_apprentice()
	return ensure_skills().apprentice

/mob/proc/return_apprentice_name()
	return ensure_skills().apprentice_name

/mob/proc/set_max_apprentices(max_apprentices)
	ensure_skills().max_apprentices = max_apprentices

/mob/proc/set_apprentice_name(apprentice_name)
	ensure_skills().apprentice_name = apprentice_name

/mob/proc/set_apprentice_training_skills(list/trainable_skills = list())
	ensure_skills().apprentice_training_skills = trainable_skills


/mob/proc/return_max_apprentices()
	return ensure_skills().max_apprentices

/mob/proc/adjust_apprentice_exp(skill, amt, silent)
	return ensure_skills().adjust_apprentice_exp(skill, amt, silent)

/mob/proc/print_levels()
	return ensure_skills().print_levels(src)

/mob/proc/get_skill_parry_modifier(skill)
	return ensure_skills().get_skill_parry_modifier(skill)

/mob/proc/get_skill_dodge_drain(skill)
	return ensure_skills().get_skill_dodge_drain(skill)

/mob/proc/get_skill_level(skill)
	return ensure_skills().get_skill_level(skill)

/mob/proc/get_skill_speed_modifier(skill)
	return ensure_skills().get_skill_speed_modifier(skill)

/mob/proc/adjust_experience(skill, amt, silent=FALSE, check_apprentice=TRUE)
	return ensure_skills().adjust_experience(skill, amt, silent, check_apprentice)

/**
 * adjusts the skill level
 * Vars:
 ** skill - associated skill to change
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

/datum/skill_holder
	///our current host
	var/mob/living/current
	///Assoc list of skills - level
	var/list/known_skills = list()
	///Assoc list of skills - exp
	var/list/skill_experience = list()
	/// is this mind an apprentice of someone?
	var/apprentice = FALSE
	/// the maximum amount of apprentices this mind can have
	var/max_apprentices = 0
	var/apprentice_name

	var/list/apprentices = list()
	var/list/apprentice_training_skills = list()
	var/our_apprentice_name

/datum/skill_holder/New()
	. = ..()
	for(var/datum/skill/skill as anything in SSskills.all_skills)
		if(!(skill in skill_experience))
			skill_experience |= skill
			skill_experience[skill] = 0

/datum/skill_holder/proc/set_current(mob/incoming)
	current = incoming
	RegisterSignal(incoming, COMSIG_MIND_TRANSFER, PROC_REF(transfer_skills))
	incoming.skills = src

/datum/skill_holder/proc/transfer_skills(mob/source, mob/destination)
	UnregisterSignal(source, COMSIG_MIND_TRANSFER)
	set_current(destination)

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
	if(choice != "Yes")
		to_chat(current, span_warning("[youngling] has rejected your apprenticeship!"))
		return
	if(length(apprentices) >= max_apprentices)
		return
	if(current.stat >= UNCONSCIOUS || youngling.stat >= UNCONSCIOUS)
		return
	apprentices |= WEAKREF(youngling)
	youngling.ensure_skills().apprentice = TRUE

	var/datum/job/job = SSjob.GetJob(current:job)
	var/title = "[job.get_informed_title(youngling)] Apprentice"
	if(apprentice_name) //Needed for advclassses
		title = apprentice_name
	youngling.ensure_skills().our_apprentice_name = "[current.real_name]'s [title]"
	to_chat(current, span_notice("[youngling.real_name] has become your apprentice."))

/datum/skill_holder/proc/print_levels(user)
	var/list/shown_skills = list()
	for(var/i in known_skills)
		if(known_skills[i]) //Do we actually have a level in this?
			shown_skills += i
	if(!length(shown_skills))
		to_chat(user, span_warning("I don't have any skills."))
		return
	var/msg = ""
	msg += span_info("*---------*\n")
	for(var/datum/skill/skill_ref as anything in shown_skills)
		var/skill_level = SSskills.level_names[known_skills[skill_ref]]
		var/skill_link = "<a href='byond://?src=[REF(skill_ref)];action=examine'>?</a>"
		msg += "[skill_ref] - [skill_level] [skill_link]\n"
	to_chat(user, msg)

/**
 * Get a bonus multiplier dependant on age to apply to exp gains.
 * Vars:
 ** skill - associated skill
*/
/datum/skill_holder/proc/get_learning_boon(skill)
	var/mob/living/carbon/human/H = current
	if(!istype(H))
		return 1
	var/boon = 1 // Can't teach an old dog new tricks. Most old jobs start with higher skill too.
	if(H.age == AGE_OLD)
		boon = 0.8
	else if(H.age == AGE_CHILD)
		boon = 1.1
	boon += get_skill_level(skill) / 10
	if(HAS_TRAIT(H, TRAIT_TUTELAGE)) //5% boost for being a good teacher
		boon += 0.05
	return boon

/**
 * Gets the parry modifier of the associated weapon skill
 * Vars:
 ** skill - the skill
*/
/datum/skill_holder/proc/get_skill_parry_modifier(skill)
	var/datum/skill/combat/skill_ref = GetSkillRef(skill)
	return skill_ref.get_skill_parry_modifier(known_skills[skill_ref] || SKILL_LEVEL_NONE)

///idk what this does, it's unused.
/datum/skill_holder/proc/get_skill_dodge_drain(skill)
	var/datum/skill/combat/skill_ref = GetSkillRef(skill)
	return skill_ref.get_skill_dodge_drain(known_skills[skill_ref] || SKILL_LEVEL_NONE)

/**
 * Gets the skill level of a mind
 * Vars:
 ** skill - the skill
*/
/datum/skill_holder/proc/get_skill_level(skill)
	var/datum/skill/skill_ref = GetSkillRef(skill)
	if(!(skill_ref in known_skills))
		return SKILL_LEVEL_NONE
	return known_skills[skill_ref] || SKILL_LEVEL_NONE

/**
 * Gets the skill's singleton and returns the result of its get_skill_speed_modifier
 * Vars:
 ** skill - the skill
*/
/datum/skill_holder/proc/get_skill_speed_modifier(skill)
	var/datum/skill/skill_ref = GetSkillRef(skill)
	return skill_ref.get_skill_speed_modifier(known_skills[skill_ref] || SKILL_LEVEL_NONE)

/**
 * adjusts experience
 * Vars:
 ** skill - associated skill
 ** amt - amount of experience to grant
 ** silent - wether the player will be notified about their skill change or not
 ** check_apprentice - wether or not to give experience to your apprentice as well
*/
/datum/skill_holder/proc/adjust_experience(skill, amt, silent = FALSE, check_apprentice = TRUE)
	var/datum/skill/skill_ref = GetSkillRef(skill)
	skill_experience[skill_ref] = max(0, skill_experience[skill_ref] + amt) //Prevent going below 0
	var/old_level = get_skill_level(skill)
	switch(skill_experience[skill_ref])
		if(SKILL_EXP_LEGENDARY to INFINITY)
			known_skills[skill_ref] = SKILL_LEVEL_LEGENDARY
		if(SKILL_EXP_MASTER to SKILL_EXP_LEGENDARY)
			known_skills[skill_ref] = SKILL_LEVEL_MASTER
		if(SKILL_EXP_EXPERT to SKILL_EXP_MASTER)
			known_skills[skill_ref] = SKILL_LEVEL_EXPERT
		if(SKILL_EXP_JOURNEYMAN to SKILL_EXP_EXPERT)
			known_skills[skill_ref] = SKILL_LEVEL_JOURNEYMAN
		if(SKILL_EXP_APPRENTICE to SKILL_EXP_JOURNEYMAN)
			known_skills[skill_ref] = SKILL_LEVEL_APPRENTICE
		if(SKILL_EXP_NOVICE to SKILL_EXP_APPRENTICE)
			known_skills[skill_ref] = SKILL_LEVEL_NOVICE
		if(0 to SKILL_EXP_NOVICE)
			known_skills[skill_ref] = SKILL_LEVEL_NONE

	if(length(apprentices) && check_apprentice)
		for(var/datum/weakref/apprentice_ref as anything in apprentices)
			var/mob/living/apprentice = apprentice_ref.resolve()
			if(!istype(apprentice))
				continue
			if(!(apprentice in view(7, current)))
				continue
			var/multiplier = 0
			if((skill in apprentice_training_skills))
				multiplier = apprentice_training_skills[skill]
			if(apprentice.get_skill_level(skill) <= (get_skill_level(skill) - 1))
				multiplier += 0.25 //this means a base 35% of your xp is also given to nearby apprentices plus skill modifiers.
			var/apprentice_amt = amt * 0.1 + multiplier
			if(apprentice.adjust_experience(skill, apprentice_amt, FALSE, FALSE))
				current.add_stress(/datum/stressevent/apprentice_making_me_proud)

	var/is_new_skill = !(skill_ref in known_skills)
	if(isnull(old_level) && !is_new_skill)
		old_level = SKILL_LEVEL_NONE
	if((isnull(old_level) && is_new_skill) || known_skills[skill_ref] == old_level)
		return
	if(silent)
		return
	if(known_skills[skill_ref] >= old_level)
		if(known_skills[skill_ref] > old_level)
			SEND_SIGNAL(current, COMSIG_SKILL_RANK_INCREASED, skill_ref, known_skills[skill_ref], old_level)
			to_chat(current, span_nicegreen("My proficiency in [skill_ref.name] grows to [SSskills.level_names[known_skills[skill_ref]]]!"))
			skill_ref.skill_level_effect(known_skills[skill_ref], src)
			GLOB.vanderlin_round_stats[STATS_SKILLS_LEARNED]++
			if(istype(skill_ref, /datum/skill/combat))
				GLOB.vanderlin_round_stats[STATS_COMBAT_SKILLS]++
			if(istype(skill_ref, /datum/skill/craft))
				GLOB.vanderlin_round_stats[STATS_CRAFT_SKILLS]++
			if(skill == /datum/skill/misc/reading && old_level == SKILL_LEVEL_NONE && current.is_literate())
				GLOB.vanderlin_round_stats[STATS_LITERACY_TAUGHT]++
		if(skill == /datum/skill/magic/arcane)
			current?.mind?.adjust_spellpoints(1)

		return TRUE
	else
		to_chat(current, span_warning("My [skill_ref.name] has weakened to [SSskills.level_names[known_skills[skill_ref]]]!"))


/**
 * adjusts the skill level
 * Vars:
 ** skill - associated skill to change
 ** amt - how much to change the skill
 ** silent - wether the player will be notified about their skill change or not
*/
/datum/skill_holder/proc/adjust_skillrank(skill, amt, silent = FALSE)
	if(!amt)
		return
	if(!skill)
		CRASH("adjust_skillrank was called without a specified skill!")
	/// The skill we are changing
	var/datum/skill/skill_ref = GetSkillRef(skill)
	/// How much experience the mob gets at the end
	var/amt2gain = 0
	// Give spellpoints if the skill is arcane
	if(skill == /datum/skill/magic/arcane)
		current.mind?.adjust_spellpoints(amt)
	if(amt > 0)
		for(var/i in 1 to amt)
			switch(skill_experience[skill_ref])
				if(SKILL_EXP_MASTER to SKILL_EXP_LEGENDARY)
					amt2gain = SKILL_EXP_LEGENDARY-skill_experience[skill_ref]
				if(SKILL_EXP_EXPERT to SKILL_EXP_MASTER)
					amt2gain = SKILL_EXP_MASTER-skill_experience[skill_ref]
				if(SKILL_EXP_JOURNEYMAN to SKILL_EXP_EXPERT)
					amt2gain = SKILL_EXP_EXPERT-skill_experience[skill_ref]
				if(SKILL_EXP_APPRENTICE to SKILL_EXP_JOURNEYMAN)
					amt2gain = SKILL_EXP_JOURNEYMAN-skill_experience[skill_ref]
				if(SKILL_EXP_NOVICE to SKILL_EXP_APPRENTICE)
					amt2gain = SKILL_EXP_APPRENTICE-skill_experience[skill_ref]
				if(0 to SKILL_EXP_NOVICE)
					amt2gain = SKILL_EXP_NOVICE-skill_experience[skill_ref] + 1
			if(!skill_experience[skill_ref])
				amt2gain = SKILL_EXP_NOVICE+1
			skill_experience[skill_ref] = max(0, skill_experience[skill_ref] + amt2gain) //Prevent going below 0
	if(amt < 0)
		var/flipped_amt = -amt
		for(var/i in 1 to flipped_amt)
			switch(skill_experience[skill_ref])
				if(SKILL_EXP_LEGENDARY)
					amt2gain = SKILL_EXP_MASTER
				if(SKILL_EXP_MASTER to SKILL_EXP_LEGENDARY-1)
					amt2gain = SKILL_EXP_EXPERT
				if(SKILL_EXP_EXPERT to SKILL_EXP_MASTER-1)
					amt2gain = SKILL_EXP_JOURNEYMAN
				if(SKILL_EXP_JOURNEYMAN to SKILL_EXP_EXPERT -1)
					amt2gain = SKILL_EXP_APPRENTICE
				if(SKILL_EXP_APPRENTICE to SKILL_EXP_JOURNEYMAN-1)
					amt2gain = SKILL_EXP_NOVICE
				if(SKILL_EXP_NOVICE to SKILL_EXP_APPRENTICE-1)
					amt2gain = 1
				if(0 to SKILL_EXP_NOVICE)
					amt2gain = 1
			if(!skill_experience[skill_ref])
				amt2gain = 1
			skill_experience[skill_ref] = amt2gain //Prevent going below 0

	var/old_level = known_skills[skill_ref]
	switch(skill_experience[skill_ref])
		if(SKILL_EXP_LEGENDARY to INFINITY)
			known_skills[skill_ref] = SKILL_LEVEL_LEGENDARY
		if(SKILL_EXP_MASTER to SKILL_EXP_LEGENDARY)
			known_skills[skill_ref] = SKILL_LEVEL_MASTER
		if(SKILL_EXP_EXPERT to SKILL_EXP_MASTER)
			known_skills[skill_ref] = SKILL_LEVEL_EXPERT
		if(SKILL_EXP_JOURNEYMAN to SKILL_EXP_EXPERT)
			known_skills[skill_ref] = SKILL_LEVEL_JOURNEYMAN
		if(SKILL_EXP_APPRENTICE to SKILL_EXP_JOURNEYMAN)
			known_skills[skill_ref] = SKILL_LEVEL_APPRENTICE
		if(SKILL_EXP_NOVICE to SKILL_EXP_APPRENTICE)
			known_skills[skill_ref] = SKILL_LEVEL_NOVICE
		if(0 to SKILL_EXP_NOVICE)
			known_skills[skill_ref] = SKILL_LEVEL_NONE
	var/is_new_skill = !(skill_ref in known_skills)
	if(isnull(old_level) && !is_new_skill)
		old_level = SKILL_LEVEL_NONE
	if((isnull(old_level) && is_new_skill) || known_skills[skill_ref] == old_level)
		return
	if(silent)
		return
	if(known_skills[skill_ref] >= old_level)
		SEND_SIGNAL(current, COMSIG_SKILL_RANK_INCREASED, skill_ref, known_skills[skill_ref], old_level)
		to_chat(current, span_nicegreen("I feel like I've become more proficient at [skill_ref.name]!"))
		GLOB.vanderlin_round_stats[STATS_SKILLS_LEARNED]++
		if(istype(skill_ref, /datum/skill/combat))
			GLOB.vanderlin_round_stats[STATS_COMBAT_SKILLS]++
		if(istype(skill_ref, /datum/skill/craft))
			GLOB.vanderlin_round_stats[STATS_CRAFT_SKILLS]++
		if(skill == /datum/skill/misc/reading && old_level == SKILL_LEVEL_NONE && current.is_literate())
			GLOB.vanderlin_round_stats[STATS_LITERACY_TAUGHT]++
	else
		to_chat(current, span_warning("I feel like I've become worse at [skill_ref.name]!"))


/**
 * increases the skill level up to a certain maximum
 * Vars:
 ** skill - associated skill to change
 ** amt - how much to change the skill
 ** max - maximum amount up to which the skill will be changed
*/
/datum/skill_holder/proc/clamped_adjust_skillrank(skill, amt, max, silent)
	adjust_skillrank(skill, clamp(abs(amt - get_skill_level(skill)), 0, max), silent)

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

	var/skill_difference = level - get_skill_level(skill)
	adjust_skillrank(skill, skill_difference, silent)

/**
 * purges all skill levels back down to 0
 * Vars:
 ** silent - do we notify the player of this change?
*/
/datum/skill_holder/proc/purge_all_skills(silent = TRUE)
	known_skills = list()
	skill_experience = list()
	for(var/datum/skill/skill as anything in SSskills.all_skills)
		if(!(skill in skill_experience))
			skill_experience |= skill
			skill_experience[skill] = 0
	if(!silent)
		to_chat(current, span_boldwarning("I forget all my skills!"))



/datum/skill_holder/proc/adjust_apprentice_exp(skill, amt, silent)
	if(length(apprentices))
		for(var/datum/weakref/apprentice_ref as anything in apprentices)
			var/mob/living/apprentice = apprentice_ref.resolve()
			if(!istype(apprentice))
				continue
			if(!(apprentice in view(7, current)))
				continue
			var/multiplier = 0
			if((skill in apprentice_training_skills))
				multiplier = apprentice_training_skills[skill]
			if(apprentice.get_skill_level(skill) <= (get_skill_level(skill) - 1))
				multiplier += 0.25 //this means a base 35% of your xp is also given to nearby apprentices plus skill modifiers.
			if(ishuman(current))
				var/mob/living/carbon/human/H = current
				if(HAS_TRAIT(H, TRAIT_TUTELAGE)) //Base 50% of your xp is given to nearby apprentice
					multiplier += 0.15
			var/apprentice_amt = amt * 0.1 + multiplier
			if(apprentice.mind.add_sleep_experience(skill, apprentice_amt, FALSE, FALSE))
				current.add_stress(/datum/stressevent/apprentice_making_me_proud)
