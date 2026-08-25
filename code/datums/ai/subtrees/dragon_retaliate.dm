
/datum/ai_planning_subtree/dragon_retaliate
	var/datum/ai_behavior/dragon_retaliate/retaliate_behavior = /datum/ai_behavior/dragon_retaliate

/datum/ai_planning_subtree/dragon_retaliate/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()

	// Check if dragon was pulled
	var/mob/living/simple_animal/hostile/retaliate/voiddragon/dragon = controller.pawn
	if(dragon.pulledby)
		controller.queue_behavior(retaliate_behavior, BB_BASIC_MOB_CURRENT_TARGET)
		return SUBTREE_RETURN_FINISH_PLANNING


/datum/ai_behavior/dragon_retaliate
	action_cooldown = 0.5 SECONDS

/datum/ai_behavior/dragon_retaliate/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	var/mob/living/simple_animal/hostile/retaliate/voiddragon/dragon = controller.pawn
	var/mob/puller = dragon.pulledby

	if(puller)
		dragon.TailSwipe(puller)

	finish_action(controller, TRUE)
