/datum/ai_planning_subtree/simple_find_target

/datum/ai_planning_subtree/simple_find_target/SelectBehaviors(datum/ai_controller/controller, delta_time)
	controller.queue_behavior(/datum/ai_behavior/find_potential_targets, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)

/datum/ai_planning_subtree/simple_find_target/rat

/datum/ai_planning_subtree/simple_find_target/rat/SelectBehaviors(datum/ai_controller/controller, delta_time)
	controller.queue_behavior(/datum/ai_behavior/find_potential_targets/rat, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)

/datum/ai_planning_subtree/simple_find_target/spider

/datum/ai_planning_subtree/simple_find_target/rat/SelectBehaviors(datum/ai_controller/controller, delta_time)
	controller.queue_behavior(/datum/ai_behavior/find_potential_targets/spider, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)


/datum/ai_planning_subtree/simple_find_target/mimic

/datum/ai_planning_subtree/simple_find_target/mimic/SelectBehaviors(datum/ai_controller/controller, delta_time)
	controller.queue_behavior(/datum/ai_behavior/find_potential_targets/mimic, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)

/datum/ai_planning_subtree/simple_find_target/mole

/datum/ai_planning_subtree/simple_find_target/mole/SelectBehaviors(datum/ai_controller/controller, delta_time)
	controller.queue_behavior(/datum/ai_behavior/find_potential_targets/mole, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)

/datum/ai_planning_subtree/simple_find_target/closest //nearest

/datum/ai_planning_subtree/simple_find_target/closest/SelectBehaviors(datum/ai_controller/controller, delta_time)
	controller.queue_behavior(/datum/ai_behavior/find_potential_targets/nearest, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)


/datum/ai_planning_subtree/aggro_find_target

/datum/ai_planning_subtree/aggro_find_target/SelectBehaviors(datum/ai_controller/controller, delta_time)
	controller.queue_behavior(/datum/ai_behavior/find_aggro_targets, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)


/datum/ai_planning_subtree/aggro_find_target/bum

/datum/ai_planning_subtree/aggro_find_target/bum/SelectBehaviors(datum/ai_controller/controller, delta_time)
	controller.queue_behavior(/datum/ai_behavior/find_aggro_targets/bum, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)

/datum/ai_planning_subtree/simple_find_target/gator/SelectBehaviors(datum/ai_controller/controller, delta_time)
	controller.queue_behavior(/datum/ai_behavior/find_potential_targets/gator, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)

/datum/ai_behavior/find_potential_targets/gator
	vision_range = 5
	var/enhanced_vision_in_water = 8 // Better vision range in water

/datum/ai_behavior/find_potential_targets/gator/setup(datum/ai_controller/controller, locate_path, target_key)
	. = ..()
	var/mob/living/simple_animal/hostile/gator_pawn = controller.pawn
	if(!istype(gator_pawn))
		return

	var/in_water = controller.blackboard[BB_GATOR_IN_WATER]

	if(in_water)
		vision_range = enhanced_vision_in_water

/datum/ai_planning_subtree/aggro_find_target/species_hostile

/datum/ai_planning_subtree/aggro_find_target/species_hostile/SelectBehaviors(datum/ai_controller/controller, delta_time)
	controller.queue_behavior(/datum/ai_behavior/find_aggro_targets/species_hostile, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
