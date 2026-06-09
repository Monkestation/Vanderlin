/datum/ai_planning_subtree/behemoth_special_abilities
	var/datum/ai_behavior/behemoth_quake/quake_behavior = /datum/ai_behavior/behemoth_quake

/datum/ai_planning_subtree/behemoth_special_abilities/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]

	if(QDELETED(target))
		return

	// Decide whether to use quake (20% chance when off cooldown)
	var/quake_cooldown = controller.blackboard[BB_QUAKE_COOLDOWN]
	if(world.time > quake_cooldown && prob(20))
		controller.queue_behavior(quake_behavior, BB_BASIC_MOB_CURRENT_TARGET)
		controller.blackboard[BB_QUAKE_COOLDOWN] = world.time + 20 SECONDS
		return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_behavior/behemoth_quake
	action_cooldown = 3 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM
	required_distance = 3

/datum/ai_behavior/behemoth_quake/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE

	set_movement_target(controller, target)

/datum/ai_behavior/behemoth_quake/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	. = ..()
	var/mob/living/simple_animal/behemoth_pawn = controller.pawn
	var/atom/target = controller.blackboard[target_key]

	if(!target || !istype(behemoth_pawn))
		finish_action(controller, FALSE)
		return

	var/turf/focalpoint = get_turf(target)
	for (var/turf/open/visual in view(1, focalpoint))
		new /obj/effect/temp_visual/marker(visual)
	sleep(1.5 SECONDS)
	for (var/mob/living/screenshaken in view(1, focalpoint))
		shake_camera(screenshaken, 5, 5)
	for (var/mob/living/shaken in view(1, focalpoint))
		to_chat(shaken, span_danger("<B>The ground ruptures beneath your feet!</B>"))
		shaken.Paralyze(50)
		var/obj/structure/flora/rock/giant_rock = new(get_turf(shaken))
		QDEL_IN(giant_rock, 200)

	finish_action(controller, TRUE)
