/datum/round_event_control/noc_wisdom
	name = "Noc's Wisdom"
	track = EVENT_TRACK_INTERVENTION
	typepath = /datum/round_event/noc_wisdom
	weight = 8
	earliest_start = 10 MINUTES
	max_occurrences = 2
	min_players = 15
	todreq = list("dusk", "night", "dawn")
	dedicated_storytellers = list(/datum/storyteller/noc)
	allowed_storytellers = DIVINE_STORYTELLERS

	tags = list(
		TAG_NOC,
	)

/datum/round_event/noc_wisdom/start()
	SSmapping.add_world_trait(/datum/world_trait/noc_wisdom, 20 MINUTES)
