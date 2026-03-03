/datum/ai_controller/mimic
	movement_delay = 0.8 SECONDS

	ai_movement = /datum/ai_movement/astar

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items()

	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/simple_find_target/mimic,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/mimic,

		/datum/ai_planning_subtree/find_dead_bodies/mimic,
		/datum/ai_planning_subtree/eat_dead_body/mimic,
	)

	idle_behavior = /datum/idle_behavior/nothing
