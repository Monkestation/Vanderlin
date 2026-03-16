/datum/loot_table/powder_sack
	name = "powder sack"
	loot_table = list(
		/datum/attribute/skill/misc/stealing = list(
			4,
			/obj/item/reagent_containers/powder/ozium = 10,
			5,
			/obj/item/reagent_containers/powder/spice = 10,
			/obj/item/reagent_containers/powder/moondust = 10,
		),
		/datum/attribute/skill/craft/alchemy = list(
			4,
			/obj/item/reagent_containers/powder/ozium = 10,
			5,
			/obj/item/reagent_containers/powder/spice = 10,
			/obj/item/reagent_containers/powder/moondust = 10,
		),
		list(
			/obj/item/reagent_containers/powder/flour = 25,
			/obj/item/reagent_containers/powder/salt = 10,
			/obj/item/reagent_containers/food/snacks/sugar = 10,
			/obj/item/reagent_containers/powder/manabloom = 2,
		)
	)

	base_min = 1
	base_max = 2

	scaling_factor = 0.2
