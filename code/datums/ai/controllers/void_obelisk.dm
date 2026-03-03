/datum/ai_controller/void_obelisk
	movement_delay = 1.1 SECONDS

	ai_movement = /datum/ai_movement/astar

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items()

	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/opportunistic,
		/datum/ai_planning_subtree/move_to_cardinal/void_obelisk,
		/datum/ai_planning_subtree/targeted_mob_ability/void_obelisk,
	)

	idle_behavior = /datum/idle_behavior/idle_random_walk

/datum/ai_planning_subtree/move_to_cardinal/void_obelisk
	move_behaviour = /datum/ai_behavior/move_to_cardinal/void_obelisk

/datum/ai_behavior/move_to_cardinal/void_obelisk
	minimum_distance = 2

/datum/ai_planning_subtree/targeted_mob_ability/void_obelisk
	use_ability_behaviour = /datum/ai_behavior/targeted_mob_ability/void_obelisk

/datum/ai_behavior/targeted_mob_ability/void_obelisk
	/// Don't shoot if too far away
	var/max_target_distance = 9

/datum/ai_behavior/targeted_mob_ability/void_obelisk/perform(seconds_per_tick, datum/ai_controller/controller, ability_key, target_key)
	var/mob/living/target = controller.blackboard[target_key]
	if (QDELETED(target) || !(get_dir(controller.pawn, target) in GLOB.cardinals) || get_dist(controller.pawn, target) > max_target_distance)
		finish_action(controller, succeeded = FALSE, ability_key = ability_key, target_key = target_key)
		return
	return ..()
