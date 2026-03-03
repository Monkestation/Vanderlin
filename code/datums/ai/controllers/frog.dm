/datum/ai_controller/frog
	movement_delay = 0.3 SECONDS
	blackboard = list(
		BB_TARGET_HELD_ITEM = /obj/item/fishingrod,
		BB_BASIC_MOB_FLEEING = TRUE, //We only flee from scary fishermen.
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items/holding_item,
		BB_PET_TARGETING_DATUM = new /datum/targetting_datum/basic/not_friends,
	)
	ai_movement = /datum/ai_movement/astar
	idle_behavior = /datum/idle_behavior/idle_random_walk
	planning_subtrees = list(
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/simple_find_nearest_target_to_flee,
		/datum/ai_planning_subtree/flee_target,
		/datum/ai_planning_subtree/go_for_swim,
	)
