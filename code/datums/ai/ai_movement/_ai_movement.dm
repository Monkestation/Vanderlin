///This datum is an abstract class that can be overriden for different types of movement
/datum/ai_movement
	///Assoc list ist of controllers that are currently moving as key, and what they are moving to as value
	var/list/moving_controllers = list()
	///Does this ai require processing?
	var/requires_processing = TRUE
	///how many attempts do we make at pathing
	var/max_pathing_attempts
	///how long path limit movements bother checking
	var/max_path_distance = 30

//Override this to setup the moveloop you want to use
/datum/ai_movement/proc/start_moving_towards(datum/ai_controller/controller, atom/current_movement_target, min_distance)
	SHOULD_CALL_PARENT(TRUE)

	controller.pathing_attempts = 0
	controller.set_blackboard_key(BB_CURRENT_MIN_MOVE_DISTANCE, min_distance)
	moving_controllers[controller] = current_movement_target

/datum/ai_movement/proc/stop_moving_towards(datum/ai_controller/controller)
	controller.pathing_attempts = 0
	moving_controllers -= controller
	GLOB.move_manager.stop_looping(controller.pawn, SSai_movement)

/datum/ai_movement/proc/increment_pathing_failures(datum/ai_controller/controller)
	controller.pathing_attempts++
	if(controller.pathing_attempts >= max_pathing_attempts)
		controller.CancelActions()
