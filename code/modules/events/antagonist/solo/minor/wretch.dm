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

	denominator = 20

	cost = 0.3 // super cheap so can usually be thrown in somehow

	base_antags = 1
	maximum_antags = 3

	earliest_start = 0 SECONDS

	min_players = 10

	weight = 15
	preferred_events = list(
		/datum/round_event_control/antagonist/solo/lich,
		/datum/round_event_control/antagonist/solo/rebel,
		/datum/round_event_control/antagonist/solo/aspirant,
		/datum/round_event_control/antagonist/solo/maniac,
		/datum/round_event_control/antagonist/solo/vampires_and_werewolves,
		/datum/round_event_control/antagonist/solo/vampires,
		/datum/round_event_control/antagonist/solo/werewolf,
		/datum/round_event_control/antagonist/solo/zizo_cult
	)
	typepath = /datum/round_event/antagonist/solo/wretch


/datum/round_event/antagonist/solo/wretch
