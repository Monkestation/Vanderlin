/client/proc/end_triumph_season()
	set name = "End Current Triumph Season"
	set category = "Server"

	if(!check_rights(R_SERVER))
		return

	if(!SStriumphs.initialized)
		to_chat(src, span_warning("SStriumphs is not ready to end the season."))
		return

	if(browser_alert(src, "This will wipe ALL TRIUMPHS are you sure?", "END SEASON", DEFAULT_INPUT_CONFIRMATIONS) != CHOICE_CONFIRM)
		return

	if(browser_alert(src, "Are you REALLY sure?", "END SEASON", DEFAULT_INPUT_CONFIRMATIONS) != CHOICE_CONFIRM)
		return

	var/name = browser_input_text(src, "Give the season a name? (Leave blank for [GLOB.triumph_wipe_season + 1])", "SEASON NAME")

	SStriumphs.start_new_season(name)

	log_admin("[key_name(src)] has ended the current triumph season.")
	message_admins("[key_name(src)] has ended the current triumph season.")
