/datum/round_event_control/haunts
	name = "Haunted Streets"
	track = EVENT_TRACK_OMENS
	typepath = /datum/round_event/haunts
	weight = 10
	max_occurrences = 2
	min_players = 0
	req_omen = TRUE
	earliest_start = 25 MINUTES
	todreq = list("night")

	tags = list(
		TAG_HAUNTED,
		TAG_CURSE,
		TAG_BATTLE,
	)

/datum/round_event/haunts
	announceWhen	= 50
	var/spawncount = 5
	var/list/starts

/datum/round_event_control/haunts/canSpawnEvent(players_amt, gamemode, fake_check)
	if(!LAZYLEN(GLOB.hauntstart))
		return FALSE
	. = ..()

/datum/round_event/haunts/start()
	if(LAZYLEN(GLOB.hauntstart))
		for(var/i in 1 to spawncount)
			var/obj/effect/landmark/events/haunts/_T = pick_n_take(GLOB.hauntstart)
			if(_T)
				_T = get_turf(_T)
				if(isfloorturf(_T))
					new /obj/structure/bonepile(_T)

	return
