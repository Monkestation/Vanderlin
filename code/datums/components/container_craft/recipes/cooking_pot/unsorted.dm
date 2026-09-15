/datum/container_craft/cooking/drugs
	abstract_type = /datum/container_craft/cooking/drugs
	category = "Boiling"

/datum/container_craft/cooking/arcyne
	abstract_type = /datum/container_craft/cooking/arcyne
	category = "Boiling"

/datum/container_craft/cooking/sugar
	name = "Sugar"
	category = "Boiling"
	created_reagent = /datum/reagent/consumable/sugar
	requirements = list(/obj/item/reagent_containers/food/snacks/sugar = 1)
	max_optionals = 0
	finished_smell = /datum/pollutant/food/sugar
	crafting_time = 10 SECONDS
	required_chem_temp = 300 // it's sugar water

/datum/container_craft/cooking/drugs/drukqs
	name = "Drukqs"
	created_reagent = /datum/reagent/druqks
	requirements = list(/obj/item/reagent_containers/powder/spice = 1)
	max_optionals = 0
	finished_smell = /datum/pollutant/food/druqks
	crafting_time = 50 SECONDS
	pollute_amount = 100
	water_conversion = 0.45

/datum/container_craft/cooking/drugs/drukqs/after_craft(atom/created_output, obj/item/crafter, mob/initiator, list/found_optional_requirements, list/found_optional_wildcards, list/found_optional_reagents, list/removing_items)
	. = ..()
	var/remaining_water = crafter.reagents.get_reagent_amount(/datum/reagent/water) - CEILING(crafter.reagents.get_reagent_amount(/datum/reagent/water) * water_conversion, 1)
	crafter.reagents.add_reagent(/datum/reagent/water/spicy, remaining_water)

/datum/container_craft/cooking/drugs/ozium
	name = "Ozium"
	created_reagent = /datum/reagent/ozium
	requirements = list(/obj/item/reagent_containers/powder/ozium = 1)
	max_optionals = 0
	finished_smell = /datum/pollutant/food/druqks
	crafting_time = 50 SECONDS
	pollute_amount = 100
	water_conversion = 0.45

/datum/container_craft/cooking/drugs/ozium/after_craft(atom/created_output, obj/item/crafter, mob/initiator, list/found_optional_requirements, list/found_optional_wildcards, list/found_optional_reagents, list/removing_items)
	. = ..()
	var/remaining_water = crafter.reagents.get_reagent_amount(/datum/reagent/water) - CEILING(crafter.reagents.get_reagent_amount(/datum/reagent/water) * water_conversion, 1)
	crafter.reagents.add_reagent(/datum/reagent/water/spicy, remaining_water)

/datum/container_craft/cooking/drugs/moondust
	name = "Moondust"
	created_reagent = /datum/reagent/moondust
	requirements = list(/obj/item/reagent_containers/powder/moondust = 1)
	max_optionals = 0
	finished_smell = /datum/pollutant/food/druqks
	crafting_time = 50 SECONDS
	pollute_amount = 100
	water_conversion = 0.45

/datum/container_craft/cooking/drugs/moondust/after_craft(atom/created_output, obj/item/crafter, mob/initiator, list/found_optional_requirements, list/found_optional_wildcards, list/found_optional_reagents, list/removing_items)
	. = ..()
	var/remaining_water = crafter.reagents.get_reagent_amount(/datum/reagent/water) - CEILING(crafter.reagents.get_reagent_amount(/datum/reagent/water) * water_conversion, 1)
	crafter.reagents.add_reagent(/datum/reagent/water/spicy, remaining_water)

/datum/container_craft/cooking/drugs/moondust_purest
	name = "Pure Moondust"
	created_reagent = /datum/reagent/moondust_purest
	requirements = list(/obj/item/reagent_containers/powder/moondust_purest = 1)
	max_optionals = 0
	finished_smell = /datum/pollutant/food/druqks
	crafting_time = 50 SECONDS
	pollute_amount = 100
	water_conversion = 0.45

/datum/container_craft/cooking/drugs/moondust_purest/after_craft(atom/created_output, obj/item/crafter, mob/initiator, list/found_optional_requirements, list/found_optional_wildcards, list/found_optional_reagents, list/removing_items)
	. = ..()
	var/remaining_water = crafter.reagents.get_reagent_amount(/datum/reagent/water) - CEILING(crafter.reagents.get_reagent_amount(/datum/reagent/water) * water_conversion, 1)
	crafter.reagents.add_reagent(/datum/reagent/water/spicy, remaining_water)

/datum/container_craft/cooking/arcyne/weak_manapot
	name = "Weak Liquid Mana"
	created_reagent = /datum/reagent/medicine/manapot/weak
	requirements = list(
		/obj/item/reagent_containers/powder/manabloom = 2,
		/obj/item/mana_battery/mana_crystal/small = 1
	)
	max_optionals = 0
	finished_smell = /datum/pollutant/food/druqks
	crafting_time = 50 SECONDS
	pollute_amount = 100
	water_conversion = 0.6

/datum/container_craft/cooking/rice
	name = "Cooked Rice"
	water_conversion = 0
	created_reagent = null
	crafting_time = 50 SECONDS
	requirements = list(
		/obj/item/reagent_containers/food/snacks/ricewet = 1,
	)
	output = /obj/item/reagent_containers/food/snacks/rice_cooked

/datum/container_craft/cooking/soaked_rice
	name = "Washed Rice"
	water_conversion = 0
	required_chem_temp = 0
	created_reagent = null
	reagent_consume_mod = 0
	craft_verb = "soaking "
	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/grain/rice = 1,
	)
	output = /obj/item/reagent_containers/food/snacks/ricewet
