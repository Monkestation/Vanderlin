/datum/distillation_recipe/sea_salt
	name = "Sea Salt"
	id = "sea_salt"
	distilled_reagent = /datum/reagent/water/salty
	consume_reagents = TRUE
	results = list(
		/datum/reagent/consumable/sodiumchloride = 0.2,
		/datum/reagent/water = 0.8
	)
	required_temp = T0C + 100
	distill_message = "The water boils away leaving salt."

/datum/distillation_recipe/mushroom_toxin
	name = "Mushroom Toxin"
	id = "mush_tox"
	distilled_reagent = /datum/reagent/caveweep
	consume_reagents = TRUE
	results = list(
		/datum/reagent/toxin/amanitin = 1
	)
	required_temp = T0C + 150
	distill_message = "The tears turn a pure white and release a foul stench."

/datum/distillation_recipe/concentrated_mush_toxin
	name = "Concentrated Mushroom Toxin"
	id = "mush_tox_conc"
	distilled_reagent = /datum/reagent/toxin/amanitin
	consume_reagents = TRUE
	results = list(
		/datum/reagent/toxin/amatoxin = 0.5
	)
	required_temp = T0C + 120
	distill_message = "The mushroom toxin starts turning an orangish brown it smells foul."
