/// A recipe that triggers when specific reagents are distilled in the chem_separator.
/// Unlike chemical reactions (which trigger on mixing), these only fire when the
/// separator is actively boiling the correct reagent above required_temp.
/datum/distillation_recipe
	var/name = null
	var/id = null
	/// The primary reagent that gets distilled (vaporized). Must match separating_reagent.
	var/distilled_reagent = null
	/// Optional additional reagents that must be present in the mixture (not consumed unless consume_reagents = TRUE)
	var/list/required_reagents = list()
	/// Whether required_reagents are consumed during the reaction
	var/consume_reagents = FALSE
	/// Output reagents: list(reagent_type = amount_per_unit_distilled)
	/// Amount scales with how much of distilled_reagent is processed each tick
	var/list/results = list()
	/// Minimum separator temperature in Kelvin (defaults to standard boiling point check)
	var/required_temp = T0C + 100
	/// Message shown when distillation completes its first tick of output
	var/distill_message = null
	/// Sound played on first output tick
	var/distill_sound = null

/datum/distillation_recipe/proc/on_distill(datum/reagents/holder, datum/reagents/output, distilled_amount)
	return

/proc/setup_distillation_recipes()
	. = list()
	for(var/recipe_type in subtypesof(/datum/distillation_recipe))
		var/datum/distillation_recipe/R = new recipe_type()
		if(!R.distilled_reagent)
			qdel(R)
			continue
		if(!.[R.distilled_reagent])
			.[R.distilled_reagent] = list()
		.[R.distilled_reagent] += R
	return .

/proc/find_distillation_recipe(datum/reagent/separating_reagent, datum/reagents/mixture, required_temp)
	if(!length(GLOB.distillation_recipes) || !GLOB.distillation_recipes[separating_reagent.type])
		return null
	for(var/datum/distillation_recipe/R in GLOB.distillation_recipes[separating_reagent.type])
		if(mixture.chem_temp < R.required_temp)
			continue
		var/valid = TRUE
		for(var/req_reagent in R.required_reagents)
			if(mixture.get_reagent_amount(req_reagent) < R.required_reagents[req_reagent])
				valid = FALSE
				break
		if(valid)
			return R
	return null
