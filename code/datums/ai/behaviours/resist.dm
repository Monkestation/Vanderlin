/datum/ai_behavior/resist/perform(seconds_per_tick, datum/ai_controller/controller)
	. = ..()
	var/mob/living/living_pawn = controller.pawn
	living_pawn.execute_resist()
	finish_action(controller, TRUE)

/datum/ai_behavior/resist/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	var/mob/living/living_pawn = controller.pawn
	if(QDELETED(living_pawn))
		return
	if(SHOULD_RESIST(living_pawn))
		living_pawn.ai_controller.set_blackboard_key(BB_RESISTING, TRUE)
	else
		living_pawn.ai_controller.set_blackboard_key(BB_RESISTING, FALSE)
