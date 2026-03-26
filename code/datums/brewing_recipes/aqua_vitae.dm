/datum/brewing_recipe/aqua_vitae
	name = "Aqua Vitae - Apple"
	brewed_amount = 3
	brew_time = 5 MINUTES
	sell_value = 120
	needed_reagents = list(/datum/reagent/consumable/ethanol/brandy = 150) // keep this in sync with this recipe's output volume
	reagent_to_brew = /datum/reagent/consumable/ethanol/aqua_vitae
	pre_reqs = /datum/reagent/consumable/ethanol/brandy
	heat_required = 360
	brewing_skill = /datum/attribute/skill/craft/cooking/preservation

/datum/brewing_recipe/aqua_vitae/pear
	name = "Aqua Vitae - Plum"
	needed_reagents = list(/datum/reagent/consumable/ethanol/brandy/pear = 150)
	pre_reqs = /datum/reagent/consumable/ethanol/brandy/pear

/datum/brewing_recipe/aqua_vitae/strawberry
	name = "Aqua Vitae - Strawberry"
	needed_reagents = list( /datum/reagent/consumable/ethanol/brandy/strawberry = 150)
	pre_reqs = /datum/reagent/consumable/ethanol/brandy/strawberry

/datum/brewing_recipe/aqua_vitae/tangerine
	name = "Aqua Vitae - Tangerine"
	needed_reagents = list(/datum/reagent/consumable/ethanol/brandy/tangerine = 150)
	pre_reqs = /datum/reagent/consumable/ethanol/brandy/tangerine

/datum/brewing_recipe/aqua_vitae/plum
	name = "Aqua Vitae - Plum"
	needed_reagents = list(/datum/reagent/consumable/ethanol/plum_wine = 150)
	pre_reqs = /datum/reagent/consumable/ethanol/brandy/plum
