
/datum/round_event_control/dendor_trees
	name = "Wise Trees Propagation"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/dendor_trees
	weight = 7
	earliest_start = 10 MINUTES
	max_occurrences = 1
	min_players = 25

	tags = list(
		TAG_DENDOR,
		TAG_NATURE,
	)

/datum/round_event_control/dendor_trees/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/divine/dendor))
			continue
		if(H.get_spell(/datum/action/cooldown/spell/transfrom_tree))
			continue
		return TRUE

	return FALSE

/datum/round_event/dendor_trees/start()
	var/list/valid_targets = list()

	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue
		if(!human_mob.patron || !istype(human_mob.patron, /datum/patron/divine/dendor))
			continue
		if(human_mob.get_spell(/datum/action/cooldown/spell/transfrom_tree))
			continue
		valid_targets += human_mob

	if(!length(valid_targets))
		return

	var/mob/living/carbon/human/chosen_one = pick(valid_targets)

	var/datum/objective/personal/wise_trees/new_objective = new(owner = chosen_one.mind)
	chosen_one.mind.add_personal_objective(new_objective)

	chosen_one.add_spell(/datum/action/cooldown/spell/transfrom_tree)

	bordered_message(chosen_one, list(
		span_userdanger("YOU ARE DENDOR'S CHOSEN!"),
		span_biginfo("Dendor wants you to choose suitable trees, which are to become guardians of the forest! [new_objective.explanation_text]"),
	))
	chosen_one.playsound_local(chosen_one, 'sound/ambience/noises/genspooky (1).ogg', 100)

	to_chat(chosen_one, span_notice("Dendor grants you the power to transform trees into guardian wise trees!"))

	chosen_one.mind.announce_personal_objectives()
