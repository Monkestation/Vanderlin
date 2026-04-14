/datum/attribute/skill
	/// Skill category we fall under - DO NOT FORGET TO SET THIS, IT BREAKS SHIT
	var/category = SKILL_CATEGORY_GENERAL
	/**
	 * This is the attribute that governs us.
	 * A person's effective skill will always be primary attribute default value + skill value
	 * The only exception is when we have null (not 0) skill, then we will use a skill default (check holder.dm)
	 */
	var/governing_attribute
	/*
	 * Most skills have a related attribute which gets used on dicerolls when you don't know the skill
	 * This is an associative list of all possible attributes to get a default in return_effective_skill()
	 * Attribute - Modifier to be added to attribute
	 * Remember - Double defaults are not possible!
	 */
	var/list/default_attributes
	/// Difficulty of a skill, mostly a simple indicator for players of how good the defaults are
	var/difficulty = SKILL_DIFFICULTY_AVERAGE
	///can we be dreamed of?
	var/randomable_dream_xp = TRUE
	///this is our list of dream strings
	var/list/dreams
	/// Base dream point cost at tier 1 (novice)
	var/dream_cost_base = 1
	/// Additional dream points per tier above novice
	var/dream_cost_per_level = 1
	/// Extra cost on top at legendary tier
	var/dream_legendary_extra_cost = 0
	/// Override costs by tier index (1=novice .. 6=legendary). Optional.
	var/list/specific_dream_costs
	/// How many levels below the default-derived floor the catchup XP multiplier applies.
	/// e.g. 10 means full boost starts 10 levels below the default and tapers to 1.0 at the default.
	var/catchup_level_range = SKILL_XP_CATCHUP_LEVEL_FLOOR
	/// Peak XP multiplier applied when the skill is at the bottom of the catchup range.
	/// Scales linearly down to 1.0 as the skill approaches the default floor.
	var/catchup_multiplier = SKILL_XP_CATCHUP_MULTIPLIER_MAX
	///if this is set it will apply this multiplier to the PRE catchup xp and pass it up to the default_attribute skills
	var/shared_xp_percent = 0

/datum/attribute/skill/description_from_level(level)
	if(isnull(level))
		return "untrained"
	switch(CEILING(level, 1))
		if(-INFINITY to 9)
			return "untrained"
		if(10 to 19)
			return "novice"
		if(20 to 29)
			return "apprentice"
		if(30 to 39)
			return "journeyman"
		if(40 to 49)
			return "expert"
		if(50 to 59)
			return "master"
		if(60 to INFINITY)
			return "legendary"
		else
			return "invalid"

/datum/attribute/skill/proc/get_skill_speed_modifier(level)
	if(isnull(level) || level < 10)
		return 1.3    // untrained
	if(level < 20)
		return 1.2    // novice
	if(level < 30)
		return 1.1    // apprentice
	if(level < 40)
		return 1.0    // journeyman
	if(level < 50)
		return 0.9    // expert
	if(level < 60)
		return 0.75   // master
	return 0.5         // legendary

/datum/attribute/skill/proc/get_random_dream()
	if(!dreams)
		return null
	return pick(dreams)

/**
 * Returns the dream point cost to advance into the tier containing 'level'.
 * Level is in 0-60 range. Tier index is 1 (novice) to 6 (legendary).
 *
 * Example: level 21 is in the apprentice tier -> tier index 2
 *          cost = dream_cost_base + dream_cost_per_level * (2 - 1)
 */
/datum/attribute/skill/proc/get_dream_cost_for_level(level)
	// Map level to 1-based tier index: levels 1-10 = tier 1, 11-20 = tier 2, etc.
	var/tier = clamp(CEILING(level, 10) / 10, 1, 6)
	if(LAZYLEN(specific_dream_costs) >= tier)
		return specific_dream_costs[tier]
	var/cost = FLOOR(dream_cost_base + (dream_cost_per_level * (tier - 1)), 1)
	if(tier == 6) // legendary tier
		cost += dream_legendary_extra_cost
	return cost
