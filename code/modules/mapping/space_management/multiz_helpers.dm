/proc/get_step_multiz(ref, dir)
	switch(dir)
		if(UP)
			return GET_TURF_ABOVE(get_turf(ref))
		if(DOWN)
			return GET_TURF_BELOW(get_turf(ref))
		if(UP to DOWN-1)
			return GET_TURF_ABOVE_DIAGONAL(get_turf(ref), dir)
		if(DOWN to INFINITY)
			return GET_TURF_BELOW_DIAGONAL(get_turf(ref), dir)
		else
			return get_step(ref, dir)
	/* switch(dir)
		if(0 to SOUTHWEST) // 0 to 10; 11-15 is invalid
			return get_step(ref, dir)
		if(UP to UP|SOUTH|WEST) // 16 to 26; 27-31 is invalid (no EASTWEST)
			return GET_TURF_ABOVE_DIAGONAL(get_turf(ref), dir)
		if(DOWN to DOWN|NORTH|SOUTH|EAST|WEST) // 32 to 47
			return GET_TURF_BELOW_DIAGONAL(get_turf(ref), dir)
		else
			CRASH("Invalid direction [dir] passed to get_step_multiz!") */

/proc/get_dir_multiz(turf/us, turf/them)
	us = get_turf(us)
	them = get_turf(them)
	if(!us || !them)
		return NONE

	// Check virtual links first before falling back to z comparison
	var/turf/T = GET_TURF_ABOVE(us)
	if(T == them)
		return (UP | get_dir(us, them))
	T = GET_TURF_BELOW(us)
	if(T == them)
		return (DOWN | get_dir(us, them))

	if(us.z == them.z)
		return get_dir(us, them)
	else
		T = GET_TURF_ABOVE(us)
		var/dir = NONE
		if(T && (T.z == them.z))
			dir = UP
		else
			T = GET_TURF_BELOW(us)
			if(T && (T.z == them.z))
				dir = DOWN
			else
				return get_dir(us, them)
		return (dir | get_dir(us, them))

/proc/get_multiz_accessible_levels(center_z, turf/center_turf = null)
	. = list(center_z)
	var/other_z = center_z
	var/offset
	while((offset = SSmapping.multiz_levels[other_z][Z_LEVEL_DOWN]))
		other_z -= offset
		if(other_z in .)
			break
		. += other_z
	other_z = center_z
	while((offset = SSmapping.multiz_levels[other_z][Z_LEVEL_UP]))
		other_z += offset
		if(other_z in .)
			break
		. += other_z

	// If we have a turf, also walk virtual links to include their z levels
	if(center_turf)
		var/turf/walking = center_turf
		var/list/visited = list(center_turf)
		while((walking = walking.virtual_above))
			if(walking in visited)
				break
			visited += walking
			. |= walking.z
		walking = center_turf
		while((walking = walking.virtual_below))
			if(walking in visited)
				break
			visited += walking
			. |= walking.z

/// A cache of stringified z-level zweb checks.
/// GLOB.zweb_cache[num2text(my_z)][num2text(compare_z)] = TRUE/FALSE
GLOBAL_LIST_EMPTY(zweb_cache)
/proc/is_in_zweb(my_z, compare_z, turf/my_turf = null)
	if(!my_z || !compare_z)
		return FALSE
	if(my_z == compare_z)
		return TRUE
	var/my_text = num2text(my_z)
	var/comp_text = num2text(compare_z)
	if(isnull(GLOB.zweb_cache[my_text]?[comp_text]))
		LAZYINITLIST(GLOB.zweb_cache[my_text])
		for(var/zlevel in get_multiz_accessible_levels(my_z, my_turf))
			var/ztext = num2text(zlevel)
			GLOB.zweb_cache[my_text][ztext] = TRUE
			LAZYINITLIST(GLOB.zweb_cache[ztext])
			LAZYADD(GLOB.zweb_cache[ztext], my_text)
	return GLOB.zweb_cache[my_text][comp_text]
