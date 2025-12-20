
/client/var/commandbar_thinking = FALSE
/client/var/commandbar_typing = FALSE

/** Sets the mob as "thinking" - with indicator and the TRAIT_THINKING_IN_CHARACTER trait */
/client/proc/start_thinking()
	// ADD_TRAIT(mob, TRAIT_THINKING_IN_CHARACTER, CURRENTLY_TYPING_TRAIT)
	mob?.set_typing_indicator(TRUE)

/** Removes typing/thinking indicators and flags the mob as not thinking */
/client/proc/stop_thinking()
	mob?.set_typing_indicator(FALSE)

/**
 * Handles the user typing. After a brief period of inactivity,
 * signals the client mob to revert to the "thinking" icon.
 */
/client/proc/start_typing()
	var/mob/client_mob = mob
	client_mob.set_typing_indicator(FALSE)
	client_mob.set_typing_indicator(TRUE)
	addtimer(CALLBACK(src, PROC_REF(stop_typing)), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_STOPPABLE)

/**
 * Callback to remove the typing indicator after a brief period of inactivity.
 * If the user was typing IC, the thinking indicator is shown.
 */
/client/proc/stop_typing()
	if(isnull(mob))
		return FALSE
	var/mob/client_mob = mob
	client_mob.set_typing_indicator(FALSE)

/client/verb/open_say()
	set name = ".open_say"
	set hidden = TRUE

	if(native_say)
		native_say.open_say_window("Say")

/client/verb/open_radio()
	set name = ".open_radio"
	set hidden = TRUE

	if(native_say)
		native_say.open_say_window("Radio")

/client/verb/open_me()
	set name = ".open_me"
	set hidden = TRUE

	if(native_say)
		native_say.open_say_window("Me")

/client/verb/open_ooc()
	set name = ".open_ooc"
	set hidden = TRUE

	if(native_say)
		native_say.open_say_window("OOC")
