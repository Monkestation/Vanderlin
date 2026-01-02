/datum/ai_controller/raccoon
	movement_delay = 0.4 SECONDS
	ai_movement = /datum/ai_movement/hybrid_pathing
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items(),
		BB_PET_TARGETING_DATUM = new /datum/targetting_datum/basic/not_friends(),
		BB_HOSTILE_MEOWS = list("Chitter!", "Hiss!", "Screee!"),
		BB_HUNGRY_MEOW = list("chirp...", "chrrr..."),
		BB_CAT_RACISM = FALSE,
	)
	planning_subtrees = list(
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/flee_target/from_flee_key/cat_struggle, // Use cat struggle flee behavior
		/datum/ai_planning_subtree/target_retaliate, // Retaliate when attacked
		/datum/ai_planning_subtree/beg_human, // Beg for food from humans
		/datum/ai_planning_subtree/find_food,
		/datum/ai_planning_subtree/basic_melee_attack_subtree, // Custom attack behavior
		/datum/ai_planning_subtree/territorial_struggle/raccoon, // Raccoon territorial fights
		/datum/ai_planning_subtree/find_dead_bodies, // Scavenger behavior
		/datum/ai_planning_subtree/eat_dead_body,
	)
	idle_behavior = /datum/idle_behavior/idle_random_walk
