/datum/round_event_control/fishing_boon
	name = "Rainy Day"
	track = EVENT_TRACK_MODERATE
	typepath = /datum/round_event/fishing_boon
	weight = 5
	max_occurrences = 8
	min_players = 0
	earliest_start = 10 MINUTES

	tags = list(
		TAG_NATURE,
		TAG_BOON,
		TAG_WATER,
	)

/datum/round_event/fishing_boon/start()
	. = ..()
	SSmapping.add_world_trait(/datum/world_trait/fishing_increase, 20 MINUTES)
