/datum/round_event_control/abyssors_temperament
	name = "Abyssor's Temperament"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/abyssors_temperament
	weight = 10
	earliest_start = 5 MINUTES
	max_occurrences = 1
	min_players = 25

	tags = list(
		TAG_ABYSSOR,
		TAG_WATER,
		TAG_UNEXPECTED,
	)

/datum/round_event_control/abyssors_temperament/canSpawnEvent(players_amt, gamemode, fake_check)
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

/datum/round_event/abyssors_temperament/start()
	var/list/valid_targets = list()

	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue
		if(!human_mob.patron || !istype(human_mob.patron, /datum/patron/divine/abyssor))
			continue
		valid_targets += human_mob

	if(!length(valid_targets))
		return

	var/mob/living/carbon/human/chosen_one = pick(valid_targets)
	var/datum/objective/abyssor_objective

	var/calm
	if(prob(50))
		abyssor_objective = new /datum/objective/personal/abyssor_bath(owner = chosen_one.mind)
		calm = TRUE
	else
		abyssor_objective = new /datum/objective/personal/abyssor_splash(owner = chosen_one.mind)
		calm = FALSE

	chosen_one.mind.add_personal_objective(abyssor_objective)

	to_chat(chosen_one, span_userdanger("YOU ARE ABYSSOR'S CHOSEN!"))
	if(calm)
		to_chat(chosen_one, span_notice("Abyssor is calm at the moment. Take a relaxing bath while wearing his amulet to honor him!"))
	else
		to_chat(chosen_one, span_notice("Abyssor is RAGING like a storm! Splash those who forgot his name with a bucket full of water to help them remember!"))
	chosen_one.playsound_local(chosen_one, 'sound/items/bucket_transfer (2).ogg', 100)

	chosen_one.mind.announce_personal_objectives()
