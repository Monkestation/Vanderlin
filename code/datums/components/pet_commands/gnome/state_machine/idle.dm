/datum/action_state/idle
	name = "idle"
	description = "Waiting for work or returning home"
	priority_eval_interval = 2 SECONDS

/datum/action_state/idle/evaluate_priority(datum/ai_controller/controller)
	// Idle is always available as the bottom-priority fallback.
	return GNOME_PRIORITY_LOW

/datum/action_state/idle/process_state(datum/ai_controller/controller, delta_time)
	var/mob/living/pawn = controller.pawn
	var/turf/home_turf = controller.blackboard[BB_GNOME_HOME_TURF]

	// Delegate pet commands
	var/datum/pet_command/active_command = controller.blackboard[BB_ACTIVE_PET_COMMAND]
	if(active_command)
		active_command.execute_action(controller)
		return ACTION_STATE_CONTINUE

	// Return home if we've drifted, queue return_home via a direct
	// priority boost rather than hard-coding a state name.
	if(home_turf && get_turf(pawn) != home_turf)
		var/datum/action_state/rh = manager.available_states["return_home"]
		if(rh)
			rh.invalidate_priority()
		return ACTION_STATE_COMPLETE // let manager re-select; return_home will win

	return ACTION_STATE_CONTINUE
