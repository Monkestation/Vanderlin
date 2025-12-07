/datum/round_event_control/antagonist/solo/werewolf
	name = "Verevolfs"
	tags = list(
		TAG_DENDOR,
		TAG_GRAGGAR,
		TAG_COMBAT,
		TAG_HAUNTED,
		TAG_VILLAIN,
	)
	roundstart = TRUE
	antag_flag = ROLE_WEREWOLF
	shared_occurence_type = SHARED_HIGH_THREAT

	denominator = 55

	base_antags = 1
	maximum_antags = 2

	weight = 12

	earliest_start = 0 SECONDS
	min_players = 45

	typepath = /datum/round_event/antagonist/solo/werewolf
	antag_datum = /datum/antagonist/werewolf

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
		"Sacrestants",
		"Adept",
		"Royal Knight",
		"Templar",
		"Assassin",
	)

/datum/round_event/antagonist/solo/werewolf
