/datum/round_event_control/crop_growth
	name = "Crop Growth"
	track = EVENT_TRACK_MUNDANE
	typepath = /datum/round_event/crop_growth
	weight = 5
	max_occurrences = 8
	min_players = 0
	earliest_start = 20 MINUTES

	tags = list(
		TAG_NATURE,
		TAG_BOON,
	)

/datum/round_event/crop_growth/start()
	. = ..()
	SSmapping.add_world_trait(/datum/world_trait/fertility, 10 MINUTES)
