/datum/brewing_recipe/gin
	name = "Gin"
	reagent_to_brew = /datum/reagent/consumable/ethanol/gin
	pre_reqs = /datum/reagent/consumable/ethanol/voddena
	needed_reagents = list(/datum/reagent/consumable/ethanol/voddena = 150)
	needed_items = list(/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry = 2)
	brewed_amount = 3
	brew_time = 3.75 MINUTES
	sell_value = 75
	heat_required = 370
	brewing_skill = /datum/attribute/skill/craft/cooking/distilling
