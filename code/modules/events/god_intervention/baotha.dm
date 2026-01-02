/datum/round_event_control/baotha_revelry
	name = "Baotha's Revelry"
	track = EVENT_TRACK_INTERVENTION
	typepath = /datum/round_event/baotha_revelry
	weight = 8
	earliest_start = 10 MINUTES
	max_occurrences = 2
	min_players = 15
	dedicated_storytellers = list(/datum/storyteller/baotha)
	allowed_storytellers = INHUMEN_STORYTELLERS

	tags = list(
		TAG_BAOTHA,
	)

/datum/round_event/baotha_revelry/start()
	SSmapping.add_world_trait(/datum/world_trait/baotha_revelry, 20 MINUTES)
