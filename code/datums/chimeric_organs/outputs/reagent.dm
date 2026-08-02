/datum/chimeric_node/output/reagent
	name = "creator"
	desc = "Generates chemicals when triggered"

	var/possible_reagents = list(
		/datum/reagent/medicine = 10,
		/datum/reagent/drug = 10,
		/datum/reagent/toxin = 10,
		/datum/reagent/consumable = 10,
		/datum/reagent/consumable/ethanol = 10,
	)
	var/datum/reagent/good_reagent

	var/generated_amount = 5

/datum/chimeric_node/output/reagent/set_ranges()
	. = ..()
	generated_amount *= (node_purity * 0.02) * (tier * 0.5)

	var/datum/reagent/reagent_type = pickweight(possible_reagents)

	var/list/pickers
	if(reagent_type == /datum/reagent/consumable)
		pickers = typesof(reagent_type) - typesof(/datum/reagent/consumable/ethanol)
	else
		pickers = typesof(reagent_type)


	var/datum/reagent/picked_reagent = pick(pickers)
	good_reagent = picked_reagent


/datum/chimeric_node/output/reagent/trigger_effect(multiplier)
	. = ..()
	if(istype(attached_input, /datum/chimeric_node/input/reagent))
		var/datum/chimeric_node/input/reagent/actual_type = attached_input

		if((good_reagent in actual_type.trigger_reagents))
			to_chat(hosted_carbon, span_warning("Your [attached_organ.name] is overloaded by the chemicals! You start to spew out chemicals causing lots of pain!"))
			var/turf/open/epicenter = get_turf(hosted_carbon)
			epicenter.add_liquid(good_reagent, 50)
			attached_organ.applyOrganDamage(30)
			hosted_carbon.apply_damage(15, BRUTE)
			return

	hosted_carbon.reagents.add_reagent(good_reagent, generated_amount * multiplier)
