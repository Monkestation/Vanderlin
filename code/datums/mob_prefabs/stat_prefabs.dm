/// Assigns stat mods. You can double these up, e.g. using a weak prefab and a proposed "brute" stat table that makes you dumb but stronger
/datum/mob_prefab/stats
	abstract_type = /datum/mob_prefab/stats
	/// assoclist of statkey to value
	var/alist/stat_mods
	/// any traits we want to tie to stats, like critical weakness
	var/list/traits

/datum/mob_prefab/stats/assign_prefab(mob/living/target)
	. = ..()
	if(!.)
		return
	target.adjust_stat_modifier_list(type, stat_mods)
	for(var/T in traits)
		ADD_TRAIT(target, T, "[type]")

/datum/mob_prefab/stats/weak
	stat_mods = alist(
		STATKEY_STR = -2,
		STATKEY_PER = 0,
		STATKEY_INT = -2,
		STATKEY_CON = 2,
		STATKEY_END = 2,
		STATKEY_SPD = 4,
		STATKEY_LCK = -1,
	)
	traits = list(TRAIT_CRITICAL_WEAKNESS)

/datum/mob_prefab/stats/average
	stat_mods = alist(
		STATKEY_STR = 0,
		STATKEY_PER = 1,
		STATKEY_INT = 0,
		STATKEY_CON = 2,
		STATKEY_END = 2,
		STATKEY_SPD = 4,
		STATKEY_LCK = -1,
	)

/datum/mob_prefab/stats/hard
	stat_mods = alist(
		STATKEY_STR = 3,
		STATKEY_PER = 3,
		STATKEY_INT = 0,
		STATKEY_CON = 2,
		STATKEY_END = 0,
		STATKEY_SPD = 4,
		STATKEY_LCK = 0,
	)
	traits = list(TRAIT_CRITICAL_RESISTANCE)

/// Modifiers - throw these on to jazz them up
/datum/mob_prefab/stats/swift
	stat_mods = alist(
		STATKEY_SPD = 2
	)
/datum/mob_prefab/stats/slow
	stat_mods = alist(
		STATKEY_SPD = -2
	)

/datum/mob_prefab/stats/meathead
	stat_mods = alist(
		STATKEY_STR = 2,
		STATKEY_INT = -2
	)

/datum/mob_prefab/stats/ranger
	stat_mods = alist(
		STATKET_PER = 2,
		STATKEY_CON = -2,
	)

/datum/mob_prefab/stats/lucky
	stat_mods = alist(
		STATKEY_LCK = 1
	)

/datum/mob_prefab/stats/cunning
	stat_mods = alist(
		STATKEY_INT = 2
	)

/datum/mob_prefab/stats/dim
	stat_mods = alist(
		STATKEY_PER = -2
	)
