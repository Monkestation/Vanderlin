/datum/round_event_control/antagonist/solo/maniac
	name = "Maniacs"
	tags = list(
		TAG_INSANITY,
		TAG_MEDICAL,
		TAG_VILLAIN,
		TAG_COMBAT,
	)
	antag_datum = /datum/antagonist/maniac
	roundstart = TRUE
	antag_flag = ROLE_MANIAC
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
		/datum/job/tomb_warden,
		/datum/job/bogwitch,
		/datum/job/bog_apprentice,
	)


	base_antags = 1
	maximum_antags = 2
	min_players = (LOWPOP_THRESHOLD*0.6) * READYUP_AVG
	denominator = (LOWPOP_THRESHOLD*0.6) * READYUP_AVG
	cost = 0.6

	earliest_start = 0 SECONDS
	weight = 8

	secondary_events = list(
		/datum/round_event_control/antagonist/solo/wretch,
	)
	secondary_prob = 50

	preferred_events = list(
		/datum/round_event_control/antagonist/solo/wretch = 1,
		/datum/round_event_control/antagonist/solo/rebel = 1,
		/datum/round_event_control/antagonist/solo/vampires = 0.7,
		/datum/round_event_control/antagonist/solo/werewolf = 0.7,
		/datum/round_event_control/antagonist/solo/vampires_and_werewolves = 0.5,
		/datum/round_event_control/antagonist/solo/zizo_cult = 0.6,
		/datum/round_event_control/antagonist/solo/lich = 0.6,
	)

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
	earliest_start = 30 MINUTES
	base_antags = 1
	maximum_antags = 2
	denominator = 25
	max_occurrences = 1
	secondary_prob = 0
	preferred_events = null
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

	for(var/i in 1 to get_antag_amount())
		var/M = pickweight(weighted_list)
		if(!length(weighted_list))
			break
		weighted_list -= M
		final_candidates += M
	return final_candidates
