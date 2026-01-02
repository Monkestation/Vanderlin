/datum/round_event_control/create_abyssoids
	name = "Create Abyssoids"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/create_abyssoids
	weight = 7
	earliest_start = 10 MINUTES
	max_occurrences = 1
	min_players = 25

	tags = list(
		TAG_ABYSSOR,
		TAG_WATER,
		TAG_NATURE,
	)

/datum/round_event_control/create_abyssoids/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/divine/abyssor))
			continue
		return TRUE

	return FALSE

/datum/round_event/create_abyssoids/start()
	var/list/valid_targets = list()

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/divine/abyssor))
			continue
		valid_targets += H

	if(!length(valid_targets))
		return

	var/mob/living/carbon/human/chosen_one = pick(valid_targets)

	var/datum/objective/personal/create_abyssoids/new_objective = new(owner = chosen_one.mind)
	chosen_one.mind.add_personal_objective(new_objective)


	chosen_one.add_spell(/datum/action/cooldown/spell/undirected/create_abyssoid)

	bordered_message(chosen_one, list(
		span_userdanger("YOU ARE ABYSSOR'S CHOSEN!"),
		span_blue("Abyssor wants everyone to remember him! Create an army of holy abyssoid leeches and distribute them among the ingrates!"),
	))
	chosen_one.playsound_local(chosen_one, 'sound/items/bucket_transfer (2).ogg', 100)

	to_chat(chosen_one, span_notice("Abyssor grants you a power to create abyssoids from the common leeches! You will just need to pay a small blood price..."))

	chosen_one.mind.announce_personal_objectives()
