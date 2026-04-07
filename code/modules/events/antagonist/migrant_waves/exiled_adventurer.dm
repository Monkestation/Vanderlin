/datum/round_event_control/antagonist/migrant_wave/werewolf
	name = "Exiled Werewolf"
	wave_type = /datum/migrant_wave/werewolf

	weight = 4
	min_players = MIDPOP_THRESHOLD
	earliest_start = 25 MINUTES
	shared_occurence_type = SHARED_HIGH_THREAT

	tags = list(
		TAG_DENDOR,
		TAG_GRAGGAR,
		TAG_VILLAIN,
		TAG_BLOOD,
		TAG_COMBAT,
	)

/datum/round_event_control/antagonist/migrant_wave/vampire
	name = "Exiled Vampire"
	wave_type = /datum/migrant_wave/vampire

	weight = 4
	max_occurrences = 2
	min_players = MIDPOP_THRESHOLD
	earliest_start = 20 MINUTES
	shared_occurence_type = SHARED_MINOR_THREAT

	tags = list(
		TAG_HAUNTED,
		TAG_COMBAT,
		TAG_BLOOD,
		TAG_VILLAIN,
	)
