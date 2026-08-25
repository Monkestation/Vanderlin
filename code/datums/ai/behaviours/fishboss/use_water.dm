
/datum/ai_behavior/fishboss_use_water
	action_cooldown = 5 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT

/datum/ai_behavior/fishboss_use_water/setup(datum/ai_controller/controller)
	. = ..()
	var/mob/living/simple_animal/hostile/boss/fishboss/boss = controller.pawn
	if(!istype(boss))
		return FALSE

	// Find nearest water
	var/obj/effect/deep_water/closest_water = null
	var/closest_dist = INFINITY

	for(var/obj/effect/deep_water/W in view(8, boss))
		var/dist = get_dist(boss, W)
		if(dist < closest_dist)
			closest_dist = dist
			closest_water = W

	if(closest_water)
		set_movement_target(controller, get_turf(closest_water))
		return TRUE

	return FALSE

/datum/ai_behavior/fishboss_use_water/perform(seconds_per_tick, datum/ai_controller/controller)
	. = ..()
	var/mob/living/simple_animal/hostile/boss/fishboss/boss = controller.pawn
	if(!istype(boss))
		finish_action(controller, FALSE)
		return

	// Check if we're on a water tile
	var/obj/effect/deep_water/W = locate() in get_turf(boss)
	if(W)
		boss.visible_message("<span class='warning'>[boss] submerges in the deep water, its wounds visibly healing!</span>")
		boss.adjustHealth(-50) // Larger heal from actively seeking water
		new /obj/effect/temp_visual/heal(get_turf(boss))

		// Create some splash effects
		var/datum/effect_system/smoke_spread/splash = new
		splash.set_up(3, 0, get_turf(boss))
		splash.start()

	finish_action(controller, TRUE)
