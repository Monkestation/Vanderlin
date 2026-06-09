/// Use in hand the currently held item
/datum/ai_behavior/use_in_hand
	behavior_flags = AI_BEHAVIOR_MOVE_AND_PERFORM

/datum/ai_behavior/use_in_hand/perform(seconds_per_tick, datum/ai_controller/controller)
	. = ..()
	var/mob/living/pawn = controller.pawn
	var/obj/item/held = pawn.get_active_held_item()
	if(!held)
		finish_action(controller, FALSE)
		return
	pawn.activate_hand(pawn.active_hand_index)
	finish_action(controller, TRUE)
