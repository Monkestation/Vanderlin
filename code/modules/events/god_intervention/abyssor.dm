/datum/round_event_control/abyssor_rage
	name = "Abyssor's Rage"
	track = EVENT_TRACK_INTERVENTION
	typepath = /datum/round_event/abyssor_rage
	weight = 8
	earliest_start = 10 MINUTES
	max_occurrences = 2
	min_players = 20
	dedicated_storytellers = list(/datum/storyteller/abyssor)
	allowed_storytellers = DIVINE_STORYTELLERS

	tags = list(
		TAG_ABYSSOR,
	)

/datum/round_event/abyssor_rage/start()
	SSmapping.add_world_trait(/datum/world_trait/abyssor_rage, 20 MINUTES)
