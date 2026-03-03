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

	RegisterSignal(loop, COMSIG_MOVELOOP_PREPROCESS_CHECK, PROC_REF(pre_move))
	RegisterSignal(loop, COMSIG_MOVELOOP_POSTPROCESS, PROC_REF(post_move))
	RegisterSignal(loop, COMSIG_MOVELOOP_REPATH, PROC_REF(repath_incoming))

/datum/ai_movement/astar/proc/pre_move(datum/move_loop/source)
	SIGNAL_HANDLER

	var/datum/ai_controller/controller = source.extra_info
	source.delay = controller.movement_delay

	// Check if this controller can actually run, so we don't chase people with corpses
	if(!controller.able_to_run())
		controller.CancelActions()
		qdel(source) //stop moving
		return MOVELOOP_SKIP_STEP

	if(controller.can_move())
		return

	increment_pathing_failures(controller)

	return MOVELOOP_SKIP_STEP

/datum/ai_movement/astar/proc/post_move(datum/move_loop/source, succeeded)
	SIGNAL_HANDLER

	if(succeeded)
		return

	var/datum/ai_controller/controller = source.extra_info
	increment_pathing_failures(controller)

/datum/ai_movement/astar/proc/repath_incoming(datum/move_loop/has_target/astar/source)
	SIGNAL_HANDLER

	var/datum/ai_controller/controller = source.extra_info

	source.access = controller.get_access()
	source.minimum_distance = controller.get_minimum_distance()
