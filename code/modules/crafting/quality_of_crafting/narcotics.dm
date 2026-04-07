
/datum/repeatable_crafting_recipe/narcotics
	abstract_type = /datum/repeatable_crafting_recipe/narcotics
	tool_usage = list(
		/obj/item/pestle = list("starts to grind materials in the mortar", "start to grind materials in the mortar", 'sound/foley/mortarpestle.ogg'),
	)

	reagent_requirements = list(
		/datum/reagent/water = 10,
	)

	starting_atom = /obj/item/pestle
	attacked_atom = /obj/item/reagent_containers/glass/mortar
	skillcraft = /datum/attribute/skill/craft/alchemy
	tool_use_time = 4 SECONDS
	craft_time = 6 SECONDS
	category = "Narcotics"

/datum/repeatable_crafting_recipe/narcotics/spice
	name = "Spice"
	output = /obj/item/reagent_containers/powder/spice
	requirements = list(
		/obj/item/alch/swampdust = 2,
		/obj/item/alch/firedust = 1,
		/obj/item/reagent_containers/powder/ozium = 1
	)
	craftdiff = 3
	sellprice = 16

/datum/repeatable_crafting_recipe/narcotics/moondust
	name = "Moondust"
	output = /obj/item/reagent_containers/powder/moondust
	requirements = list(
		/obj/item/alch/earthdust = 2,
		/obj/item/alch/waterdust = 1,
		/obj/item/reagent_containers/powder/ozium = 1
	)
	craftdiff = 3
	sellprice = 16

/datum/repeatable_crafting_recipe/narcotics/moondustpurify
	name = "Purify Moondust"
	output = /obj/item/reagent_containers/powder/moondust_purest
	requirements = list(
		/obj/item/alch/silverdust = 1,
		/obj/item/alch/magicdust = 1,
		/obj/item/reagent_containers/powder/moondust = 1
	)
	craftdiff = 4
	sellprice = 20
