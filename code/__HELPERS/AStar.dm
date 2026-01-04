/*
A Star pathfinding algorithm
Returns a list of tiles forming a path from A to B, taking dense objects as well as walls, and the orientation of
windows along the route into account.
Use:
your_list = AStar(start location, end location, moving atom, distance proc, max nodes, maximum node depth, minimum distance to target, adjacent proc, atom id, turfs to exclude, check only simulated)

Optional extras to add on (in order):
Distance proc : the distance used in every A* calculation (length of path and heuristic)
MaxNodes: The maximum number of nodes the returned path can be (0 = infinite)
Maxnodedepth: The maximum number of nodes to search (default: 30, 0 = infinite)
Mintargetdist: Minimum distance to the target before path returns, could be used to get
near a target, but not right to it - for an AI mob with a gun, for example.
Adjacent proc : returns the turfs to consider around the actually processed node
Simulated only : whether to consider unsimulated turfs or not (used by some Adjacent proc)

Also added 'exclude' turf to avoid travelling over; defaults to null

Actual Adjacent procs :

	/turf/proc/reachableAdjacentTurfs : returns reachable turfs in cardinal directions (uses simulated_only)


*/

#define ATURF 1
#define TOTAL_COST_F 2
#define DIST_FROM_START_G 3
#define HEURISTIC_H 4
#define PREV_NODE 5
#define NODE_TURN 6
#define BLOCKED_FROM 7  // Available directions to explore FROM this node

#define ASTAR_NODE(turf, dist_from_start, heuristic, prev_node, node_turn, blocked_from) \
	list(turf, (dist_from_start + heuristic * (1 + PF_TIEBREAKER)), dist_from_start, heuristic, prev_node, node_turn, blocked_from)

#define ASTAR_UPDATE_NODE(node, new_prev, new_g, new_h, new_nt) \
	node[PREV_NODE] = new_prev; \
	node[DIST_FROM_START_G] = new_g; \
	node[HEURISTIC_H] = new_h; \
	node[TOTAL_COST_F] = new_g + new_h * (1 + PF_TIEBREAKER); \
	node[NODE_TURN] = new_nt

#define ASTAR_CLOSE_ENOUGH_TO_END(end, checking_turf, mintargetdist) \
	(checking_turf == end || (mintargetdist && (get_dist_3d(checking_turf, end) <= mintargetdist)))

#define SORT_TOTAL_COST_F(list) (list[TOTAL_COST_F])

#define PF_TIEBREAKER 0.005
#define MASK_ODD 85
#define MASK_EVEN 170

/proc/PathWeightCompare(list/a, list/b)
	return a[TOTAL_COST_F] - b[TOTAL_COST_F]

/proc/HeapPathWeightCompare(list/a, list/b)
	return b[TOTAL_COST_F] - a[TOTAL_COST_F]

/proc/get_path_to(requester, end, dist, maxnodes, maxnodedepth = 30, mintargetdist, adjacent = /turf/proc/reachableTurftest, id = null, turf/exclude = null, simulated_only = TRUE, check_z_levels = TRUE)
	var/l = SSpathfinder.mobs.getfree(requester)
	while (!l)
		stoplag(3)
		l = SSpathfinder.mobs.getfree(requester)
	var/list/path = AStar(requester, end, dist, maxnodes, maxnodedepth, mintargetdist, adjacent, id, exclude, simulated_only, check_z_levels)
	SSpathfinder.mobs.found(l)
	if (!path)
		path = list()
	return path

/proc/AStar(requester, _end, dist, maxnodes, maxnodedepth = 30, mintargetdist, adjacent = /turf/proc/reachableTurftest, id = null, turf/exclude = null, simulated_only = TRUE, check_z_levels = TRUE)
	var/turf/end = get_turf(_end)
	var/turf/start = get_turf(requester)
	if (!start || !end)
		stack_trace("Invalid A* start or destination")
		return FALSE
	if (start == end)
		return FALSE
	if (maxnodes && start.Distance3D(end) > maxnodes)
		return FALSE
	if(maxnodes)
		maxnodedepth = maxnodes

	var/list/open = list()  // Binary sorted list of nodes (lowest weight at end for easy Pop)
	var/list/openc = new()  // turf -> node mapping for nodes in open list
	var/list/closed = new()  // turf -> bitmask of blocked directions
	var/list/path = null
	var/const/ALL_DIRS = NORTH|SOUTH|EAST|WEST

	// Create initial node
	var/list/cur = ASTAR_NODE(start, 0, start.Distance3D(end), null, 0, ALL_DIRS)
	var/list/insert_item = list(cur)
	BINARY_INSERT_DEFINE_REVERSE(insert_item, open, SORT_VAR_NO_TYPE, cur, SORT_TOTAL_COST_F, COMPARE_KEY)
	openc[start] = cur

	while (requester && open.len && !path)
		// Pop from end (highest priority in reverse sorted list)
		cur = open[open.len]
		open.len--

		var/turf/cur_turf = cur[ATURF]
		openc -= cur_turf
		closed[cur_turf] = ALL_DIRS

		// Destination check - must be exact match or valid closeenough on same Z-level
		var/is_destination = (cur_turf == end)
		// Only consider "close enough" if on the same Z-level
		var/closeenough = FALSE
		if (!check_z_levels || cur_turf.z == end.z)
			if (mintargetdist)
				closeenough = cur_turf.Distance3D(end) <= mintargetdist
			else
				closeenough = cur_turf.Distance3D(end) < 1

		if (is_destination || closeenough)
			path = list(cur_turf)
			var/list/prev = cur[PREV_NODE]
			while (prev)
				path.Add(prev[ATURF])
				prev = prev[PREV_NODE]
			break

		if(maxnodedepth && (cur[NODE_TURN] > maxnodedepth))
			CHECK_TICK
			continue

		for(var/dir_to_check in GLOB.cardinals)
			if(!(cur[BLOCKED_FROM] & dir_to_check))
				continue

			var/turf/T = get_step(cur_turf, dir_to_check)

			var/obj/structure/stairs/source_stairs = locate(/obj/structure/stairs) in cur_turf
			if(source_stairs)
				T = source_stairs.get_transit_destination(dir_to_check)

			if(!T || T == exclude)
				continue

			var/reverse = REVERSE_DIR(dir_to_check)
			if(closed[T] & reverse)
				continue

			if(!call(cur_turf, adjacent)(requester, T, id))
				closed[T] |= reverse
				continue

			var/list/CN = openc[T]
			var/newg = cur[DIST_FROM_START_G] + call(cur_turf, dist)(T, requester)

			if(CN)
				// Already in open list, check if this is a better path
				if(newg < CN[DIST_FROM_START_G])
					// Remove old instance
					var/list/old_item = list(CN)
					open -= old_item

					// Update node
					ASTAR_UPDATE_NODE(CN, cur, newg, CN[HEURISTIC_H], cur[NODE_TURN] + 1)

					// Re-insert with new priority
					var/list/new_item = list(CN)
					BINARY_INSERT_DEFINE_REVERSE(new_item, open, SORT_VAR_NO_TYPE, CN, SORT_TOTAL_COST_F, COMPARE_KEY)
			else
				// Not in open list, create new node
				CN = ASTAR_NODE(T, newg, call(T, dist)(end, requester), cur, cur[NODE_TURN] + 1, ALL_DIRS^reverse)
				var/list/new_item = list(CN)
				BINARY_INSERT_DEFINE_REVERSE(new_item, open, SORT_VAR_NO_TYPE, CN, SORT_TOTAL_COST_F, COMPARE_KEY)
				openc[T] = CN

		CHECK_TICK

	if (path)
		for (var/i = 1 to round(0.5 * path.len))
			path.Swap(i, path.len - i + 1)

	openc = null
	closed = null
	return path

/turf/proc/reachableTurftest(requester, turf/T, ID, simulated_only = TRUE, check_z_levels = TRUE)
	if(!T || T.density)
		return FALSE
	if(!T.can_traverse_safely(requester))  // dangerous turf! lava or openspace (or others in the future)
		return FALSE

	var/z_distance = abs(T.z - z)
	if(!z_distance)  // standard check for same-z pathing
		return !LinkBlockedWithAccess(T, requester, ID)

	if(z_distance != 1)  // no single movement lets you move more than one z-level at a time (currently; update if this changes)
		return FALSE

	var/obj/structure/stairs/source_stairs = locate(/obj/structure/stairs) in src
	if(T.z < z)  // going down
		if(source_stairs?.get_target_loc(REVERSE_DIR(source_stairs.dir)) == T)
			return TRUE
	else  // heading DOWN stairs was handled earlier, so now handle going UP stairs
		if(source_stairs?.get_target_loc(source_stairs.dir) == T)
			return TRUE

	return FALSE

/proc/get_dist_3d(atom/source, atom/target)
	var/turf/source_turf = get_turf(source)
	return source_turf.Distance3D(get_turf(target))

// Add a helper function to compute 3D Manhattan distance
/turf/proc/Distance3D(turf/T)
	if (!T || !istype(T))
		return 0
	var/dx = abs(x - T.x)
	var/dy = abs(y - T.y)
	var/dz = abs(z - T.z) * 5  // Weight z-level differences higher
	return (dx + dy + dz)

/turf/proc/LinkBlockedWithAccess(turf/T, requester, ID)
	var/adir = get_dir(src, T)
	var/rdir = ((adir & MASK_ODD)<<1)|((adir & MASK_EVEN)>>1)
	for(var/obj/O in T)
		if(!O.CanAStarPass(ID, rdir, requester))
			return TRUE
	for(var/obj/O in src)
		if(!O.CanAStarPass(ID, adir, requester))
			return TRUE
	for(var/mob/living/M in T)
		if(!M.CanPass(requester, src))
			return TRUE
	for(var/obj/structure/M in T)
		if(!M.CanPass(requester, src))
			return TRUE
	return FALSE

#undef ATURF
#undef TOTAL_COST_F
#undef DIST_FROM_START_G
#undef HEURISTIC_H
#undef PREV_NODE
#undef NODE_TURN
#undef BLOCKED_FROM
#undef ASTAR_NODE
#undef ASTAR_UPDATE_NODE
#undef ASTAR_CLOSE_ENOUGH_TO_END
