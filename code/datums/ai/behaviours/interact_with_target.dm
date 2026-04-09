///behavior for general interactions with any targets
/datum/ai_behavior/interact_with_target
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH
	///should we be clearing the target after the fact?
	var/clear_target = TRUE
	///should our combat mode be on during interaction?
	var/combat_mode = TRUE
	///Any params to be handed to OnClick()
	var/list/interact_params

/datum/ai_behavior/interact_with_target/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE
	set_movement_target(controller, target)

/datum/ai_behavior/interact_with_target/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	. = ..()
	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target) || !pre_interact(controller, target))
		finish_action(controller, FALSE)
		return FALSE
	controller.ai_interact(target, combat_mode, interact_params)
	finish_action(controller, TRUE)
	return TRUE

/datum/ai_behavior/interact_with_target/finish_action(datum/ai_controller/controller, succeeded, target_key)
	. = ..()
	if(clear_target || !succeeded)
		controller.clear_blackboard_key(target_key)

/datum/ai_behavior/interact_with_target/proc/pre_interact(datum/ai_controller/controller, target)
	return TRUE

///-----------Leech interacts----------///
/datum/ai_behavior/interact_with_target/drink_blood
	interact_params = list(RIGHT_CLICK = TRUE, BUTTON_CHANGED = RIGHT_CLICK)

/datum/ai_behavior/interact_with_target/drink_blood/setup(datum/ai_controller/controller, target_key)
	var/mob/living/living_pawn = controller.pawn
	if(living_pawn?.GetComponent(/datum/component/generic_mob_hunger))
		return ..()
	return FALSE // we cant even hunger to do this

/datum/ai_behavior/interact_with_target/drink_blood/finish_action(datum/ai_controller/controller, succeeded, target_key)
	var/mob/living/living_pawn = controller.pawn
	if(living_pawn)
		var/drinking = DOING_INTERACTION(living_pawn, DOAFTER_SOURCE_LEECH_BLOOD)
		if(succeeded)
			if(drinking)
				return //we're still drinking, and succeeding to, so let's not stop yet
		if(drinking) // something wants us to stop so we probably should!
			living_pawn.stop_doing(DOAFTER_SOURCE_LEECH_BLOOD)
	return ..()

/// feed blood instead of drink it by not being in combat mode
/datum/ai_behavior/interact_with_target/drink_blood/feed
	combat_mode = FALSE
