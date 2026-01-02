/datum/round_event_control/baotha_sniffing
	name = "Drug Desire"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/baotha_sniffing
	weight = 10
	earliest_start = 5 MINUTES
	max_occurrences = 1
	min_players = 15

	tags = list(
		TAG_BAOTHA,
		TAG_INSANITY,
		TAG_ALCHEMY,
	)

/datum/round_event_control/baotha_sniffing/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/inhumen/baotha))
			continue
		return TRUE

	return FALSE

/datum/round_event/baotha_sniffing/start()
	var/list/valid_targets = list()

	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue
		if(!human_mob.patron || !istype(human_mob.patron, /datum/patron/inhumen/baotha))
			continue
		valid_targets += human_mob

	if(!length(valid_targets))
		return

	var/mob/living/carbon/human/chosen_one = pick(valid_targets)

	var/datum/objective/personal/sniff_drugs/new_objective = new(owner = chosen_one.mind)
	chosen_one.mind.add_personal_objective(new_objective)

	bordered_message(chosen_one, list(
		span_userdanger("YOU ARE BAOTHA'S CHOSEN!"),
		span_notice("Baotha demands chemical ecstasy! Sniff drugs to earn Baotha's favor!"),
	))
	chosen_one.playsound_local(chosen_one, 'sound/misc/gods/baotha_omen.ogg', 100)

	chosen_one.mind.announce_personal_objectives()
