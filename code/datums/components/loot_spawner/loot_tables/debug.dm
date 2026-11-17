/obj/structure/closet/crate/chest/gold/debug
	name = "loot table testing chest"

/obj/structure/closet/crate/chest/gold/debug/Initialize()
	. = ..()
	AddComponent(/datum/component/loot_spawner, /datum/loot_table/debug, 100, 100)

/datum/loot_table/debug
	name = "testing table"
	cascading = TRUE
	loot_table = list(
		/datum/loot_table/debug/fortune_high = 25,
		/datum/loot_table/debug/stealing = 40,
		/datum/loot_table/debug/fortune = 50,
		/datum/loot_table/debug/basic = 100
	)

	base_min = 10
	base_max = 15

	scaling_factor = 1

/datum/loot_table/debug/basic
	loot_table = list(
		/obj/item/reagent_containers/food/snacks/biscuit = 25,
		/obj/item/reagent_containers/food/snacks/breadslice/toast = 10
	)
	cascading = FALSE

/datum/loot_table/debug/fortune
	req_keys = list(STAT_FORTUNE)
	loot_table = list(
		/obj/item/coin/gold = 5,
		/obj/item/coin/silver = 10
	)
	cascading = FALSE

/datum/loot_table/debug/fortune_high
	req_keys = list(STAT_FORTUNE)
	min_level = 200
	loot_table = list(
		/obj/item/coin/copper = 25
	)
	cascading = FALSE

/datum/loot_table/debug/stealing
	req_keys = list(/datum/attribute/skill/misc/stealing)
	loot_table = list(
		/obj/item/gem/green = 5,
		/obj/item/gem/blue = 10,
		/obj/item/lockpick = 25
	)
	cascading = FALSE
