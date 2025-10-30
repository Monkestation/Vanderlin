
/datum/round_event_control/zizo_shrines
	name = "Profane Construction"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/zizo_shrines
	weight = 7
	earliest_start = 15 MINUTES
	max_occurrences = 1
	min_players = 25

	tags = list(
		TAG_ZIZO,
		TAG_CORRUPTION,
		TAG_WORK,
	)

/datum/round_event_control/zizo_shrines/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/inhumen/zizo))
			continue
		if(H.get_skill_level(/datum/skill/craft/crafting) < 1)
			continue
		return TRUE

	return FALSE

/datum/round_event/zizo_shrines/start()
	var/list/valid_targets = list()

	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue
		if(!human_mob.patron || !istype(human_mob.patron, /datum/patron/inhumen/zizo))
			continue
		if(human_mob.get_skill_level(/datum/skill/craft/crafting) < 1)
			continue
		valid_targets += human_mob

	if(!length(valid_targets))
		return

	var/mob/living/carbon/human/chosen_one = pick(valid_targets)

	var/datum/objective/personal/build_zizo_shrine/new_objective = new(owner = chosen_one.mind)
	chosen_one.mind.add_personal_objective(new_objective)

	bordered_message(chosen_one, list(
		span_userdanger("YOU ARE ZIZO'S CHOSEN!"),
		span_biginfo("Zizo wants you to spread corruption! Construct [new_objective.target_count] profane shrines using your newly gained knowledge to complete Zizo's will!"),
	))
	to_chat(chosen_one, span_notice("You can construct unholy shrines with one small log, two stones and three wooden stakes."))
	chosen_one.playsound_local(chosen_one, 'sound/misc/gods/zizo_omen.ogg', 100)

	chosen_one.mind.announce_personal_objectives()
