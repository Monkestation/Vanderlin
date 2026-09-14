/datum/migrant_role/acolytes
	name = "Acolytes"
	greet_text = "The word of the Ten is everything to you and your pilgrimage has brought to you seek the local church."
	migrant_job = /datum/job/monk

/datum/migrant_wave/acolytes
	name = "The Holy Voyage"
	shared_wave_type = /datum/migrant_wave/acolytes
	weight = 40
	roles = list(
		/datum/migrant_role/acolytes = 4,
	)
	greet_text = "The Tens have decreed that this land needs additional persons of faith, so here you are."
