///Returns the src and all recursive contents as a list.
/atom/proc/get_all_contents(ignore_flag_1)
	. = list(src)
	var/i = 0
	while(i < length(.))
		var/atom/checked_atom = .[++i]
		if(checked_atom.flags_1 & ignore_flag_1)
			continue
		. += checked_atom.contents

///Returns a list of all locations (except the area) the movable is within.
/proc/get_nested_locs(atom/movable/atom_on_location, include_turf = FALSE)
	. = list()
	var/atom/location = atom_on_location.loc
	var/turf/our_turf = get_turf(atom_on_location)
	while(location && location != our_turf)
		. += location
		location = location.loc
	if(our_turf && include_turf) //At this point, only the turf is left, provided it exists.
		. += our_turf

///Step-towards method of determining whether one atom can see another. Similar to viewers()
///note: this is a line of sight algorithm, view() does not do any sort of raycasting and cannot be emulated by it accurately
/proc/can_see(atom/source, atom/target, length=5) // I couldnt be arsed to do actual raycasting :I This is horribly inaccurate.
	var/turf/current = get_turf(source)
	var/turf/target_turf = get_turf(target)
	if(get_dist(source, target) > length)
		return FALSE
	var/steps = 1
	if(current == target_turf)//they are on the same turf, source can see the target
		return TRUE
	current = get_step_towards(current, target_turf)
	while(current != target_turf)
		if(steps > length)
			return FALSE
		if(IS_OPAQUE_TURF(current))
			return FALSE
		current = get_step_towards(current, target_turf)
		steps++
	return TRUE

///Get the cardinal direction between two atoms
/proc/get_cardinal_dir(atom/start, atom/end)
	var/dx = abs(end.x - start.x)
	var/dy = abs(end.y - start.y)
	return get_dir(start, end) & (rand() * (dx+dy) < dy ? 3 : 12)

///Forces the atom to take a step in a random direction
/proc/random_step(atom/movable/moving_atom, steps, chance)
	var/initial_chance = chance
	while(steps > 0)
		if(prob(chance))
			step(moving_atom, pick(GLOB.alldirs))
		chance = max(chance - (initial_chance / steps), 0)
		steps--

/**
 * Compare source's dir, the clockwise dir of source and the anticlockwise dir of source
 * To the opposite dir of the dir returned by get_dir(target,source)
 * If one of them is a match, then source is facing target
**/
/proc/is_source_facing_target(atom/source,atom/target)
	if(!istype(source) || !istype(target))
		return FALSE
	if(isliving(source))
		var/mob/living/source_mob = source
		if(source_mob.body_position == LYING_DOWN)
			return FALSE
	var/goal_dir = get_dir(source, target)
	var/clockwise_source_dir = turn(source.dir, -45)
	var/anticlockwise_source_dir = turn(source.dir, 45)
	if(source.dir == goal_dir || clockwise_source_dir == goal_dir || anticlockwise_source_dir == goal_dir)
		return TRUE
	return FALSE


/*
rough example of the "cone" made by the 3 dirs checked

* \
*  \
*   >
*     <
*      \
*       \
*B --><-- A
*       /
*      /
*     <
*    >
*   /
*  /

*/

///ultra range (no limitations on distance, faster than range for distances > 8); including areas drastically decreases performance
/proc/urange(dist = 0, atom/center = usr, orange = FALSE, areas = FALSE)
	if(!dist)
		if(!orange)
			return list(center)
		else
			return list()
	var/list/turfs = RANGE_TURFS(dist, center)
	if(orange)
		turfs -= get_turf(center)
	. = list()
	for(var/turf/checked_turf as anything in turfs)
		. += checked_turf
		. += checked_turf.contents
		if(areas)
			. |= checked_turf.loc

///similar function to range(), but with no limitations on the distance; will search spiralling outwards from the center
/proc/spiral_range(dist = 0, center = usr, orange = FALSE)
	var/list/atom_list = list()
	var/turf/t_center = get_turf(center)
	if(!t_center)
		return list()
	if(!orange)
		atom_list += t_center
		atom_list += t_center.contents
	if(!dist)
		return atom_list
	var/turf/checked_turf
	var/y
	var/x
	var/c_dist = 1
	while( c_dist <= dist )
		y = t_center.y + c_dist
		x = t_center.x - c_dist + 1
		for(x in x to t_center.x + c_dist)
			checked_turf = locate(x, y, t_center.z)
			if(checked_turf)
				atom_list += checked_turf
				atom_list += checked_turf.contents
		y = t_center.y + c_dist - 1
		x = t_center.x + c_dist
		for(y in t_center.y - c_dist to y)
			checked_turf = locate(x, y, t_center.z)
			if(checked_turf)
				atom_list += checked_turf
				atom_list += checked_turf.contents
		y = t_center.y - c_dist
		x = t_center.x + c_dist - 1
		for(x in t_center.x - c_dist to x)
			checked_turf = locate(x, y, t_center.z)
			if(checked_turf)
				atom_list += checked_turf
				atom_list += checked_turf.contents
		y = t_center.y - c_dist + 1
		x = t_center.x - c_dist
		for(y in y to t_center.y + c_dist)
			checked_turf = locate(x, y, t_center.z)
			if(checked_turf)
				atom_list += checked_turf
				atom_list += checked_turf.contents
		c_dist++
	return atom_list

///Returns the closest atom of a specific type in a list from a source
/proc/get_closest_atom(type, list/atom_list, source)
	var/closest_atom
	var/closest_distance
	for(var/atom in atom_list)
		if(!istype(atom, type))
			continue
		var/distance = get_dist(source, atom)
		if(!closest_atom)
			closest_distance = distance
			closest_atom = atom
		else
			if(closest_distance > distance)
				closest_distance = distance
				closest_atom = atom
	return closest_atom

///Returns a chosen path that is the closest to a list of matches
/proc/pick_closest_path(value, list/matches = get_fancy_list_of_atom_types())
	if(value == FALSE) //nothing should be calling us with a number, so this is safe
		value = tgui_input_text(usr, "Enter type to find (blank for all, cancel to cancel)", "Search for type")
		if(isnull(value))
			return
	value = trim(value)
	if(!isnull(value) && value != "")
		matches = filter_fancy_list(matches, value)

	if(matches.len==0)
		return

	var/chosen
	if(matches.len==1)
		chosen = matches[1]
	else
		chosen = tgui_input_list(usr, "Select a type", "Pick Type", matches, matches[1])
		if(!chosen)
			return
	chosen = matches[chosen]
	return chosen

///Creates new items inside an atom based on a list
/proc/generate_items_inside(list/items_list, where_to)
	for(var/each_item in items_list)
		for(var/i in 1 to items_list[each_item])
			new each_item(where_to)

///Returns the atom type in the specified loc
/proc/get(atom/loc, type)
	while(loc)
		if(istype(loc, type))
			return loc
		loc = loc.loc
	return null

///Returns true if the src countain the atom target
/atom/proc/contains(atom/target)
	if(!target)
		return FALSE
	for(var/atom/location = target.loc, location, location = location.loc)
		if(location == src)
			return TRUE

///A do nothing proc
/proc/pass(...)
	return

/// Returns an x and y value require to reverse the transformations made to center an oversized icon
/atom/proc/get_oversized_icon_offsets()
	if (pixel_x == 0 && pixel_y == 0)
		return list("x" = 0, "y" = 0)
	var/list/icon_dimensions = get_icon_dimensions(icon)
	var/icon_width = icon_dimensions["width"]
	var/icon_height = icon_dimensions["height"]
	return list(
		"x" = icon_width > world.icon_size && pixel_x != 0 ? (icon_width - world.icon_size) * 0.5 : 0,
		"y" = icon_height > world.icon_size && pixel_y != 0 ? (icon_height - world.icon_size) * 0.5 : 0,
	)
