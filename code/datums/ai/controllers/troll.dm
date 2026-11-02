/datum/ai_controller/troll
	movement_delay = 0.7 SECONDS

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items()

	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/flee_target,

		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/find_food/troll,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,

		/datum/ai_planning_subtree/find_dead_bodies,
		/datum/ai_planning_subtree/eat_dead_body,
	)

	idle_behavior = /datum/idle_behavior/idle_random_walk

/datum/ai_controller/bog_troll
	movement_delay = 0.7 SECONDS

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items()

	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/bog_troll,

		/datum/ai_planning_subtree/find_dead_bodies/bog_troll,
		/datum/ai_planning_subtree/eat_dead_body/bog_troll,
		/datum/ai_planning_subtree/no_target_hide,
	)

	idle_behavior = /datum/idle_behavior/nothing

/datum/ai_controller/troll/cave
	movement_delay = 0.7 SECONDS

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items()

	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/flee_target,

		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/find_food/troll,
		/datum/ai_planning_subtree/targeted_mob_ability/stone_throw,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,

		/datum/ai_planning_subtree/find_dead_bodies,
		/datum/ai_planning_subtree/eat_dead_body,
	)

	idle_behavior = /datum/idle_behavior/idle_random_walk

/datum/ai_controller/troll/ambush
	movement_delay = 0.7 SECONDS

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items()

	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/targeted_mob_ability,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/bog_troll,

		/datum/ai_planning_subtree/find_dead_bodies/bog_troll,
		/datum/ai_planning_subtree/eat_dead_body/bog_troll,
		/datum/ai_planning_subtree/no_target_hide,
	)

	idle_behavior = /datum/idle_behavior/nothing

/datum/ai_controller/troll/axe
	planning_subtrees = list(
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/flee_target,
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/find_food/troll,
		/datum/ai_planning_subtree/targeted_mob_ability/ground_slam,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		/datum/ai_planning_subtree/find_dead_bodies,
		/datum/ai_planning_subtree/eat_dead_body,
	)

/datum/ai_controller/troll/sea
	movement_delay = 0.7 SECONDS
	ai_movement = /datum/ai_movement/hybrid_pathing
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items()
	)
	planning_subtrees = list(
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/targeted_mob_ability/harpoon_pull,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/bog_troll,
		/datum/ai_planning_subtree/find_dead_bodies/bog_troll,
		/datum/ai_planning_subtree/eat_dead_body/bog_troll,
		/datum/ai_planning_subtree/no_target_hide,
	)
	idle_behavior = /datum/idle_behavior/nothing
