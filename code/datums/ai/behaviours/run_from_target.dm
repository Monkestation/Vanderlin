/**
 * Get ranged target turf, but with direct targets as opposed to directions
 *
 * Starts at atom starting_atom and gets the exact angle between starting_atom and target
 * Moves from starting_atom with that angle, Range amount of times, until it stops, bound to map size
 * Arguments:
 * * starting_atom - Initial Firer / Position
 * * target - Target to aim towards
 * * range - Distance of returned target turf from starting_atom
 * * offset - Angle offset, 180 input would make the returned target turf be in the opposite direction
 */
/proc/get_ranged_target_turf_direct(atom/starting_atom, atom/target, range, offset)
	if(!starting_atom)
		return
	var/angle = ATAN2(target.x - starting_atom.x, target.y - starting_atom.y)
	if(offset)
		angle += offset
	var/turf/starting_turf = get_turf(starting_atom)
	for(var/i in 1 to range)
		var/turf/check = locate(starting_atom.x + cos(angle) * i, starting_atom.y + sin(angle) * i, starting_atom.z)
		if(!check)
			break
		starting_turf = check

	return starting_turf

// Move to a position further away from your current target
/datum/ai_behavior/run_away_from_target
	required_distance = 0
	action_cooldown = 0
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION
	/// How far do we try to run? Further makes for smoother running, but potentially weirder pathfinding
	var/run_distance = 8
	var/until_destination = FALSE
	/// Clear target if we finish the action unsuccessfully
	var/clear_failed_targets = TRUE

/datum/ai_behavior/run_away_from_target/setup(datum/ai_controller/controller, target_key, hiding_location_key)
	var/atom/target = controller.blackboard[hiding_location_key] || controller.blackboard[target_key]
	if(!target)
		return FALSE
	var/mob/pawn = controller.pawn
	if(!controller.pawn)
		return FALSE //the fuck how?
	pawn?.emote("retreat")
	set_movement_target(controller, get_turf(controller.pawn))
	return ..()

/datum/ai_behavior/run_away_from_target/perform(delta_time, datum/ai_controller/controller, target_key, hiding_location_key)
	. = ..()
	var/atom/target = controller.blackboard[hiding_location_key] || controller.blackboard[target_key]
	var/escaped =  !target || !can_see(controller.pawn, target, run_distance) // If we can't see it we got away
	var/mob/living/living_pawn = controller.pawn
	if(SHOULD_RESIST(living_pawn))
		living_pawn.execute_resist()
		return

	if (!controller.blackboard[BB_BASIC_MOB_FLEEING])
		finish_action(controller, succeeded = TRUE)
		return
	if (escaped)
		finish_action(controller, succeeded = TRUE)
		return
	if (!in_range(controller.pawn, controller.current_movement_target))
		if(until_destination)
			finish_action(controller, TRUE)
		return
	plot_path_away_from(controller, target)

/datum/ai_behavior/run_away_from_target/proc/plot_path_away_from(datum/ai_controller/controller, atom/target)
	var/turf/target_destination = controller.current_movement_target
	var/static/list/offset_angles = list(45, 90, 135, 180, 225, 270)
	for(var/angle in offset_angles)
		if(get_dist(target, target_destination) > run_distance) //we already got the max running distance
			break
		var/turf/test_turf = get_furthest_turf(controller.pawn, angle, target)
		if(isnull(test_turf))
			continue
		var/distance_from_target = get_dist(target, test_turf)
		if(distance_from_target <= get_dist(target, target_destination))
			continue
		target_destination = test_turf
		if(distance_from_target > run_distance) //we already got the max running distance
			break
	if (target_destination == get_turf(controller.pawn))
		return FALSE
	set_movement_target(controller, target_destination)
	return TRUE

/datum/ai_behavior/run_away_from_target/proc/get_furthest_turf(atom/source, angle, atom/target)
	var/turf/return_turf
	for(var/i in 1 to run_distance)
		var/turf/test_destination = get_ranged_target_turf_direct(source, target, range = i, offset = angle)
		if(isopenspace(test_destination) || is_blocked_turf(test_destination, exclude_mobs = !source.density))
			var/origin = return_turf || get_turf(source)
			var/obj/structure/stairs/found_stairs = locate() in origin
			if(!found_stairs)
				break
			var/stairs_destination = found_stairs.get_transit_destination(get_dir(origin, test_destination))
			if(isopenspace(stairs_destination) || is_blocked_turf(stairs_destination, exclude_mobs = !source.density))
				break
			return stairs_destination
		return_turf = test_destination
	return return_turf

/datum/ai_behavior/run_away_from_target/finish_action(datum/ai_controller/controller, succeeded, target_key, hiding_location_key)
	. = ..()
	if (clear_failed_targets)
		controller.clear_blackboard_key(target_key)

/datum/ai_behavior/run_away_from_target/until_destination
	until_destination = TRUE
	run_distance = 6

/datum/ai_behavior/run_away_from_target/until_destination/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	controller.set_blackboard_key(BB_BASIC_MOB_RUN_WITH_ITEM, FALSE)

/datum/ai_behavior/run_away_from_target/saiga
	run_distance = 4
