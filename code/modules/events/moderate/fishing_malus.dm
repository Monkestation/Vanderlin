/datum/round_event_control/fishing_malus
	name = "River Drought"
	track = EVENT_TRACK_MODERATE
	typepath = /datum/round_event/fishing_malus
	weight = 5
	max_occurrences = 8
	min_players = 0
	earliest_start = 10 MINUTES

	tags = list(
		TAG_NATURE,
		TAG_CURSE,
		TAG_WATER,
	)

/datum/round_event/fishing_malus/start()
	. = ..()
	SSmapping.add_world_trait(/datum/world_trait/fishing_decrease, 10 MINUTES)
