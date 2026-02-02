/datum/round_event_control/spacevine
	name = "Evil Vines"
	track = EVENT_TRACK_OMENS
	typepath = /datum/round_event/vines
	weight = 4
	max_occurrences = 1
	min_players = 3
	req_omen = TRUE
	todreq = list("dusk", "night", "dawn", "day")

	tags = list(
		TAG_NATURE,
		TAG_CURSE,
	)
