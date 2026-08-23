/datum/distillation_recipe/hallucinogen_concentrate
	name = "Hallucinogen Concentrate"
	id = "hallucinogen_concentrate"
	distilled_reagent = /datum/reagent/toxin/fyritiusnectar
	required_temp = T0C + 95
	results = list(/datum/reagent/drug/hallucinogen_concetrate = 0.5)
	distill_message = "The explosive compounds boil off, leaving something concentrated and deeply strange."
	distill_sound = "bubbles"

/datum/distillation_recipe/methamphetamine
	name = "Methamphetamine"
	id = "methamphetamine"
	distilled_reagent = /datum/reagent/meth_precursor
	consume_reagents = TRUE
	results = list(/datum/reagent/drug/methamphetamine = 1.5)
	required_temp = T0C + 140
	distill_message = "The precursor boils down into a clear crystalline liquid."
