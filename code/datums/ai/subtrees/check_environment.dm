/datum/ai_planning_subtree/fishboss_check_environment
	var/datum/ai_behavior/fishboss_use_water/water_behavior = /datum/ai_behavior/fishboss_use_water

/datum/ai_planning_subtree/fishboss_check_environment/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/mob/living/simple_animal/hostile/boss/fishboss/boss = controller.pawn
	if(!istype(boss) || boss.health > boss.maxHealth * 0.5)
		return

	// If health is low, try to find water to heal in
	for(var/obj/effect/deep_water/W in range(1, boss))
		controller.queue_behavior(water_behavior)
		break
