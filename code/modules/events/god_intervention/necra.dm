/datum/round_event_control/necra_requiem
	name = "Necra's Requiem"
	track = EVENT_TRACK_INTERVENTION
	typepath = /datum/round_event/necra_requiem
	weight = 8
	earliest_start = 15 MINUTES
	max_occurrences = 2
	min_players = 20
	dedicated_storytellers = list(/datum/storyteller/necra)
	allowed_storytellers = DIVINE_STORYTELLERS

	tags = list(
		TAG_NECRA,
	)

/datum/round_event/necra_requiem/start()
	SSmapping.add_world_trait(/datum/world_trait/necra_requiem, 20 MINUTES)

	if(is_ascendant(NECRA))
		for(var/mob/living/carbon/human/potential_zombie as anything in GLOB.human_list)
			var/is_zombie = potential_zombie.mind?.has_antag_datum(/datum/antagonist/zombie)
			if(!is_zombie)
				continue
			bordered_message(potential_zombie, list(
				span_danger("An overwhelming power of Necra purifies your body and puts you to an eternal rest!")
			))
			potential_zombie.mind.remove_antag_datum(/datum/antagonist/zombie)
			potential_zombie.death()
