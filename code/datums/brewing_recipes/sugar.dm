/datum/brewing_recipe/molasses
	name = "Molasses"
	reagent_to_brew = /datum/reagent/consumable/sugar/molasses
	needed_items = list(/obj/item/reagent_containers/food/snacks/sugar = 4)
	brewed_amount = 5
	brew_time = 2 MINUTES
	sell_value = 25
	brewing_skill = /datum/attribute/skill/craft/cooking/confectionery

/datum/brewing_recipe/rum
	name = "Rum"
	reagent_to_brew = /datum/reagent/consumable/ethanol/rum
	needed_reagents = list(/datum/reagent/consumable/sugar/molasses = 150)
	pre_reqs = /datum/reagent/consumable/sugar/molasses
	brewed_amount = 3
	brew_time = 3 MINUTES
	sell_value = 75
	heat_required = 380
	brewing_skill = /datum/attribute/skill/craft/cooking/distilling
