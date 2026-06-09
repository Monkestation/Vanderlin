/datum/ai_controller/shade
	movement_delay = 0.2 SECONDS

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items(),
		BB_PET_TARGETING_DATUM = new /datum/targetting_datum/basic/not_friends(),
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/generic_resist,
		/datum/ai_planning_subtree/shade_burning_check,
		/datum/ai_planning_subtree/simple_find_nearest_target_to_flee,
		/datum/ai_planning_subtree/flee_target,

		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/no_flee,
	)


/datum/ai_planning_subtree/shade_burning_check/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/mob/living/shade = controller.pawn
	if(shade.on_fire)
		controller.set_blackboard_key(BB_BASIC_MOB_FLEEING, TRUE)
	else
		controller.set_blackboard_key(BB_BASIC_MOB_FLEEING, FALSE)
