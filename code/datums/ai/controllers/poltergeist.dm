/datum/ai_controller/polter
	movement_delay = 0.5 SECONDS

	ai_movement = /datum/ai_movement/astar

	blackboard = list(
		BB_TARGET_HELD_ITEM = /obj/item/clothing/neck/psycross,
		BB_BASIC_MOB_FLEEING = TRUE, //We only flee from scary priests.
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items/holding_item,
		BB_PET_TARGETING_DATUM = new /datum/targetting_datum/basic/not_friends(),
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/simple_find_nearest_target_to_flee,
		/datum/ai_planning_subtree/flee_target,
		/datum/ai_planning_subtree/polter,
	)

	idle_behavior = /datum/idle_behavior/idle_random_walk
