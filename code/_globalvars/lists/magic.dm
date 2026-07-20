GLOBAL_LIST_INIT(rune_types, generate_rune_types_for_tier(null))
GLOBAL_LIST_INIT(t1rune_types, generate_rune_types_for_tier(1))
GLOBAL_LIST_INIT(t2rune_types, generate_rune_types_for_tier(2))
GLOBAL_LIST_INIT(t3rune_types, generate_rune_types_for_tier(3))
GLOBAL_LIST_INIT(t4rune_types, generate_rune_types_for_tier(4))
/// List of all teleport runes currently active in the world
GLOBAL_LIST(teleport_runes)


/// Builds an assoc list of [rune.name] = typepath for all scribable runes.
/// Pass max_tier = null to include every tier (used for the admin/debug list).
/proc/generate_rune_types_for_tier(max_tier)
	RETURN_TYPE(/list)
	var/list/runes = list()
	for(var/obj/effect/decal/cleanable/ritual_rune/rune as anything in subtypesof(/obj/effect/decal/cleanable/ritual_rune))
		if(!initial(rune.can_be_scribed))
			continue
		if(!isnull(max_tier) && initial(rune.tier) > max_tier)
			continue
		runes[initial(rune.name)] = rune
	return runes

GLOBAL_LIST_INIT(allowedrunerituallist, generate_ritual_list(/datum/runerituals, exclude_types = list(/datum/runerituals/summoning, /datum/runerituals/wall)))

GLOBAL_LIST_INIT(t1summoningrunerituallist, generate_ritual_list(/datum/runerituals/summoning, max_tier = 1))
GLOBAL_LIST_INIT(t2summoningrunerituallist, generate_ritual_list(/datum/runerituals/summoning, max_tier = 2))
GLOBAL_LIST_INIT(t3summoningrunerituallist, generate_ritual_list(/datum/runerituals/summoning, max_tier = 3))
GLOBAL_LIST_INIT(t4summoningrunerituallist, generate_ritual_list(/datum/runerituals/summoning))

GLOBAL_LIST_INIT(t2wallrunerituallist, generate_ritual_list(/datum/runerituals/wall, max_tier = 2))
GLOBAL_LIST_INIT(t4wallrunerituallist, generate_ritual_list(/datum/runerituals/wall, min_tier = 3))

GLOBAL_LIST_INIT(buffrunerituallist, generate_ritual_list(/datum/runerituals/buff, max_tier = 1))
GLOBAL_LIST_INIT(t2buffrunerituallist, generate_ritual_list(/datum/runerituals/buff))

/**
 * Builds an assoc list of [ritual.name] = typepath from subtypes of root_type.
 *
 * Arguments:
 * * root_type - The parent type to search under (uses subtypesof).
 * * max_tier - If set, skips rituals with tier > max_tier.
 * * min_tier - If set, skips rituals with tier < min_tier.
 * * exclude_types - List of typepaths; rituals that are or inherit from any of these are skipped.
 * Uses istype() so child types are also excluded.
 */
/proc/generate_ritual_list(root_type, max_tier = null, min_tier = null, list/exclude_types = null)
	RETURN_TYPE(/list)
	var/list/out = list()
	for(var/datum/runerituals/R as anything in subtypesof(root_type))
		if(initial(R.blacklisted))
			continue
		var/r_tier = initial(R.tier)
		if(!isnull(max_tier) && r_tier > max_tier)
			continue
		if(!isnull(min_tier) && r_tier < min_tier)
			continue
		if(length(exclude_types))
			var/excluded = FALSE
			for(var/exc in exclude_types)
				if(istype(R, exc))
					excluded = TRUE
					break
			if(excluded)
				continue
		out[initial(R.name)] = R
	return out
