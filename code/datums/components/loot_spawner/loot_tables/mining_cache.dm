/datum/loot_table/mining_cache
	name = "mining cache"
	loot_table = list(
		/datum/attribute/skill/labor/mining = list(
			/obj/item/gem = 5,
			/obj/item/ore/silver = 8,
			3, // requires level 3 mining for gold ore
			/obj/item/ore/gold = 10,
		),
		list(
			/obj/item/ore/coal = 25,
			/obj/item/ore/iron = 10,
			/obj/item/ore/copper = 10,
			/obj/item/ore/tin = 10,
			/obj/item/ore/cinnabar = 5,
		)
	)

	base_min = 2
	base_max = 3

	scaling_factor = 0.1
