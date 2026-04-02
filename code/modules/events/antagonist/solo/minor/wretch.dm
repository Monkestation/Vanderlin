/datum/round_event_control/antagonist/solo/wretch
	name = "Wretches"
	tags = list(
		TAG_VILLAIN,
		TAG_COMBAT,
		TAG_UNEXPECTED,
		TAG_CORRUPTION
	)
	antag_datum = /datum/antagonist/wretch
	roundstart = TRUE
	antag_flag = ROLE_WRETCH
	shared_occurence_type = SHARED_MINOR_THREAT
	minor_roleset = TRUE

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
		/datum/job/gmtemplar,
		/datum/job/templar,
	)

	base_antags = 1
	maximum_antags = 3
	denominator = (LOWPOP_THRESHOLD*0.6) * READYUP_AVG
	min_players = 10
	cost = 0.3 // super cheap so can usually be thrown in somehow

	earliest_start = 0 SECONDS
	weight = 12

	preferred_events = list(
		/datum/round_event_control/antagonist/solo/lich = 1,
		/datum/round_event_control/antagonist/solo/rebel = 1,
		/datum/round_event_control/antagonist/solo/aspirant = 1,
		/datum/round_event_control/antagonist/solo/maniac = 1,
		/datum/round_event_control/antagonist/solo/vampires_and_werewolves = 1,
		/datum/round_event_control/antagonist/solo/vampires = 1,
		/datum/round_event_control/antagonist/solo/werewolf = 1,
		/datum/round_event_control/antagonist/solo/zizo_cult = 1
	)
	typepath = /datum/round_event/antagonist/solo/wretch


/datum/round_event/antagonist/solo/wretch
