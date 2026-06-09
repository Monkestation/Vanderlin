/datum/ai_planning_subtree/cat_rest_behavior

/datum/ai_planning_subtree/cat_rest_behavior/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()

	var/mob/living/simple_animal/pet/cat/cat_pawn = controller.pawn

	// Skip if cat is dead, buckled, or has a client
	if(cat_pawn.stat || cat_pawn.buckled || cat_pawn.client)
		return

	// Rest behavior
	if(!cat_pawn.resting && prob(controller.blackboard[BB_CAT_REST_CHANCE]))
		controller.queue_behavior(/datum/ai_behavior/cat_rest)
	else if(!cat_pawn.resting && prob(controller.blackboard[BB_CAT_SIT_CHANCE]))
		controller.queue_behavior(/datum/ai_behavior/cat_sit)
	else if(cat_pawn.resting && prob(controller.blackboard[BB_CAT_GET_UP_CHANCE]))
		controller.queue_behavior(/datum/ai_behavior/cat_get_up)
	else if(!cat_pawn.resting && prob(controller.blackboard[BB_CAT_GROOM_CHANCE]))
		controller.queue_behavior(/datum/ai_behavior/cat_groom)

/datum/ai_behavior/cat_rest
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT

/datum/ai_behavior/cat_rest/perform(seconds_per_tick, datum/ai_controller/controller)
	. = ..()
	var/mob/living/simple_animal/pet/cat/cat_pawn = controller.pawn
	cat_pawn.emote("me", 1, pick("stretches out for a belly rub.", "wags its tail.", "lies down."))
	cat_pawn.icon_state = "[cat_pawn.icon_living]_rest"
	cat_pawn.set_resting(TRUE)
	finish_action(controller, TRUE)

/datum/ai_behavior/cat_sit
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT

/datum/ai_behavior/cat_sit/perform(seconds_per_tick, datum/ai_controller/controller)
	. = ..()
	var/mob/living/simple_animal/pet/cat/cat_pawn = controller.pawn
	cat_pawn.emote("me", 1, pick("sits down.", "crouches on its hind legs.", "looks alert."))
	cat_pawn.icon_state = "[cat_pawn.icon_living]_sit"
	cat_pawn.set_resting(TRUE)
	finish_action(controller, TRUE)

/datum/ai_behavior/cat_get_up
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT

/datum/ai_behavior/cat_get_up/perform(seconds_per_tick, datum/ai_controller/controller)
	. = ..()
	var/mob/living/simple_animal/pet/cat/cat_pawn = controller.pawn
	cat_pawn.emote("me", 1, pick("gets up and meows.", "walks around.", "stops resting."))
	cat_pawn.icon_state = "[cat_pawn.icon_living]"
	cat_pawn.set_resting(FALSE, instant = TRUE)
	finish_action(controller, TRUE)

/datum/ai_behavior/cat_groom
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT

/datum/ai_behavior/cat_groom/perform(seconds_per_tick, datum/ai_controller/controller)
	. = ..()
	var/mob/living/simple_animal/pet/cat/cat_pawn = controller.pawn
	cat_pawn.emote("me", 1, pick("grooms its fur.", "twitches its whiskers.", "shakes out its coat."))
	finish_action(controller, TRUE)
