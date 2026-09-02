/datum/ai_behavior/wave_attack_point
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM
	required_distance = 2

/datum/ai_behavior/wave_attack_point/setup(datum/ai_controller/controller, target_key)
	. = ..()
	controller.set_movement_target(type, controller.blackboard[target_key])
	return TRUE

/datum/ai_behavior/wave_attack_point/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	. = ..()
	var/atom/target_point = controller.blackboard[target_key]
	var/datum/wave_defense_coordinator/coordinator = controller.blackboard[BB_WAVE_COORDINATOR]

	var/atom/destructible = locate_destructible_near(controller, controller.pawn)
	if(destructible)
		if(isliving(destructible))
			feed_threat(controller, destructible)
		else
			controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, destructible)
		finish_action(controller, TRUE, target_key)
	else if(coordinator?.wave_state == WAVE_ADVANCING && get_dist(target_point, controller.pawn) <= required_distance)
		coordinator.begin_occupying()
		finish_action(controller, TRUE, target_key)

/datum/ai_behavior/wave_attack_point/proc/feed_threat(datum/ai_controller/controller, mob/living/target)
	var/mob/living/pawn = controller.pawn
	var/datum/component/ai_aggro_system/aggro_comp = pawn.GetComponent(/datum/component/ai_aggro_system)
	if(aggro_comp)
		aggro_comp.add_threat_to_mob_capped(target, 15, 15)
		aggro_comp.add_threat_to_mob(target, 3)
	controller.set_blackboard_key(BB_HIGHEST_THREAT_MOB, target)

/datum/ai_behavior/wave_attack_point/proc/locate_destructible_near(datum/ai_controller/controller, atom/point, radius = WAVE_DEFENSE_POINT_RADIUS)
	var/atom/movable/pawn = controller.pawn
	for(var/atom/movable/thing in view(radius, point))
		if(thing.density && !ismob(thing))
			return thing
	for(var/mob/living/enemy in oview(radius, point))
		if(!pawn.faction_check_atom(enemy))
			return enemy
	return null

/datum/ai_behavior/wave_attack_point/finish_action(datum/ai_controller/controller, succeeded, target_key)
	. = ..()
	controller.clear_blackboard_key(target_key)


/datum/ai_behavior/wave_occupy_point
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT
	required_distance = 3

/datum/ai_behavior/wave_occupy_point/setup(datum/ai_controller/controller, target_key)
	. = ..()
	controller.set_movement_target(type, controller.blackboard[target_key])
	return TRUE

/datum/ai_behavior/wave_occupy_point/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	. = ..()
	var/datum/wave_defense_coordinator/coordinator = controller.blackboard[BB_WAVE_COORDINATOR]
	coordinator?.check_occupy_progress()

	var/atom/movable/pawn = controller.pawn
	for(var/mob/living/enemy in oview(3, pawn))
		if(!pawn.faction_check_atom(enemy))
			var/datum/component/ai_aggro_system/aggro_comp = pawn.GetComponent(/datum/component/ai_aggro_system)
			if(aggro_comp)
				aggro_comp.add_threat_to_mob_capped(enemy, 15, 15)
				aggro_comp.add_threat_to_mob(enemy, 3)
			controller.set_blackboard_key(BB_HIGHEST_THREAT_MOB, enemy)
			break

	finish_action(controller, TRUE, target_key)

/datum/ai_behavior/wave_occupy_point/finish_action(datum/ai_controller/controller, succeeded, target_key)
	. = ..()
	controller.clear_blackboard_key(target_key)

/datum/ai_behavior/wave_occupy_point/finish_action(datum/ai_controller/controller, succeeded, target_key)
	. = ..()
	controller.clear_blackboard_key(target_key)
