/datum/action_state
	var/name = "base_state"
	var/description = "Base state"
	var/datum/action_state_manager/manager

	/// Cached priority from the last evaluate_priority() call.
	/// Do NOT read this directly, use get_priority() which refreshes the cache.
	var/cached_priority = GNOME_PRIORITY_NONE

	/// How many seconds between full re-evaluations of priority.
	/// Cheap states (idle, return_home) can use a longer interval.
	var/priority_eval_interval = 1 SECONDS
	var/next_priority_eval = 0

/datum/action_state/New(datum/action_state_manager/_manager)
	. = ..()
	manager = _manager

/**
 * Returns the current priority of this state.
 * Results are cached for priority_eval_interval seconds to avoid spamming
 * expensive world-scans every subtree tick.
 */
/datum/action_state/proc/get_priority(datum/ai_controller/controller)
	if(world.time >= next_priority_eval)
		var/dynamic = evaluate_priority(controller)
		if(dynamic <= GNOME_PRIORITY_NONE)
			cached_priority = GNOME_PRIORITY_NONE
		else
			var/list/overrides = controller.blackboard[BB_GNOME_PRIORITY_OVERRIDES]
			var/offset = overrides ? (overrides[name] || 0) : 0
			cached_priority = clamp(dynamic + offset, 1, GNOME_PRIORITY_CRITICAL)
		next_priority_eval = world.time + priority_eval_interval
	return cached_priority


/**
 * Override in subclasses.  Return a GNOME_PRIORITY_* value.
 * Called at most once per priority_eval_interval, safe to do moderate work here.
 */
/datum/action_state/proc/evaluate_priority(datum/ai_controller/controller)
	return GNOME_PRIORITY_NONE

/**
 * Force an immediate priority re-evaluation on the next get_priority() call.
 * Call this whenever external state changes (mode toggled, item picked up, etc.)
 */
/datum/action_state/proc/invalidate_priority()
	next_priority_eval = 0

// Called when entering this state
/datum/action_state/proc/enter_state(datum/ai_controller/controller)
	return

// Called every tick while in this state
/datum/action_state/proc/process_state(datum/ai_controller/controller, delta_time)
	return ACTION_STATE_CONTINUE

// Called when exiting this state
/datum/action_state/proc/exit_state(datum/ai_controller/controller)
	return
