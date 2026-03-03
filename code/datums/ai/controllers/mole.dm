/datum/ai_controller/mole
	movement_delay = 0.6 SECONDS

	ai_movement = /datum/ai_movement/astar

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items()

	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/flee_target,

		/datum/ai_planning_subtree/simple_find_target/mole,
		/datum/ai_planning_subtree/find_food/mole,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,

		/datum/ai_planning_subtree/find_dead_bodies/mole,
		/datum/ai_planning_subtree/eat_dead_body,
	)

	idle_behavior = /datum/idle_behavior/idle_random_walk
