/// Check if we are close enough to be considered done
#define ASTAR_CLOSE_ENOUGH_TO_END(end, checking_turf) (end == checking_turf || (mintargetdist && (get_dist(checking_turf, end) <= mintargetdist)))

/// A datum to hold astar node information
/datum/astar_node
	/// The turf associated with this node
	var/turf/turf = null
	/// The node we just came from
	var/datum/astar_node/previous_node = null
	/// The A* node weight (f_value = distance_from_start + heuristic)
	var/f_value = 0
	/// The A* node heuristic (a rough estimate of how far we are from the goal)
	var/node_heuristic = 0
	/// Biased distance from the start
	var/distance_from_start = 0
	/// Distance is affected by bias to smooth out diagonals, this tracks the raw number of steps required.
	var/real_distance_from_start = 0

/datum/astar_node/Destroy(force, ...)
	previous_node = null
	return ..()


/datum/pathfind/astar
	/// The thing that we're actually trying to path for
	var/atom/movable/invoker
	/// The turf we're trying to path to (note that this won't track a moving target)
	var/turf/end
	/// The list we compile at the end if successful to pass back
	var/list/path

	/// A k:v list of turf -> directions. The directions are directions the pathfinder attempted to step into the turf but failed.
	var/list/closed
	/// A binary search tree containing the discovered nodes.
	var/list/open_binary_tree
	/// A k:V list of turf -> astar node
	var/list/open_turf_to_node

	/// How far away we have to get to the end target before we can call it quits
	var/mintargetdist = 0
	/// If we should delete the first step in the path or not. Used often because it is just the starting tile
	var/skip_first = FALSE
	/// Defines how we handle diagonal moves. See __DEFINES/path.dm
	var/use_diagonals = TRUE
	/// An optional callback to invoke to return a positive value to add to the path's distance.
	var/datum/callback/heuristic_function

#ifdef DEBUG_PATHFINDING
	/// List of all nodes we've parsed, used for debug spew.
	var/list/all_nodes_ever = list()
#endif

/datum/pathfind/astar/New(
	atom/movable/invoker,
	atom/goal,
	access,
	max_steps,
	mintargetdist,
	avoid,
	skip_first,
	use_diagonals,
	list/on_finish,
	datum/callback/heuristic_function,
)
	src.invoker = invoker
	src.pass_info = new(invoker, access)

	end = get_turf(goal)
	open_binary_tree = new()
	open_turf_to_node = new()
	closed = new()

	src.max_steps = max_steps
	src.mintargetdist = mintargetdist
	src.avoid = avoid
	src.skip_first = skip_first
	src.use_diagonals = use_diagonals
	src.on_finish = on_finish
	src.heuristic_function = heuristic_function || CALLBACK(src, PROC_REF(generic_heuristic))

/datum/pathfind/astar/Destroy(force, ...)
	invoker = null
	end = null
	open_binary_tree = null
	open_turf_to_node = null
	closed = null
	return ..()

/**
 * "starts" off the pathfinding, by storing the values this datum will need to work later on
 *  returns FALSE if it fails to setup properly, TRUE otherwise
 */
/datum/pathfind/astar/start()
	start ||= get_turf(invoker)
	. = ..()
	if(!.)
		return

	if(!get_turf(end))
		stack_trace("Invalid A* destination")
		return FALSE

	if(start.z != end.z || start == end ) //no pathfinding between z levels
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

/**
 * Cleanup pass for the pathfinder. This tidies up the path, and fufills the pathfind's obligations
 */
/datum/pathfind/astar/finished()
	var/list/path = src.path || list()
	if(length(path) > 0 && skip_first)
		path.Cut(1,2)

	hand_back(path)
#ifdef DEBUG_PATHFINDING
	/// If the global flag is set, replace the current global node spew.
	if(GLOB.__pathfinding_debug_generate)
		GLOB.__pathfinding_debug_info = all_nodes_ever
#endif
	return ..()

/**
 * search_step() is the workhorse of pathfinding. It'll do the searching logic, and will slowly build up a path
 * returns TRUE if everything is stable, FALSE if the pathfinding logic has failed, and we need to abort
 */
/datum/pathfind/astar/search_step(tick_check = TRUE)
	. = ..()
	if(!.)
		return

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
		if(ASTAR_CLOSE_ENOUGH_TO_END(end, current_node_turf))
			unwind_path(current_node)
			return TRUE

		// Scan cardinal turfs for valid movements.
		for(var/scan_direction in use_diagonals ? all_search_dirs : lateral_search_dirs)
			var/turf/searching_turf = get_step(current_node_turf, scan_direction)
			var/is_diagonal = ISDIAGONALDIR(scan_direction)
			if(closed[searching_turf] & scan_direction)
				continue // Turf is known to be blocked from this direction, skip!

			if(!(is_diagonal ? can_step_diagonal(current_node_turf, searching_turf) : CAN_STEP(current_node_turf, searching_turf, pass_info, avoid)))
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
			if(ASTAR_CLOSE_ENOUGH_TO_END(end, new_node))
				unwind_path(new_node)
				return TRUE

		// Stable, we'll just be back later
		if(tick_check && TICK_CHECK)
			return TRUE

	return TRUE

/datum/pathfind/astar/proc/binary_insert_node(datum/astar_node/node)
	BINARY_INSERT_REVERSE(node, open_binary_tree, /datum/astar_node, node, f_value, COMPARE_KEY)

/datum/pathfind/astar/proc/can_step_diagonal(turf/from_turf, turf/to_turf)
	var/in_dir = get_dir(from_turf, to_turf) // eg. northwest (1+8) = 9 (00001001)
	var/first_step_direction_a = in_dir & 3 // eg. north   (1+8)&3 (0000 0011) = 1 (0000 0001)
	var/first_step_direction_b = in_dir & 12 // eg. west   (1+8)&12 (0000 1100) = 8 (0000 1000)

	for(var/direction in list(first_step_direction_a, first_step_direction_b))
		var/turf/midpoint = get_step(from_turf, direction)
		// If the midpoint is known to be inaccessible from the starting direction, no need to check it again.
		if(closed[midpoint] & direction)
			continue

		if(CAN_STEP(midpoint, to_turf, pass_info, avoid))
			return TRUE

	return FALSE


/// The generic heuristic
/datum/pathfind/astar/proc/generic_heuristic(turf/searching_turf, turf/end)
	return get_dist_euclidean(searching_turf, end)

/// Called when we've hit the goal with the node that represents the last tile, then sets the path var to that path so it can be returned by [datum/pathfind/proc/search]
/datum/pathfind/astar/proc/unwind_path(datum/astar_node/unwind_node)
	path = new()
	var/turf/iter_turf = unwind_node.turf
	path += iter_turf

	var/datum/astar_node/iter_node = unwind_node.previous_node
	while(iter_node)
		path.Insert(1, iter_node.turf)
		iter_node = iter_node.previous_node

	return path
