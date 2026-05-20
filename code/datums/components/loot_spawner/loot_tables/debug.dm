/obj/structure/closet/crate/chest/gold/debug
	name = "loot table testing chest"

/obj/structure/closet/crate/chest/gold/debug/Initialize()
	. = ..()
	AddComponent(/datum/component/loot_spawner, /datum/loot_table/debug, 100, 100)

/datum/loot_table/debug
	name = "testing table"
	loot_table = list(
		STAT_FORTUNE = list(
			/obj/item/coin/gold = 5,
			/obj/item/coin/silver = 10,
			200,
			/obj/item/coin/copper = 25,
		),
		/datum/attribute/skill/misc/stealing = list(
			/obj/item/gem/green = 5,
			/obj/item/gem/blue = 10,
			/obj/item/lockpick = 25,
		),
		list(
			/obj/item/reagent_containers/food/snacks/biscuit = 25,
			/obj/item/reagent_containers/food/snacks/breadslice/toast = 10,
		)
	)

	base_min = 10
	base_max = 15

	scaling_factor = 1
