/datum/round_event_control/matthios_fingers
	name = "Matthios' Fingers"
	track = EVENT_TRACK_INTERVENTION
	typepath = /datum/round_event/matthios_fingers
	weight = 8
	earliest_start = 10 MINUTES
	max_occurrences = 2
	min_players = 20
	dedicated_storytellers = list(/datum/storyteller/matthios)
	allowed_storytellers = INHUMEN_STORYTELLERS

	tags = list(
		TAG_MATTHIOS,
	)

/datum/round_event/matthios_fingers/start()
	SSmapping.add_world_trait(/datum/world_trait/matthios_fingers, 20 MINUTES)
