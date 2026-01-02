/datum/round_event_control/matthios_theft
	name = "Thieving Task"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/matthios_theft
	weight = 10
	earliest_start = 10 MINUTES
	max_occurrences = 1
	min_players = 25

	tags = list(
		TAG_MATTHIOS,
		TAG_TRICKERY,
		TAG_LOOT,
	)

/datum/round_event_control/matthios_theft/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/inhumen/matthios))
			continue
		if(istype(H.mind?.assigned_role, /datum/job/bandit) || H.job == "Bandit")
			continue
		if(H.get_skill_level(/datum/skill/misc/stealing) < 2)
			continue
		return TRUE

	return FALSE

/datum/round_event/matthios_theft/start()
	var/list/valid_targets = list()

	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue
		if(!human_mob.patron || !istype(human_mob.patron, /datum/patron/inhumen/matthios))
			continue
		if(istype(human_mob.mind?.assigned_role, /datum/job/bandit) || human_mob.job == "Bandit")
			continue
		if(human_mob.get_skill_level(/datum/skill/misc/stealing) < 2)
			continue
		valid_targets += human_mob

	if(!length(valid_targets))
		return

	var/mob/living/carbon/human/chosen_one = pick(valid_targets)

	var/datum/objective/personal/steal_items/new_objective = new(owner = chosen_one.mind)
	chosen_one.mind.add_personal_objective(new_objective)

	bordered_message(chosen_one, list(
		span_userdanger("YOU ARE MATTHIOS' CHOSEN!"),
		span_notice("Matthios demands you prove your cunning! Pickpocket fools to earn Matthios' favor!"),
	))
	chosen_one.playsound_local(chosen_one, 'sound/misc/gods/matthios_omen.ogg', 100)

	chosen_one.mind.announce_personal_objectives()
