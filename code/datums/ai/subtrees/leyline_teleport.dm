/datum/ai_planning_subtree/leyline_teleport
	var/teleport_behavior = /datum/ai_behavior/leyline_teleport

/datum/ai_planning_subtree/leyline_teleport/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	var/cooldown = controller.blackboard[BB_TELEPORT_COOLDOWN]
	var/energy_level = controller.blackboard[BB_LEYLINE_ENERGY]

	if(QDELETED(target) || (world.time < cooldown) || (energy_level < 20))
		return

	controller.queue_behavior(teleport_behavior, BB_BASIC_MOB_CURRENT_TARGET)


/datum/ai_behavior/leyline_teleport
	action_cooldown = 7 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM

/datum/ai_behavior/leyline_teleport/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE

	set_movement_target(controller, target)

/datum/ai_behavior/leyline_teleport/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/leylinelycan/lycan = controller.pawn
	var/atom/target = controller.blackboard[target_key]

	if(QDELETED(target) || !isturf(target.loc) || !isturf(lycan.loc))
		finish_action(controller, FALSE)
		return

	// Calculate teleport target location - step twice in our direction
	var/turf/turf_target = get_step(get_step(get_turf(target), lycan.dir), lycan.dir)

	if(!isopenturf(turf_target) || !(turf_target in view(12, lycan)))
		finish_action(controller, FALSE)
		return

	// Set cooldown
	controller.set_blackboard_key(BB_TELEPORT_COOLDOWN, world.time + action_cooldown)

	// Perform teleport sequence
	var/turf/source = get_turf(lycan)
	new /obj/effect/temp_visual/lycan(turf_target, lycan)
	new /obj/effect/temp_visual/lycan(source, lycan)
	playsound(source, 'sound/misc/portalactivate.ogg', 200, 1)

	animate(lycan, alpha = 0, time = 2, easing = EASE_OUT) // fade out
	lycan.visible_message(span_warning("[lycan] dives into a leyline rift!"))

	addtimer(CALLBACK(src, PROC_REF(complete_teleport), controller, lycan, turf_target), 0.4 SECONDS)

/datum/ai_behavior/leyline_teleport/proc/complete_teleport(datum/ai_controller/controller, mob/living/simple_animal/hostile/retaliate/leylinelycan/lycan, turf/target_turf)
	if(QDELETED(lycan) || QDELETED(target_turf))
		finish_action(controller, FALSE)
		return
	var/energy_level = controller.blackboard[BB_LEYLINE_ENERGY]

	controller.set_blackboard_key(BB_LEYLINE_ENERGY, energy_level - 20)
	lycan.forceMove(target_turf)
	animate(lycan, alpha = 255, time = 2, easing = EASE_IN) // fade in
	lycan.visible_message(span_warning("[lycan] tears it's way out of the leyline rift!"))
	finish_action(controller, TRUE)
