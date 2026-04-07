/datum/round_event_control/xylix_mocking
	name = "Mockery (Monarch)"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/xylix_mocking
	weight = 7
	earliest_start = 15 MINUTES
	max_occurrences = 1
	min_players = 25

	tags = list(
		TAG_XYLIX,
		TAG_TRICKERY,
	)

/datum/round_event_control/xylix_mocking/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client || is_lord_job(H.mind?.assigned_role))
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/divine/xylix))
			continue
		if(H.get_spell(/datum/action/cooldown/spell/vicious_mockery))
			continue
		return TRUE

	return FALSE

/datum/round_event/xylix_mocking/start()
	var/list/valid_targets = list()

	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client || is_lord_job(human_mob.mind?.assigned_role))
			continue
		if(!human_mob.patron || !istype(human_mob.patron, /datum/patron/divine/xylix))
			continue
		if(human_mob.get_spell(/datum/action/cooldown/spell/vicious_mockery))
			continue
		valid_targets += human_mob

	if(!length(valid_targets))
		return

	var/mob/living/carbon/human/chosen_one = pick(valid_targets)

	var/datum/objective/personal/mock/monarch/new_objective = new(owner = chosen_one.mind)
	chosen_one.mind.add_personal_objective(new_objective)

	bordered_message(chosen_one, list(
		span_userdanger("YOU ARE XYLIX'S CHOSEN!"),
		span_biginfo("Xylix demands great entertainment! Seek out and viciously mock the monarch to prove your devotion and earn Xylix's favor!"),
	))
	chosen_one.playsound_local(chosen_one, 'sound/misc/gods/xylix_omen.ogg', 100)

	chosen_one.add_spell(/datum/action/cooldown/spell/vicious_mockery)
	to_chat(chosen_one, span_notice("Xylix has granted you the gift of savage mockery! Use it to ridicule your target."))

	chosen_one.mind.announce_personal_objectives()
