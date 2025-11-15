/datum/round_event_control/antagonist/solo/lich
	name = "Lich"
	tags = list(
		TAG_ZIZO,
		TAG_COMBAT,
		TAG_HAUNTED,
		TAG_VILLAIN,
	)
	roundstart = TRUE
	antag_flag = ROLE_LICH
	shared_occurence_type = SHARED_HIGH_THREAT

	denominator = 65

	base_antags = 1
	maximum_antags = 2

	min_players = 25
	weight = 12

	earliest_start = 0 SECONDS

	typepath = /datum/round_event/antagonist/solo/lich
	antag_datum = /datum/antagonist/lich

	restricted_roles = list(
		"Monarch",
		"Consort",
		"Priest",
	)


/datum/round_event_control/antagonist/solo/lich/valid_for_map()
	if(SSmapping.config.map_name != "Voyage")
		return TRUE
	return FALSE

/datum/round_event/antagonist/solo/lich
