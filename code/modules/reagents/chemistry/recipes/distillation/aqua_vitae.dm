/datum/distillation_recipe/aqua_vitae
	name = "Aqua Vitae - Apple"
	id = "aqua_vitae_apple"
	distilled_reagent = /datum/reagent/consumable/ethanol/brandy
	required_temp = T0C + 78
	results = list(
		/datum/reagent/consumable/ethanol/aqua_vitae = 0.5
	)
	distill_message = "The brandy begins to separate into a concentrated spirit!"
	distill_sound = "bubbles"

/datum/distillation_recipe/aqua_vitae/pear
	name = "Aqua Vitae - Pear"
	distilled_reagent = /datum/reagent/consumable/ethanol/brandy/pear

/datum/distillation_recipe/aqua_vitae/strawberry
	name = "Aqua Vitae - Strawberry"
	distilled_reagent = /datum/reagent/consumable/ethanol/brandy/strawberry

/datum/distillation_recipe/aqua_vitae/tangerine
	name = "Aqua Vitae - Tangerine"
	distilled_reagent = /datum/reagent/consumable/ethanol/brandy/tangerine

/datum/distillation_recipe/aqua_vitae/plum
	name = "Aqua Vitae - Plum"
	distilled_reagent = /datum/reagent/consumable/ethanol/plum_wine
