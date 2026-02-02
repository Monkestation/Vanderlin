/datum/round_event_control/skellysiege
	name = "Skeleton Omen"
	track = EVENT_TRACK_OMENS
	typepath = /datum/round_event/skellysiege
	weight = 10
	max_occurrences = 2
	min_players = 0
	req_omen = TRUE
	earliest_start = 60 MINUTES
	todreq = list("dusk", "night", "dawn", "day")

	tags = list(
		TAG_RAID,
		TAG_BATTLE,
	)

	var/last_siege = 0

/datum/round_event/skellysiege
	announceWhen	= 1

/datum/round_event/skellysiege/setup()
	return

/datum/round_event/skellysiege/start()
	SSmapping.add_world_trait(/datum/world_trait/skeleton_siege, rand(4 MINUTES, 8 MINUTES))
	for(var/mob/dead/observer/O in GLOB.player_list)
		addtimer(CALLBACK(O, TYPE_PROC_REF(/mob/dead/observer, horde_respawn)), 1)
	return
