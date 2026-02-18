/datum/round_event_control/antagonist/solo/vampires
	name = "Vampires"
	tags = list(
		TAG_COMBAT,
		TAG_HAUNTED,
		TAG_VILLAIN,
	)
	roundstart = TRUE
	antag_flag = ROLE_NBEAST
	shared_occurence_type = SHARED_HIGH_THREAT

	weight = 12

	denominator = 40

	base_antags = 1
	maximum_antags = 1

	earliest_start = 0 SECONDS

	typepath = /datum/round_event/antagonist/solo/vampire
	antag_datum = /datum/antagonist/vampire/lord

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

/datum/round_event_control/antagonist/solo/vampires/valid_for_map()
	if(SSmapping.config.map_name != "Voyage")
		return TRUE
	return FALSE

/datum/round_event/antagonist/solo/vampire

/datum/round_event/antagonist/solo/vampire/add_datum_to_mind(datum/mind/antag_mind)
	var/datum/job/J = SSjob.GetJob(antag_mind.current?.job)
	J?.adjust_current_positions(-1)
	if(SSmapping.config.map_name != "Voyage")
		antag_mind.current.unequip_everything()
	antag_mind.add_antag_datum(antag_datum)
	var/datum/antagonist/vampire/lord/lord = antag_mind.has_antag_datum(/datum/antagonist/vampire/lord)
	lord.get_thralls()
	return
