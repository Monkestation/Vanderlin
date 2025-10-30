/datum/round_event_control/baotha_lux_tasting
	name = "Lux Experience"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/baotha_lux_tasting
	weight = 7
	earliest_start = 10 MINUTES
	max_occurrences = 1
	min_players = 30

	tags = list(
		TAG_BAOTHA,
		TAG_INSANITY,
	)

/datum/round_event_control/baotha_lux_tasting/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/inhumen/baotha))
			continue
		if(!H.is_noble())
			continue
		return TRUE

	return FALSE

/datum/round_event/baotha_lux_tasting/start()
	var/list/valid_targets = list()

	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue
		if(!human_mob.patron || !istype(human_mob.patron, /datum/patron/inhumen/baotha))
			continue
		if(!human_mob.is_noble())
			continue
		valid_targets += human_mob

	if(!length(valid_targets))
		return

	var/mob/living/carbon/human/chosen_one = pick(valid_targets)

	var/datum/objective/personal/taste_lux/new_objective = new(owner = chosen_one.mind)
	chosen_one.mind.add_personal_objective(new_objective)

	bordered_message(chosen_one, list(
		span_userdanger("YOU ARE BAOTHA'S CHOSEN!"),
		span_notice("Seek out and taste Lux to experience true pleasure and make Baotha proud! You might need to grind it first though..."),
	))
	chosen_one.playsound_local(chosen_one, 'sound/misc/gods/baotha_omen.ogg', 100)

	chosen_one.mind.announce_personal_objectives()
