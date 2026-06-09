/datum/ai_behavior/find_water_source
	behavior_flags = AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/find_water_source/setup(datum/ai_controller/controller, search_range)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/gator/gator_pawn = controller.pawn
	if(!istype(gator_pawn))
		return FALSE

	var/list/possible_water_sources = list()
	for(var/turf/T in range(search_range, gator_pawn))
		if(istype(T, /turf/open/water) && !istype(T, /turf/open/water/river))
			possible_water_sources += T

	if(length(possible_water_sources))
		var/turf/chosen_water = pick(possible_water_sources)
		controller.set_blackboard_key(BB_GATOR_PREFERRED_TERRITORY, chosen_water)
		set_movement_target(controller, chosen_water)
		return TRUE
	return FALSE

/datum/ai_behavior/find_water_source/perform(seconds_per_tick, datum/ai_controller/controller, search_range)
	. = ..()
	finish_action(controller, TRUE)
