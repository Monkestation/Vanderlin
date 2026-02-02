/datum/round_event_control/graggar_punch
	name = "Graggar's Misogyny"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/graggar_punch
	weight = 7
	earliest_start = 15 MINUTES
	max_occurrences = 1
	min_players = 30

	tags = list(
		TAG_GRAGGAR,
		TAG_BLOOD,
		TAG_BATTLE,
	)

/datum/round_event_control/graggar_punch/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/inhumen/graggar))
			continue
		if(H.gender == FEMALE)
			continue
		return TRUE

	return FALSE

/datum/round_event/graggar_punch/start()
	var/list/valid_targets = list()

	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue
		if(!human_mob.patron || !istype(human_mob.patron, /datum/patron/inhumen/graggar))
			continue
		if(human_mob.gender == FEMALE)
			continue
		valid_targets += human_mob

	if(!length(valid_targets))
		return

	var/mob/living/carbon/human/chosen_one = pick(valid_targets)

	var/datum/objective/personal/punch_women/new_objective = new(owner = chosen_one.mind)
	chosen_one.mind.add_personal_objective(new_objective)

	bordered_message(chosen_one, list(
		span_userdanger("YOU ARE GRAGGAR'S CHOSEN!"),
		span_biginfo("[new_objective.explanation_text]"),
	))
	chosen_one.playsound_local(chosen_one, 'sound/misc/gods/graggar_omen.ogg', 100)

	chosen_one.mind.announce_personal_objectives()
