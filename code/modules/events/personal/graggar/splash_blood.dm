/datum/round_event_control/blood_rite
	name = "Blood Rite"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/blood_rite
	weight = 10
	earliest_start = 5 MINUTES
	max_occurrences = 1
	min_players = 20

	tags = list(
		TAG_GRAGGAR,
		TAG_BLOOD,
	)

/datum/round_event_control/blood_rite/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/inhumen/graggar))
			continue
		return TRUE

	return FALSE

/datum/round_event/blood_rite/start()
	var/list/valid_targets = list()

	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue
		if(!human_mob.patron || !istype(human_mob.patron, /datum/patron/inhumen/graggar))
			continue
		valid_targets += human_mob

	if(!length(valid_targets))
		return

	var/mob/living/carbon/human/chosen_one = pick(valid_targets)

	var/datum/objective/personal/blood_splash/new_objective = new(owner = chosen_one.mind)
	chosen_one.mind.add_personal_objective(new_objective)

	bordered_message(chosen_one, list(
		span_userdanger("YOU ARE GRAGGAR'S CHOSEN!"),
		span_notice("There is power in blood. Splash a bucket full of blood on yourself to honor Graggar!"),
	))
	chosen_one.playsound_local(chosen_one, 'sound/misc/gods/graggar_omen.ogg', 100)

	chosen_one.mind.announce_personal_objectives()
