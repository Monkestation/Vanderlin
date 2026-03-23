#define SKILL_XP_NONE        0
#define SKILL_XP_NOVICE      100
#define SKILL_XP_APPRENTICE  300
#define SKILL_XP_JOURNEYMAN  700
#define SKILL_XP_EXPERT      1500
#define SKILL_XP_MASTER      3100
#define SKILL_XP_LEGENDARY   6300


GLOBAL_VAR_INIT(skill_xp_modifier, 1.0)
GLOBAL_VAR_INIT(sleep_experience_modifier, 1.0)

/datum/attribute_holder
	/// Associative list: skill typepath -> float XP accumulated
	/// Lazy - only populated once a skill receives XP
	var/list/skill_xp
	/// Associative list: skill typepath -> float multiplier override
	var/list/skill_xp_multipliers

/datum/attribute_holder/Destroy()
	skill_xp?.Cut()
	skill_xp_multipliers?.Cut()
	. = ..()

/**
 * Returns the XP required to reach a given raw level (skill_min-skill_max).
 * Used to convert between XP pool and level.
 */
/datum/attribute_holder/proc/xp_for_level(level)
	level = clamp(level, skill_min, skill_max)
	if(level < SKILL_LEVEL_NONE)
		// Negative levels: linear reduction below 0
		// Each negative level costs the same as the first positive tier
		var/progress = level / 10.0 // e.g. -5 gives -0.5
		return SKILL_XP_NONE + progress * SKILL_XP_NOVICE /// this prevents someone at massively negative levels from being fucked forever
	// Which tier does this level sit in, and how far into it are we?
	if(level >= SKILL_LEVEL_LEGENDARY * 10)
		return SKILL_XP_LEGENDARY
	if(level >= SKILL_LEVEL_MASTER * 10)
		var/progress = (level - SKILL_LEVEL_MASTER * 10) / 10.0
		return SKILL_XP_MASTER + progress * (SKILL_XP_LEGENDARY - SKILL_XP_MASTER)
	if(level >= SKILL_LEVEL_EXPERT * 10)
		var/progress = (level - SKILL_LEVEL_EXPERT * 10) / 10.0
		return SKILL_XP_EXPERT + progress * (SKILL_XP_MASTER - SKILL_XP_EXPERT)
	if(level >= SKILL_LEVEL_JOURNEYMAN * 10)
		var/progress = (level - SKILL_LEVEL_JOURNEYMAN * 10) / 10.0
		return SKILL_XP_JOURNEYMAN + progress * (SKILL_XP_EXPERT - SKILL_XP_JOURNEYMAN)
	if(level >= SKILL_LEVEL_APPRENTICE * 10)
		var/progress = (level - SKILL_LEVEL_APPRENTICE * 10) / 10.0
		return SKILL_XP_APPRENTICE + progress * (SKILL_XP_JOURNEYMAN - SKILL_XP_APPRENTICE)
	if(level >= SKILL_LEVEL_NOVICE * 10)
		var/progress = (level - SKILL_LEVEL_NOVICE * 10) / 10.0
		return SKILL_XP_NOVICE + progress * (SKILL_XP_APPRENTICE - SKILL_XP_NOVICE)
	// NONE tier (0-9)
	var/progress = level / 10.0
	return SKILL_XP_NONE + progress * (SKILL_XP_NOVICE - SKILL_XP_NONE)

/**
 * Converts a raw XP value into the corresponding level (skill_min-skill_max).
 * Inverse of xp_for_level().
 */
/datum/attribute_holder/proc/level_for_xp(xp)
	if(xp < SKILL_XP_NONE)
		// Inverse of the negative extension above
		var/progress = xp / SKILL_XP_NOVICE
		return floor(progress * 10)
	if(xp >= SKILL_XP_LEGENDARY)
		return SKILL_LEVEL_LEGENDARY * 10
	if(xp >= SKILL_XP_MASTER)
		var/progress = (xp - SKILL_XP_MASTER) / (SKILL_XP_LEGENDARY - SKILL_XP_MASTER)
		return FLOOR(SKILL_LEVEL_MASTER * 10 + progress * 10, 1)
	if(xp >= SKILL_XP_EXPERT)
		var/progress = (xp - SKILL_XP_EXPERT) / (SKILL_XP_MASTER - SKILL_XP_EXPERT)
		return FLOOR(SKILL_LEVEL_EXPERT * 10 + progress * 10, 1)
	if(xp >= SKILL_XP_JOURNEYMAN)
		var/progress = (xp - SKILL_XP_JOURNEYMAN) / (SKILL_XP_EXPERT - SKILL_XP_JOURNEYMAN)
		return FLOOR(SKILL_LEVEL_JOURNEYMAN * 10 + progress * 10, 1)
	if(xp >= SKILL_XP_APPRENTICE)
		var/progress = (xp - SKILL_XP_APPRENTICE) / (SKILL_XP_JOURNEYMAN - SKILL_XP_APPRENTICE)
		return FLOOR(SKILL_LEVEL_APPRENTICE * 10 + progress * 10, 1)
	if(xp >= SKILL_XP_NOVICE)
		var/progress = (xp - SKILL_XP_NOVICE) / (SKILL_XP_APPRENTICE - SKILL_XP_NOVICE)
		return FLOOR(SKILL_LEVEL_NOVICE * 10 + progress * 10, 1)
	var/progress = xp / SKILL_XP_NOVICE
	return FLOOR(SKILL_LEVEL_NONE + progress * 10, 1)

/**
 * Returns the raw XP accumulated for a skill.
 * Returns 0 for skills that have never received XP.
 */
/datum/attribute_holder/proc/get_skill_xp(skill_type)
	return LAZYACCESS(skill_xp, skill_type) || 0

/**
 * Primary XP grant proc. Call this instead of directly touching raw_attribute_list.
 *
 * Arguments:
 *   skill_type       - typepath of the /datum/attribute/skill being trained
 *   amount           - raw XP to award (before global modifier and per-skill multiplier)
 *   silent           - if TRUE, suppresses level-up chat messages
 *   check_apprentice - if TRUE, shares a portion of XP with any nearby apprentice
 */
/datum/attribute_holder/proc/adjust_experience(skill_type, amount, silent = FALSE, check_apprentice = TRUE, shared = TRUE)
	if(!ispath(skill_type, SKILL))
		return FALSE
	if(HAS_TRAIT(parent, TRAIT_NO_EXPERIENCE))
		return FALSE

	if(shared)
		share_parent_skill_xp(skill_type, amount, silent)

	// Apply global scalar and any per-mob multiplier
	amount *= GLOB.skill_xp_modifier
	amount *= get_skill_xp_multiplier(skill_type)

	// Clamp to prevent going below 0
	var/old_xp = get_skill_xp(skill_type)
	var/new_xp = max(0, old_xp + amount)
	LAZYSET(skill_xp, skill_type, new_xp)

	// Derive the new level from the accumulated XP
	var/old_level = nulltozero(raw_attribute_list[skill_type])
	var/new_level = level_for_xp(new_xp)
	new_level = clamp(new_level, skill_min, skill_max)

	if(new_level == old_level)
		return TRUE // XP recorded, no level change

	apply_skill_level(skill_type, new_level, old_level, silent)

	if(check_apprentice)
		share_apprentice_xp(skill_type, amount, silent)

	return TRUE

/**
 * If a skill has a multiplier set, shares a portion of granted XP upward
 * to any parent skills listed in default_attributes (skill typepaths only).
 */
/datum/attribute_holder/proc/share_parent_skill_xp(skill_type, amount, silent)
	var/datum/attribute/skill/skill = GET_ATTRIBUTE_DATUM(skill_type)
	if(!istype(skill) || !skill?.shared_xp_percent ||  !LAZYLEN(skill.default_attributes))
		return

	var/shared_amount = floor(amount * skill.shared_xp_percent)
	if(!shared_amount)
		return

	for(var/parent_skill_type in skill.default_attributes)
		if(!ispath(parent_skill_type, SKILL))
			continue
		adjust_experience(parent_skill_type, shared_amount, silent, check_apprentice = FALSE, shared = FALSE)

/**
 * Handles special-case side effects on level change.
 * Add new cases here as skills require them.
 */
/datum/attribute_holder/proc/on_skill_level_changed(skill_type, new_level, old_level)
	var/datum/attribute/skill = GET_ATTRIBUTE_DATUM(skill_type)
	skill?.on_level_change(parent, new_level, old_level)

/**
 * Shares a fraction of XP with nearby apprentices.
 * Mirrors the old adjust_apprentice_exp() logic.
 */
/datum/attribute_holder/proc/share_apprentice_xp(skill_type, base_amount, silent)
	// The apprentice relationship is tracked elsewhere (see apprentice system).
	// We fire a signal and let the apprentice system handle the actual grant,
	// so this file stays decoupled from however apprentices are stored.
	SEND_SIGNAL(parent, COMSIG_SHARE_APPRENTICE_XP, skill_type, base_amount, silent)

/**
 * Returns the effective XP multiplier for a skill.
 * Accounts for per-skill overrides and mob quirks.
 */
/datum/attribute_holder/proc/get_skill_xp_multiplier(skill_type)
	var/multiplier = LAZYACCESS(skill_xp_multipliers, skill_type) || 1.0
	if(HAS_TRAIT(parent, TRAIT_TUTELAGE))
		multiplier += 0.05
	if(parent?.has_quirk(/datum/quirk/boon/quick_learner))
		multiplier += 0.2

	// Catchup multiplier: boost XP when skill is below its default-attribute floor
	var/datum/attribute/skill/skill = GET_ATTRIBUTE_DATUM(skill_type)
	if(istype(skill) && LAZYLEN(skill.default_attributes))
		var/current_level = nulltozero(raw_attribute_list[skill_type])
		// Compute the default-derived floor level using the holder's raw attributes
		var/default_floor = 0
		for(var/attr_type in skill.default_attributes)
			if(!ispath(attr_type, SKILL))
				continue
			var/attr_val = nulltozero(raw_attribute_list[attr_type])
			var/adjusted = attr_val + skill.default_attributes[attr_type]
			default_floor = max(default_floor, adjusted)
		// Only apply catchup if we're below the floor
		if(current_level < default_floor)
			var/gap = default_floor - current_level
			var/range = max(1, skill.catchup_level_range)
			// Linear scale: full boost at gap >= range, tapers to 0 bonus at gap = 0
			var/catchup_bonus = (skill.catchup_multiplier - 1.0) * min(gap / range, 1.0)
			multiplier += catchup_bonus

	return multiplier

/**
 * Sets a per-skill XP multiplier.
 * multiplier: 1.0 = normal, 2.0 = double XP, 0.5 = half XP.
 */
/datum/attribute_holder/proc/set_skill_xp_multiplier(skill_type, multiplier)
	LAZYSET(skill_xp_multipliers, skill_type, max(0, multiplier))

/**
 * Adjusts a per-skill XP multiplier by a delta (can be negative).
 */
/datum/attribute_holder/proc/adjust_skill_xp_multiplier(skill_type, delta)
	var/current = get_skill_xp_multiplier(skill_type)
	LAZYSET(skill_xp_multipliers, skill_type, max(0, current + delta))

/**
 * Resets a per-skill XP multiplier back to 1.0.
 */
/datum/attribute_holder/proc/remove_skill_xp_multiplier(skill_type)
	LAZYREMOVE(skill_xp_multipliers, skill_type)

/**
 * Returns an additive multiplier to apply to XP grants based on
 * the mob's age and traits. Equivalent to old get_learning_boon().
 *
 * Call this at the XP grant site if you want age to affect learning speed:
 *   amount *= get_learning_boon(skill_type)
 * It is NOT automatically applied in adjust_experience() so callers can
 * opt out (e.g. admin-forced XP grants should ignore age penalties).
 */
/datum/attribute_holder/proc/get_learning_boon(skill_type)
	var/boon = 1.0
	// Higher skill = harder to keep improving (diminishing returns on the boon itself)
	boon += nulltozero(raw_attribute_list[skill_type]) / 600.0 // max +0.1 at level 60
	if(!ishuman(parent))
		return boon
	var/mob/living/carbon/human/H = parent
	if(H.age == AGE_OLD)
		boon -= 0.2
	else if(H.age == AGE_CHILD)
		boon += 0.2
	return boon

/**
 * Returns an additive bonus to XP gains from actiive stress events.
 * Base mob returns 0 - only carbon mobs accumulate stress events.
 */
/mob/proc/get_inspirational_bonus()
	return 0

/**
 * Sums quality_modifier from all active stress events on this carbon mob.
 * Positive stress events (pride, accomplishment) give bonus XP.
 * Negative ones (fear, exhaustion) can reduce it.
 */
/mob/living/carbon/get_inspirational_bonus()
	var/bonus = 0
	for(var/datum/stress_event/event in stressors)
		bonus += event.quality_modifier
	return bonus
