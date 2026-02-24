/datum/round_event_control/antagonist/solo/daewalker
	name = "The Daewalker"
	tags = list(
		TAG_ASTRATA,
		TAG_BLOOD,
		TAG_COMBAT,
		TAG_WAR,
	)
	antag_datum = /datum/antagonist/vampire/lord/daewalker
	antag_flag = ROLE_NBEAST
	shared_occurence_type = SHARED_MINOR_THREAT
	minor_roleset = TRUE

	base_antags = 1
	maximum_antags = 1

	earliest_start = 30 MINUTES
	secondary_prob = 0

	min_players = 20
	weight = 0
	typepath = /datum/round_event/antagonist/solo/daewalker

/datum/round_event/antagonist/solo/daewalker
