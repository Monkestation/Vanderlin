/datum/ai_planning_subtree/wave_defense
	operational_datums = list(/datum/ai_behavior/wave_attack_point, /datum/ai_behavior/wave_occupy_point)

/datum/ai_planning_subtree/wave_defense/SelectBehaviors(datum/ai_controller/controller, delta_time)
	var/datum/wave_defense_coordinator/coordinator = controller.blackboard[BB_WAVE_COORDINATOR]
	if(!coordinator)
		return

	if(coordinator.wave_state == WAVE_FAILED || coordinator.wave_state == WAVE_COMPLETE)
		return

	// If we already have a combat target, let the normal combat subtrees handle it
	if(controller.blackboard[BB_HIGHEST_THREAT_MOB] || controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET])
		return

	var/atom/target_point = coordinator.get_current_point()
	if(!target_point)
		return

	controller.set_blackboard_key(BB_WAVE_TARGET_POINT, target_point)

	switch(coordinator.wave_state)
		if(WAVE_ADVANCING)
			controller.queue_behavior(/datum/ai_behavior/wave_attack_point, BB_WAVE_TARGET_POINT)
		if(WAVE_OCCUPYING)
			controller.queue_behavior(/datum/ai_behavior/wave_occupy_point, BB_WAVE_TARGET_POINT)

	return SUBTREE_RETURN_FINISH_PLANNING
