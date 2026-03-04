/// A version of Astar that can handle multi Z
/datum/pathfind/astar/multi

/datum/pathfind/astar/multi/start()
	start ||= get_turf(invoker)

	if(!start)
		stack_trace("Invalid A* start")
		return

	if(!get_turf(end))
		stack_trace("Invalid A* destination")
		return FALSE

	// If the turf is out of the step range we already know it's too far.
	if(max_steps && (max_steps < get_dist_manhattan(start, end)))
		return FALSE

	var/datum/astar_node/start_node = new /datum/astar_node
	start_node.turf = start
	start_node.f_value = 0
	start_node.distance_from_start = 0
	start_node.node_heuristic = 0
	start_node.real_distance_from_start = 0

	open_turf_to_node[start] = start_node
	binary_insert_node(start_node)

	return TRUE

// This copies most of Astar but this is so we don't slow down Astar with multiZ checks we aren't using
/datum/pathfind/astar/multi/search_step(tick_check = TRUE)
	if(QDELETED(invoker))
		return FALSE

	var/static/list/lateral_search_dirs = list(EAST, WEST, NORTH, SOUTH)
	var/static/list/all_search_dirs = list(EAST, WEST, NORTH, SOUTH, NORTHEAST, SOUTHWEST, NORTHWEST, SOUTHEAST)

	while(length(open_binary_tree) && !path)
		var/datum/astar_node/current_node = open_binary_tree[length(open_binary_tree)]
		open_binary_tree.len--

		var/turf/current_node_turf = current_node.turf
		closed[current_node_turf] = ALL

		if(max_steps && current_node.real_distance_from_start > max_steps)
			continue

		// Check to see if we're close enough to the end destination.
		if(current_node_turf.z == end.z && ASTAR_CLOSE_ENOUGH_TO_END(end, current_node_turf))
			unwind_path(current_node)
			return TRUE

		// Scan cardinal turfs for valid movements.
		for(var/scan_direction in use_diagonals ? all_search_dirs : lateral_search_dirs)
			var/turf/searching_turf = get_step(current_node_turf, scan_direction)
			var/is_diagonal = ISDIAGONALDIR(scan_direction)
			if(closed[searching_turf] & scan_direction)
				continue // Turf is known to be blocked from this direction, skip!

			// This is our main change
			if(!is_diagonal)
				if(current_node_turf.z != end.z)
					var/turf/new_search = get_multi_z_turf(current_node_turf, searching_turf)
					if(new_search)
						searching_turf = new_search
				if(!can_z_step(current_node_turf, searching_turf, pass_info, avoid))
					closed[searching_turf] |= scan_direction
					continue
			else if(!can_step_diagonal(current_node_turf, searching_turf))
				closed[searching_turf] |= scan_direction
				continue // Turf cannot be entered, atleast from this direction. Skip!

			// At this point we consider this turf a valid node.

			var/datum/astar_node/existing_node = open_turf_to_node[searching_turf]

			// Prefer straighter lines for more visual appeal. Penalize changing from cardinal to diagonal, but if you're already diagonal, it's okay.
			var/distance_g = current_node.distance_from_start
			var/real_distance = current_node.real_distance_from_start
			if(is_diagonal)
				// Diagonal is not continuing from previous node
				if(!current_node.previous_node || !ISDIAGONALDIR(get_dir(current_node.previous_node.turf, current_node_turf)))
					distance_g += 2
					real_distance += 2

				// Diagonal is continuing from previous node
				else
					distance_g += sqrt(2) // It const folds dont cry
					real_distance += 2
			else
				distance_g += 1
				real_distance += 1

			// If the node already exists, update it to reflect new information. Maybe we found a shorter path to it, or similar.
			if(existing_node)
				if(distance_g < existing_node.distance_from_start)
					existing_node.previous_node = current_node
					existing_node.distance_from_start = distance_g
					existing_node.real_distance_from_start = real_distance
					existing_node.f_value = distance_g + existing_node.node_heuristic
					open_binary_tree -= existing_node
					binary_insert_node(existing_node)
				continue

			// The node isn't known to us so we need to check the heuristic.
			var/node_heuristic = heuristic_function.Invoke(searching_turf, end)
			if(node_heuristic == 0)
				closed[searching_turf] |= scan_direction
				continue

			// Node is not known, create it.
			var/datum/astar_node/new_node = new /datum/astar_node
			new_node.turf = searching_turf
			new_node.f_value = distance_g + node_heuristic
			new_node.distance_from_start = distance_g
			new_node.real_distance_from_start = real_distance
			new_node.node_heuristic = node_heuristic
			new_node.previous_node = current_node

			binary_insert_node(new_node)

			open_turf_to_node[searching_turf] = new_node
#ifdef DEBUG_PATHFINDING
			all_nodes_ever[++all_nodes_ever.len] = new_node
#endif

			// Check to see if we're close enough to the end destination.
			if(new_node.turf.z == end.z && ASTAR_CLOSE_ENOUGH_TO_END(end, new_node.turf))
				unwind_path(new_node)
				return TRUE

		// Stable, we'll just be back later
		if(tick_check && TICK_CHECK)
			return TRUE

	return TRUE

/datum/pathfind/astar/multi/can_step_diagonal(turf/from_turf, turf/to_turf)
	var/in_dir = get_dir(from_turf, to_turf) // eg. northwest (1+8) = 9 (00001001)
	var/first_step_direction_a = in_dir & 3 // eg. north   (1+8)&3 (0000 0011) = 1 (0000 0001)
	var/first_step_direction_b = in_dir & 12 // eg. west   (1+8)&12 (0000 1100) = 8 (0000 1000)

	for(var/direction in list(first_step_direction_a, first_step_direction_b))
		var/turf/midpoint = get_step(from_turf, direction)
		// If the midpoint is known to be inaccessible from the starting direction, no need to check it again.
		if(closed[midpoint] & direction)
			continue

		if(can_z_step(midpoint, to_turf, pass_info, avoid))
			return TRUE

	return FALSE

// We lose time here unfortunately because we need to call this as a wrapper for regular CAN_STEP even for same Z moves
/// Check if we can step up from here with just normal movement.
/// Returns a turf above if its a successful Z move to replace the current node
/datum/pathfind/astar/multi/proc/can_z_step(turf/from_turf, turf/to_turf, datum/can_pass_info/pass_info, turf/avoid)
	return CAN_STEP(from_turf, to_turf, pass_info, avoid)

/datum/pathfind/astar/multi/proc/get_multi_z_turf(turf/from_turf, turf/to_turf)
	. = to_turf

	var/is_above = 1 //(from_turf.z < to_turf.z)

	var/obj/structure/stairs/our_stairs = locate() in from_turf
	if(!our_stairs)
		return

	var/turf/above_from = GET_TURF_ABOVE(from_turf)
	if(!isopenspace(above_from))
		return

	var/turf/above_to = GET_TURF_ABOVE(to_turf)
	if(!above_to)
		return

	var/obj/structure/stairs/their_stairs = locate() in above_to
	if(!their_stairs || (our_stairs.dir != their_stairs.dir))
		return

	var/turf_dir = get_dir(from_turf, to_turf)
	if(is_above ? turf_dir != our_stairs.dir : REVERSE_DIR(turf_dir) != our_stairs.dir)
		return

	return above_to
