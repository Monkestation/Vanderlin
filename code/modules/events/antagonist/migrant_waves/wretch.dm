/datum/round_event_control/antagonist/migrant_wave/wretch
	name = "Wandering Wretch"
	wave_type = /datum/migrant_wave/wretch
	tags = list(
		TAG_VILLAIN,
		TAG_COMBAT,
		TAG_UNEXPECTED,
		TAG_CORRUPTION
	)

	cost = 0.8
	weight = 12
	earliest_start = 15 MINUTES

/datum/migrant_wave/wretch
	name = "Wretched Adventurer"
	roles = list(
		/datum/migrant_role/wretch = 1,
	)
	can_roll = FALSE

/datum/migrant_role/wretch
	name = ROLE_WRETCH
	antag_datum = /datum/antagonist/wretch
