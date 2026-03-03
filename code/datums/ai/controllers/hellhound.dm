/datum/ai_controller/hellhound
	movement_delay = 0.4 SECONDS

	ai_movement = /datum/ai_movement/astar

	blackboard = list(
		BB_HELLHOUND_FIRE = 0,
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic(),
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/flee_target,
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/hellhound,

	)

	idle_behavior = /datum/idle_behavior/idle_random_walk
