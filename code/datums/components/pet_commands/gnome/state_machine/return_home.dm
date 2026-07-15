/datum/action_state/return_home
	name = "return_home"
	description = "Returning to home position"
	priority_eval_interval = 2 SECONDS

/datum/action_state/return_home/evaluate_priority(datum/ai_controller/controller)
	var/mob/living/pawn = controller.pawn
	var/turf/home_turf = controller.blackboard[BB_GNOME_HOME_TURF]

	if(!home_turf || !pawn)
		return GNOME_PRIORITY_NONE

	if(get_turf(pawn) == home_turf)
		return GNOME_PRIORITY_NONE // already home

	// Only return home when there is nothing productive to do.
	// Check whether any work state wants to run,if so, stand down.
	for(var/state_name in manager.available_states)
		if(state_name == "idle" || state_name == "return_home")
			continue
		var/datum/action_state/state = manager.available_states[state_name]
		if(state.cached_priority >= GNOME_PRIORITY_NORMAL)
			return GNOME_PRIORITY_NONE

	return GNOME_PRIORITY_LOW

/datum/action_state/return_home/process_state(datum/ai_controller/controller, delta_time)
	var/mob/living/pawn = controller.pawn
	var/turf/home_turf = controller.blackboard[BB_GNOME_HOME_TURF]

	if(!home_turf)
		return ACTION_STATE_FAILED

	if(get_turf(pawn) == home_turf)
		return ACTION_STATE_COMPLETE

	manager.set_movement_target(controller, home_turf)
	return ACTION_STATE_CONTINUE
