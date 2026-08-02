/datum/round_event_control/antagonist/migrant_wave/zizo_cultist
	name = "Wandering Cultist"
	wave_type = /datum/migrant_wave/zizo_cultist

	weight = 8
	min_players = MIDPOP_THRESHOLD
	earliest_start = 25 MINUTES
	max_occurrences = 1
	shared_occurence_type = SHARED_HIGH_THREAT

	tags = list(
		TAG_ZIZO,
		TAG_COMBAT,
		TAG_VILLAIN,
		TAG_MAGICAL
	)

/datum/migrant_wave/zizo_cultist
	name = "The Path to Ascension"
	max_spawns = 1
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/zizo_cultist
	downgrade_wave = /datum/migrant_wave/zizo_cultist_down
	roles = list(
		/datum/migrant_role/zizo_cultist = 1,
		/datum/migrant_role/zizo_cultist_lesser = 1,
	)
	greet_text = "This is the land that will witness your ascension."

/datum/migrant_wave/zizo_cultist_down
	name = "The Path to Ascension"
	shared_wave_type = /datum/migrant_wave/zizo_cultist
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/zizo_cultist = 1,
	)
	greet_text = "This is the land that will witness your ascension."
