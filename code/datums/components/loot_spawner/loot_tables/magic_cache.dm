/datum/loot_table/magic_cache
	name = "magic cache"
	cascading = TRUE
	loot_table = list(
		/datum/loot_table/magic_cache/arcane_focus = 8,
		/datum/loot_table/magic_cache/arcane = 15,
		/datum/loot_table/magic_cache/basic = 100
	)

	base_min = 3
	base_max = 4

	scaling_factor = 0.2

/datum/loot_table/magic_cache/basic
	loot_table = list(
		/obj/item/mana_battery/mana_crystal/standard = 25,
		/obj/item/reagent_containers/food/snacks/produce/manabloom = 15,
		/obj/item/natural/obsidian = 10,
		/obj/item/natural/leyline = 7,
		/obj/item/natural/elementalmote = 5,
		/obj/item/natural/infernalash = 5,
		/obj/item/natural/fairydust = 5
	)
	cascading = FALSE

/datum/loot_table/magic_cache/arcane
	req_keys = list(/datum/attribute/skill/magic/arcane)
	loot_table = list(
		/obj/item/chalk = 8,
		/obj/item/reagent_containers/glass/bottle/manapot = 5
	)
	cascading = FALSE

/// Needs level 4 arcane
/datum/loot_table/magic_cache/arcane_focus
	req_keys = list(/datum/attribute/skill/magic/arcane)
	min_level = 40
	loot_table = list(
		/obj/item/mana_battery/mana_crystal/small/focus = 1
	)
	cascading = FALSE
