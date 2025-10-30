/datum/round_event_control/antagonist/migrant_wave/maniac
	name = "Crazed Adventurer"
	wave_type = /datum/migrant_wave/maniac

	weight = 8

	earliest_start = 25 MINUTES

	tags = list(
		TAG_ZIZO,
		TAG_GRAGGAR,
		TAG_HAUNTED,
		TAG_COMBAT,
		TAG_VILLAIN,
	)

/datum/round_event_control/antagonist/migrant_wave/maniac/canSpawnEvent(players_amt, gamemode, fake_check)
	if(GLOB.maniac_highlander) // Has a Maniac already TRIUMPHED?
		return FALSE
	. = ..()
