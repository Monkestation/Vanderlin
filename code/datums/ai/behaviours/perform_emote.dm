/datum/ai_behavior/perform_emote

/datum/ai_behavior/perform_emote/perform(delta_time, datum/ai_controller/controller, emote)
	. = ..()
	var/mob/living/living_pawn = controller.pawn
	if(!istype(living_pawn))
		return
	living_pawn.manual_emote(emote)
	finish_action(controller, TRUE)

/**
* Allows the intrepid coder to send a basic emote
* Takes text as input, sends it out to those who need to know after some light parsing
* If you need something more complex, make it into a datum emote
* Arguments:
* * text - The text to send out
*
* Returns TRUE if it was able to run the emote, FALSE otherwise.
*/
/atom/proc/manual_emote(text)
	if(!text)
		CRASH("Someone passed nothing to manual_emote(), fix it")

	log_message(text, LOG_EMOTE)
	visible_message(span_emote("[name] [text]"))
	return TRUE

/mob/manual_emote(text)
	if (stat != CONSCIOUS)
		return FALSE
	. = ..()
	if (!.)
		return FALSE
	if (!client)
		return TRUE
	var/ghost_text = "<b>[src]</b> [text]"
	var/origin_turf = get_turf(src)
	for(var/mob/ghost as anything in GLOB.dead_mob_list)
		if(!ghost.client || isnewplayer(ghost))
			continue
		if(ghost.client.prefs.chat_toggles & CHAT_GHOSTSIGHT && !(ghost in viewers(origin_turf, null)))
			ghost.show_message("[FOLLOW_LINK(ghost, src)] [ghost_text]")
	return TRUE
