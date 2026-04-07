/datum/round_event_control/zizo_torture
	name = "Demand of Cruelty"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/zizo_torture
	weight = 7
	earliest_start = 10 MINUTES
	max_occurrences = 1
	min_players = 20

	tags = list(
		TAG_ZIZO,
		TAG_BLOOD,
		TAG_INSANITY,
	)

/datum/round_event_control/zizo_torture/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/inhumen/zizo))
			continue
		return TRUE

	return FALSE

/datum/round_event/zizo_torture/start()
	var/list/valid_targets = list()

	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue
		if(!human_mob.patron || !istype(human_mob.patron, /datum/patron/inhumen/zizo))
			continue
		valid_targets += human_mob

	if(!length(valid_targets))
		return

	var/mob/living/carbon/human/chosen_one = pick(valid_targets)

	var/datum/objective/personal/torture/new_objective = new(owner = chosen_one.mind)
	chosen_one.mind.add_personal_objective(new_objective)

	add_verb(chosen_one, /mob/living/carbon/human/proc/torture_victim)
	add_verb(chosen_one, /mob/living/carbon/human/proc/faith_test)

	bordered_message(chosen_one, list(
		span_userdanger("YOU ARE ZIZO'S CHOSEN!"),
		span_biginfo("Zizo demands suffering! Extract information through pain to earn Zizo's favor!"),
	))
	chosen_one.playsound_local(chosen_one, 'sound/misc/gods/zizo_omen.ogg', 100)

	to_chat(chosen_one, span_notice("You have gained an ability to <b>torture</b> others!"))

	chosen_one.mind.announce_personal_objectives()
