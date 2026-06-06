/datum/ai_movement/hybrid_pathing/wormhole_aware
	max_path_distance = 100
	// Extends the hybrid pathing to consider wormholes as shortcuts
	var/wormhole_check_distance = 15 // How far to look for wormholes
	var/wormhole_check_cooldown = 3 SECONDS

/datum/ai_movement/hybrid_pathing/wormhole_aware/process(delta_time)
	for(var/datum/ai_controller/controller as anything in moving_controllers)
		var/datum/weakref/used_ref = WEAKREF(controller)
		if(!(future_path_blackboard_key in controller.blackboard))
			controller.add_blackboard_key(future_path_blackboard_key, null)
		if(!COOLDOWN_FINISHED(controller, movement_cooldown))
			continue
		COOLDOWN_START(controller, movement_cooldown, controller.movement_delay)

		if(!controller.can_move())
			continue

		var/atom/movable/movable_pawn = controller.pawn
		var/turf/target_turf = get_step_towards(movable_pawn, controller.current_movement_target)
		var/turf/end_turf = get_turf(controller.current_movement_target)
		var/advanced = TRUE
		var/turf/current_turf = get_turf(movable_pawn)

		// Store location before movement attempt
		var/turf/location_before_move = current_turf

		// Check for wormhole shortcuts periodically
		var/last_check = controller.blackboard[BB_LAST_WORMHOLE_CHECK]
		if(!last_check)
			last_check = 0

		if(world.time > last_check + wormhole_check_cooldown)
			controller.set_blackboard_key(BB_LAST_WORMHOLE_CHECK, world.time)
			var/obj/structure/meatvine/intestine_wormhole/shortcut = find_wormhole_shortcut(movable_pawn, controller.current_movement_target, controller)
			if(shortcut)
				// Try to path to the wormhole entrance
				controller.movement_path = get_path_to(movable_pawn, shortcut, TYPE_PROC_REF(/turf, Heuristic_cardinal_3d),
					max_path_distance + 1, max_path_distance + 1, 0, id=controller.get_access())
				if(length(controller.movement_path))
					controller.set_blackboard_key(BB_WORMHOLE_TARGET, shortcut)
					SEND_SIGNAL(movable_pawn, COMSIG_AI_GENERAL_CHANGE, "Routing through wormhole")

		// Check if we've reached a wormhole we were targeting
		var/obj/structure/meatvine/intestine_wormhole/wormhole_target = controller.blackboard[BB_WORMHOLE_TARGET]
		if(wormhole_target && get_turf(movable_pawn) == get_turf(wormhole_target))
			var/obj/structure/meatvine/intestine_wormhole/best_exit = find_best_wormhole_exit(wormhole_target, controller.current_movement_target)
			if(best_exit && best_exit != wormhole_target)
				// Teleport through the wormhole
				movable_pawn.forceMove(get_turf(best_exit))
				controller.clear_blackboard_key(BB_WORMHOLE_TARGET)
				controller.movement_path = null // Regenerate path from new position
				controller.clear_blackboard_key(future_path_blackboard_key)
				SEND_SIGNAL(movable_pawn, COMSIG_AI_GENERAL_CHANGE, "Traveled through wormhole")
				continue

		var/mob/cliented_mob = controller.current_movement_target
		var/cliented = FALSE
		if(istype(cliented_mob))
			if(cliented_mob.client)
				cliented = TRUE

		// Check if we've moved to a lower Z-level (possibly thrown) and our path expects us to be higher
		if(length(controller.movement_path) && controller.movement_path[1])
			var/turf/next_step = controller.movement_path[1]

			if(next_step.z > current_turf.z)
				var/turf/above = get_step_multiz(current_turf, UP)
				var/can_go_up = FALSE

				if(above && !above.density)
					for(var/obj/structure/stairs/S in current_turf.contents)
						var/turf/dest = get_step(above, S.dir)
						if(dest == next_step || get_step(dest, S.dir) == next_step)
							can_go_up = TRUE
							break

				if(!can_go_up)
					controller.movement_path = null
					controller.clear_blackboard_key(future_path_blackboard_key)
					if(!(used_ref in falling_back))
						falling_back |= used_ref
						fallback_fail |= used_ref
					falling_back[used_ref] = FALSE
					fallback_fail[used_ref] = 0
					continue

		// Basic movement for targets on the same z-level with no existing path
		if(end_turf?.z == movable_pawn?.z && !length(controller.movement_path) && !cliented)
			advanced = FALSE
			var/can_move = controller.can_move()
			var/current_loc = get_turf(movable_pawn)

			if(!is_type_in_typecache(target_turf, GLOB.dangerous_turfs) && can_move)
				step_to(movable_pawn, target_turf, controller.blackboard[BB_CURRENT_MIN_MOVE_DISTANCE], controller.movement_delay)

				// Check if movement was successful
				if(current_loc != get_turf(movable_pawn))
					// Successful basic movement - reset failure counter and clear fallback state
					controller.pathing_attempts = 0
					falling_back -= used_ref
					fallback_fail -= used_ref
				else
					// Movement failed - check if it's due to bounds
					if(is_blocked_by_bounds(movable_pawn, controller))
						SEND_SIGNAL(movable_pawn, COMSIG_AI_GENERAL_CHANGE, "At bounds edge, cancelling action")
						controller.CancelActions()
						stop_moving_towards(controller)
						continue

					// Movement failed - increment failure counter
					controller.pathing_attempts++

					// Only switch to A* after multiple consecutive failures
					if(controller.pathing_attempts >= max_basic_failures)
						advanced = TRUE
						controller.movement_path = null
						controller.clear_blackboard_key(future_path_blackboard_key)
						if(!(used_ref in falling_back))
							falling_back |= used_ref
							fallback_fail |= used_ref
						falling_back[used_ref] = TRUE
						fallback_fail[used_ref] = 0
						SEND_SIGNAL(movable_pawn, COMSIG_AI_GENERAL_CHANGE, "Unable to Basic Move after [max_basic_failures] attempts, swapping to AStar.")

					// Check if we've exceeded maximum pathing attempts
					if(controller.pathing_attempts >= max_pathing_attempts)
						controller.CancelActions()
						SEND_SIGNAL(movable_pawn, COMSIG_AI_GENERAL_CHANGE, "Failed pathfinding cancelling.")

		if(advanced)
			var/minimum_distance = controller.max_target_distance
			for(var/datum/ai_behavior/iter_behavior as anything in controller.current_behaviors)
				if(iter_behavior.required_distance < minimum_distance)
					minimum_distance = iter_behavior.required_distance

			if(get_dist(movable_pawn, controller.current_movement_target) <= minimum_distance)
				continue

			var/generate_path = FALSE
			var/list/future_path = controller.blackboard[future_path_blackboard_key]

			// Path following logic
			if(length(controller.movement_path))
				var/turf/last_turf = controller.movement_path[length(controller.movement_path)]
				var/turf/next_step = controller.movement_path[1]
				var/remaining_path_length = length(controller.movement_path)

				if(next_step.z != movable_pawn.z)
					var/can_transition = FALSE

					if(next_step.z > movable_pawn.z)
						for(var/obj/structure/stairs/S in current_turf.contents)
							var/turf/above = get_step_multiz(current_turf, UP)
							if(above)
								var/turf/dest = get_step(above, S.dir)
								if(dest == next_step)
									can_transition = TRUE
									break

					else if(next_step.z < movable_pawn.z)
						var/turf/below = get_step_multiz(current_turf, DOWN)
						if(below == next_step)
							can_transition = TRUE
						else
							for(var/obj/structure/stairs/S in current_turf.contents)
								var/turf/dest = get_step(below, turn(S.dir, 180))
								if(dest == next_step)
									can_transition = TRUE
									break

					if(can_transition)
						movable_pawn.Move(next_step)
					else
						generate_path = TRUE
						controller.clear_blackboard_key(future_path_blackboard_key)
				else
					step_to(movable_pawn, next_step, controller.blackboard[BB_CURRENT_MIN_MOVE_DISTANCE], controller.movement_delay)

				if(last_turf != get_turf(controller.current_movement_target))
					if(future_path && length(future_path) && future_path[length(future_path)] == get_turf(controller.current_movement_target))
						controller.movement_path = future_path.Copy()
						controller.clear_blackboard_key(future_path_blackboard_key)
						SEND_SIGNAL(controller.pawn, COMSIG_AI_PATH_SWAPPED, controller.movement_path)
					else
						generate_path = TRUE
						controller.clear_blackboard_key(future_path_blackboard_key)

				if(!(used_ref in falling_back))
					falling_back |= used_ref
					fallback_fail |= used_ref
					falling_back[used_ref] = TRUE
					fallback_fail[used_ref] = 0

				if(get_turf(movable_pawn) == next_step || (istype(next_step, /turf/open/openspace) && get_turf(movable_pawn) == GET_TURF_BELOW(next_step)))
					controller.movement_path.Cut(1,2)
					if(length(controller.movement_path))
						var/turf/double_checked = controller.movement_path[1]
						if(get_turf(movable_pawn) == double_checked)
							controller.movement_path.Cut(1,2)

					if(!length(controller.movement_path) && falling_back[used_ref])
						falling_back[used_ref] = FALSE
						// Successfully completed A* path - allow basic movement again on next iteration
						controller.pathing_attempts = 0
				else
					// Movement failed in advanced pathing - check if it's due to bounds
					if(location_before_move == get_turf(movable_pawn) && is_blocked_by_bounds(movable_pawn, controller))
						SEND_SIGNAL(movable_pawn, COMSIG_AI_GENERAL_CHANGE, "At bounds edge, cancelling action")
						controller.CancelActions()
						stop_moving_towards(controller)
						continue

					if(!falling_back[used_ref])
						generate_path = TRUE
						controller.clear_blackboard_key(future_path_blackboard_key)
					else
						fallback_fail[used_ref]++
						if(fallback_fail[used_ref] >= 2)
							fallback_fail[used_ref] = 0
							generate_path = TRUE
							falling_back[used_ref] = FALSE
							controller.clear_blackboard_key(future_path_blackboard_key)

				if(!generate_path && remaining_path_length <= repath_anticipation_distance && !future_path && COOLDOWN_FINISHED(controller, repath_cooldown))
					if(QDELETED(controller.current_movement_target) || controller.current_movement_target.loc == movable_pawn)
						continue
					COOLDOWN_START(controller, repath_cooldown, 1 SECONDS)
					var/list/new_future_path = get_path_to(movable_pawn, controller.current_movement_target, TYPE_PROC_REF(/turf, Heuristic_cardinal_3d),
						max_path_distance + 1, max_path_distance + 1, minimum_distance, id=controller.get_access())
					controller.set_blackboard_key(future_path_blackboard_key, new_future_path)
					SEND_SIGNAL(controller.pawn, COMSIG_AI_FUTURE_PATH_GENERATED, new_future_path)
			else
				generate_path = TRUE

			if(generate_path)
				if(!COOLDOWN_FINISHED(controller, repath_cooldown))
					continue
				controller.pathing_attempts++
				if(controller.pathing_attempts >= max_pathing_attempts)
					SEND_SIGNAL(movable_pawn, COMSIG_AI_GENERAL_CHANGE, "Failed advanced pathfinding cancelling.")
					controller.CancelActions()
					stop_moving_towards(controller)
					continue
				if(QDELETED(controller.current_movement_target) || controller.current_movement_target.loc == movable_pawn)
					stop_moving_towards(controller)
					continue
				COOLDOWN_START(controller, repath_cooldown, 1.5 SECONDS)
				controller.movement_path = get_path_to(movable_pawn, controller.current_movement_target, TYPE_PROC_REF(/turf, Heuristic_cardinal_3d),
					max_path_distance + 1, max_path_distance + 1, minimum_distance, id=controller.get_access())
				controller.clear_blackboard_key(future_path_blackboard_key)
				SEND_SIGNAL(controller.pawn, COMSIG_AI_PATH_GENERATED, controller.movement_path)


/datum/ai_movement/hybrid_pathing/wormhole_aware/proc/is_blocked_by_bounds(atom/movable/pawn, datum/ai_controller/controller)
	// Check if the pawn has a bounded component
	var/datum/component/bounded/bounds = pawn.GetComponent(/datum/component/bounded)
	if(!bounds)
		return FALSE

	// Check if the pawn has a movement target
	if(!controller.current_movement_target)
		return FALSE

	var/turf/current_loc = get_turf(pawn)
	var/turf/target_loc = get_turf(controller.current_movement_target)

	if(!current_loc || !target_loc)
		return FALSE

	var/atom/bounds_origin = bounds.master
	if(!bounds_origin)
		return FALSE

	var/turf/origin_turf = get_turf(bounds_origin)
	if(!origin_turf)
		return FALSE

	var/current_distance = get_dist(current_loc, origin_turf)
	var/max_distance = bounds.max_dist

	if(current_distance >= max_distance)
		var/target_distance = get_dist(target_loc, origin_turf)
		if(target_distance > current_distance)
			return TRUE

	return FALSE

/datum/ai_movement/hybrid_pathing/wormhole_aware/proc/find_wormhole_shortcut(atom/movable/pawn, atom/target, datum/ai_controller/controller)
	// Find nearby wormholes
	var/turf/pawn_turf = get_turf(pawn)
	var/turf/target_turf = get_turf(target)

	if(!pawn_turf || !target_turf)
		return null

	var/current_distance = get_dist_3d(pawn_turf, target_turf)
	var/best_wormhole = null
	var/best_savings = 0

	// Search for wormholes within range
	for(var/obj/structure/meatvine/intestine_wormhole/wormhole in range(wormhole_check_distance, pawn))
		// Skip if we're already at this wormhole
		if(get_turf(wormhole) == pawn_turf)
			continue

		// Check if this wormhole has valid exits
		var/list/network_wormholes = list()
		if(wormhole.master)
			for(var/obj/structure/meatvine/intestine_wormhole/other in wormhole.master.vines)
				if(other.wormhole_id == wormhole.wormhole_id)
					network_wormholes += other

		if(length(network_wormholes) <= 1)
			continue

		// Find the exit that gets us closest to target
		for(var/obj/structure/meatvine/intestine_wormhole/exit in network_wormholes)
			if(exit == wormhole)
				continue

			var/turf/exit_turf = get_turf(exit)
			if(!exit_turf)
				continue

			// Calculate distance savings
			var/distance_to_entrance = get_dist_3d(pawn_turf, get_turf(wormhole))
			var/distance_from_exit = get_dist_3d(exit_turf, target_turf)
			var/total_distance = distance_to_entrance + distance_from_exit
			var/savings = current_distance - total_distance

			// Must save at least 5 tiles to be worth it
			if(savings > best_savings && savings > 5)
				best_savings = savings
				best_wormhole = wormhole

	return best_wormhole

/datum/ai_movement/hybrid_pathing/wormhole_aware/proc/find_best_wormhole_exit(obj/structure/meatvine/intestine_wormhole/entrance, atom/target)
	if(!entrance.master)
		return null

	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return null

	var/list/network_wormholes = list()
	for(var/obj/structure/meatvine/intestine_wormhole/wormhole in entrance.master.vines)
		if(wormhole.wormhole_id == entrance.wormhole_id)
			network_wormholes += wormhole

	if(length(network_wormholes) <= 1)
		return null

	var/obj/structure/meatvine/intestine_wormhole/best_exit = null
	var/best_distance = INFINITY

	for(var/obj/structure/meatvine/intestine_wormhole/exit in network_wormholes)
		if(exit == entrance)
			continue

		var/turf/exit_turf = get_turf(exit)
		if(!exit_turf)
			continue

		var/distance = get_dist_3d(exit_turf, target_turf)
		if(distance < best_distance)
			best_distance = distance
			best_exit = exit

	return best_exit
