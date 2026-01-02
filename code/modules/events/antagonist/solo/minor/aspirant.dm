/datum/round_event_control/antagonist/solo/aspirant
	name = "Aspirant"
	tags = list(
		TAG_ZIZO,
		TAG_BAOTHA,
		TAG_VILLAIN,
		TAG_COMBAT,
	)
	antag_datum = /datum/antagonist/aspirant
	roundstart = TRUE
	antag_flag = ROLE_ASPIRANT
	shared_occurence_type = SHARED_MINOR_THREAT
	minor_roleset = TRUE

	needed_job = list(
		/datum/job/consort,
		/datum/job/hand,
		/datum/job/prince,
		/datum/job/captain,
		/datum/job/steward,
		/datum/job/magician,
		/datum/job/courtphys,
		/datum/job/archivist,
		/datum/job/minor_noble,
	)

	restricted_roles = list(
		/datum/job/lord,
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
	secondary_prob = 75
	min_players = 25
	weight = 8

	typepath = /datum/round_event/antagonist/solo/aspirant

/datum/round_event_control/antagonist/solo/aspirant/valid_for_map()
	if(SSmapping.config.map_name != "Voyage")
		return TRUE
	return FALSE

/datum/round_event/antagonist/solo/aspirant

/datum/round_event/antagonist/solo/aspirant/start()
	. = ..()

	var/static/list/helping = list(
		/datum/job/consort,
		/datum/job/hand,
		/datum/job/prince,
		/datum/job/captain,
		/datum/job/steward,
		/datum/job/magician,
		/datum/job/courtphys,
		/datum/job/archivist,
		/datum/job/minor_noble,
		/datum/job/jester,
		/datum/job/dungeoneer,
		/datum/job/men_at_arms,
		/datum/job/gatemaster,
		/datum/job/butler,
		/datum/job/servant,
	)
	var/list/possible_helpers = list()

	for(var/mob/living/carbon/human/helper in GLOB.player_list)
		if(!helper.client || !helper.mind)
			continue
		if(is_banned_from(helper.client.ckey, ROLE_ASPIRANT))
			continue
		if(!is_type_in_list(helper.mind.assigned_role, helping))
			continue
		if(helper.mind in setup_minds)
			continue
		possible_helpers |= helper

	var/num_helpers = min(rand(1, 3), length(possible_helpers))

	for(var/i in 1 to num_helpers)
		var/mob/living/helper = pick_n_take(possible_helpers)
		helper.mind.add_antag_datum(/datum/antagonist/aspirant/supporter)

	if(SSticker.rulermob?.mind)
		SSticker.rulermob.mind.add_antag_datum(/datum/antagonist/aspirant/ruler)
