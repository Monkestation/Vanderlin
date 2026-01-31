/datum/round_event_control/antagonist/solo/rebel
	name = "Rebels"
	tags = list(
		TAG_MATTHIOS,
		TAG_COMBAT,
		TAG_VILLAIN,
	)
	roundstart = TRUE
	antag_flag = ROLE_PREBEL
	shared_occurence_type = SHARED_HIGH_THREAT

	base_antags = 1
	maximum_antags = 4

	earliest_start = 0 SECONDS

	typepath = /datum/round_event/antagonist/solo/rebel
	antag_datum = /datum/antagonist/prebel/head

	min_players = 30
	weight = 6

	restricted_roles = list(
		/datum/job/lord,
		/datum/job/consort,
		/datum/job/priest,
		/datum/job/hand,
		/datum/job/captain,
		/datum/job/prince,
		/datum/job/inquisitor,
		/datum/job/absolver,
		/datum/job/orthodoxist,
		/datum/job/adept,
		/datum/job/forestwarden,
		/datum/job/royalknight,
		/datum/job/templar,
	)

/datum/round_event_control/antagonist/solo/rebel/valid_for_map()
	if(SSmapping.config.map_name != "Voyage")
		return TRUE
	return FALSE

/datum/round_event/antagonist/solo/rebel
