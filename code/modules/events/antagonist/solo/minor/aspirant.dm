/datum/round_event_control/antagonist/solo/aspirant
	name = "Aspirant"
	tags = list(
		TAG_ZIZO,
		TAG_VILLAIN,
	)
	antag_datum = /datum/antagonist/aspirant
	roundstart = TRUE
	antag_flag = ROLE_ASPIRANT
	shared_occurence_type = SHARED_MINOR_THREAT
	minor_roleset = TRUE

	needed_job = list(
		"Consort",
		"Hand",
		"Prince",
		"Captain",
		"Steward",
		"Court Magician",
		"Court Physician",
		"Archivist",
		"Noble"
	)

	base_antags = 1
	maximum_antags = 1

	earliest_start = 0 SECONDS
	secondary_events = list(
		/datum/round_event_control/antagonist/solo/lich,
		/datum/round_event_control/antagonist/solo/rebel,
		/datum/round_event_control/antagonist/solo/vampires_and_werewolves,
		/datum/round_event_control/antagonist/solo/vampires,
		/datum/round_event_control/antagonist/solo/werewolf,
		/datum/round_event_control/antagonist/solo/zizo_cult
	)
	secondary_prob = 90
	weight = 8

	typepath = /datum/round_event/antagonist/solo/aspirant

/datum/round_event_control/antagonist/solo/aspirant/valid_for_map()
	if(SSmapping.config.map_name != "Voyage")
		return TRUE
	return FALSE

/datum/round_event/antagonist/solo/aspirant

/datum/round_event/antagonist/solo/aspirant/start()
	. = ..()

	var/list/helping = list("Consort", "Hand", "Prince", "Captain", "Steward", "Court Magician", "Court Physician", "Archivist", "Noble", "Jester", "Dungeoneer", "Men-at-arms", "Gatemaster", "Butler", "Servant")
	var/list/possible_helpers = list()

	for(var/mob/living/living in GLOB.human_list)
		if(!living.client)
			continue
		if(is_banned_from(living.client.ckey, ROLE_ASPIRANT))
			continue
		if(!(living.mind?.assigned_role.title in helping))
			continue
		if(living.mind in setup_minds)
			continue
		possible_helpers |= living

	var/num_helpers = min(rand(1, 3), length(possible_helpers))

	for(var/i in 1 to num_helpers)
		var/mob/living/helper = pick_n_take(possible_helpers)
		if(!helper?.mind)
			continue
		helper.mind.add_antag_datum(/datum/antagonist/aspirant/supporter)

	if(SSticker.rulermob?.mind)
		SSticker.rulermob.mind.add_antag_datum(/datum/antagonist/aspirant/ruler)
