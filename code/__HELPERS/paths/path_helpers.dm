/**
 * This proc uses A* to find the most optimal path between two turfs. It allows using a custom heuristic callback to change the
 * weights of nodes. A* will always return the most optimal path.
 *
 * Arguments:
 * * invoker: The movable atom that's trying to find the path
 * * end: What we're trying to path to. It doesn't matter if this is a turf or some other atom, we're gonna just path to the turf it's on anyway
 * * max_steps: The maximum number of steps we can take in a given path to search (default: 30, 0 = infinite)
 * * mintargetdistance: Minimum distance to the target before path returns, could be used to get near a target, but not right to it - for an AI mob with a gun, for example.
 * * access: A list representing what access we have and what doors we can open.
 * * simulated_only: Whether we consider turfs without atmos simulation (AKA do we want to ignore space)
 * * exclude: If we want to avoid a specific turf, like if we're a mulebot who already got blocked by some turf
 * * skip_first: Whether or not to delete the first item in the path. This would be done because the first item is the starting tile, which can break movement for some creatures.
 * * use_diagonals: If you want the path to include diagonal steps. Set to FALSE for cardinal moves only.
 * * heuristic: A proc to call to determine how nodes are weighted. The higher the returned value, the less likely the pathfinder wants to traverse. 0 means invalid turf.
 */
/proc/astar_path_to(
	atom/movable/invoker,
	atom/end,
	max_steps = 30,
	mintargetdist,
	list/access,
	turf/exclude,
	skip_first = TRUE,
	use_diagonals = TRUE,
	datum/callback/heuristic,
)
	var/datum/pathfind_packet/packet = new
	// We're guarenteed that list will be the first list in pathfinding_finished's argset because of how callback handles the arguments list
	var/datum/callback/await = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(pathfinding_finished), packet)
	if(!SSpathfinder.astar_pathfind(invoker, end, max_steps, mintargetdist, access, exclude, skip_first, use_diagonals, list(await), heuristic))
		return null

	UNTIL(packet.path)

	return packet.path

/// Wrapper around the path list since we play with refs.
/datum/pathfind_packet
	/// The unwound path, set when it's finished.
	var/list/path

/// Uses funny pass by reference bullshit to take the path created by pathfinding, and insert it into a return list
/// We'll be able to use this return list to tell a sleeping proc to continue execution
/proc/pathfinding_finished(datum/pathfind_packet/packet, list/path)
	// We use += here to ensure the list is still pointing at the same thing
	packet.path = path
