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
			var/is_diagonal = ISDIAGONALDIR(scan_direction)
			var/turf/searching_turf = is_diagonal ? get_step(current_node_turf, scan_direction) : null

			// For cardinal moves check if there is stairs to move onto first
			if(!is_diagonal)
				var/obj/structure/stairs/z_mover = locate() in current_node_turf
				if(!z_mover)
					searching_turf = get_step(current_node_turf, scan_direction)
				else
					// Technically we could go further and account for legendary skills/flying/etc to just jump straight off open space,
					// we aren't going to (yet)
					searching_turf = z_mover.get_transit_destination(scan_direction)

			if(closed[searching_turf] & scan_direction)
				continue // Turf is known to be blocked from this direction, skip!

			if(!(is_diagonal ? can_step_diagonal(current_node_turf, searching_turf) : CAN_STEP(current_node_turf, searching_turf, pass_info, avoid)))
				closed[searching_turf] |= scan_direction
				continue // Turf cannot be entered, atleast from this direction. Skip!

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
