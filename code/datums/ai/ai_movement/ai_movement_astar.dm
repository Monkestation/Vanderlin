/**
 * This movement datum represents smart-pathing
 */
/datum/ai_movement/astar
	max_pathing_attempts = 4

/datum/ai_movement/astar/start_moving_towards(datum/ai_controller/controller, atom/current_movement_target, min_distance)
	. = ..()
	var/atom/movable/moving = controller.pawn
	var/delay = controller.movement_delay

	var/datum/move_loop/loop = GLOB.move_manager.astar_move(
		moving,
		current_movement_target,
		delay,
		repath_delay = 0.5 SECONDS,
		max_path_length = AI_MAX_PATH_LENGTH,
		minimum_distance = controller.get_minimum_distance(),
		access = controller.get_access(),
		subsystem = SSai_movement,
		extra_info = controller,
		initial_path = controller.blackboard[BB_PATH_TO_USE],
	)
	controller.clear_blackboard_key(BB_PATH_TO_USE)

	RegisterSignal(loop, COMSIG_MOVELOOP_PREPROCESS_CHECK, PROC_REF(pre_move))
	RegisterSignal(loop, COMSIG_MOVELOOP_POSTPROCESS, PROC_REF(post_move))
	RegisterSignal(loop, COMSIG_MOVELOOP_REPATH, PROC_REF(repath_incoming))

/datum/ai_movement/astar/proc/pre_move(datum/move_loop/has_target/astar/source)
	SIGNAL_HANDLER

	var/datum/ai_controller/controller = source.extra_info
	source.delay = controller.movement_delay

	// Check if this controller can actually run, so we don't chase people with corpses
	if(!controller.able_to_run())
		controller.CancelActions()
		qdel(source) //stop moving
		return MOVELOOP_SKIP_STEP

	if(controller.can_move())
		return NONE

	increment_pathing_failures(controller)

	return MOVELOOP_SKIP_STEP

/datum/ai_movement/astar/proc/post_move(datum/move_loop/has_target/astar/source, succeeded)
	SIGNAL_HANDLER

	var/datum/ai_controller/controller = source.extra_info
	if(!succeeded)
		increment_pathing_failures(controller)
		return

	// Anticipated paths for smoother but more expensive pathing
	if(source.is_pathing || !COOLDOWN_FINISHED(source, repath_anticipated_cooldown))
		return

	// We only do this if we are about to be near the end of the path
	var/remaining_path = length(source.movement_path)
	if(remaining_path > 5)
		return

	var/turf/end = get_turf(controller.current_movement_target)
	var/turf/checking = get_turf(controller.pawn)
	var/mintargetdist = controller.get_minimum_distance()

	var/dist_to_end = get_dist(end, checking)

	// Same as ASTAR_CLOSE_ENOUGH_TO_END
	if(end == checking || (mintargetdist && (dist_to_end <= mintargetdist)))
		return

	// Severely limit max length since the target is close and we don't want to take a long time
	var/max_steps = min(dist_to_end, 8)

	COOLDOWN_START(source, repath_anticipated_cooldown, 2 SECONDS)

	var/list/path = SSpathfinder.astar_pathfind_now( \
		controller.pawn, \
		controller.current_movement_target, \
		max_steps, \
		mintargetdist, \
		controller.get_access(), \
		source.avoid, \
		source.skip_first, \
		source.use_diagonals, \
		source.heuristic)

	if(!length(path))
		return

	source.access = controller.get_access()
	source.minimum_distance = controller.get_minimum_distance()
	source.movement_path = path

/datum/ai_movement/astar/proc/repath_incoming(datum/move_loop/has_target/astar/source)
	SIGNAL_HANDLER

	var/datum/ai_controller/controller = source.extra_info

	source.access = controller.get_access()
	source.minimum_distance = controller.get_minimum_distance()
