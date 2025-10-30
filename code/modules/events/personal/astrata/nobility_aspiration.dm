/datum/round_event_control/astrata_nobility
	name = "Nobility Aspiration"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/astrata_nobility
	weight = 7
	earliest_start = 5 MINUTES
	max_occurrences = 1
	min_players = 25

	tags = list(
		TAG_ASTRATA,
	)

/datum/round_event_control/astrata_nobility/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/divine/astrata))
			continue
		if(H.is_noble() || (H.mind?.assigned_role.title in GLOB.church_positions))
			continue
		if(!(H.dna?.species.id in RACES_PLAYER_NONHERETICAL))
			continue
		return TRUE

	return FALSE

/datum/round_event/astrata_nobility/start()
	var/list/valid_targets = list()

	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue
		if(!human_mob.patron || !istype(human_mob.patron, /datum/patron/divine/astrata))
			continue
		if(human_mob.is_noble() || (human_mob.mind?.assigned_role.title in GLOB.church_positions))
			continue
		if(!(human_mob.dna?.species.id in RACES_PLAYER_NONHERETICAL))
			continue
		valid_targets += human_mob

	if(!length(valid_targets))
		return

	var/mob/living/carbon/human/chosen_one = pick(valid_targets)

	var/datum/objective/personal/nobility/new_objective = new(owner = chosen_one.mind)
	chosen_one.mind.add_personal_objective(new_objective)

	bordered_message(chosen_one, list(
		span_userdanger("YOU ARE ASTRATA'S CHOSEN!"),
		span_notice("Astrata wishes you to ascend in status! Become a part of the nobility to earn Astrata's favor!"),
	))
	chosen_one.playsound_local(chosen_one, 'sound/magic/bless.ogg', 100)

	chosen_one.mind.announce_personal_objectives()
