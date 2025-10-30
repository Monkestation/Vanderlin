/datum/round_event_control/skellyinvade
	name = "Skeleton Invasion"
	track = EVENT_TRACK_OMENS
	typepath = /datum/round_event/skellyinvade
	weight = 10
	max_occurrences = 2
	min_players = 0
	req_omen = TRUE
	earliest_start = 35 MINUTES
	todreq = list("night")


	tags = list(
		TAG_RAID,
		TAG_BATTLE,
	)

/datum/round_event/skellyinvade
	announceWhen	= 50
	var/spawncount = 3
	var/list/starts

/datum/round_event_control/skellyinvade/canSpawnEvent(players_amt, gamemode, fake_check)
	if(!LAZYLEN(GLOB.hauntstart))
		return FALSE

/datum/round_event/skellyinvade/setup()
	announceWhen = rand(announceWhen, announceWhen + 50)
//	var/maxi = max(GLOB.badomens.len, 1)
//	spawncount = 3 + maxi

/datum/round_event/skellyinvade/start()
	if(LAZYLEN(GLOB.hauntstart))
		for(var/i in 1 to spawncount)
			var/obj/effect/landmark/events/haunts/_T = pick_n_take(GLOB.hauntstart)
			if(_T)
				_T = get_turf(_T)
				if(isfloorturf(_T))
					new /mob/living/carbon/human/species/skeleton/npc(_T)

	return
