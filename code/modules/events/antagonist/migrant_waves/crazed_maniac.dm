/datum/round_event_control/antagonist/migrant_wave/maniac
	name = "Crazed Adventurer"
	wave_type = /datum/migrant_wave/maniac

	min_players = LOWPOP_THRESHOLD
	weight = 8
	earliest_start = 20 MINUTES
	shared_occurence_type = SHARED_MINOR_THREAT

	tags = list(
		TAG_INSANITY,
		TAG_MEDICAL,
		TAG_VILLAIN,
		TAG_COMBAT,
	)

/datum/round_event_control/antagonist/migrant_wave/maniac/canSpawnEvent(players_amt, gamemode, fake_check)
	if(GLOB.maniac_highlander) // Has a Maniac already TRIUMPHED?
		return FALSE
	. = ..()
