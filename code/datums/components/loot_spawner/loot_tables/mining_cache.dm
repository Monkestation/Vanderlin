/datum/loot_table/mining_cache
	name = "mining cache"
	cascading = TRUE
	loot_table = list(
		/datum/loot_table/mining_cache/gold = 12,
		/datum/loot_table/mining_cache/skilled = 18,
		/datum/loot_table/mining_cache/basic = 100
	)

	base_min = 2
	base_max = 3

	scaling_factor = 0.1

/datum/loot_table/mining_cache/basic
	loot_table = list(
		/obj/item/ore/coal = 25,
		/obj/item/ore/iron = 10,
		/obj/item/ore/copper = 10,
		/obj/item/ore/tin = 10,
		/obj/item/ore/cinnabar = 5
	)
	cascading = FALSE

/datum/loot_table/mining_cache/skilled
	req_keys = list(/datum/attribute/skill/labor/mining)
	loot_table = list(
		/obj/item/gem = 5,
		/obj/item/ore/silver = 8
	)
	cascading = FALSE

/// Needs level 3 mining
/datum/loot_table/mining_cache/gold
	req_keys = list(/datum/attribute/skill/labor/mining)
	min_level = 30
	loot_table = list(
		/obj/item/ore/gold = 1
	)
	cascading = FALSE
