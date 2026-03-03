/datum/ai_controller/voiddragon
	movement_delay = 0.5 SECONDS
	ai_movement = /datum/ai_movement/astar
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic(),
		BB_DRAGON_ENRAGED = FALSE,
		BB_DRAGON_SWOOPING = NONE,
		BB_DRAGON_RECOVERY_TIME = 0,
		BB_DRAGON_ANGER_MODIFIER = 0
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/dragon_retaliate,
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/dragon_attack_subtree,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
	)

	idle_behavior = /datum/idle_behavior/idle_random_walk
