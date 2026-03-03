/datum/ai_controller/watcher
	movement_delay = 0.7 SECONDS

	ai_movement = /datum/ai_movement/astar

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/spacing/ranged,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/opportunistic_watcher,
		/datum/ai_planning_subtree/basic_ranged_attack_subtree,

	)

	idle_behavior = /datum/idle_behavior/idle_random_walk
