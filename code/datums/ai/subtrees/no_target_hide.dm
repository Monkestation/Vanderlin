/datum/ai_planning_subtree/no_target_hide

/datum/ai_planning_subtree/no_target_hide/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/atom/target = controller.blackboard[BB_BASIC_MOB_FOOD_TARGET]
	if(target)
		return
	controller.queue_behavior(/datum/ai_behavior/hide)
	return SUBTREE_RETURN_FINISH_PLANNING //we are going into battle...no distractions.
