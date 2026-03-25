/datum/brewing_recipe/spidermead
	name = "Spider Honey Mead"
	reagent_to_brew = /datum/reagent/consumable/ethanol/mead/spider
	needed_reagents = list(/datum/reagent/water = 100)
	needed_items = list(/obj/item/reagent_containers/food/snacks/spiderhoney = 4)
	brewed_amount = 3
	brew_time = 1.5 MINUTES
	sell_value = 75
	brewing_skill = /datum/attribute/skill/craft/cooking/brewing

/datum/brewing_recipe/mead
	name = "Mead"
	reagent_to_brew = /datum/reagent/consumable/ethanol/mead
	needed_reagents = list(/datum/reagent/water = 100)
	needed_items = list(/obj/item/reagent_containers/food/snacks/spiderhoney/honey = 4)
	brewed_amount = 3
	brew_time = 1.5 MINUTES
	sell_value = 30
	brewing_skill = /datum/attribute/skill/craft/cooking/brewing
