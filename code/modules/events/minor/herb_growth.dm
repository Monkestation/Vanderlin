GLOBAL_LIST_INIT(harvested_herbs, list())

/datum/round_event_control/herb_growth
	name = "Herb Regrowth"
	track = EVENT_TRACK_MUNDANE
	typepath = /datum/round_event/herb_growth
	weight = 5
	max_occurrences = 8
	min_players = 0
	earliest_start = 20 MINUTES

	tags = list(
		TAG_NATURE,
		TAG_BOON,
		TAG_ALCHEMY,
	)

/datum/round_event/herb_growth/start()
	. = ..()
	if(length(GLOB.harvested_herbs))
		for(var/i = 1 to rand(1, 25))
			if(!length(GLOB.harvested_herbs))
				return
			var/obj/structure/flora/grass/herb/herb = pick(GLOB.harvested_herbs)
			herb.loot_replenish()
