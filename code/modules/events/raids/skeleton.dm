/datum/round_event_control/worldsiege
	name = "Skeleton Siege"
	typepath = /datum/round_event/worldsiege
	weight = 10
	max_occurrences = 1
	min_players = 4
	earliest_start = 35 MINUTES
	track = EVENT_TRACK_RAIDS

	tags = list(
		TAG_WAR,
		TAG_RAID,
		TAG_COMBAT,
	)

	var/last_siege
	var/raid_text = "The skeleton horde approaches."

/datum/round_event_control/worldsiege/preRunEvent()
	. = ..()
	if(. == EVENT_READY)
		priority_announce(raid_text, "", 'sound/misc/evilevent.ogg')
	last_siege = world.time

/datum/round_event/worldsiege
	announceWhen	= 1

/datum/round_event/worldsiege/setup()
	return TRUE

/datum/round_event/worldsiege/start()
	SSmapping.add_world_trait(/datum/world_trait/skeleton_siege, rand(4 MINUTES, 8 MINUTES))
	for(var/mob/dead/observer/O in GLOB.player_list)
		addtimer(CALLBACK(O, TYPE_PROC_REF(/mob/dead/observer, horde_respawn)), 1)
	return
