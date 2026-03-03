/datum/ai_controller/fiend
	movement_delay = 1 SECONDS
	ai_movement = /datum/ai_movement/astar

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic(),
		BB_FIEND_FLAME_CD = 0,
		BB_FIEND_SUMMON_CD = 0,
		BB_MINION_COUNT = 0,
		BB_MAX_MINIONS = 6,
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/fiend_abilities,
		/datum/ai_planning_subtree/spacing/ranged,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/opportunistic,
		/datum/ai_planning_subtree/basic_ranged_attack_subtree,
	)

	idle_behavior = /datum/idle_behavior/idle_random_walk
