/datum/ai_controller/swamp_kraken
	movement_delay = 0.5 SECONDS
	ai_movement = /datum/ai_movement/hybrid_pathing
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items(),
	)
	idle_behavior = /datum/idle_behavior/idle_random_walk
	planning_subtrees = list(
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/opportunistic_watcher,
		/datum/ai_planning_subtree/targeted_mob_ability/summon,
		/datum/ai_planning_subtree/targeted_mob_ability/ink,
		/datum/ai_planning_subtree/targeted_mob_ability/whirlpool,
		/datum/ai_planning_subtree/simple_self_recovery/dragon
	)

/datum/ai_planning_subtree/targeted_mob_ability/whirlpool
	ability_key = BB_KRAKEN_WHIRLPOOL
	finish_planning = FALSE

/datum/ai_planning_subtree/targeted_mob_ability/ink
	ability_key = BB_KRAKEN_INK
	finish_planning = FALSE

/datum/ai_planning_subtree/targeted_mob_ability/summon
	ability_key = BB_KRAKEN_SUMMON

/datum/ai_planning_subtree/targeted_mob_ability/kraken
	ability_key = BB_TARGETED_ACTION
	finish_planning = FALSE

/datum/ai_controller/kraken_tentacle
	movement_delay = 0.3 SECONDS
	ai_movement = /datum/ai_movement/hybrid_pathing
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items(),
	)
	idle_behavior = /datum/idle_behavior/idle_random_walk
	planning_subtrees = list(
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
	)

/datum/ai_controller/kraken_tentacle/grabber
	planning_subtrees = list(
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		/datum/ai_planning_subtree/targeted_mob_ability/continue_planning,
	)

/datum/ai_controller/kraken_tentacle/spitter
	planning_subtrees = list(
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/basic_ranged_attack_subtree,
		/datum/ai_planning_subtree/targeted_mob_ability/continue_planning,
	)
