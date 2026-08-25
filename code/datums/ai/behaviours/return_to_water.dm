/datum/ai_behavior/return_to_water
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM

/datum/ai_behavior/return_to_water/setup(datum/ai_controller/controller, water_target_key)
	. = ..()
	var/atom/water_target = controller.blackboard[water_target_key]
	if(QDELETED(water_target))
		return FALSE
	set_movement_target(controller, water_target)
	return TRUE

/datum/ai_behavior/return_to_water/perform(seconds_per_tick, datum/ai_controller/controller, water_target_key)
	. = ..()
	var/atom/water_target = controller.blackboard[water_target_key]
	var/mob/living/simple_animal/hostile/retaliate/gator/gator_pawn = controller.pawn

	if(!istype(gator_pawn) || QDELETED(water_target))
		finish_action(controller, FALSE)
		return

	if(get_dist(gator_pawn, water_target) <= 1)
		gator_pawn.visible_message("<span class='notice'>[gator_pawn] slips into the water.</span>")
		controller.set_blackboard_key(BB_GATOR_IN_WATER, TRUE)
		finish_action(controller, TRUE)
		return
