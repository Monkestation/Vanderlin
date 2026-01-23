/client/proc/end_triumph_season()
	set name = "End Current Triumph Season"
	set category = "Server"

	if(!check_rights(R_SERVER))
		return

	if(!SStriumphs.initialized)
		to_chat(usr, span_warning("SStriumphs is not ready to end the season."))
		return

	if(browser_alert(usr, "This will wipe ALL TRIUMPHS are you sure?", "END SEASON", DEFAULT_INPUT_CONFIRMATIONS) != CHOICE_CONFIRM)
		return

	if(browser_alert(usr, "Are you REALLY sure?", "END SEASON", DEFAULT_INPUT_CONFIRMATIONS) != CHOICE_CONFIRM)
		return

	SStriumphs.start_new_season()

	log_admin("[key_name(usr)] has ended the current triumph season.")
	message_admins("[key_name(usr)] has ended the current triumph season.")
