/datum/brewing_recipe/cider
	name = "Apple Cider"
	reagent_to_brew = /datum/reagent/consumable/ethanol/cider
	needed_reagents = list(/datum/reagent/water = 100)
	needed_crops = list(/obj/item/reagent_containers/food/snacks/produce/fruit/apple = 3)
	brewed_amount = 3
	brew_time = 2.5 MINUTES
	sell_value = 30
	brewing_skill = /datum/attribute/skill/craft/cooking/brewing

/datum/brewing_recipe/cider/pear
	name = "Pear Cider"
	reagent_to_brew = /datum/reagent/consumable/ethanol/cider/pear
	needed_crops = list(/obj/item/reagent_containers/food/snacks/produce/fruit/pear = 3)

/datum/brewing_recipe/cider/strawberry
	name = "Strawberry Cider"
	reagent_to_brew = /datum/reagent/consumable/ethanol/cider/strawberry
	needed_crops = list(/obj/item/reagent_containers/food/snacks/produce/fruit/strawberry = 3)
	sell_value = 40
