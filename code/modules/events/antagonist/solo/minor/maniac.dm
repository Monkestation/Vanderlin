/datum/round_event_control/antagonist/solo/maniac
	name = "Maniacs"
	tags = list(
		TAG_ZIZO,
		TAG_GRAGGAR,
		TAG_VILLAIN,
		TAG_COMBAT,
	)
	antag_datum = /datum/antagonist/maniac
	roundstart = TRUE
	antag_flag = ROLE_MANIAC
	shared_occurence_type = SHARED_MINOR_THREAT
	minor_roleset = TRUE

	restricted_roles = list(
		"Monarch",
		"Consort",
		"Priest",
		"Captain",
		"Hand",
		"Forest Warden",
		"Royal Knight",
		"Templar",
		"Bandit",
		"Wretch",
		"Inquisitor",
		"Absolver",
		"Confessor",
		"Sacrestants",
		"Adept",
		"Assassin",
	)

	denominator = 30

	base_antags = 1
	maximum_antags = 2

	earliest_start = 0 SECONDS

	min_players = 25
	weight = 8
	secondary_events = list(
		/datum/round_event_control/antagonist/solo/lich,
		/datum/round_event_control/antagonist/solo/rebel,
		/datum/round_event_control/antagonist/solo/vampires_and_werewolves,
		/datum/round_event_control/antagonist/solo/vampires,
		/datum/round_event_control/antagonist/solo/werewolf,
		/datum/round_event_control/antagonist/solo/zizo_cult
	)
	secondary_prob = 75
	typepath = /datum/round_event/antagonist/solo/maniac

/datum/round_event_control/antagonist/solo/maniac/canSpawnEvent(players_amt, gamemode, fake_check)
	if(GLOB.maniac_highlander) // Has a Maniac already TRIUMPHED?
		return FALSE
	. = ..()

/datum/round_event_control/antagonist/solo/maniac/midround
	name = "Maniac Awakening"
	roundstart = FALSE
	shared_occurence_type = null
	weight = 6
	base_antags = 1
	earliest_start = 30 MINUTES
	maximum_antags = 2
	secondary_prob = 0
	typepath = /datum/round_event/antagonist/solo/maniac/midround

/datum/round_event/antagonist/solo/maniac/midround

/datum/round_event_control/antagonist/solo/maniac/midround/get_candidates()
	. = ..()
	var/list/possible_candidates = . //typecasting
	var/list/weighted_list = list()
	var/list/final_candidates = list()

	for(var/mob/living/carbon/human/M in possible_candidates)
		var/stress = M.get_stress_amount()
		var/stressweight = 1
		if(stress >= STRESS_INSANE)
			stressweight = 10
		else if(stress >= STRESS_VBAD)
			stressweight = 5
		else if(stress >= STRESS_BAD)
			stressweight = 3
		weighted_list[M] = stressweight

	for(var/i in 1 to maximum_antags)
		var/M = pickweight(weighted_list)
		if(!length(weighted_list))
			break
		weighted_list -= M
		final_candidates += M
	return final_candidates
