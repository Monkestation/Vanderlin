/mob/dead/new_player/Login()
//	winset(client, "outputwindow.output", "max-lines=1")
//	winset(client, "outputwindow.output", "max-lines=100")

	if(CONFIG_GET(flag/use_exp_tracking))
		client.set_exp_from_db()
		client.set_db_player_flags()
	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	..()

	if(GLOB.join_motd)
		to_chat(src, span_info("MOTD:\n \t [GLOB.join_motd]"))

	if(GLOB.current_tms)
		to_chat(src, span_info("Testmerges:\n \t [GLOB.current_tms]"))

	if(GLOB.rogue_round_id)
		to_chat(src, span_info("ROUND ID: [GLOB.rogue_round_id]"))

	if(GLOB.admin_notice)
		to_chat(src, span_notice("<b>Admin Notice:</b>\n \t [GLOB.admin_notice]"))

	var/spc = CONFIG_GET(number/soft_popcap)
	if(spc && living_player_count() >= spc)
		to_chat(src, span_notice("<b>Server Notice:</b>\n \t [CONFIG_GET(string/soft_popcap_message)]"))

	sight |= SEE_TURFS

	client?.playtitlemusic()
	if(SSticker.current_state < GAME_STATE_SETTING_UP)
		var/tl = SSticker.GetTimeLeft()
		var/postfix
		if(tl > 0)
			postfix = "in about [DisplayTimeText(tl)]"
		else
			postfix = "soon"
		to_chat(src, "The game will start [postfix].")
		if(client)
			var/usedkey = get_display_ckey(ckey)
			var/list/thinz = list("takes [client.p_their()] seat.", "settles in.", "joins the session", "joins the table.", "becomes a player.")
			SEND_TEXT(world, "<span class='notice'>[usedkey] [pick(thinz)]</span>")

	// client?.change_view(8)
	// sleep(1 SECONDS)
	client?.view_size?.resetToDefault()
