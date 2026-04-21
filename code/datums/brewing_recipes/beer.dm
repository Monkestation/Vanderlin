/datum/brewing_recipe/beer
	name = "Wheat Beer"
	reagent_to_brew = /datum/reagent/consumable/ethanol/beer
	needed_reagents = list(/datum/reagent/water = 100)
	needed_items = list(/obj/item/reagent_containers/food/snacks/produce/grain/wheat = 4)
	brewed_amount = 4
	brew_time = 1.33 MINUTES
	sell_value = 20
	brewing_skill = /datum/attribute/skill/craft/cooking/brewing

/datum/brewing_recipe/beer/oat
	name = "Oat Ale"
	reagent_to_brew = /datum/reagent/consumable/ethanol/ale
	needed_items = list(/obj/item/reagent_containers/food/snacks/produce/grain/oat = 4)
