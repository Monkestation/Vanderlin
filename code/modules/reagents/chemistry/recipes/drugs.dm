/datum/chemical_reaction/meth_precursor
	name = "Methamphetamine Precursor"
	id = "meth_precursor"
	required_reagents = list(
		/datum/reagent/mercury = 5,
		/datum/reagent/medicine/soporpot = 5,
		/datum/reagent/water = 5
	)
	results = list(/datum/reagent/meth_precursor = 15)
	mix_message = "The mixture foams and takes on a sharp chemical smell."
