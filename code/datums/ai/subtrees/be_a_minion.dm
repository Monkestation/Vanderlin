/// Obey your summoner (or equivalent)
/datum/ai_planning_subtree/being_a_minion
	/// Blackboard key where we travel a place
	var/location_key = BB_TRAVEL_DESTINATION
	/// Who we're following
	var/follow_target = BB_FOLLOW_TARGET
	/// What do we do in order to travel
	var/travel_behavior = /datum/ai_behavior/travel_towards/stop_on_arrival
/datum/ai_planning_subtree/being_a_minion/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/turf/travel = controller.blackboard[location_key]
	var/mob/following = controller.blackboard[follow_target]
	var/mob/living/pawn = controller.pawn

	if(travel)
		controller.queue_behavior(travel_behavior, location_key)
		return SUBTREE_RETURN_FINISH_PLANNING //end here
	else if(following)
		if(get_dist(pawn, following) > 12) //If further than 12 then you've lost that friendly target
			controller.clear_blackboard_key(BB_FOLLOW_TARGET)
		else
			controller.queue_behavior(/datum/ai_behavior/follow_friend, follow_target)
		return SUBTREE_RETURN_FINISH_PLANNING //end here
	return //no travel target and no one to follow. being a minion in other ways
/// Follow the target
/datum/ai_behavior/follow_friend
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM
/datum/ai_behavior/follow_friend/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/atom/target = controller.blackboard[target_key]

	if (QDELETED(target))
		return FALSE
	set_movement_target(controller, target)
/datum/ai_behavior/follow_friend/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	var/mob/target = controller.blackboard[target_key]

	if (QDELETED(target))
		return

	return
