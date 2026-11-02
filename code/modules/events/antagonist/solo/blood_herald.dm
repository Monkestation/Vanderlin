/datum/round_event_control/antagonist/solo/blood_herald
	name = ROLE_BLOOD_HERALD
	tags = list(
		TAG_COMBAT,
		TAG_VILLAIN,
		TAG_BLOOD,
		TAG_WAR,
		TAG_UNEXPECTED,
		TAG_CORRUPTION
	)
	roundstart = TRUE
	antag_flag = ROLE_BLOOD_HERALD
	shared_occurence_type = SHARED_HIGH_THREAT

	base_antags = 1
	maximum_antags = 2
	min_players = (LOWPOP_THRESHOLD+5) * READYUP_AVG
	denominator = HIGHPOP_THRESHOLD * READYUP_AVG

	earliest_start = 0 SECONDS
	weight = 10

	typepath = /datum/round_event/antagonist/solo/blood_herald
	antag_datum = /datum/antagonist/blood_mage/herald

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
		/datum/job/royalknight,
		/datum/job/templar,
		/datum/job/gmtemplar,
		/datum/job/advclass/combat/assassin,
		/datum/job/tomb_warden,
		/datum/job/forestwarden,
		/datum/job/forestenforcer,
		/datum/job/forestpreacher,
		/datum/job/bogwitch,
		/datum/job/bog_apprentice,
		/datum/job/admin/oracle,
		/datum/job/admin/lunar_champion,
		/datum/job/admin/lunar_sentinel,
		/datum/job/admin/darkspawn,
		/datum/job/admin/blood_sorcerer,
		/datum/job/admin/kingsfield_constable,
	)


/datum/round_event_control/antagonist/solo/lich/valid_for_map()
	if(SSmapping.config.map_name != "Voyage")
		return TRUE
	return FALSE

/datum/round_event/antagonist/solo/blood_herald
