/// similar to finding a target but looks for food types in the // the what?
/datum/ai_planning_subtree/find_food
	var/vision_range = 9

/datum/ai_planning_subtree/find_food/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	if(istype(controller.pawn, /mob/living/simple_animal/hostile/retaliate))
		var/mob/living/simple_animal/hostile/retaliate/mob = controller.pawn
		if(SEND_SIGNAL(mob, COMSIG_MOB_RETURN_HUNGER) >= 50)
			return // not hungry

	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!QDELETED(target))
		// Busy with something
		return

	controller.queue_behavior(/datum/ai_behavior/find_and_set/in_list, BB_BASIC_MOB_CURRENT_TARGET, controller.blackboard[BB_BASIC_FOODS], vision_range)


/datum/ai_planning_subtree/find_dead_bodies
	var/vision_range = 9
	var/datum/ai_behavior/find_and_set/dead_bodies/behavior = /datum/ai_behavior/find_and_set/dead_bodies

/datum/ai_planning_subtree/find_dead_bodies/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	if(istype(controller.pawn, /mob/living/simple_animal))
		var/mob/living/simple_animal/hostile/retaliate/mob = controller.pawn
		if(SEND_SIGNAL(mob, COMSIG_MOB_RETURN_HUNGER) >= 50)
			return // not hungry

	var/atom/target = controller.blackboard[BB_BASIC_MOB_FOOD_TARGET]
	if(!QDELETED(target))
		// Busy with something
		return

	controller.queue_behavior(behavior, BB_BASIC_MOB_FOOD_TARGET, controller.blackboard[BB_BASIC_FOODS], vision_range)


/datum/ai_planning_subtree/find_dead_bodies/mole
	vision_range = 7

/datum/ai_planning_subtree/find_food/rat
	vision_range = 2

/datum/ai_planning_subtree/find_food/spider
	vision_range = 5

/datum/ai_planning_subtree/find_food/mole
	vision_range = 7

/datum/ai_planning_subtree/find_food/troll
	vision_range = 7

/datum/ai_planning_subtree/find_food/gator
	vision_range = 9


/datum/ai_planning_subtree/find_dead_bodies/bog_troll
	vision_range = 7
	behavior = /datum/ai_behavior/find_and_set/dead_bodies/bog_troll

/datum/ai_planning_subtree/find_dead_bodies/mimic
	vision_range = 2
	behavior = /datum/ai_behavior/find_and_set/dead_bodies/mimic

/datum/ai_planning_subtree/find_food/saiga/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	if(istype(controller.pawn, /mob/living/simple_animal/hostile/retaliate))
		var/mob/living/simple_animal/hostile/retaliate/mob = controller.pawn
		if(SEND_SIGNAL(mob, COMSIG_MOB_RETURN_HUNGER) >= 50)
			return // not hungry

	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!QDELETED(target))
		// Busy with something
		return

	controller.queue_behavior(/datum/ai_behavior/find_and_set/in_list/saiga, BB_BASIC_MOB_CURRENT_TARGET, controller.blackboard[BB_BASIC_FOODS], vision_range)
