/datum/ai_planning_subtree/call_for_help

/datum/ai_planning_subtree/call_for_help/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()

	if(!controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET])
		return

	var/mob/living/living_pawn = controller.pawn
	if(living_pawn.getBruteLoss() < 40 && living_pawn.getFireLoss() < 40)
		return

	var/allowed = FALSE
	for(var/mob/living/carbon/human/ally in range(controller.max_target_distance - 1, living_pawn))
		if(ally == living_pawn)
			continue
		var/datum/ai_controller/ally_ctrl = ally.ai_controller
		if(!ally_ctrl)
			continue
		allowed = TRUE
		break

	if(!allowed)
		return

	controller.queue_behavior(/datum/ai_behavior/call_for_help, BB_BASIC_MOB_CURRENT_TARGET)

/datum/ai_behavior/call_for_help
	action_cooldown = 45 SECONDS
	behavior_flags = AI_BEHAVIOR_MOVE_AND_PERFORM | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION | AI_BEHAVIOR_EXECUTE_ALONGSIDE

/datum/ai_behavior/call_for_help/perform(delta_time, datum/ai_controller/controller, target_key)
	. = ..()
	var/mob/living/living_pawn = controller.pawn
	living_pawn.emote("scream")
	var/atom/current_target = controller.blackboard[target_key]

	for(var/mob/living/carbon/human/ally in range(controller.max_target_distance - 1, living_pawn))
		if(ally == living_pawn)
			continue
		var/datum/ai_controller/ally_ctrl = ally.ai_controller
		if(!ally_ctrl)
			continue
		if(!living_pawn.faction_check_mob(ally, FALSE))
			continue
		if(ally_ctrl.blackboard[BB_BASIC_MOB_CURRENT_TARGET] == current_target)
			continue

		ally_ctrl.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, current_target)

		var/datum/component/ai_aggro_system/aggro_comp = ally_ctrl.pawn.GetComponent(/datum/component/ai_aggro_system)
		if(aggro_comp)
			aggro_comp.add_threat_to_mob_capped(current_target, 15, 15)
			aggro_comp.add_threat_to_mob(current_target, 3)

		ally_ctrl.set_blackboard_key(BB_HIGHEST_THREAT_MOB, current_target)

		var/datum/proximity_monitor/field = ally_ctrl.blackboard[BB_FIND_TARGETS_FIELD(/datum/ai_behavior/find_aggro_targets)]
		if(field)
			qdel(field)

		ally_ctrl.CancelActions()

	finish_action(controller, TRUE, target_key)
