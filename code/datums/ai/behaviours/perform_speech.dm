/datum/ai_behavior/perform_speech

/datum/ai_behavior/perform_speech/perform(delta_time, datum/ai_controller/controller, speech)
	. = ..()
	var/mob/living/living_pawn = controller.pawn
	if(!istype(living_pawn))
		return
	living_pawn.say(speech, forced = "AI Controller")
	finish_action(controller, TRUE)
