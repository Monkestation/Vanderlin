
/// Queues and manages pathfinding steps
SUBSYSTEM_DEF(pathfinder)
	name = "Pathfinder"
	init_order = INIT_ORDER_PATH
	priority = FIRE_PRIORITY_PATHFINDING
	/// List of pathfind datums we are currently trying to process
	var/list/datum/pathfind/active_pathing = list()
	/// List of pathfind datums being ACTIVELY processed. exists to make subsystem stats readable
	var/list/datum/pathfind/currentrun = list()

/datum/controller/subsystem/pathfinder/stat_entry(msg)
	msg = "P:[length(active_pathing)]"
	return ..()

// This is another one of those subsystems (hey lighting) in which one "Run" means fully processing a queue
// We'll use a copy for this just to be nice to people reading the mc panel
/datum/controller/subsystem/pathfinder/fire(resumed)
	if(!resumed)
		src.currentrun = active_pathing.Copy()

	// Dies of sonic speed from caching datum var reads
	var/list/currentrun = src.currentrun
	while(length(currentrun))
		var/datum/pathfind/path = currentrun[length(currentrun)]
		if(!path.search_step()) // Something's wrong
			path.early_exit()
			currentrun.len--
			continue
		if(MC_TICK_CHECK)
			return
		path.finished()
		// Next please
		currentrun.len--

/datum/controller/subsystem/pathfinder/proc/astar_pathfind(
	atom/movable/invoker,
	atom/end,
	max_steps = 30,
	mintargetdist,
	list/access,
	turf/exclude,
	skip_first = TRUE,
	use_diagonals = TRUE,
	list/on_finish,
	datum/callback/heuristic,
)

	var/datum/pathfind/astar/path = new(
		invoker,
		end,
		access,
		max_steps,
		mintargetdist,
		exclude,
		skip_first,
		use_diagonals,
		on_finish,
		heuristic,
	)

	if(path.start())
		active_pathing += path
		return TRUE

	return FALSE

/datum/controller/subsystem/pathfinder/proc/astar_pathfind_now(
	atom/movable/invoker,
	atom/end,
	max_steps = 14,
	mintargetdist,
	list/access,
	turf/exclude,
	skip_first = TRUE,
	use_diagonals = TRUE,
	datum/callback/heuristic,
)

	var/datum/pathfind/astar/path = new(
		invoker,
		end,
		access,
		max_steps,
		mintargetdist,
		exclude,
		skip_first,
		use_diagonals,
		null,
		heuristic,
	)

	if(!path.start())
		return FALSE

	if(!path.search_step(FALSE))
		path.early_exit()
		return FALSE

	path.finished()

	return path.path
