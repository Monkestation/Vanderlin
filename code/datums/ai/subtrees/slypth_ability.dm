/datum/ai_planning_subtree/sylph_special_abilities
	var/datum/ai_behavior/sylph_create_shroom/shroom_behavior = /datum/ai_behavior/sylph_create_shroom

/datum/ai_planning_subtree/sylph_special_abilities/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/current_time = world.time
	var/shroom_cooldown = controller.blackboard[BB_SHROOM_COOLDOWN] || 0

	if(current_time >= shroom_cooldown)
		var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
		if(!QDELETED(target) && ismob(target))
			controller.queue_behavior(shroom_behavior, BB_BASIC_MOB_CURRENT_TARGET)

/datum/ai_behavior/sylph_create_shroom
	action_cooldown = 25 SECONDS

/datum/ai_behavior/sylph_create_shroom/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	. = ..()
	var/mob/living/simple_animal/sylph = controller.pawn
	var/atom/target = controller.blackboard[target_key]

	if(!target || !istype(sylph))
		finish_action(controller, FALSE)
		return

	target.visible_message(span_boldwarning("Kneestingers pop out from the ground around [sylph]!"))
	for(var/turf/turf as anything in RANGE_TURFS(3,sylph.loc))
		if(prob(30))
			new /obj/structure/kneestingers(turf)

	controller.set_blackboard_key(BB_SHROOM_COOLDOWN, world.time + action_cooldown)
	finish_action(controller, TRUE)
