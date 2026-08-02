/datum/brewing_recipe/wine
	abstract_type = /datum/brewing_recipe/wine
	brewed_amount = 4
	brew_time = 3.33 MINUTES
	sell_value = 50
	brewing_skill = /datum/attribute/skill/craft/cooking/winemaking

/datum/brewing_recipe/wine/jack_wine
	name = "Jacksberry Wine"
	reagent_to_brew = /datum/reagent/consumable/ethanol/jackberrywine
	needed_reagents = list(/datum/reagent/water = 200)
	needed_crops = list(/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry = 4)

	age_times = list(
		/datum/reagent/consumable/ethanol/jackberrywine/aged = 5 MINUTES,
		/datum/reagent/consumable/ethanol/jackberrywine/delectable = 10 MINUTES,
	)

/datum/brewing_recipe/wine/plum_wine
	name = "Umeshu"
	reagent_to_brew = /datum/reagent/consumable/ethanol/plum_wine
	needed_reagents = list(/datum/reagent/water = 100)
	needed_items = list(/obj/item/reagent_containers/food/snacks/produce/fruit/plum = 3, /obj/item/reagent_containers/food/snacks/sugar = 1)
	age_times = list(
		/datum/reagent/consumable/ethanol/plum_wine/aged = 5 MINUTES,
		/datum/reagent/consumable/ethanol/plum_wine/delectable = 10 MINUTES,
	)

/datum/brewing_recipe/wine/tangerine_wine
	name = "Tangerine Wine"
	reagent_to_brew = /datum/reagent/consumable/ethanol/tangerine
	needed_reagents = list(/datum/reagent/water = 100)
	needed_items = list(/obj/item/reagent_containers/food/snacks/produce/fruit/tangerine = 3, /obj/item/reagent_containers/food/snacks/sugar = 1)
	age_times = list(
		/datum/reagent/consumable/ethanol/tangerine/aged = 5 MINUTES,
		/datum/reagent/consumable/ethanol/tangerine/delectable = 10 MINUTES,
	)

/datum/brewing_recipe/wine/raspberry_wine
	name = "Raspberry Wine"
	reagent_to_brew = /datum/reagent/consumable/ethanol/raspberry
	needed_reagents = list(/datum/reagent/water = 100)
	needed_items = list(/obj/item/reagent_containers/food/snacks/produce/fruit/raspberry = 3, /obj/item/reagent_containers/food/snacks/sugar = 1)
	age_times = list(
		/datum/reagent/consumable/ethanol/raspberry/aged = 5 MINUTES,
		/datum/reagent/consumable/ethanol/raspberry/delectable = 10 MINUTES,
	)

/datum/brewing_recipe/wine/blackberry_wine
	name = "Blackberry Wine"
	reagent_to_brew = /datum/reagent/consumable/ethanol/blackberry
	needed_reagents = list(/datum/reagent/water = 100)
	needed_items = list(/obj/item/reagent_containers/food/snacks/produce/fruit/blackberry = 3, /obj/item/reagent_containers/food/snacks/sugar = 1)
	age_times = list(
		/datum/reagent/consumable/ethanol/blackberry/aged = 5 MINUTES,
		/datum/reagent/consumable/ethanol/blackberry/delectable = 10 MINUTES,
	)


/datum/brewing_recipe/wine/tiefling_wine
	name = "Tiefling Blood Wine"
	reagent_to_brew = /datum/reagent/consumable/ethanol/tiefling
	needed_reagents = list(/datum/reagent/water = 100, /datum/reagent/blood/tiefling = 60)
	needed_items = list(/obj/item/reagent_containers/food/snacks/sugar = 1)
	sell_value = 90
	age_times = list(
		/datum/reagent/consumable/ethanol/tiefling/aged = 5 MINUTES,
		/datum/reagent/consumable/ethanol/tiefling/delectable = 10 MINUTES,
	)

/datum/brewing_recipe/wine/luxwine
	name = "Luxintenebre"
	reagent_to_brew = /datum/reagent/consumable/ethanol/luxwine
	needed_reagents = list(/datum/reagent/water = 100)
	needed_items = list(/obj/item/reagent_containers/lux = 1, /obj/item/reagent_containers/food/snacks/sugar = 1)
	sell_value = 100
	age_times = list(
		/datum/reagent/consumable/ethanol/luxwine/aged = 5 MINUTES,
		/datum/reagent/consumable/ethanol/luxwine/delectable = 10 MINUTES,
	)
