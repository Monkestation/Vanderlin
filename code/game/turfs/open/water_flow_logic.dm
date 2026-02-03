
/turf/open/water
	var/turf/open/water/source_originate
	var/turf/open/water/parent
	var/list/children
	var/list/conflicting_originate_turfs


/turf/open/water/proc/set_parent(turf/open/water/incoming)
	if(mapped)
		return
	if(source_originate && incoming.source_originate)
		if(source_originate != incoming.source_originate)
			LAZYOR(source_originate.conflicting_originate_turfs, incoming.source_originate)
			LAZYOR(incoming.source_originate.conflicting_originate_turfs, source_originate)

	source_originate = incoming.source_originate
	if(istype(incoming, /turf/open/water/river/creatable))
		var/turf/open/water/river/creatable/river = incoming
		if(!river.river_processes)
			source_originate = incoming
	if(!source_originate)
		source_originate = incoming
	parent?.remove_child(src)
	parent = incoming
	parent.add_child(src)
	water_volume = parent.water_volume - 10
	water_reagent = parent.water_reagent
	if(istype(src, /turf/open/water/river/creatable))
		dir = get_dir(src, parent)
		if(!(dir & ALL_CARDINALS))
			return
		for(var/obj/structure/waterwheel/potential_rotator in contents)
			if(potential_rotator.last_stress_generation == 1024)
				continue
			potential_rotator.set_rotational_direction_and_speed(dir, 8)
			potential_rotator.set_stress_generation(1024)

	check_surrounding_water()
	handle_water()

/turf/open/water/proc/try_set_parent(turf/open/water/incoming)
	if(!incoming)
		return
	if(incoming.water_volume < 10)
		return
	set_parent(incoming)

/turf/open/water/proc/check_surrounding_water(reassess = FALSE)
	for(var/direction in GLOB.cardinals)
		if(istype(src, /turf/open/water/river))
			if(direction == REVERSE_DIR(dir))
				continue
		if(blocked_flow_directions & direction)
			continue
		var/turf/open/water/river/creatable/water = get_step(src, direction)
		if(!istype(water))
			continue
		if(!reassess)
			if(water.water_volume > (water_volume - 10))
				continue
		addtimer(CALLBACK(water, PROC_REF(try_set_parent), src), 0.2 SECONDS)
		//water.try_set_parent(src)

/turf/open/water/proc/recursive_clear_icon()
	dryup()
	check_surrounding_water()
	for(var/turf/open/water/child in children)
		addtimer(CALLBACK(child, PROC_REF(recursive_clear_icon)), 0.25 SECONDS)
	for(var/direction in GLOB.cardinals)
		var/turf/open/water/river/creatable/water = get_step(src, direction)
		if(!istype(water))
			continue
		if(water.water_volume < 0)
			continue
		water.check_surrounding_water()

/turf/open/water/proc/remove_child(turf/open/water/water)
	LAZYREMOVE(children, water)

/turf/open/water/proc/add_child(turf/open/water/water)
	LAZYOR(children, water)
