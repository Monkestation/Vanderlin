/datum/attribute_holder
	/// TRUE if this mob is currently someone's apprentice
	var/is_apprentice = FALSE
	/// Max apprentices this mob can take on. 0 = cannot take apprentices.
	var/max_apprentices = 0
	/// Display name shown to the youngling when offered apprenticeship (e.g. "Blacksmith Apprentice")
	var/apprentice_name
	/// The title shown to this mob (e.g. "Gareth's Blacksmith Apprentice")
	var/our_apprentice_name
	/// Weak references to current apprentices
	var/list/apprentices
	/// Associative list: skill typepath -> additive XP share multiplier bonus for that skill
	var/list/apprentice_training_skills

/datum/attribute_holder/Destroy()
	apprentices = null
	apprentice_training_skills = null
	. = ..()

/**
 * Offers apprenticeship to youngling. Prompts them for confirmation.
 * Does nothing if tutor is at max apprentices, either party is unconscious,
 * or youngling is already an apprentice.
 */
/datum/attribute_holder/proc/make_apprentice(mob/living/youngling)
	if(isnull(youngling))
		CRASH("make_apprentice called without an argument!")
	if(youngling.attributes?.is_apprentice)
		return
	if(LAZYLEN(apprentices) >= max_apprentices)
		return
	if(parent.stat >= UNCONSCIOUS || youngling.stat >= UNCONSCIOUS)
		return

	var/choice = input(youngling, "Do you wish to become [parent.name]'s apprentice?") as anything in list("Yes", "No")

	// Re-check conditions after async input
	if(LAZYLEN(apprentices) >= max_apprentices)
		return
	if(parent.stat >= UNCONSCIOUS || youngling.stat >= UNCONSCIOUS)
		return
	if(choice != "Yes")
		to_chat(parent, span_warning("[youngling] has rejected your apprenticeship!"))
		return

	LAZYADD(apprentices, WEAKREF(youngling))
	youngling.attributes.is_apprentice = TRUE

	// Build the apprentice title
	var/title
	if(apprentice_name)
		title = apprentice_name // Advanced class override
	else
		var/datum/job/job = SSjob.GetJob(parent:job)
		title = "[job.get_informed_title(youngling)] Apprentice"
	youngling.attributes.our_apprentice_name = "[parent.real_name]'s [title]"

	to_chat(parent, span_notice("[youngling.real_name] has become your apprentice."))
	SEND_SIGNAL(parent, COMSIG_APPRENTICE_MADE, youngling)

/**
 * Shares a fraction of XP with nearby apprentices.
 * Called via COMSIG_SHARE_APPRENTICE_XP signal fired in adjust_experience().
 *
 * Multiplier breakdown:
 *   Base share:                    0.10
 *   Tutor has TRAIT_TUTELAGE:     +0.15
 *   Per-skill training bonus:     +apprentice_training_skills[skill] if set
 *   Apprentice below tutor level: +0.25
 *   ──────────────────────────────────
 *   Typical trained share:         0.50  (10 + 15 + 25)
 */
/datum/attribute_holder/proc/adjust_apprentice_exp(skill_type, base_amount, silent)
	if(!LAZYLEN(apprentices))
		return

	var/tutor_level = nulltozero(raw_attribute_list[skill_type])
	var/list/surroundings = view(7, parent)
	var/taught_anyone = FALSE

	for(var/datum/weakref/ref as anything in apprentices)
		var/mob/living/apprentice = ref.resolve()
		if(!istype(apprentice))
			continue
		if(!(apprentice in surroundings))
			continue

		var/multiplier = 0
		if(HAS_TRAIT(parent, TRAIT_TUTELAGE))
			multiplier += 0.15
		if(LAZYACCESS(apprentice_training_skills, skill_type))
			multiplier += apprentice_training_skills[skill_type]
		if(nulltozero(apprentice.attributes?.raw_attribute_list[skill_type]) >= APPRENTICE_SKILL_CAP)
			continue
		if(nulltozero(apprentice.attributes?.raw_attribute_list[skill_type]) < tutor_level)
			multiplier += 0.25

		var/share = base_amount * (0.1 + multiplier)
		// Route through mind's sleep experience system to preserve that mechanic
		if(apprentice.mind?.add_sleep_experience(skill_type, share, FALSE, FALSE))
			taught_anyone = TRUE
			SEND_SIGNAL(parent, COMSIG_TAUGHT_APPRENTICE, apprentice, skill_type, share)

	if(taught_anyone)
		parent.add_stress(/datum/stress_event/apprentice_making_me_proud)

/datum/attribute_holder/proc/onshare_apprentice_xp(mob/source, skill_type, base_amount, silent)
	SIGNAL_HANDLER
	adjust_apprentice_exp(skill_type, base_amount, silent)

/**
 * Offers apprenticeship to youngling on behalf of this mob.
 */
/mob/proc/make_apprentice(mob/living/youngling)
	attributes?.make_apprentice(youngling)

/**
 * Returns TRUE if this mob is currently an apprentice.
 */
/mob/proc/is_apprentice()
	return attributes?.is_apprentice

/**
 * Returns the list of this mob's current apprentices (list of WEAKREFs).
 */
/mob/proc/return_apprentices()
	return attributes?.apprentices

/**
 * Returns the max number of apprentices this mob can have.
 */
/mob/proc/return_max_apprentices()
	return attributes?.max_apprentices

/**
 * Sets the max number of apprentices this mob can have.
 */
/mob/proc/set_max_apprentices(new_max)
	attributes.max_apprentices = new_max

/**
 * Returns the display title for apprentices of this mob.
 */
/mob/proc/return_apprentice_name()
	return attributes?.apprentice_name

/**
 * Sets the display title for apprentices of this mob (e.g. for advanced classes).
 */
/mob/proc/set_apprentice_name(new_name)
	attributes?.apprentice_name = new_name

/**
 * Returns the title this mob holds as someone's apprentice.
 * e.g. "Gareth's Blacksmith Apprentice"
 */
/mob/proc/return_our_apprentice_name()
	return attributes?.our_apprentice_name

/**
 * Sets per-skill XP share bonus multipliers for apprentice training.
 * list format: skill typepath = additive float multiplier
 */
/mob/proc/set_apprentice_training_skills(list/trainable_skills)
	attributes?.apprentice_training_skills = trainable_skills
