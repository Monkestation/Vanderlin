/datum/action_state_manager
	var/datum/action_state/current_state
	var/list/available_states = list(
		/datum/action_state/idle,
		/datum/action_state/return_home,
		/datum/action_state/transport,
		/datum/action_state/farming,
		/datum/action_state/alchemy,
		/datum/action_state/splitter,
	)
	var/atom/last_movement_target = null

/datum/action_state_manager/New()
	init_states()

/datum/action_state_manager/proc/register_signals(datum/ai_controller/controller)
	RegisterSignal(controller, COMSIG_AI_PATHING_FAILED, PROC_REF(on_pathing_failed))

/datum/action_state_manager/proc/on_pathing_failed(datum/ai_controller/controller)
	SIGNAL_HANDLER
	clear_movement_target(controller)
	current_state.invalidate_priority()
	change_state(controller, available_states["idle"])

/datum/action_state_manager/proc/init_states()
	var/list/created = list()
	for(var/datum/action_state/T as anything in available_states)
		created[initial(T.name)] = new T(src)
	available_states = created
	current_state = available_states["idle"]

/**
 * Finds the highest-priority state.  Ties are broken by list order (first wins).
 * Returns the state datum, or null if only GNOME_PRIORITY_NONE states exist.
 */
/datum/action_state_manager/proc/select_best_state(datum/ai_controller/controller)
	var/datum/action_state/best = null
	var/best_priority = GNOME_PRIORITY_NONE

	for(var/state_name in available_states)
		var/datum/action_state/state = available_states[state_name]
		var/priority = state.get_priority(controller)
		if(priority > best_priority)
			best_priority = priority
			best = state

	return best


/datum/action_state_manager/proc/process_machine(datum/ai_controller/controller, delta_time)
	var/mob/living/pawn = controller.pawn

	// Movement handling, same as original
	if(last_movement_target)
		if(get_dist(pawn, last_movement_target) > 1)
			if(controller.ai_movement.moving_controllers[controller] != last_movement_target)
				controller.ai_movement.start_moving_towards(controller, last_movement_target)
			return TRUE
		else
			clear_movement_target(controller)

	// Priority-based state selection
	var/datum/action_state/best = select_best_state(controller)
	if(best && best != current_state)
		change_state(controller, best)

	// Process current state
	var/result = current_state.process_state(controller, delta_time)
	switch(result)
		if(ACTION_STATE_COMPLETE, ACTION_STATE_FAILED)
			// Invalidate priority so we re-evaluate immediately next tick
			current_state.invalidate_priority()
			var/datum/action_state/next = select_best_state(controller)
			change_state(controller, next || available_states["idle"])
			return FALSE
	return TRUE

/datum/action_state_manager/proc/change_state(datum/ai_controller/controller, datum/action_state/new_state)
	if(!new_state || new_state == current_state)
		return
	if(current_state)
		current_state.exit_state(controller)
	if(last_movement_target)
		clear_movement_target(controller)
	current_state = new_state
	current_state.enter_state(controller)

/datum/action_state_manager/proc/set_movement_target(datum/ai_controller/controller, atom/target)
	controller.set_movement_target(type, target)
	controller.ai_movement.start_moving_towards(controller, target)
	last_movement_target = target

/datum/action_state_manager/proc/clear_movement_target(datum/ai_controller/controller)
	controller.set_movement_target(type, null)
	controller.ai_movement.stop_moving_towards(controller)
	last_movement_target = null

/datum/action_state_manager/proc/get_state_name()
	return current_state?.name || "unknown"

/**
 * Called by external code (verb handlers, pet commands) to notify the manager
 * that something relevant changed and priorities should be reconsidered ASAP.
 */
/datum/action_state_manager/proc/notify_priority_change()
	for(var/state_name in available_states)
		var/datum/action_state/state = available_states[state_name]
		state.invalidate_priority()

/**
 * Returns a list of state names that currently have work (dynamic priority > NONE),
 * excluding housekeeping states. Sorted highest-priority-first using cached values.
 * Used by the set_priority pet command to build its dialog.
 */
/datum/action_state_manager/proc/get_active_state_names(datum/ai_controller/controller)
	var/list/active = list()
	for(var/state_name in available_states)
		if(state_name == "idle" || state_name == "return_home")
			continue
		var/datum/action_state/state = available_states[state_name]
		if(state.cached_priority > GNOME_PRIORITY_NONE)
			active += state_name

	// Sort descending by cached priority so the dialog reflects current ranking.
	for(var/i in 1 to active.len - 1)
		for(var/j in 1 to active.len - i)
			var/datum/action_state/a = available_states[active[j]]
			var/datum/action_state/b = available_states[active[j + 1]]
			if(b.cached_priority > a.cached_priority)
				var/tmp = active[j]
				active[j] = active[j + 1]
				active[j + 1] = tmp
	return active

/**
 * Applies a player-specified ranking to the priority override table.
 * [ranked_names] is ordered highest-priority first (index 1 = most important).
 *
 * Offset formula:  (total - index) * GNOME_PRIORITY_USER_STEP
 *   3 tasks:  rank 1 → +8,  rank 2 → +4,  rank 3 → +0
 * States absent from the list receive offset 0 (cleared).
 */
/datum/action_state_manager/proc/apply_priority_ranking(datum/ai_controller/controller, list/ranked_names)
	if(!ranked_names || !ranked_names.len)
		return

	if(!controller.blackboard[BB_GNOME_PRIORITY_OVERRIDES])
		controller.blackboard[BB_GNOME_PRIORITY_OVERRIDES] = list()

	var/list/overrides = controller.blackboard[BB_GNOME_PRIORITY_OVERRIDES]
	var/total = ranked_names.len

	// Reset all known state offsets.
	for(var/state_name in available_states)
		overrides[state_name] = 0

	// Write ranked offsets.
	for(var/i in 1 to total)
		var/state_name = ranked_names[i]
		if(state_name in available_states)
			overrides[state_name] = (total - i) * GNOME_PRIORITY_USER_STEP

	notify_priority_change()

/**
 * Removes the user priority offset for a single state.
 * Call this from stop commands so a disabled task stops influencing ordering.
 */
/datum/action_state_manager/proc/clear_priority_override(datum/ai_controller/controller, state_name)
	var/list/overrides = controller.blackboard[BB_GNOME_PRIORITY_OVERRIDES]
	if(overrides)
		overrides -= state_name
	var/datum/action_state/state = available_states[state_name]
	if(state)
		state.invalidate_priority()
