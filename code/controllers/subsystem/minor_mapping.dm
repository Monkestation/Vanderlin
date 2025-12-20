SUBSYSTEM_DEF(minor_mapping)
	name = "Minor Mapping"
	init_order = INIT_ORDER_MINOR_MAPPING
	flags = SS_NO_FIRE

/datum/controller/subsystem/minor_mapping/Initialize(timeofday)
	//Minor mapping comes quite late in the init list so it should be safe to add here. We want this long after everything else is done
	SSmapping.load_marks()

//	place_sunlight()
	return ..()

/proc/find_sun_suitable_turfs()
	var/list/suitable = list()

	for(var/z in SSmapping.levels_by_trait(ZTRAIT_STATION))
		for(var/t in block(locate(1,1,z), locate(world.maxx,world.maxy,z)))
			if(isfloorturf(t))
				var/area/A = get_area(t)
				if(istype(A, /area/outdoors))
					suitable += t

	return shuffle(suitable)
