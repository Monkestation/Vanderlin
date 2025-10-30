/datum/round_event_control/worldsiege/goblin
	name = "Goblin Siege"
	typepath = /datum/round_event/worldsiege/goblin
	weight = 10
	max_occurrences = 1
	min_players = 4
	todreq = null
	earliest_start = 35 MINUTES
	track = EVENT_TRACK_RAIDS

	raid_text = "The goblin horde approaches."

/datum/round_event/worldsiege/goblin/start()
	SSmapping.add_world_trait(/datum/world_trait/goblin_siege, rand(4 MINUTES, 8 MINUTES))
	for(var/mob/dead/observer/O in GLOB.player_list)
		addtimer(CALLBACK(O, TYPE_PROC_REF(/mob/dead/observer, horde_respawn)), 1)
	return
