/datum/ai_planning_subtree/collossus_special_abilities
	var/datum/ai_behavior/collossus_quake/quake_behavior = /datum/ai_behavior/collossus_quake

/datum/ai_planning_subtree/collossus_special_abilities/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]

	if(QDELETED(target))
		return

	// Decide whether to use quake (20% chance when off cooldown)
	var/quake_cooldown = controller.blackboard[BB_EARTHQUAKE_COOLDOWN]
	if(world.time > quake_cooldown && prob(20))
		controller.queue_behavior(quake_behavior, BB_BASIC_MOB_CURRENT_TARGET)
		controller.blackboard[BB_EARTHQUAKE_COOLDOWN] = world.time + 25 SECONDS
		return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_behavior/collossus_quake
	action_cooldown = 3 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM
	required_distance = 3

/datum/ai_behavior/collossus_quake/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE

	set_movement_target(controller, target)

/datum/ai_behavior/collossus_quake/perform(delta_time, datum/ai_controller/controller, target_key)
	. = ..()
	var/mob/living/simple_animal/behemoth_pawn = controller.pawn
	var/atom/target = controller.blackboard[target_key]

	if(!target || !istype(behemoth_pawn))
		finish_action(controller, FALSE)
		return

	for (var/mob/living/stomped in view(1, behemoth_pawn))
		new	/obj/effect/temp_visual/stomp(stomped)
		var/atom/throw_target = get_edge_target_turf(behemoth_pawn, get_dir(behemoth_pawn, stomped)) //ill be real I got no idea why this worked.
		var/mob/living/L = stomped
		L.throw_at(throw_target, 7, 4)
		L.adjustBruteLoss(20, damage_type = BCLASS_BLUNT)

	finish_action(controller, TRUE)
