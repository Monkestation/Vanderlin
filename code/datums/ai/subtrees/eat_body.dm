/datum/ai_planning_subtree/eat_dead_body
	var/datum/ai_behavior/eat_dead_body/behavior = /datum/ai_behavior/eat_dead_body

/datum/ai_planning_subtree/eat_dead_body/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/atom/target = controller.blackboard[BB_BASIC_MOB_FOOD_TARGET]
	if(QDELETED(target))
		return
	var/mob/living/pawn = controller.pawn
	if(pawn.doing())
		return
	controller.queue_behavior(behavior, BB_BASIC_MOB_FOOD_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
	return SUBTREE_RETURN_FINISH_PLANNING //we are going into battle...no distractions.


/datum/ai_planning_subtree/eat_dead_body/bog_troll
	behavior = /datum/ai_behavior/eat_dead_body/bog_troll

/datum/ai_planning_subtree/eat_dead_body/mimic
	behavior = /datum/ai_behavior/eat_dead_body/mimic
