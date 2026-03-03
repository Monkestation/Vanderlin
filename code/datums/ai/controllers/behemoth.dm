/datum/ai_controller/behemoth
	movement_delay = 0.9 SECONDS
	ai_movement = /datum/ai_movement/astar
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic(),
		BB_PET_TARGETING_DATUM = new /datum/targetting_datum/basic/not_friends(),
		BB_QUAKE_COOLDOWN = 0,
	)
	planning_subtrees = list(
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/behemoth_special_abilities,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/warden,
	)
	idle_behavior = /datum/idle_behavior/idle_random_walk
