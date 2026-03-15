/datum/ai_planning_subtree/flesh_frenzy_subtree/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/blood/flesh = controller.pawn
	var/current_time = world.time

	if(controller.blackboard[BB_FLESH_FRENZY_COOLDOWN] > current_time)
		return

	if(controller.blackboard[BB_FLESH_FRENZY_ACTIVE])
		if(controller.blackboard[BB_FLESH_FRENZY_ACTIVE] + 30 SECONDS < current_time)
			controller.queue_behavior(/datum/ai_behavior/end_flesh_frenzy)
		return

	if((flesh.health < flesh.maxHealth * 0.3 || controller.blackboard[BB_FLESH_HUNGER] > 200) && prob(40))
		controller.queue_behavior(/datum/ai_behavior/start_flesh_frenzy)

/datum/ai_behavior/start_flesh_frenzy
	behavior_flags = AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/start_flesh_frenzy/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/blood/flesh = controller.pawn

	flesh.visible_message("<span class='danger'>[flesh] goes into a blood frenzy!</span>")
	flesh.add_filter("frenzy_outline", 2, outline_filter(2, "#FF0000"))
	playsound(flesh, 'sound/magic/barbroar.ogg', 100, TRUE)

	controller.blackboard[BB_FLESH_FRENZY_ACTIVE] = world.time
	flesh.melee_damage_lower *= 1.5
	flesh.melee_damage_upper *= 1.5
	flesh.move_to_delay *= 0.7

	finish_action(controller, TRUE)

/datum/ai_behavior/end_flesh_frenzy
	behavior_flags = AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/end_flesh_frenzy/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/blood/flesh = controller.pawn

	flesh.visible_message("<span class='notice'>[flesh] calms down.</span>")
	flesh.remove_filter("frenzy_outline")

	flesh.melee_damage_lower = initial(flesh.melee_damage_lower)
	flesh.melee_damage_upper = initial(flesh.melee_damage_upper)
	flesh.move_to_delay = initial(flesh.move_to_delay)

	controller.blackboard[BB_FLESH_FRENZY_ACTIVE] = FALSE
	controller.blackboard[BB_FLESH_FRENZY_COOLDOWN] = world.time + 2 MINUTES

	finish_action(controller, TRUE)


/datum/ai_planning_subtree/flesh_regeneration_subtree/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/blood/flesh = controller.pawn

	if(controller.blackboard[BB_FLESH_IS_REGENERATING])
		controller.queue_behavior(/datum/ai_behavior/continue_flesh_regeneration)
		return SUBTREE_RETURN_FINISH_PLANNING

	if(flesh.health < flesh.maxHealth * 0.4 && !controller.blackboard[BB_FLESH_FRENZY_ACTIVE] && prob(30))
		controller.queue_behavior(/datum/ai_behavior/start_flesh_regeneration)
		return SUBTREE_RETURN_FINISH_PLANNING

	controller.blackboard[BB_FLESH_LAST_HEALTH] = flesh.health

/datum/ai_behavior/start_flesh_regeneration
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT

/datum/ai_behavior/start_flesh_regeneration/setup(datum/ai_controller/controller)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/blood/flesh = controller.pawn

	// Find a safe place to regenerate
	var/datum/targetting_datum/targetting = controller.blackboard[BB_TARGETTING_DATUM]
	var/list/possible_regen_spots = list()
	for(var/turf/T in orange(10, flesh))
		if((IS_OPAQUE_TURF(T) || T.get_lumcount() < 0.3))
			if(!flesh.CanReach(T))
				continue

			// Check if spot is away from enemies
			var/safe = TRUE
			for(var/mob/living/L in view(5, T))
				if((targetting.can_attack(controller.pawn, L)))
					safe = FALSE
					break

			if(safe)
				possible_regen_spots += T

	if(length(possible_regen_spots))
		var/turf/regen_spot = pick(possible_regen_spots)
		set_movement_target(controller, regen_spot)
		return TRUE

	return TRUE

/datum/ai_behavior/start_flesh_regeneration/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/blood/flesh = controller.pawn

	flesh.visible_message("<span class='warning'>[flesh] hunkers down and begins to pulsate grotesquely!</span>")
	flesh.add_filter("regen_ripple", 3, ripple_filter(0, 2, flags = WAVE_BOUNDED))
	animate(flesh.get_filter("regen_ripple"), radius = 32, time = 15, size = 2, repeat = -1, flags = ANIMATION_PARALLEL)

	controller.blackboard[BB_FLESH_IS_REGENERATING] = TRUE
	controller.blackboard[BB_FLESH_LAST_HEALTH] = flesh.health

	// Clear aggro list to stop attacking while regenerating
	controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)

	finish_action(controller, TRUE)

/datum/ai_behavior/continue_flesh_regeneration
	behavior_flags = AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION
	action_cooldown = 3 SECONDS

/datum/ai_behavior/continue_flesh_regeneration/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/blood/flesh = controller.pawn

	// If we've been attacked during regeneration
	if(flesh.health < controller.blackboard[BB_FLESH_LAST_HEALTH])
		// Either go into frenzy or stop regenerating
		if(prob(50) && controller.blackboard[BB_FLESH_FRENZY_COOLDOWN] < world.time)
			controller.blackboard[BB_FLESH_IS_REGENERATING] = FALSE
			flesh.remove_filter("regen_ripple")
			controller.queue_behavior(/datum/ai_behavior/start_flesh_frenzy)
			finish_action(controller, FALSE)
			return

	// Regenerate health
	flesh.health = min(flesh.maxHealth, flesh.health + flesh.maxHealth * 0.05)
	new /obj/effect/temp_visual/heal(get_turf(flesh), "#8a0303")

	// Update last known health
	controller.blackboard[BB_FLESH_LAST_HEALTH] = flesh.health

	// Stop regenerating if we're mostly healed
	if(flesh.health > flesh.maxHealth * 0.9)
		controller.blackboard[BB_FLESH_IS_REGENERATING] = FALSE
		flesh.remove_filter("regen_ripple")
		flesh.visible_message("<span class='warning'>[flesh] shudders and rises up, looking reinvigorated.</span>")
		finish_action(controller, TRUE)
		return

	finish_action(controller, FALSE) // Continue regenerating
