/datum/round_event_control/antagonist/migrant_wave/bandits
	name = "Bandit Migration"
	wave_type = /datum/migrant_wave/bandit

	min_players = LOWPOP_THRESHOLD
	weight = 8
	earliest_start = 20 MINUTES
	shared_occurence_type = SHARED_MINOR_THREAT

	tags = list(
		TAG_MATTHIOS,
		TAG_COMBAT,
		TAG_VILLAIN,
	)
