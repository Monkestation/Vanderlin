#define LOOT_MAX_DEPTH 6

/datum/loot_table
	var/name = "generic table"

	/// Weighted: path = weight. Cascading: ordered path = chance (rarest first).
	var/list/loot_table = list()
	/// TRUE = roll entries top to bottom as percentage chances instead of pickweight.
	var/cascading = FALSE
	/// Cascading only: percentage points added to every chance below 100 per level of fortune.
	var/luck_chance_bonus = 0

	// These only matter if you use it as a sub table.
	/// Stats (STAT_*) and/or skill paths. The looter's HIGHEST level among these is used,
	/// so listing several keys means "any of these".
	var/list/req_keys = list()
	/// Minimum level in req_keys needed for this sub-table to be in play at all.
	var/min_level = 0
	/// Growth per level above min_level. Leave null for defaults
	/// (fortune 0.99, other stats 1.02, skills 1.05).
	var/growth_factor = null
	/// How many picks are made on this table when a parent cascades into it.
	var/rolls = 1

	/// Bare minimum spawn count.
	var/base_min = 1
	/// Bare maximum spawn count. Luck * scaling_factor is added to min and max.
	var/base_max = 3
	/// How much each point of fortune affects the min and max.
	var/scaling_factor = 0.4

/// Returns a shared instance of a loot table type.
/proc/get_loot_table(table_path)
	var/static/list/table_cache = list()
	var/datum/loot_table/table = table_cache[table_path]
	if(!table)
		table = new table_path()
		table_cache[table_path] = table
	return table

/// Rolls the table and spawns the results. Returns the list of spawned things.
/datum/loot_table/proc/spawn_loot(mob/living/looter = null)
	var/mob_stat_level = 0
	if(istype(looter))
		mob_stat_level = looter.get_stat_level(STAT_FORTUNE)

	var/adjusted_min = base_min + round(mob_stat_level * scaling_factor, 1)
	var/adjusted_max = base_max + round(mob_stat_level * scaling_factor, 1)

	adjusted_min = min(adjusted_min, adjusted_max)
	var/spawn_count = rand(adjusted_min, adjusted_max)

	var/turf/spawn_location = looter ? get_turf(looter) : null

	var/list/loot = list()
	for(var/spawn_path in roll_table(looter, spawn_count))
		var/atom/movable/new_spawn = new spawn_path(spawn_location)
		if(spawn_location && istype(looter))
			looter.put_in_active_hand(new_spawn)
		loot += new_spawn
	return loot

/// Makes `picks` picks on this table. Returns a list of item PATHS.
/datum/loot_table/proc/roll_table(mob/living/looter = null, picks = 1, depth = 0)
	var/list/results = list()
	if(depth > LOOT_MAX_DEPTH)
		CRASH("Loot table [type] cascaded deeper than [LOOT_MAX_DEPTH] levels, check for a loop.")

	if(cascading)
		for(var/i in 1 to picks)
			results += roll_cascade(looter, depth)
		return results

	var/list/pool = build_pool(looter)
	if(!length(pool))
		return results

	for(var/i in 1 to picks)
		var/choice = pickweight(pool)
		if(!choice)
			continue
		results += resolve_entry(choice, looter, depth)
	return results

/// Cascading pick: walk the list top to bottom, first successful chance roll wins.
/datum/loot_table/proc/roll_cascade(mob/living/looter, depth)
	var/fortune = 0
	if(istype(looter))
		fortune = looter.get_stat_level(STAT_FORTUNE)

	for(var/entry in loot_table)
		var/chance = loot_table[entry]
		if(ispath(entry, /datum/loot_table))
			var/datum/loot_table/sub_table = get_loot_table(entry)
			chance = sub_table.scale_weight(chance, looter)
			if(chance <= 0)
				continue // gated out, fall through to the next tier
		if(chance < 100)
			chance = min(100, chance + fortune * luck_chance_bonus)
		if(!prob(chance))
			continue
		return resolve_entry(entry, looter, depth)
	return list()

/// Turns a chosen entry into item paths, descending if it is a sub-table.
/datum/loot_table/proc/resolve_entry(entry, mob/living/looter, depth)
	if(ispath(entry, /datum/loot_table))
		var/datum/loot_table/sub_table = get_loot_table(entry)
		return sub_table.roll_table(looter, sub_table.rolls, depth + 1)
	return list(entry)

/// Weighted mode: builds the pool, dropping sub-tables the looter doesn't qualify for.
/datum/loot_table/proc/build_pool(mob/living/looter = null)
	var/list/pool = list()
	for(var/entry in loot_table)
		var/weight = loot_table[entry]
		if(ispath(entry, /datum/loot_table))
			var/datum/loot_table/sub_table = get_loot_table(entry)
			weight = sub_table.scale_weight(weight, looter)
		else
			weight = max(0.01, weight)
		if(weight <= 0)
			continue
		pool[entry] = weight
	return pool

/// Applies this table's gate to its weight/chance in the parent. 0 = excluded.
/datum/loot_table/proc/scale_weight(base_value, mob/living/looter = null)
	if(!length(req_keys))
		return max(0.01, base_value)
	if(!istype(looter))
		return base_value

	var/best_level = -1
	var/best_key = null
	for(var/key in req_keys)
		var/level = get_key_level(key, looter)
		if(level > best_level)
			best_level = level
			best_key = key

	if(best_level < min_level)
		return 0

	var/levels_over = best_level - min_level
	if(levels_over <= 0)
		return max(0.01, base_value)

	var/growth = get_growth(best_key)
	return max(0.01, base_value * (1 + growth ** levels_over))

/datum/loot_table/proc/get_key_level(key, mob/living/looter)
	if(ispath(key, /datum/attribute/skill))
		return GET_MOB_SKILL_VALUE(looter, key)
	if(key in MOBSTATS)
		return looter.get_stat_level(key)
	return 0

/datum/loot_table/proc/get_growth(key)
	if(!isnull(growth_factor))
		return growth_factor
	if(key == STAT_FORTUNE)
		return 0.99
	if(ispath(key, /datum/attribute/skill))
		return 1.05
	return 1.02

#undef LOOT_MAX_DEPTH
