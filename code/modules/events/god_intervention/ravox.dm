/datum/round_event_control/ravox_resolve
	name = "Ravox's Resolve"
	track = EVENT_TRACK_INTERVENTION
	typepath = /datum/round_event/ravox_resolve
	weight = 8
	earliest_start = 15 MINUTES
	max_occurrences = 1
	min_players = 30
	dedicated_storytellers = list(/datum/storyteller/ravox)
	allowed_storytellers = DIVINE_STORYTELLERS

	tags = list(
		TAG_RAVOX,
	)

/datum/round_event_control/ravox_resolve/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE
	if(GLOB.patron_follower_counts["Ravox"] < 3)
		return FALSE

/datum/round_event/ravox_resolve/start()
	var/mob/living/carbon/human/weakest
	var/weakest_stat
	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue

		if(!human_mob.patron || !istype(human_mob.patron, /datum/patron/divine/ravox))
			continue

		if(!weakest)
			weakest_stat = human_mob.get_stat_level(STATKEY_STR)
			weakest = human_mob

		var/mob_stat_level = human_mob.get_stat_level(STATKEY_STR)
		if(mob_stat_level < weakest_stat)
			weakest = human_mob
		else if(mob_stat_level == weakest_stat && prob(50))
			weakest = human_mob

	if(!weakest)
		return

	weakest.adjust_stat_modifier(STATMOD_RAVOX_RESOLVE, STATKEY_STR, 2)
	weakest.adjust_stat_modifier(STATMOD_RAVOX_RESOLVE, STATKEY_END, 2)
	weakest.adjust_stat_modifier(STATMOD_RAVOX_RESOLVE, STATKEY_CON, 2)
	if(is_ascendant(RAVOX))
		weakest.adjust_stat_modifier(STATMOD_RAVOX_RESOLVE, STATKEY_PER, 2)
		weakest.adjust_stat_modifier(STATMOD_RAVOX_RESOLVE, STATKEY_INT, 2)
		weakest.adjust_stat_modifier(STATMOD_RAVOX_RESOLVE, STATKEY_SPD, 2)
		weakest.adjust_stat_modifier(STATMOD_RAVOX_RESOLVE, STATKEY_LCK, 2)

	bordered_message(weakest, list(
		span_green("You may be weak compared to your fellow warriors of justice, but still you persevere. Ravox honors those who fight even when victory seems impossible. May his gift of strength help you overcome the odds.")
	))
	weakest.playsound_local(weakest, 'sound/vo/male/knight/rage (6).ogg', 70)
