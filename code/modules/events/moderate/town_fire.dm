/datum/round_event_control/town_fire
	name = "Town Fire"
	track = EVENT_TRACK_MODERATE
	typepath = /datum/round_event/town_fire
	weight = 3
	max_occurrences = 4
	min_players = 0
	earliest_start = 25 MINUTES

	tags = list(
		TAG_CURSE,
		TAG_WORK,
	)

/datum/round_event/town_fire/start()
	. = ..()
	var/list/turfs = get_area_turfs(/area/indoors/town, subtypes = TRUE)
	for(var/i = 1 to rand(2, 5))
		var/turf/turf = pick(turfs)
		new /obj/effect/hotspot(turf)

