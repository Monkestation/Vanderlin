/datum/round_event_control/antagonist/migrant_wave/lich
	name = "Wandering Lich"
	wave_type = /datum/migrant_wave/lich

	weight = 6

	earliest_start = 25 MINUTES

	tags = list(
		TAG_ZIZO,
		TAG_HAUNTED,
		TAG_COMBAT,
		TAG_VILLAIN,
	)

/datum/migrant_wave/lich
	name = "Wandering Lich"
	roles = list(
		/datum/migrant_role/lich = 1,
	)
	can_roll = FALSE
