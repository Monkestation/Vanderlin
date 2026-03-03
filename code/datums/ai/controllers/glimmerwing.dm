/datum/ai_controller/glimmerwing
	movement_delay = 0.6 SECONDS
	ai_movement = /datum/ai_movement/astar
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic(),
		BB_PET_TARGETING_DATUM = new /datum/targetting_datum/basic/not_friends(),
		BB_DRUG_COOLDOWN = 0,
	)
	planning_subtrees = list(
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/flee_target,
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/glimmerwing_special_abilities,
		/datum/ai_planning_subtree/basic_melee_attack_subtree
	)
	idle_behavior = /datum/idle_behavior/idle_random_walk
