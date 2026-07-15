/datum/brewing_recipe/limoncello
	name = "Limoncello"
	reagent_to_brew = /datum/reagent/consumable/ethanol/limoncello
	pre_reqs = /datum/reagent/consumable/ethanol/voddena
	needed_items = list(/obj/item/reagent_containers/food/snacks/produce/fruit/lemon = 2, /obj/item/reagent_containers/food/snacks/sugar = 1)
	needed_reagents = list(/datum/reagent/consumable/ethanol/voddena = 150)
	brewed_amount = 3
	brew_time = 3 MINUTES
	sell_value = 66
	heat_required = 360
	brewing_skill = /datum/attribute/skill/craft/cooking/distilling
