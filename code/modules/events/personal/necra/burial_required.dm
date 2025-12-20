/datum/round_event_control/necra_burials
	name = "Burial Request"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/necra_burials
	weight = 10
	earliest_start = 10 MINUTES
	max_occurrences = 1
	min_players = 30

	tags = list(
		TAG_NECRA,
		TAG_HAUNTED,
	)

/datum/round_event_control/necra_burials/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/divine/necra))
			continue
		if(H.is_noble())
			continue
		return TRUE

	return FALSE

/datum/round_event/necra_burials/start()
	var/list/valid_targets = list()

	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue
		if(!human_mob.patron || !istype(human_mob.patron, /datum/patron/divine/necra))
			continue
		if(human_mob.is_noble())
			continue
		valid_targets += human_mob

	if(!length(valid_targets))
		return

	var/mob/living/carbon/human/chosen_one = pick(valid_targets)

	var/datum/objective/personal/proper_burial/new_objective = new(owner = chosen_one.mind)
	chosen_one.mind.add_personal_objective(new_objective)

	bordered_message(chosen_one, list(
		span_userdanger("YOU ARE NECRA'S CHOSEN!"),
		span_notice("Necra demands proper rites for the departed! Give enough corpses a proper burial to earn Necra's favor!"),
	))
	chosen_one.playsound_local(chosen_one, 'sound/ambience/noises/genspooky (1).ogg', 100)

	chosen_one.mind.announce_personal_objectives()
