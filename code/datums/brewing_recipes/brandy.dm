/datum/brewing_recipe/brandy
	name = "Apple Brandy"
	reagent_to_brew = /datum/reagent/consumable/ethanol/brandy
	needed_reagents = list(/datum/reagent/consumable/ethanol/cider = 150)
	pre_reqs = /datum/reagent/consumable/ethanol/cider
	brewed_amount = 3
	brew_time = 2 MINUTES
	sell_value = 60
	heat_required = 360
	brewing_skill = /datum/attribute/skill/craft/cooking/distilling

/datum/brewing_recipe/brandy/pear
	name = "Pear Brandy"
	pre_reqs = /datum/reagent/consumable/ethanol/cider/pear
	needed_reagents = list(/datum/reagent/consumable/ethanol/cider/pear = 150)
	reagent_to_brew = /datum/reagent/consumable/ethanol/brandy/pear

/datum/brewing_recipe/brandy/strawberry
	name = "Strawberry Brandy"
	pre_reqs = /datum/reagent/consumable/ethanol/cider/strawberry
	needed_reagents = list(/datum/reagent/consumable/ethanol/cider/strawberry = 150)
	reagent_to_brew = /datum/reagent/consumable/ethanol/brandy/strawberry

/datum/brewing_recipe/brandy/tangerine
	name = "Tangerine Brandy"
	pre_reqs = /datum/reagent/consumable/ethanol/tangerine
	needed_reagents = list(/datum/reagent/consumable/ethanol/tangerine = 150)
	reagent_to_brew = /datum/reagent/consumable/ethanol/brandy/tangerine

/datum/brewing_recipe/brandy/plum
	name = "Plum Brandy"
	pre_reqs = /datum/reagent/consumable/ethanol/plum_wine
	needed_reagents = list(/datum/reagent/consumable/ethanol/plum_wine = 150)
	reagent_to_brew = /datum/reagent/consumable/ethanol/brandy/plum
