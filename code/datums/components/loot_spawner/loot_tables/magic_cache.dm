/datum/loot_table/magic_cache
	name = "magic cache"
	loot_table = list(
		/datum/attribute/skill/magic/arcane = list(
			/obj/item/chalk = 8,
			/obj/item/reagent_containers/glass/bottle/manapot = 5,
			4, // requires level 4 arcane for focus
			/obj/item/mana_battery/mana_crystal/small/focus = 7,
		),
		list(
			/obj/item/mana_battery/mana_crystal/standard = 25,
			/obj/item/reagent_containers/food/snacks/produce/manabloom = 15,
			/obj/item/natural/obsidian = 10,
			/obj/item/natural/leyline = 7,
			/obj/item/natural/elementalmote = 5,
			/obj/item/natural/infernalash = 5,
			/obj/item/natural/fairydust = 5,
		)
	)

	base_min = 3
	base_max = 4

	scaling_factor = 0.2
