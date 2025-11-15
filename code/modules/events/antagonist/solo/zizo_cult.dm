/datum/round_event_control/antagonist/solo/zizo_cult
	name = "Zizo Cult"
	tags = list(
		TAG_ZIZO,
		TAG_COMBAT,
		TAG_VILLAIN,
	)
	roundstart = TRUE
	antag_flag = ROLE_ZIZOIDCULTIST
	shared_occurence_type = SHARED_HIGH_THREAT

	base_antags = 1
	maximum_antags = 4

	min_players = 35
	weight = 6

	earliest_start = 0 SECONDS

	typepath = /datum/round_event/antagonist/solo/zizo_cultist
	antag_datum = /datum/antagonist/zizocultist

	restricted_roles = list(
		"Monarch",
		"Consort",
		"Hand",
		"Captain",
		"Prince",
		"Priest",
		"Merchant",
		"Forest Warden",
		"Inquisitor",
		"Absolver",
		"Confessor",
		"Orthodoxist",
		"Adept",
		"Royal Knight",
		"Templar",
	)

/datum/round_event/antagonist/solo/zizo_cultist
	var/leader = FALSE

/datum/round_event/antagonist/solo/zizo_cultist/add_datum_to_mind(datum/mind/antag_mind)
	if(!leader)
		antag_mind.add_antag_datum(/datum/antagonist/zizocultist/leader)
		leader = TRUE
	else
		antag_mind.add_antag_datum(antag_datum)
