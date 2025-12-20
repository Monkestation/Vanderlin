/datum/round_event_control/pain_relief
	name = "Pain Relief"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/pain_relief
	weight = 7
	earliest_start = 5 MINUTES
	max_occurrences = 1
	min_players = 30

	tags = list(
		TAG_PESTRA,
		TAG_MEDICAL,
	)

/datum/round_event_control/pain_relief/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	var/recipient_found = FALSE
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/divine/pestra))
			continue
		recipient_found = TRUE

	if(recipient_found)
		return TRUE

	return FALSE

/datum/round_event/pain_relief/start()
	var/list/valid_targets = list()

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/divine/pestra))
			continue
		valid_targets += H

	if(!length(valid_targets))
		return

	var/mob/living/carbon/human/chosen_one = pick(valid_targets)

	var/datum/objective/personal/take_pain/new_objective = new(owner = chosen_one.mind)
	chosen_one.mind.add_personal_objective(new_objective)

	chosen_one.add_spell(/datum/action/cooldown/spell/transfer_pain)

	bordered_message(chosen_one, list(
		span_userdanger("YOU ARE PESTRA'S CHOSEN!"),
		span_notice("Pestra calls you to ease the suffering of others! Find those in pain and take their suffering upon yourself."),
	))
	chosen_one.playsound_local(chosen_one, 'sound/magic/cosmic_expansion.ogg', 100)

	chosen_one.mind.announce_personal_objectives()
