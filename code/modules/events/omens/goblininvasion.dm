/datum/round_event_control/gobinvade
	name = "Gob Invasion"
	track = EVENT_TRACK_OMENS
	typepath = /datum/round_event/gobinvade
	weight = 10
	max_occurrences = 2
	min_players = 0
	req_omen = TRUE
	earliest_start = 35 MINUTES
	todreq = list("night", "dawn", "day", "dusk")

	tags = list(
		TAG_RAID,
		TAG_BATTLE,
	)

/datum/round_event/gobinvade
	announceWhen	= 50
	var/spawncount = 5
	var/list/starts

/datum/round_event_control/gobinvade/canSpawnEvent(players_amt, gamemode, fake_check)
	if(!LAZYLEN(GLOB.hauntstart))
		return FALSE
	. = ..()

/datum/round_event/gobinvade/start()
	var/list/spawn_locs = GLOB.hauntstart.Copy()
	if(LAZYLEN(spawn_locs))
		for(var/i in 1 to spawncount)
			var/obj/effect/landmark/events/haunts/_T = pick_n_take(spawn_locs)
			if(_T)
				_T = get_turf(_T)
				if(isfloorturf(_T))
					var/obj/structure/gob_portal/G = locate() in _T
					if(G)
						continue
					new /obj/structure/gob_portal(_T)
	return

