/datum/round_event_control/ultimate_sacrifice
	name = "Ultimate Sacrifice"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/ultimate_sacrifice
	weight = 5
	earliest_start = 20 MINUTES
	max_occurrences = 1
	min_players = 35

	tags = list(
		TAG_RAVOX,
		TAG_MEDICAL,
	)

/datum/round_event_control/ultimate_sacrifice/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/divine/ravox))
			continue
		if(H.age == AGE_CHILD)
			continue
		return TRUE

	return FALSE

/datum/round_event/ultimate_sacrifice/start()
	var/list/valid_targets = list()

	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue
		if(!human_mob.patron || !istype(human_mob.patron, /datum/patron/divine/ravox))
			continue
		if(human_mob.age == AGE_CHILD)
			continue
		valid_targets += human_mob

	if(!length(valid_targets))
		return

	var/mob/living/carbon/human/chosen_one = pick(valid_targets)

	var/datum/objective/personal/ultimate_sacrifice/new_objective = new(owner = chosen_one.mind)
	chosen_one.mind.add_personal_objective(new_objective)

	bordered_message(chosen_one, list(
		span_userdanger("YOU ARE RAVOX'S CHOSEN!"),
		span_notice("There is an honor in sacrifice. You have been granted a power by Ravox to sacrifice your own life to revive another. Beware, as you won't be able to be revived ever again. Use it only as a last resort to see a truly heinous injustice undone."),
	))
	chosen_one.playsound_local(chosen_one, 'sound/vo/male/knight/rage (6).ogg', 70)

	chosen_one.mind.announce_personal_objectives()
