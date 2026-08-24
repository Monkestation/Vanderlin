/datum/ai_movement/basic_avoidance/adaptive

/datum/ai_movement/basic_avoidance/adaptive/post_move(datum/move_loop/source, succeeded)
	. = ..()
	if (succeeded != MOVELOOP_FAILURE)
		return
	var/datum/ai_controller/controller = source.extra_info
	stop_moving_towards(controller)
	controller.change_ai_movement_type(/datum/ai_movement/astar/adaptive) // we failed? it's JPS time

/datum/ai_movement/astar/adaptive

/datum/ai_movement/astar/adaptive/post_move(datum/move_loop/source, succeeded)
	. = ..()
	var/datum/move_loop/has_target/astar/loop = source
	if(length(loop.movement_path))
		return

	var/datum/ai_controller/controller = source.extra_info
	if(QDELETED(controller) || QDELETED(controller.pawn))
		return

	var/turf/current = get_turf(controller.pawn)
	var/turf/target = get_turf(loop.target)
	if(current == target || get_dist(current, target) <= loop.minimum_distance)
		stop_moving_towards(controller)
		controller.change_ai_movement_type(/datum/ai_movement/basic_avoidance/adaptive) // we succeeded? it's basic time
