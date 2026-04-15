/datum/round_event_control/antagonist/solo/werewolf
	name = "Verevolfs"
	tags = list(
		TAG_DENDOR,
		TAG_GRAGGAR,
		TAG_BLOOD,
		TAG_COMBAT,
		TAG_VILLAIN,
	)
	roundstart = TRUE
	antag_flag = ROLE_WEREWOLF
	shared_occurence_type = SHARED_HIGH_THREAT

	base_antags = 1
	maximum_antags = 2
	min_players = (LOWPOP_THRESHOLD+5) * READYUP_AVG
	denominator = LOWPOP_THRESHOLD * READYUP_AVG

	weight = 12
	earliest_start = 0 SECONDS

	typepath = /datum/round_event/antagonist/solo/werewolf
	antag_datum = /datum/antagonist/werewolf

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
		/datum/job/gmtemplar,
		/datum/job/advclass/combat/assassin,
		/datum/job/tomb_warden,
		/datum/job/bogwitch,
		/datum/job/bog_apprentice,
		/datum/job/magician,
		/datum/job/archivist,
	)

/datum/round_event_control/antagonist/solo/werewolf/valid_for_map()
	if(SSmapping.config.map_name != "Voyage")
		return TRUE
	return FALSE

/datum/round_event/antagonist/solo/werewolf
