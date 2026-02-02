/datum/round_event_control/matthios_hoard
	name = "Mammon Desire"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/matthios_hoard
	weight = 10
	earliest_start = 5 MINUTES
	max_occurrences = 1
	min_players = 20

	tags = list(
		TAG_MATTHIOS,
		TAG_LOOT,
		TAG_CORRUPTION,
	)

/datum/round_event_control/matthios_hoard/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/inhumen/matthios))
			continue
		if(H.is_noble())
			continue
		return TRUE

	return FALSE

/datum/round_event/matthios_hoard/start()
	var/list/valid_targets = list()

	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue
		if(!human_mob.patron || !istype(human_mob.patron, /datum/patron/inhumen/matthios))
			continue
		if(human_mob.is_noble())
			continue
		valid_targets += human_mob

	if(!length(valid_targets))
		return

	var/mob/living/carbon/human/chosen_one = pick(valid_targets)

	var/datum/objective/personal/hoard_mammons/new_objective = new(owner = chosen_one.mind)
	chosen_one.mind.add_personal_objective(new_objective)

	bordered_message(chosen_one, list(
		span_userdanger("YOU ARE MATTHIOS' CHOSEN!"),
		span_notice("Accumulate [new_objective.target_mammons] mammons to prove your greed to Matthios!"),
	))
	chosen_one.playsound_local(chosen_one, 'sound/misc/gods/matthios_omen.ogg', 100)

	chosen_one.mind.announce_personal_objectives()
