/datum/ai_planning_subtree/glimmerwing_special_abilities
	var/datum/ai_behavior/glimmerwing_drug/shroom_behavior = /datum/ai_behavior/glimmerwing_drug

/datum/ai_planning_subtree/glimmerwing_special_abilities/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/current_time = world.time
	var/shroom_cooldown = controller.blackboard[BB_DRUG_COOLDOWN] || 0

	if(current_time >= shroom_cooldown)
		var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
		if(!QDELETED(target) && ismob(target))
			controller.queue_behavior(shroom_behavior, BB_BASIC_MOB_CURRENT_TARGET)

/datum/ai_behavior/glimmerwing_drug
	action_cooldown = 25 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH

/datum/ai_behavior/glimmerwing_drug/setup(datum/ai_controller/controller, target_key)
	. = ..()
	//Hiding location is priority
	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE
	set_movement_target(controller, (target))
	SEND_SIGNAL(controller.pawn, COMSIG_COMBAT_TARGET_SET, TRUE)


/datum/ai_behavior/glimmerwing_drug/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	. = ..()
	var/mob/living/simple_animal/sylph = controller.pawn
	var/mob/living/target = controller.blackboard[target_key]
	if(!isliving(target))
		finish_action(controller, FALSE)
		return

	if(!target || !istype(sylph))
		finish_action(controller, FALSE)
		return

	target.visible_message(span_boldwarning("Kneestingers pop out from the ground around [sylph]!"))
	target.apply_status_effect(/datum/status_effect/buff/seelie_drugs)
	target.visible_message(span_danger("[sylph] dusts [target] with some kind of powder!"))
	target.adjustToxLoss(15)

	controller.set_blackboard_key(BB_DRUG_COOLDOWN, world.time + action_cooldown)
	finish_action(controller, TRUE)
