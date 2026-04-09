/datum/round_event_control/antagonist/solo/vampires_and_werewolves
	name = "Vampires and Verevolves"
	tags = list(
		TAG_DENDOR,
		TAG_GRAGGAR,
		TAG_BLOOD,
		TAG_WAR,
		TAG_HAUNTED,
		TAG_VILLAIN,
	)
	roundstart = TRUE
	antag_flag = ROLE_VAMPIRE
	shared_occurence_type = SHARED_HIGH_THREAT

	base_antags = 4
	maximum_antags = 4
	cost = 1.1
	min_players = HIGHPOP_THRESHOLD * READYUP_AVG
	denominator = LOWPOP_THRESHOLD * READYUP_AVG

	earliest_start = 0 SECONDS
	weight = 8
	secondary_prob = 0
	typepath = /datum/round_event/antagonist/solo/vampires_and_werewolves

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
		/datum/job/magician,
		/datum/job/archivist,
		/datum/job/bogwitch,
		/datum/job/bog_apprentice,,
		/datum/job/tomb_warden,
	)

/datum/round_event_control/antagonist/solo/vampires_and_werewolves/valid_for_map()
	if(SSmapping.config.map_name != "Voyage")
		return TRUE
	return FALSE

/datum/round_event/antagonist/solo/vampires_and_werewolves
	var/datum/antagonist/vampire/lord/lord
	/// True for vamps, false for ww
	var/spawn_type = FALSE
	/// True for vampire spawn, false for normal vamp
	var/vampire_spawn = FALSE

/datum/round_event/antagonist/solo/vampires_and_werewolves/start()
	spawn_type = prob(50) // randomizes who gets more on an odd number of antags
	. = ..()

/datum/round_event/antagonist/solo/vampires_and_werewolves/add_datum_to_mind(datum/mind/antag_mind)
	spawn_type = !spawn_type
	if(spawn_type)
		if(!lord)
			lord = antag_mind.add_antag_datum(antag_datum)
			return
		lord.starting_thralls += antag_mind.add_antag_datum(vampire_spawn ? /datum/antagonist/vampire/lords_spawn : /datum/antagonist/vampire)
		vampire_spawn = !vampire_spawn
	else
		antag_mind.add_antag_datum(/datum/antagonist/werewolf)

/datum/round_event/antagonist/solo/vampires_and_werewolves/kill()
	lord = null
	. = ..()
