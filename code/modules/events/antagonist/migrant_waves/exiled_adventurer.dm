/datum/round_event_control/antagonist/migrant_wave/werewolf
	name = "Exiled Werewolf"
	wave_type = /datum/migrant_wave/werewolf

	weight = 4

	earliest_start = 25 MINUTES

	tags = list(
		TAG_DENDOR,
		TAG_GRAGGAR,
		TAG_HAUNTED,
		TAG_VILLAIN,
		TAG_COMBAT,
	)

/datum/round_event_control/antagonist/migrant_wave/vampire
	name = "Exiled Vampire"
	wave_type = /datum/migrant_wave/vampire

	weight = 4
	max_occurrences = 2

	earliest_start = 20 MINUTES

	tags = list(
		TAG_HAUNTED,
		TAG_COMBAT,
		TAG_VILLAIN,
	)
