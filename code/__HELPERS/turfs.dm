/**
 * Returns the top-most atom sitting on the turf.
 * For example, using this on a disk, which is in a bag, on a mob,
 * will return the mob because it's on the turf.
 *
 * Arguments
 * * something_in_turf - a movable within the turf, somewhere.
 * * stop_type - optional - stops looking if stop_type is found in the turf, returning that type (if found).
 **/
/proc/get_atom_on_turf(atom/movable/something_in_turf, stop_type)
	if(!istype(something_in_turf))
		CRASH("get_atom_on_turf was not passed an /atom/movable! Got [isnull(something_in_turf) ? "null":"type: [something_in_turf.type]"]")

	var/atom/movable/topmost_thing = something_in_turf

	while(topmost_thing?.loc && !isturf(topmost_thing.loc))
		topmost_thing = topmost_thing.loc
		if(stop_type && istype(topmost_thing, stop_type))
			break

	return topmost_thing

// returns the turf located at the map edge in the specified direction relative to A
// used for mass driver
/proc/get_edge_target_turf(atom/A, direction)
	var/turf/target = locate(A.x, A.y, A.z)
	if(!A || !target)
		return 0
		//since NORTHEAST == NORTH|EAST, etc, doing it this way allows for diagonal mass drivers in the future
		//and isn't really any more complicated

	var/x = A.x
	var/y = A.y
	if(direction & NORTH)
		y = world.maxy
	else if(direction & SOUTH) //you should not have both NORTH and SOUTH in the provided direction
		y = 1
	if(direction & EAST)
		x = world.maxx
	else if(direction & WEST)
		x = 1
	if(direction in GLOB.diagonals) //let's make sure it's accurately-placed for diagonals
		var/lowest_distance_to_map_edge = min(abs(x - A.x), abs(y - A.y))
		return get_ranged_target_turf(A, direction, lowest_distance_to_map_edge)
	return locate(x,y,A.z)

// returns turf relative to A in given direction at set range
// result is bounded to map size
// note range is non-pythagorean
// used for disposal system
/proc/get_ranged_target_turf(atom/A, direction, range)

	var/x = A.x
	var/y = A.y
	if(direction & NORTH)
		y = min(world.maxy, y + range)
	else if(direction & SOUTH)
		y = max(1, y - range)
	if(direction & EAST)
		x = min(world.maxx, x + range)
	else if(direction & WEST) //if you have both EAST and WEST in the provided direction, then you're gonna have issues
		x = max(1, x - range)

	return locate(x,y,A.z)

// returns turf relative to A offset in dx and dy tiles
// bound to map limits
/proc/get_offset_target_turf(atom/A, dx, dy)
	var/x = min(world.maxx, max(1, A.x + dx))
	var/y = min(world.maxy, max(1, A.y + dy))
	return locate(x,y,A.z)

///Returns a turf based on text inputs, original turf and viewing client
/proc/parse_caught_click_modifiers(list/modifiers, turf/origin, client/viewing_client)
	if(!modifiers)
		return null

	var/screen_loc = splittext(LAZYACCESS(modifiers, SCREEN_LOC), ",")
	var/list/actual_view = getviewsize(viewing_client ? viewing_client.view : world.view)
	var/click_turf_x = splittext(screen_loc[1], ":")
	var/click_turf_y = splittext(screen_loc[2], ":")
	var/click_turf_z = origin.z

	var/click_turf_px = text2num(click_turf_x[2])
	var/click_turf_py = text2num(click_turf_y[2])
	click_turf_x = origin.x + text2num(click_turf_x[1]) - round(actual_view[1] / 2) - 1
	click_turf_y = origin.y + text2num(click_turf_y[1]) - round(actual_view[2] / 2) - 1

	var/turf/click_turf = locate(clamp(click_turf_x, 1, world.maxx), clamp(click_turf_y, 1, world.maxy), click_turf_z)
	LAZYSET(modifiers, ICON_X, "[(click_turf_px - click_turf.pixel_x) + ((click_turf_x - click_turf.x) * 32)]")
	LAZYSET(modifiers, ICON_Y, "[(click_turf_py - click_turf.pixel_y) + ((click_turf_y - click_turf.y) * 32)]")
	return click_turf

/**
 * Checks whether the target turf is in a valid state to accept a directional construction
 * such as windows or railings.
 *
 * Returns FALSE if the target turf cannot accept a directional construction.
 * Returns TRUE otherwise.
 *
 * Arguments:
 * * dest_turf - The destination turf to check for existing directional constructions
 * * test_dir - The prospective dir of some atom you'd like to put on this turf.
 * * is_fulltile - Whether the thing you're attempting to move to this turf takes up the entire tile or whether it supports multiple movable atoms on its tile.
 */
/proc/valid_build_direction(turf/dest_turf, test_dir, is_fulltile = FALSE)
	if(!dest_turf)
		return FALSE
	for(var/obj/turf_content in dest_turf)
		if(turf_content.obj_flags & BLOCKS_CONSTRUCTION_DIR)
			if(is_fulltile)  // for making it so fulltile things can't be built over directional things--a special case
				return FALSE
			if(turf_content.dir == test_dir)
				return FALSE
	return TRUE

/**
 * Converts mouse-pos control coordinates to a specific turf location on the map.
 *
 * Handles the conversion between control-space mouse coordinates and screen-space map coordinates,
 * accounting for various BYOND quirks and display scaling factors.
 *
 * @param mousepos_x	The x-coordinate of the mouse click (in control pixels, top-left origin)
 * @param mousepos_y	The y-coordinate of the mouse click (in control pixels, top-left origin)
 * @param sizex			x control width of the map
 * @param sizey			y control width of the map
 * @param viewing_client The client whose view perspective to use for the conversion
 *
 * @return The turf at the calculated map position, or the closest one if out of bounds, as well as the residual x and y map offsets
 *
 * Important Notes:
 * - This WILL be incorrect when client pixel_wxyz is animating, and it WILL be incorrect if the user is gliding, because we don't have a good way to compensate this on the serverside. Yay!!!
 * - Mouse coordinates originate from the top-left corner because we can't have consistency in this engine
 * - Coordinate systems are inconsistent between control pixels and screen pixels
 * - Something on the byond side (icon size likely? needs debugging) affects the control pixels
 * - This uses the ratios between them rather than absolute values for reliable results
 * - For absolute value comparisons, dividing by 2 may work as a temporary hack,
 *   but using ratios (as implemented in the proc) is the recommended approach
 */
/proc/get_loc_from_mousepos(mousepos_x, mousepos_y, sizex, sizey, client/viewing_client)
	if(sizex == 0 || sizey == 0) //contexts where this information is not availible should return 0 in size, aka tgui passthrough
		return list(null, 0, 0)

	var/turf/baseloc = get_turf(viewing_client.eye)
	var/list/actual_view = getviewsize(viewing_client ? viewing_client.view : world.view)

	var/screen_width = actual_view[1] * ICON_SIZE_X
	var/screen_height = actual_view[2] * ICON_SIZE_Y

	//handle letterboxing to get the right sizes and mouseposes
	var/size_ratio = sizex/sizey
	var/screen_ratio = screen_width/screen_height
	if(size_ratio < screen_ratio) //sizex too high, y has black banners
		var/effective_height = sizex / screen_ratio
		var/banner_height = (sizey - effective_height) / 2
		mousepos_y -= banner_height
		sizey -= (banner_height*2)
	else if (size_ratio > screen_ratio) //sizey too high, x has black banners
		var/effective_width = sizey * screen_ratio
		var/banner_width = (sizex - effective_width) / 2
		mousepos_x -= banner_width
		sizex -= (banner_width*2)

	// if its a black banner, just assume we clicked the turf
	mousepos_x = max(mousepos_x, 0)
	mousepos_y = max(mousepos_y, 0)

	//fix ratios being off due to screen width/height
	var/x_ratio = sizex / screen_width
	var/y_ratio = sizey / screen_height
	mousepos_x /= x_ratio
	mousepos_y /= y_ratio

	// PURE SHIT CODE PLS FIX
	// Even though screen is 15x15 it's actually 19x15 god knows why but it's load bearing
	var/shitty_offet_x = ICON_SIZE_X * 2

	//relative to bottom left corner of turf in the middle of the screen
	var/relative_x = (mousepos_x - shitty_offet_x) - (screen_width / 2) + (ICON_SIZE_X/2) + viewing_client.pixel_x + viewing_client.pixel_w
	var/relative_y = -(mousepos_y - (screen_height / 2))+ (ICON_SIZE_Y/2) - 1 + viewing_client.pixel_y + viewing_client.pixel_z
	var/turf_x_diff = FLOOR(relative_x / ICON_SIZE_X, 1)
	var/turf_y_diff = FLOOR(relative_y / ICON_SIZE_Y, 1)

	var/click_turf_x = baseloc.x + turf_x_diff
	var/click_turf_y = baseloc.y + turf_y_diff
	var/click_turf_z = baseloc.z

	var/turf/click_turf = locate(clamp(click_turf_x, 1, world.maxx), clamp(click_turf_y, 1, world.maxy), click_turf_z)

	var/x_residual = relative_x % ICON_SIZE_X
	var/y_residual = relative_y % ICON_SIZE_Y
	return list(click_turf, x_residual, y_residual)
