/mob/Logout()
	SEND_SIGNAL(src, COMSIG_MOB_LOGOUT)
	log_message("[key_name(src)] is no longer owning mob [src]([src.type])", LOG_OWNERSHIP)
	SStgui.on_logout(src)
	unset_machine()
	set_typing_indicator(FALSE)
	GLOB.player_list -= src
	update_ambience_area(null) // Unset ambience vars so it plays again on login
	..()

	if(loc)
		loc.on_log(FALSE)

	if(client)
		for(var/datum/callback/CB as anything in client.player_details.post_logout_callbacks)
			CB.Invoke()

	clear_important_client_contents(client)
	remove_all_uis()
	return TRUE
