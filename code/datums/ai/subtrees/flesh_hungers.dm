/datum/ai_planning_subtree/flesh_hunger_subtree/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/hunger = controller.blackboard[BB_FLESH_HUNGER]

	// Increment hunger over time
	controller.blackboard[BB_FLESH_HUNGER] = min(250, hunger + (seconds_per_tick * 0.1))

	// Prioritize eating when very hungry
	if(hunger > 150 && !controller.blackboard[BB_FLESH_IS_REGENERATING])
		controller.queue_behavior(/datum/ai_behavior/find_food_urgently)

/datum/ai_behavior/find_food_urgently
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM
	action_cooldown = 10 SECONDS

/datum/ai_behavior/find_food_urgently/setup(datum/ai_controller/controller)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/blood/flesh = controller.pawn

	// Look for bodies or food items nearby
	var/list/possible_food = list()

	// Check for dead bodies
	for(var/mob/living/L in view(10, flesh))
		if(L.stat == DEAD)
			possible_food += L

	// Check for meat/organs on the ground
	for(var/obj/item/I in view(10, flesh))
		if(is_type_in_list(I, flesh.food_type))
			possible_food += I

	if(length(possible_food))
		var/atom/food_target = pick(possible_food)
		set_movement_target(controller, food_target)
		controller.blackboard[BB_TEMP_FOOD_TARGET] = food_target
		return TRUE

	return FALSE

/datum/ai_behavior/find_food_urgently/perform(seconds_per_tick, datum/ai_controller/controller)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/blood/flesh = controller.pawn
	var/atom/food_target = controller.blackboard[BB_TEMP_FOOD_TARGET]

	if(QDELETED(food_target) || !flesh.CanReach(food_target))
		finish_action(controller, FALSE)
		return

	// Try to eat the food
	if(istype(food_target, /mob/living))
		var/mob/living/L = food_target
		if(L.stat == DEAD)
			flesh.visible_message("<span class='danger'>[flesh] tears into [L] ravenously!</span>")
			L.gib()
			controller.blackboard[BB_FLESH_HUNGER] = max(0, controller.blackboard[BB_FLESH_HUNGER] - 100)
			controller.blackboard[BB_FLESH_CONSUMED_BODIES]++

			// Chance to grow stronger after consuming enough bodies
			if(controller.blackboard[BB_FLESH_CONSUMED_BODIES] % 3 == 0)
				flesh.maxHealth += 50
				flesh.health = min(flesh.health + 50, flesh.maxHealth)
				flesh.melee_damage_lower += 5
				flesh.melee_damage_upper += 5
				flesh.visible_message("<span class='danger'>[flesh] pulses with new strength!</span>")

			finish_action(controller, TRUE)
			return
	else if(is_type_in_list(food_target, flesh.food_type))
		flesh.visible_message("<span class='warning'>[flesh] consumes [food_target]!</span>")
		controller.blackboard[BB_FLESH_HUNGER] = max(0, controller.blackboard[BB_FLESH_HUNGER] - 50)
		qdel(food_target)
		finish_action(controller, TRUE)
		return

	finish_action(controller, FALSE)
