/datum/admins/proc/CheckAdminHref(href, href_list)
	var/auth = href_list["admin_token"]
	. = auth && (auth == href_token || auth == GLOB.href_token)
	if(.)
		return
	var/msg = !auth ? "no" : "a bad"
	message_admins("[key_name_admin(usr)] clicked an href with [msg] authorization key!")
	if(CONFIG_GET(flag/debug_admin_hrefs))
		message_admins("Debug mode enabled, call not blocked. Please ask my coders to review this round's logs.")
		log_world("UAH: [href]")
		return TRUE
	log_admin_private("[key_name_admin(usr)] clicked an href with [msg] authorization key! [href]")

/datum/admins/Topic(href, href_list)
	..()

	if(usr.client != src.owner || !check_rights(0))
		message_admins("[usr.key] has attempted to override the admin panel!")
		log_admin("[key_name_admin(usr)] tried to use the admin panel without authorization.")
		return

	if(!CheckAdminHref(href, href_list))
		return

	if(href_list["ahelp"])
		if(!check_rights(R_ADMIN, TRUE))
			return

		var/ahelp_ref = href_list["ahelp"]
		var/datum/admin_help/AH = locate(ahelp_ref)
		if(AH)
			AH.Action(href_list["ahelp_action"])
		else
			to_chat(usr, "Ticket [ahelp_ref] has been deleted!")

	else if(href_list["ahelp_tickets"])
		GLOB.ahelp_tickets.BrowseTickets(text2num(href_list["ahelp_tickets"]))

	else if(href_list["getplaytimewindow"])
		if(!check_rights(R_ADMIN))
			return
		var/mob/M = locate(href_list["getplaytimewindow"]) in GLOB.mob_list
		if(!M)
			to_chat(usr, "<span class='danger'>ERROR: Mob not found.</span>")
			return
		cmd_show_exp_panel(M.client)

	else if(href_list["toggleexempt"])
		if(!check_rights(R_ADMIN))
			return
		var/client/C = locate(href_list["toggleexempt"]) in GLOB.clients
		if(!C)
			to_chat(usr, "<span class='danger'>ERROR: Client not found.</span>")
			return
		toggle_exempt_status(C)

	else if(href_list["forceevent"])
		if(!check_rights(R_FUN))
			return
		var/datum/round_event_control/E = locate(href_list["forceevent"]) in SSevents.control
		if(E)
			E.admin_setup(usr)
			var/datum/round_event/event = E.runEvent()
			if(event.announceWhen>0)
				event.processing = FALSE
				var/prompt = alert(usr, "Would you like to alert the crew?", "Alert", "Yes", "No", "Cancel")
				switch(prompt)
					if("Yes")
						event.announceChance = 100
					if("Cancel")
						event.kill()
						return
					if("No")
						event.announceChance = 0
				event.processing = TRUE
			message_admins("[key_name_admin(usr)] has triggered an event. ([E.name])")
			log_admin("[key_name(usr)] has triggered an event. ([E.name])")
		return

	else if(href_list["editrightsbrowser"])
		edit_admin_permissions(0)

	else if(href_list["editrightsbrowserlog"])
		edit_admin_permissions(1, href_list["editrightstarget"], href_list["editrightsoperation"], href_list["editrightspage"])

	if(href_list["editrightsbrowsermanage"])
		if(href_list["editrightschange"])
			change_admin_rank(ckey(href_list["editrightschange"]), href_list["editrightschange"], TRUE)
		else if(href_list["editrightsremove"])
			remove_admin(ckey(href_list["editrightsremove"]), href_list["editrightsremove"], TRUE)
		else if(href_list["editrightsremoverank"])
			remove_rank(href_list["editrightsremoverank"])
		edit_admin_permissions(2)

	else if(href_list["editrights"])
		edit_rights_topic(href_list)

	else if(href_list["gamemode_panel"])
		if(!check_rights(R_ADMIN))
			return
		forceGamemode(usr)

	else if(href_list["delay_round_end"])
		if(!check_rights(R_SERVER))
			return

		if(!SSticker.delay_end)
			SSticker.admin_delay_notice = input(usr, "Enter a reason for delaying the round end", "Round Delay Reason") as null|text
			if(isnull(SSticker.admin_delay_notice))
				return
		else
			if(alert(usr, "Really cancel current round end delay? The reason for the current delay is: \"[SSticker.admin_delay_notice]\"", "Undelay round end", "Yes", "No") != "Yes")
				return
			SSticker.admin_delay_notice = null

		SSticker.delay_end = !SSticker.delay_end

		var/reason = SSticker.delay_end ? "for reason: [SSticker.admin_delay_notice]" : "."//laziness
		var/msg = "[SSticker.delay_end ? "delayed" : "undelayed"] the round end [reason]"

		log_admin("[key_name(usr)] [msg]")
		message_admins("[key_name_admin(usr)] [msg]")

		if(SSticker.delay_end)
			if(SSticker.reboot_timer)
				SSticker.cancel_reboot(usr)
		else if(SSticker.ready_for_reboot)
			SSticker.standard_reboot()

	else if(href_list["end_round"])
		if(!check_rights(R_ADMIN))
			return

		message_admins("<span class='adminnotice'>[key_name_admin(usr)] is considering ending the round.</span>")
		if(alert(usr, "This will end the round, are you SURE you want to do this?", "Confirmation", "Yes", "No") == "Yes")
			if(alert(usr, "Final Confirmation: End the round NOW?", "Confirmation", "Yes", "No") == "Yes")
				message_admins("<span class='adminnotice'>[key_name_admin(usr)] has ended the round.</span>")
				SSticker.force_ending = 1 //Yeah there we go APC destroyed mission accomplished
				return
			else
				message_admins("<span class='adminnotice'>[key_name_admin(usr)] decided against ending the round.</span>")
		else
			message_admins("<span class='adminnotice'>[key_name_admin(usr)] decided against ending the round.</span>")

	else if(href_list["simplemake"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/M = locate(href_list["mob"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob.")
			return

		var/delmob = TRUE
		if(!isobserver(M))
			switch(alert("Delete old mob?","Message","Yes","No","Cancel"))
				if("Cancel")
					return
				if("No")
					delmob = FALSE

		log_admin("[key_name_admin(usr)] has used rudimentary transformation on [key_name(M)]. Transforming to [href_list["simplemake"]].; deletemob=[delmob]")
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] has used rudimentary transformation on [key_name_admin(M)]. Transforming to [href_list["simplemake"]].; deletemob=[delmob]</span>")
		switch(href_list["simplemake"])
			if("observer")
				M.change_mob_type( /mob/dead/observer , null, null, delmob )
			if("human")
				var/posttransformoutfit = usr.client.robust_dress_shop()
				if (!posttransformoutfit)
					return
				var/mob/living/carbon/human/newmob = M.change_mob_type( /mob/living/carbon/human , null, null, delmob )
				if(posttransformoutfit && istype(newmob))
					newmob.equipOutfit(posttransformoutfit)
			if("monkey")
				M.change_mob_type( /mob/living/carbon/monkey , null, null, delmob )
			if("cat")
				M.change_mob_type( /mob/living/simple_animal/pet/cat , null, null, delmob )

	else if(href_list["boot2"])
		if(!check_rights(R_ADMIN))
			return
		var/mob/M = locate(href_list["boot2"])
		if(ismob(M))
			if(!check_if_greater_rights_than(M.client))
				to_chat(usr, "<span class='danger'>Error: They have more rights than you do.</span>")
				return
			if(alert(usr, "Kick [key_name(M)]?", "Confirm", "Yes", "No") != "Yes")
				return
			if(!M)
				to_chat(usr, "<span class='danger'>Error: [M] no longer exists!</span>")
				return
			if(!M.client)
				to_chat(usr, "<span class='danger'>Error: [M] no longer has a client!</span>")
				return
			to_chat(M, "<span class='danger'>I have been kicked from the server by [usr.client.holder.fakekey ? "an Administrator" : "[usr.client.key]"].</span>")
			log_admin("[key_name(usr)] kicked [key_name(M)].")
			message_admins("<span class='adminnotice'>[key_name_admin(usr)] kicked [key_name_admin(M)].</span>")
			qdel(M.client)

	else if(href_list["addmessage"])
		if(!check_rights(R_ADMIN))
			return
		var/target_key = href_list["addmessage"]
		create_message("message", target_key, secret = 0)

	else if(href_list["addnote"])
		if(!check_rights(R_ADMIN))
			return
		var/target_key = href_list["addnote"]
		create_message("note", target_key)

	else if(href_list["addwatch"])
		if(!check_rights(R_ADMIN))
			return
		var/target_key = href_list["addwatch"]
		create_message("watchlist entry", target_key, secret = 1)

	else if(href_list["addmemo"])
		if(!check_rights(R_ADMIN))
			return
		create_message("memo", secret = 0, browse = 1)

	else if(href_list["addmessageempty"])
		if(!check_rights(R_ADMIN))
			return
		create_message("message", secret = 0)

	else if(href_list["addnoteempty"])
		if(!check_rights(R_ADMIN))
			return
		create_message("note")

	else if(href_list["addwatchempty"])
		if(!check_rights(R_ADMIN))
			return
		create_message("watchlist entry", secret = 1)

	else if(href_list["deletemessage"])
		if(!check_rights(R_ADMIN))
			return
		var/safety = alert("Delete message/note?",,"Yes","No");
		if (safety == "Yes")
			var/message_id = href_list["deletemessage"]
			delete_message(message_id)

	else if(href_list["deletemessageempty"])
		if(!check_rights(R_ADMIN))
			return
		var/safety = alert("Delete message/note?",,"Yes","No");
		if (safety == "Yes")
			var/message_id = href_list["deletemessageempty"]
			delete_message(message_id, browse = TRUE)

	else if(href_list["editmessage"])
		if(!check_rights(R_ADMIN))
			return
		var/message_id = href_list["editmessage"]
		edit_message(message_id)

	else if(href_list["editmessageempty"])
		if(!check_rights(R_ADMIN))
			return
		var/message_id = href_list["editmessageempty"]
		edit_message(message_id, browse = 1)

	else if(href_list["editmessageexpiry"])
		if(!check_rights(R_ADMIN))
			return
		var/message_id = href_list["editmessageexpiry"]
		edit_message_expiry(message_id)

	else if(href_list["editmessageexpiryempty"])
		if(!check_rights(R_ADMIN))
			return
		var/message_id = href_list["editmessageexpiryempty"]
		edit_message_expiry(message_id, browse = 1)

	else if(href_list["editmessageseverity"])
		if(!check_rights(R_ADMIN))
			return
		var/message_id = href_list["editmessageseverity"]
		edit_message_severity(message_id)

	else if(href_list["secretmessage"])
		if(!check_rights(R_ADMIN))
			return
		var/message_id = href_list["secretmessage"]
		toggle_message_secrecy(message_id)

	else if(href_list["searchmessages"])
		if(!check_rights(R_ADMIN))
			return
		var/target = href_list["searchmessages"]
		browse_messages(index = target)

	else if(href_list["nonalpha"])
		if(!check_rights(R_ADMIN))
			return
		var/target = href_list["nonalpha"]
		target = text2num(target)
		browse_messages(index = target)

	else if(href_list["showmessages"])
		if(!check_rights(R_ADMIN))
			return
		var/target = href_list["showmessages"]
		browse_messages(index = target)

	else if(href_list["showmemo"])
		if(!check_rights(R_ADMIN))
			return
		browse_messages("memo")

	else if(href_list["showwatch"])
		if(!check_rights(R_ADMIN))
			return
		browse_messages("watchlist entry")

	else if(href_list["showwatchfilter"])
		if(!check_rights(R_ADMIN))
			return
		browse_messages("watchlist entry", filter = 1)

	else if(href_list["showmessageckey"])
		if(!check_rights(R_ADMIN))
			return
		var/target = href_list["showmessageckey"]
		var/agegate = TRUE
		if (href_list["showall"])
			agegate = FALSE
		browse_messages(target_ckey = target, agegate = agegate)

	else if(href_list["showmessageckeylinkless"])
		var/target = href_list["showmessageckeylinkless"]
		browse_messages(target_ckey = target, linkless = 1)

	else if(href_list["messageedits"])
		if(!check_rights(R_ADMIN))
			return
		var/datum/DBQuery/query_get_message_edits = SSdbcore.NewQuery(
			"SELECT edits FROM [format_table_name("messages")] WHERE id = :message_id",
			list("message_id" = href_list["messageedits"])
		)
		if(!query_get_message_edits.warn_execute())
			qdel(query_get_message_edits)
			return
		if(query_get_message_edits.NextRow())
			var/edit_log = query_get_message_edits.item[1]
			if(!QDELETED(usr))
				var/datum/browser/browser = new(usr, "Note edits", "Note edits")
				browser.set_content(jointext(edit_log, ""))
				browser.open()
		qdel(query_get_message_edits)

	else if(href_list["mute"])
		if(!check_rights(R_ADMIN))
			return
		cmd_admin_mute(href_list["mute"], text2num(href_list["mute_type"]))

	else if(href_list["c_mode"])
		return HandleCMode()

	else if(href_list["f_secret"])
		return HandleFSecret()

	else if(href_list["c_mode2"])
		if(!check_rights(R_ADMIN|R_SERVER))
			return

		if (SSticker.HasRoundStarted())
			if(browser_alert(usr, "The game has already started. Would you like to save this as the default mode effective next round?", "Save mode", DEFAULT_INPUT_CHOICES) == CHOICE_YES)
				SSticker.save_mode(href_list["c_mode2"])
			HandleCMode()
			return
		GLOB.master_mode = href_list["c_mode2"]
		log_admin("[key_name_admin(usr)] set the mode as [GLOB.master_mode].")
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] set the mode as [GLOB.master_mode].</span>")
		to_chat(world, "<span class='adminnotice'><b>The mode is now: [GLOB.master_mode]</b></span>")
		Game() // updates the main game menu
		if(browser_alert(usr, "Would you like to save this as the default mode for the server?", "Save mode", DEFAULT_INPUT_CHOICES) == CHOICE_YES)
			SSticker.save_mode(GLOB.master_mode)
		HandleCMode()

	else if(href_list["f_secret2"])
		if(!check_rights(R_ADMIN|R_SERVER))
			return

		if(SSticker.HasRoundStarted())
			return alert(usr, "The game has already started.", null, null, null, null)
		if(GLOB.master_mode != "secret")
			return alert(usr, "The game mode has to be secret!", null, null, null, null)
		GLOB.secret_force_mode = href_list["f_secret2"]
		log_admin("[key_name_admin(usr)] set the forced secret mode as [GLOB.secret_force_mode].")
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] set the forced secret mode as [GLOB.secret_force_mode].</span>")
		Game() // updates the main game menu
		HandleFSecret()

	else if(href_list["monkeyone"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/human/H = locate(href_list["monkeyone"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human.")
			return

		log_admin("[key_name_admin(usr)] attempting to monkeyize [key_name(H)].")
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] attempting to monkeyize [key_name_admin(H)].</span>")
		H.monkeyize()

	else if(href_list["humanone"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/monkey/Mo = locate(href_list["humanone"])
		if(!istype(Mo))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/monkey.")
			return

		log_admin("[key_name_admin(usr)] attempting to humanize [key_name(Mo)].")
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] attempting to humanize [key_name_admin(Mo)].</span>")
		Mo.humanize()

	else if(href_list["forcespeech"])
		if(!check_rights(R_FUN))
			return

		var/mob/M = locate(href_list["forcespeech"])
		if(!ismob(M))
			to_chat(usr, "this can only be used on instances of type /mob.")

		var/speech = input("What will [key_name(M)] say?", "Force speech", "")// Don't need to sanitize, since it does that in say(), we also trust our admins.
		if(!speech)
			return
		M.say(speech, forced = "admin speech")
		speech = sanitize(speech) // Nah, we don't trust them
		log_admin("[key_name_admin(usr)] forced [key_name(M)] to say: [speech]")
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] forced [key_name_admin(M)] to say: [speech]</span>")

	else if(href_list["sendtoprison"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["sendtoprison"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob.")
			return

		if(alert(usr, "Send [key_name(M)] to Prison?", "Message", "Yes", "No") != "Yes")
			return

		M.forceMove(pick(GLOB.prisonwarp))
		to_chat(M, "<span class='adminnotice'>I have been sent to Prison!</span>")

		log_admin("[key_name(usr)] has sent [key_name(M)] to Prison!")
		message_admins("[key_name_admin(usr)] has sent [key_name_admin(M)] to Prison!")

	else if(href_list["sendbacktolobby"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["sendbacktolobby"])

		if(alert(usr, "Send [key_name(M)] back to Lobby?", "Message", "Yes", "No") != "Yes")
			return
		var/living = isliving(M)
		if(living)
			if(alert(usr, "[key_name(M)] is a LIVING MOB. Are you sure you want to send him back?", "Message", "Yes", "No") != "Yes")
				return
		if(!M.client)
			to_chat(usr, "<span class='warning'>[M] doesn't seem to have an active client.</span>")
			return
		log_admin("[key_name_admin(usr)] has sent [key_name(M)] back to the Lobby.")
		message_admins("[key_name_admin(usr)] sent [key_name_admin(M)] back to the lobby")

		var/mob/dead/new_player/NP = new()
		NP.ckey = M.ckey
		if(living)
			if(alert(usr, "Would you like to also delete the living mob [key_name(M)]?", "Message", "Yes", "No") == "Yes")
				log_admin("[key_name(usr)] has chosen to delete \the [M] mob while sending the client to lobby.")
				qdel(M)
		else
			qdel(M)

	else if(href_list["cryomob"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["cryomob"])
		usr.client.send_to_cryo(M)

	else if(href_list["revive"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/living/L = locate(href_list["revive"])
		if(!istype(L))
			to_chat(usr, "This can only be used on instances of type /mob/living.")
			return

		L.revive(ADMIN_HEAL_ALL)
		message_admins("<span class='danger'>Admin [key_name_admin(usr)] healed / revived [key_name_admin(L)]!</span>")
		log_admin("[key_name(usr)] healed / Revived [key_name(L)].")

	else if(href_list["makeanimal"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/M = locate(href_list["makeanimal"])
		if(isnewplayer(M))
			to_chat(usr, "This cannot be used on instances of type /mob/dead/new_player.")
			return

		usr.client.cmd_admin_animalize(M)

	else if(href_list["adminplayeropts"])
		var/mob/M = locate(href_list["adminplayeropts"])
		show_player_panel(M)

	else if(href_list["ppbyckey"])
		var/target_ckey = href_list["ppbyckey"]
		var/mob/original_mob = locate(href_list["ppbyckeyorigmob"]) in GLOB.mob_list
		var/mob/target_mob = get_mob_by_ckey(target_ckey)
		if(!target_mob)
			to_chat(usr, span_warning("No mob found with that ckey."))
			return

		if(original_mob == target_mob)
			to_chat(usr, span_warning("[target_ckey] is still in their original mob: [original_mob]."))
			return

		to_chat(usr, span_notice("Jumping to [target_ckey]'s new mob: [target_mob]!"))
		show_player_panel(target_mob)

	else if(href_list["adminplayerobservefollow"])
		if(!isobserver(usr) && !check_rights(R_ADMIN))
			return

		var/atom/movable/AM = locate(href_list["adminplayerobservefollow"])

		var/client/C = usr.client
		var/can_ghost = TRUE
		if(!isobserver(usr))
			can_ghost = C.admin_ghost()

		if(!can_ghost)
			return
		var/mob/dead/observer/A = C.mob
		A.ManualFollow(AM)

	else if(href_list["admingetmovable"])
		if(!check_rights(R_ADMIN))
			return

		var/atom/movable/AM = locate(href_list["admingetmovable"])
		if(QDELETED(AM))
			return
		AM.forceMove(get_turf(usr))

	else if(href_list["adminplayerobservecoodjump"])
		if(!isobserver(usr) && !check_rights(R_ADMIN))
			return

		var/x = text2num(href_list["X"])
		var/y = text2num(href_list["Y"])
		var/z = text2num(href_list["Z"])

		var/client/C = usr.client
		if(!isobserver(usr))
			C.admin_ghost()
		sleep(2)
		C.jumptocoord(x,y,z)

	else if(href_list["adminmoreinfo"])
		var/mob/M = locate(href_list["adminmoreinfo"]) in GLOB.mob_list
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob.")
			return

		var/location_description = ""
		var/special_role_description = ""
		var/health_description = ""
		var/gender_description = ""
		var/turf/T = get_turf(M)

		//Location
		if(isturf(T))
			if(isarea(T.loc))
				location_description = "([M.loc == T ? "at coordinates " : "in [M.loc] at coordinates "] [T.x], [T.y], [T.z] in area <b>[T.loc]</b>)"
			else
				location_description = "([M.loc == T ? "at coordinates " : "in [M.loc] at coordinates "] [T.x], [T.y], [T.z])"

		//Job + antagonist
		if(M.mind)
			special_role_description = "Role: <b>[M.mind.assigned_role.title]</b>; Antagonist: <font color='red'><b>[M.mind.special_role]</b></font>"
		else
			special_role_description = "Role: <i>Mind datum missing</i> Antagonist: <i>Mind datum missing</i>"

		//Health
		if(isliving(M))
			var/mob/living/L = M
			var/status
			switch (M.stat)
				if(CONSCIOUS)
					status = "Alive"
				if(SOFT_CRIT)
					status = "<font color='orange'><b>Dying</b></font>"
				if(UNCONSCIOUS)
					status = "<font color='orange'><b>[L.InCritical() ? "Unconscious and Dying" : "Unconscious"]</b></font>"
				if(DEAD)
					status = "<font color='red'><b>Dead</b></font>"
			health_description = "Status = [status]"
			health_description += "<BR>Oxy: [L.getOxyLoss()] - Tox: [L.getToxLoss()] - Fire: [L.getFireLoss()] - Brute: [L.getBruteLoss()] - Clone: [L.getCloneLoss()] - Brain: [L.getOrganLoss(ORGAN_SLOT_BRAIN)]"
		else
			health_description = "This mob type has no health to speak of."

		//Gender
		switch(M.gender)
			if(MALE,FEMALE,PLURAL)
				gender_description = "[M.gender]"
			else
				gender_description = "<font color='red'><b>[M.gender]</b></font>"

		to_chat(src.owner, "<b>Info about [M.name]:</b> ")
		to_chat(src.owner, "Mob type = [M.type]; Gender = [gender_description] Damage = [health_description]")
		to_chat(src.owner, "Name = <b>[M.name]</b>; Real_name = [M.real_name]; Mind_name = [M.mind?"[M.mind.name]":""]; Key = <b>[M.key]</b>;")
		to_chat(src.owner, "Location = [location_description];")
		to_chat(src.owner, "[special_role_description]")
		to_chat(src.owner, ADMIN_FULLMONTY_NONAME(M))

	else if(href_list["add_quirk"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/living/carbon/human/H = locate(href_list["add_quirk"])
		if(!ishuman(H))
			to_chat(usr, "<span class='warning'>This can only be used on human mobs.</span>")
			return

		var/quirk_type = text2path(href_list["quirk"])
		if(!ispath(quirk_type, /datum/quirk))
			to_chat(usr, "<span class='warning'>Invalid quirk type.</span>")
			return

		// Check if they already have this quirk
		if(H.has_quirk(quirk_type))
			to_chat(usr, "<span class='warning'>[H] already has this quirk.</span>")
			return

		// Get the quirk singleton for customization check
		var/datum/quirk/singleton = GLOB.quirk_singletons[quirk_type]
		var/custom_value = null

		// Handle customization if the quirk has options
		if(length(singleton.customization_options))
			var/list/options = singleton.return_customization(H.client?.prefs)
			if(length(options))
				var/selected = input(usr, "Select [singleton.customization_label]:", "Quirk Customization") as null|anything in options
				if(selected)
					custom_value = selected
				else
					to_chat(usr, "<span class='warning'>Quirk addition cancelled - no option selected.</span>")
					return

		// Add the quirk - this calls New() which calls on_spawn()
		if(H.add_quirk(quirk_type, custom_value))
			// Now trigger after_job_spawn() since the quirk is already spawned
			var/datum/quirk/new_quirk = H.get_quirk(quirk_type)
			if(new_quirk)
				new_quirk.after_job_spawn()

			log_admin("[key_name_admin(usr)] added quirk [initial(singleton.name)] to [key_name_admin(H)].")
			message_admins("[key_name_admin(usr)] added quirk [initial(singleton.name)] to [key_name_admin(H)].")
			to_chat(usr, "<span class='notice'>Added quirk [initial(singleton.name)] to [H].</span>")
		else
			to_chat(usr, "<span class='warning'>Failed to add quirk to [H].</span>")

		show_player_panel_next(H, "quirks")

	else if(href_list["remove_quirk"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/living/carbon/human/H = locate(href_list["remove_quirk"])
		if(!ishuman(H))
			to_chat(usr, "<span class='warning'>This can only be used on human mobs.</span>")
			return

		var/quirk_type = text2path(href_list["quirk"])
		if(!ispath(quirk_type, /datum/quirk))
			to_chat(usr, "<span class='warning'>Invalid quirk type.</span>")
			return

		var/datum/quirk/Q = H.get_quirk(quirk_type)
		if(!Q)
			to_chat(usr, "<span class='warning'>[H] doesn't have this quirk.</span>")
			return

		var/quirk_name = initial(Q.name)

		if(H.remove_quirk(quirk_type))
			log_admin("[key_name_admin(usr)] removed quirk [quirk_name] from [key_name_admin(H)].")
			message_admins("[key_name_admin(usr)] removed quirk [quirk_name] from [key_name_admin(H)].")
			to_chat(usr, "<span class='notice'>Removed quirk [quirk_name] from [H].</span>")
		else
			to_chat(usr, "<span class='warning'>Failed to remove quirk from [H].</span>")

		show_player_panel_next(H, "quirks")

	else if(href_list["addjobslot"])
		if(!check_rights(R_ADMIN))
			return

		var/Add = href_list["addjobslot"]

		for(var/datum/job/job in SSjob.joinable_occupations)
			if(job.title == Add)
				job.total_positions += 1
				break

		src.manage_free_slots()


	else if(href_list["customjobslot"])
		if(!check_rights(R_ADMIN))
			return

		var/Add = href_list["customjobslot"]

		for(var/datum/job/job in SSjob.joinable_occupations)
			if(job.title == Add)
				var/newtime = null
				newtime = input(usr, "How many jebs do you want?", "Add wanted posters", "[newtime]") as num|null
				if(!newtime)
					to_chat(src.owner, "Setting to amount of positions filled for the job")
					job.total_positions = job.current_positions
					break
				job.total_positions = newtime

		src.manage_free_slots()

	else if(href_list["removejobslot"])
		if(!check_rights(R_ADMIN))
			return

		var/Remove = href_list["removejobslot"]

		for(var/datum/job/job in SSjob.joinable_occupations)
			if(job.title == Remove && job.total_positions - job.current_positions > 0)
				job.total_positions -= 1
				break

		src.manage_free_slots()

	else if(href_list["unlimitjobslot"])
		if(!check_rights(R_ADMIN))
			return

		var/Unlimit = href_list["unlimitjobslot"]

		for(var/datum/job/job in SSjob.joinable_occupations)
			if(job.title == Unlimit)
				job.total_positions = -1
				break

		src.manage_free_slots()

	else if(href_list["limitjobslot"])
		if(!check_rights(R_ADMIN))
			return

		var/Limit = href_list["limitjobslot"]

		for(var/datum/job/job in SSjob.joinable_occupations)
			if(job.title == Limit)
				job.total_positions = job.current_positions
				break

		src.manage_free_slots()

	else if(href_list["enablejob"])
		if(!check_rights(R_ADMIN))
			return

		var/Enable = href_list["enablejob"]
		for(var/datum/job/job in SSjob.joinable_occupations)
			if(job.title == Enable)
				job.enabled = TRUE
				job.total_positions = initial(job.total_positions)
				job.spawn_positions = initial(job.spawn_positions)
				break

		src.manage_free_slots()

	else if(href_list["disablejob"])
		if(!check_rights(R_ADMIN))
			return

		var/Disable = href_list["disablejob"]
		for(var/datum/job/job in SSjob.joinable_occupations)
			if(job.title == Disable)
				job.enabled = FALSE
				job.total_positions = 0
				job.spawn_positions = 0
				break
		src.manage_free_slots()


	else if(href_list["adminsmite"])
		if(!check_rights(R_ADMIN|R_FUN))
			return

		var/mob/living/carbon/human/H = locate(href_list["adminsmite"]) in GLOB.mob_list
		if(!H || !istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
			return

		usr.client.smite(H)

	else if(href_list["jumpto"])
		if(!isobserver(usr) && !check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["jumpto"])
		usr.client.jumptomob(M)

	else if(href_list["getmob"])
		if(!check_rights(R_ADMIN))
			return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")
			return
		var/mob/M = locate(href_list["getmob"])
		usr.client.Getmob(M)

	else if(href_list["increase_skill"])
		var/mob/M = locate(href_list["increase_skill"])
		var/datum/skill/skill = href_list["skill"]
		M.adjust_skillrank(text2path(skill), 1)
		log_admin("[key_name_admin(usr)] increased [key_name_admin(M)]'s [initial(skill.name)] skill.")
		show_player_panel_next(M, "skills")

	else if(href_list["decrease_skill"])
		var/mob/M = locate(href_list["decrease_skill"])
		var/datum/skill/skill = href_list["skill"]
		M.adjust_skillrank(text2path(skill), -1)
		log_admin("[key_name_admin(usr)] decreased [key_name_admin(M)]'s [initial(skill.name)] skill.")
		show_player_panel_next(M, "skills")

	else if(href_list["add_language"])
		var/mob/M = locate(href_list["add_language"])
		var/datum/language/lang = text2path(href_list["language"])
		M.grant_language(lang)
		log_admin("[key_name_admin(usr)] added [lang] to [key_name_admin(M)].")
		message_admins("[key_name_admin(usr)] added [lang] to [key_name_admin(M)].")
		show_player_panel_next(M, "languages")

	else if(href_list["remove_language"])
		var/mob/M = locate(href_list["remove_language"])
		var/datum/language/lang = text2path(href_list["language"])
		M.remove_language(lang)
		log_admin("[key_name_admin(usr)] removed [lang] to [key_name_admin(M)].")
		message_admins("[key_name_admin(usr)] removed [lang] to [key_name_admin(M)].")
		show_player_panel_next(M, "languages")

	else if(href_list["add_stat"])
		var/mob/living/M = locate(href_list["add_stat"])
		var/statkey = href_list["stat"]
		M.change_stat(statkey, 1)
		log_admin("[key_name_admin(usr)] increased [key_name_admin(M)]'s [statkey].")
		message_admins("[key_name_admin(usr)] increased [key_name_admin(M)]'s [statkey].")
		show_player_panel_next(M, "stats")

	else if(href_list["lower_stat"])
		var/mob/living/M = locate(href_list["lower_stat"])
		var/statkey = href_list["stat"]
		M.change_stat(statkey, -1)
		log_admin("[key_name_admin(usr)] decreased [key_name_admin(M)]'s [statkey].")
		message_admins("[key_name_admin(usr)] decreased [key_name_admin(M)]'s [statkey].")
		show_player_panel_next(M, "stats")

	else if(href_list["bulk_change"])
		var/mob/living/M = locate(href_list["bulk_change"])
		var/statkey = href_list["stat"]
		var/change_stat = input(usr, "Increase or Decrease this stat.", "Bulk Stat Change", 1) as num
		if(!change_stat)
			return
		M.change_stat(statkey, change_stat)

		log_admin("[key_name_admin(usr)] changed [key_name_admin(M)]'s [statkey] by [change_stat].")
		message_admins("[key_name_admin(usr)] changed [key_name_admin(M)]'s [statkey] by [change_stat].")
		show_player_panel_next(M, "stats")

	else if(href_list["sendmob"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["sendmob"])
		usr.client.sendmob(M)


	else if(href_list["narrateto"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["narrateto"])
		usr.client.cmd_admin_direct_narrate(M)

	else if(href_list["subtlemessage"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["subtlemessage"])
		usr.client.cmd_admin_subtle_message(M)

	else if(href_list["individuallog"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["individuallog"]) in GLOB.mob_list
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob.")
			return

		show_individual_logging_panel(usr.client, M, href_list["log_src"], href_list["log_type"])
	else if(href_list["languagemenu"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["languagemenu"]) in GLOB.mob_list
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob.")
			return
		var/datum/language_holder/H = M.get_language_holder()
		H.open_language_menu(usr)

	else if(href_list["traitor"])
		if(!check_rights(R_ADMIN))
			return

		if(!SSticker.HasRoundStarted())
			alert("The game hasn't started yet!")
			return

		var/mob/M = locate(href_list["traitor"])
		if(!ismob(M))
			var/datum/mind/D = M
			if(!istype(D))
				to_chat(usr, "This can only be used on instances of type /mob and /mind")
				return
			else
				D.traitor_panel()
		else
			show_traitor_panel(M)

	else if(href_list["initmind"])
		if(!check_rights(R_ADMIN))
			return
		var/mob/M = locate(href_list["initmind"])
		if(!ismob(M) || M.mind)
			to_chat(usr, "This can only be used on instances on mindless mobs")
			return
		M.mind_initialize()

	else if(href_list["create_object"])
		if(!check_rights(R_SPAWN))
			return
		return create_object(usr)

	else if(href_list["quick_create_object"])
		if(!check_rights(R_SPAWN))
			return
		return quick_create_object(usr)

	else if(href_list["create_turf"])
		if(!check_rights(R_SPAWN))
			return
		return create_turf(usr)

	else if(href_list["create_mob"])
		if(!check_rights(R_SPAWN))
			return
		return create_mob(usr)

	else if(href_list["dupe_marked_datum"])
		if(!check_rights(R_SPAWN))
			return
		return DuplicateObject(marked_datum, perfectcopy=1, newloc=get_turf(usr))

	else if(href_list["object_list"])			//this is the laggiest thing ever
		if(!check_rights(R_SPAWN))
			return

		var/atom/loc = usr.loc

		var/dirty_paths
		if (istext(href_list["object_list"]))
			dirty_paths = list(href_list["object_list"])
		else if (istype(href_list["object_list"], /list))
			dirty_paths = href_list["object_list"]

		var/paths = list()

		for(var/dirty_path in dirty_paths)
			var/path = text2path(dirty_path)
			if(!path)
				continue
			else if(!ispath(path, /obj) && !ispath(path, /turf) && !ispath(path, /mob))
				continue
			paths += path

		if(!paths)
			alert("The path list you sent is empty.")
			return
		if(length(paths) > 5)
			alert("Select fewer object types, (max 5).")
			return

		var/list/offset = splittext(href_list["offset"],",")
		var/number = CLAMP(text2num(href_list["object_count"]), 1, ADMIN_SPAWN_CAP)
		var/X = offset.len > 0 ? text2num(offset[1]) : 0
		var/Y = offset.len > 1 ? text2num(offset[2]) : 0
		var/Z = offset.len > 2 ? text2num(offset[3]) : 0
		var/obj_dir = text2num(href_list["object_dir"])
		if(obj_dir && !(obj_dir in list(1,2,4,8,5,6,9,10)))
			obj_dir = null
		var/obj_name = sanitize(href_list["object_name"])


		var/atom/target //Where the object will be spawned
		var/where = href_list["object_where"]
		if (!( where in list("onfloor","frompod","inhand","inmarked") ))
			where = "onfloor"


		switch(where)
			if("inhand")
				if (!iscarbon(usr))
					to_chat(usr, "Can only spawn in hand when you're a carbon mob or cyborg.")
					where = "onfloor"
				target = usr

			if("onfloor", "frompod")
				switch(href_list["offset_type"])
					if ("absolute")
						target = locate(0 + X,0 + Y,0 + Z)
					if ("relative")
						target = locate(loc.x + X,loc.y + Y,loc.z + Z)
			if("inmarked")
				if(!marked_datum)
					to_chat(usr, "You don't have any object marked. Abandoning spawn.")
					return
				else if(!istype(marked_datum, /atom))
					to_chat(usr, "The object you have marked cannot be used as a target. Target must be of type /atom. Abandoning spawn.")
					return
				else
					target = marked_datum

		var/obj/structure/closet/supplypod/centcompod/pod

		if(target)
			if(where == "frompod")
				pod = new()

			for (var/path in paths)
				for (var/i = 0; i < number; i++)
					if(path in typesof(/turf))
						var/turf/O = target
						var/turf/N = O.ChangeTurf(path)
						if(N && obj_name)
							N.name = obj_name
					else
						var/atom/O
						if(where == "frompod")
							O = new path(pod)
						else
							O = new path(target)

						if(!QDELETED(O))
							O.flags_1 |= ADMIN_SPAWNED_1
							if(obj_dir)
								O.setDir(obj_dir)
							if(obj_name)
								O.name = obj_name
								if(ismob(O))
									var/mob/M = O
									M.real_name = obj_name
							if(where == "inhand" && isliving(usr) && isitem(O))
								var/mob/living/L = usr
								var/obj/item/I = O
								L.put_in_hands(I)

		if(pod)
			new /obj/effect/DPtarget(target, pod)

		if (number == 1)
			log_admin("[key_name(usr)] created a [english_list(paths)]")
			for(var/path in paths)
				if(ispath(path, /mob))
					message_admins("[key_name_admin(usr)] created a [english_list(paths)]")
					break
		else
			log_admin("[key_name(usr)] created [number]ea [english_list(paths)]")
			for(var/path in paths)
				if(ispath(path, /mob))
					message_admins("[key_name_admin(usr)] created [number]ea [english_list(paths)]")
					break
		return

	else if(href_list["secrets"])
		Secrets_topic(href_list["secrets"],href_list)

	else if(href_list["check_antagonist"])
		if(!check_rights(R_ADMIN))
			return
		usr.client.check_antagonists()

	else if(href_list["kick_all_from_lobby"])
		if(!check_rights(R_ADMIN))
			return
		if(SSticker.IsRoundInProgress())
			var/afkonly = text2num(href_list["afkonly"])
			if(alert("Are you sure you want to kick all [afkonly ? "AFK" : ""] clients from the lobby??","Message","Yes","Cancel") != "Yes")
				to_chat(usr, "Kick clients from lobby aborted")
				return
			var/list/listkicked = kick_clients_in_lobby("<span class='danger'>I were kicked from the lobby by [usr.client.holder.fakekey ? "an Administrator" : "[usr.client.key]"].</span>", afkonly)

			var/strkicked = ""
			for(var/name in listkicked)
				strkicked += "[name], "
			message_admins("[key_name_admin(usr)] has kicked [afkonly ? "all AFK" : "all"] clients from the lobby. [length(listkicked)] clients kicked: [strkicked ? strkicked : "--"]")
			log_admin("[key_name(usr)] has kicked [afkonly ? "all AFK" : "all"] clients from the lobby. [length(listkicked)] clients kicked: [strkicked ? strkicked : "--"]")
		else
			to_chat(usr, "You may only use this when the game is running.")
	else if(href_list["viewruntime"])
		var/datum/error_viewer/error_viewer = locate(href_list["viewruntime"])
		if(!istype(error_viewer))
			to_chat(usr, "<span class='warning'>That runtime viewer no longer exists.</span>")
			return

		if(href_list["viewruntime_backto"])
			error_viewer.show_to(owner, locate(href_list["viewruntime_backto"]), href_list["viewruntime_linear"])
		else
			error_viewer.show_to(owner, null, href_list["viewruntime_linear"])

	else if(href_list["showrelatedacc"])
		if(!check_rights(R_ADMIN))
			return
		var/client/C = locate(href_list["client"]) in GLOB.clients
		var/thing_to_check
		if(href_list["showrelatedacc"] == "cid")
			thing_to_check = C.related_accounts_cid
		else
			thing_to_check = C.related_accounts_ip
		thing_to_check = splittext(thing_to_check, ", ")


		var/list/dat = list("Related accounts by [uppertext(href_list["showrelatedacc"])]:")
		dat += thing_to_check

		usr << browse(dat.Join("<br>"), "window=related_[C];size=420x300")

	else if(href_list["centcomlookup"])
		if(!check_rights(R_ADMIN))
			return

		if(!CONFIG_GET(string/centcom_ban_db))
			to_chat(usr, span_warning("Centcom Galactic Ban DB is disabled!"))
			return

		var/ckey = href_list["centcomlookup"]

		// Make the request
		var/datum/http_request/request = new()
		request.prepare(RUSTG_HTTP_METHOD_GET, "[CONFIG_GET(string/centcom_ban_db)]/[ckey]", "", "")
		request.begin_async()
		UNTIL(request.is_complete() || !usr)
		if (!usr)
			return
		var/datum/http_response/response = request.into_response()

		var/list/bans

		var/list/dat = list("<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><body>")

		if(response.errored)
			dat += "<br>Failed to connect to CentCom."
		else if(response.status_code != 200)
			dat += "<br>Failed to connect to CentCom. Status code: [response.status_code]"
		else
			if(response.body == "\[]")
				dat += "<center><b>0 bans detected for [ckey]</b></center>"
			else
				bans = json_decode(response.body)

				//Ignore bans from non-whitelisted sources, if a whitelist exists
				var/list/valid_sources
				if(CONFIG_GET(string/centcom_source_whitelist))
					valid_sources = splittext(CONFIG_GET(string/centcom_source_whitelist), ",")
					dat += "<center><b>Bans detected for [ckey]</b></center>"
				else
					//Ban count is potentially inaccurate if they're using a whitelist
					dat += "<center><b>[bans.len] ban\s detected for [ckey]</b></center>"

				for(var/list/ban in bans)
					if(valid_sources && !(ban["sourceName"] in valid_sources))
						continue
					dat += "<b>Server: </b> [sanitize(ban["sourceName"])]<br>"
					dat += "<b>RP Level: </b> [sanitize(ban["sourceRoleplayLevel"])]<br>"
					dat += "<b>Type: </b> [sanitize(ban["type"])]<br>"
					dat += "<b>Banned By: </b> [sanitize(ban["bannedBy"])]<br>"
					dat += "<b>Reason: </b> [sanitize(ban["reason"])]<br>"
					dat += "<b>Datetime: </b> [sanitize(ban["bannedOn"])]<br>"
					var/expiration = ban["expires"]
					dat += "<b>Expires: </b> [expiration ? "[sanitize(expiration)]" : "Permanent"]<br>"
					if(ban["type"] == "job")
						dat += "<b>Jobs: </b> "
						var/list/jobs = ban["jobs"]
						dat += sanitize(jobs.Join(", "))
						dat += "<br>"
					dat += "<hr>"

		dat += "<br></body>"
		var/datum/browser/popup = new(usr, "centcomlookup-[ckey]", "<div align='center'>Central Command Galactic Ban Database</div>", 700, 600)
		popup.set_content(dat.Join())
		popup.open(0)

	else if(href_list["modantagrep"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["mob"]) in GLOB.mob_list
		var/client/C = M.client
		usr.client.cmd_admin_mod_antag_rep(C, href_list["modantagrep"])
		show_player_panel(M)

	else if(href_list["editpq"])
		if(!check_rights(R_ADMIN))
			return
		var/mob/M = locate(href_list["mob"]) in GLOB.mob_list
		var/client/mob_client = M.client
		var/amt2change = input("How much to modify the PQ by? (20 to -20, or 0 to just add a note)") as null|num
		if(!check_rights(R_ADMIN,0))
			amt2change = CLAMP(amt2change, -20, 20)
		var/raisin = stripped_input("State a short reason for this change", "Game Master", "", null)
		if(!amt2change && !raisin)
			return
		adjust_playerquality(amt2change, mob_client.ckey, usr.ckey, raisin)
		for(var/client/C in GLOB.clients) // I hate this, but I'm not refactoring the cancer above this point.
			if(lowertext(C.key) == lowertext(mob_client.ckey))
				to_chat(C, "<span class=\"admin\"><span class=\"prefix\">ADMIN LOG:</span> <span class=\"message linkify\">Your PQ has been adjusted by [amt2change] by [usr.key] for reason: [raisin]</span></span>")
				return
	else if(href_list["showpq"])
		if(!check_rights(R_ADMIN))
			return
		var/mob/M = locate(href_list["mob"]) in GLOB.mob_list
		var/client/mob_client = M.client
		check_pq_menu(mob_client.key)
	else if(href_list["showtriumphs"])
		if(!check_rights(R_ADMIN))
			return
		var/mob/M = locate(href_list["mob"]) in GLOB.mob_list
		var/client/mob_client = M.client
		check_triumphs_menu(mob_client.ckey)

	else if(href_list["edittriumphs"])
		if(!check_rights(R_ADMIN))
			return
		var/mob/M = (locate(href_list["mob"]) in GLOB.mob_list)
		if(!M?.key)
			alert(usr, "[M] does not have a key.")
			return

		var/amt2change = input(usr, "How much to modify the Triumphs by? (100 to -100)") as null|num
		amt2change = clamp(amt2change, -100, 100)
		if(!amt2change)
			return

		var/raisin = stripped_input(usr, "State a short reason for this change", "Game Master", null, null)
		M.adjust_triumphs(amt2change, FALSE, raisin, override_bonus = TRUE)
		message_admins("[key_name_admin(usr)] adjusted [M.key]'s triumphs by [amt2change] with [!raisin ? "no reason given" : "reason: [raisin]"].")
		log_admin("[key_name_admin(usr)] adjusted [M.key]'s triumphs by [amt2change] with [!raisin ? "no reason given" : "reason: [raisin]"].")

	else if(href_list["changepatron"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = (locate(href_list["mob"]) in GLOB.mob_list)

		if(!ishuman(M))
			return

		var/patron_to_change_to = browser_input_list(usr, "Change to what patron?", "THE GODS", GLOB.patron_list)
		if(!patron_to_change_to)
			return

		var/mob/living/carbon/human/being_changed = M

		message_admins("[key_name_admin(usr)] changed [key_name_admin(M)]'s patron from [being_changed.patron] to [patron_to_change_to]")
		log_admin("[key_name_admin(usr)] changed [key_name_admin(M)]'s patron from [being_changed.patron] to [patron_to_change_to]")

		being_changed.set_patron(patron_to_change_to)

	else if(href_list["modifycurses"])

		// admin rights checked in admin_curse
		var/mob/M = (locate(href_list["mob"]) in GLOB.mob_list)

		admin_curse(M)

	else if(href_list["setjob"])
		if(!check_rights(R_ADMIN))
			return
		var/mob/M = (locate(href_list["mob"]) in GLOB.mob_list)
		if(isnull(M?.mind))
			return

		var/list/jobslist = get_job_assignment_order()
		var/job_to_change_to = browser_input_list(usr, "Change to what job?", "THEIR ROLE IN THIS WORLD", jobslist)

		if(!job_to_change_to || isnull(M.mind))
			return

		var/datum/job/new_job = job_to_change_to
		var/datum/mind/mind_of_mob = M.mind

		message_admins("[key_name_admin(usr)] changed [key_name_admin(M)]'s job from [mind_of_mob.assigned_role ? mind_of_mob.assigned_role.title : "NA"] to [new_job.title]")
		log_admin("[key_name_admin(usr)] changed [key_name_admin(M)]'s job from [mind_of_mob.assigned_role ? mind_of_mob.assigned_role.title : "NA"] to [new_job.title]")

		mind_of_mob.set_assigned_role(new_job)

	else if(href_list["roleban"])
		if(!check_rights(R_ADMIN))
			return
		var/mob/M = locate(href_list["mob"]) in GLOB.mob_list
		var/client/mob_client = M.client
		role_ban_panel.show_ui(usr, mob_client.key)

	else if(href_list["slowquery"])
		if(!check_rights(R_ADMIN))
			return
		var/answer = href_list["slowquery"]
		if(answer == "yes")
			log_query_debug("[usr.key] | Reported a server hang")
			if(alert(usr, "Had you just press any admin buttons?", "Query server hang report", "Yes", "No") == "Yes")
				var/response = input(usr,"What were you just doing?","Query server hang report") as null|text
				if(response)
					log_query_debug("[usr.key] | [response]")
		else if(answer == "no")
			log_query_debug("[usr.key] | Reported no server hang")

	else if(href_list["rebootworld"])
		if(!check_rights(R_ADMIN))
			return
		var/confirm = alert("Are you sure you want to reboot the server?", "Confirm Reboot", "Yes", "No")
		if(confirm == "No")
			return
		if(confirm == "Yes")
			restart()

	else if(href_list["check_teams"])
		if(!check_rights(R_ADMIN))
			return
		check_teams()

	else if(href_list["team_command"])
		if(!check_rights(R_ADMIN))
			return
		switch(href_list["team_command"])
			if("create_team")
				admin_create_team(usr)
			if("rename_team")
				var/datum/team/T = locate(href_list["team"]) in GLOB.antagonist_teams
				if(T)
					T.admin_rename(usr)
			if("communicate")
				var/datum/team/T = locate(href_list["team"]) in GLOB.antagonist_teams
				if(T)
					T.admin_communicate(usr)
			if("delete_team")
				var/datum/team/T = locate(href_list["team"]) in GLOB.antagonist_teams
				if(T)
					T.admin_delete(usr)
			if("add_objective")
				var/datum/team/T = locate(href_list["team"]) in GLOB.antagonist_teams
				if(T)
					T.admin_add_objective(usr)
			if("remove_objective")
				var/datum/team/T = locate(href_list["team"]) in GLOB.antagonist_teams
				if(!T)
					return
				var/datum/objective/O = locate(href_list["tobjective"]) in T.objectives
				if(O)
					T.admin_remove_objective(usr,O)
			if("add_member")
				var/datum/team/T = locate(href_list["team"]) in GLOB.antagonist_teams
				if(T)
					T.admin_add_member(usr)
			if("remove_member")
				var/datum/team/T = locate(href_list["team"]) in GLOB.antagonist_teams
				if(!T)
					return
				var/datum/mind/M = locate(href_list["tmember"]) in T.members
				if(M)
					T.admin_remove_member(usr,M)
		check_teams()

	else if(href_list["newbankey"])
		var/player_key = href_list["newbankey"]
		var/player_ip = href_list["newbanip"]
		var/player_cid = href_list["newbancid"]
		ban_panel(player_key, player_ip, player_cid)

	else if(href_list["intervaltype"]) //check for ban panel, intervaltype is used as it's the only value which will always be present
		if(href_list["roleban_delimiter"])
			ban_parse_href(href_list)
		else
			ban_parse_href(href_list, TRUE)

	else if(href_list["searchunbankey"] || href_list["searchunbanadminkey"] || href_list["searchunbanip"] || href_list["searchunbancid"])
		var/player_key = href_list["searchunbankey"]
		var/admin_key = href_list["searchunbanadminkey"]
		var/player_ip = href_list["searchunbanip"]
		var/player_cid = href_list["searchunbancid"]
		unban_panel(player_key, admin_key, player_ip, player_cid)

	else if(href_list["unbanpagecount"])
		var/page = href_list["unbanpagecount"]
		var/player_key = href_list["unbankey"]
		var/admin_key = href_list["unbanadminkey"]
		var/player_ip = href_list["unbanip"]
		var/player_cid = href_list["unbancid"]
		unban_panel(player_key, admin_key, player_ip, player_cid, page)

	else if(href_list["editbanid"])
		var/edit_id = href_list["editbanid"]
		var/player_key = href_list["editbankey"]
		var/player_ip = href_list["editbanip"]
		var/player_cid = href_list["editbancid"]
		var/role = href_list["editbanrole"]
		var/duration = href_list["editbanduration"]
		var/applies_to_admins = text2num(href_list["editbanadmins"])
		var/reason = url_decode(href_list["editbanreason"])
		var/page = href_list["editbanpage"]
		var/admin_key = href_list["editbanadminkey"]
		ban_panel(player_key, player_ip, player_cid, role, duration, applies_to_admins, reason, edit_id, page, admin_key)

	else if(href_list["unbanid"])
		var/ban_id = href_list["unbanid"]
		var/player_key = href_list["unbankey"]
		var/player_ip = href_list["unbanip"]
		var/player_cid = href_list["unbancid"]
		var/role = href_list["unbanrole"]
		var/page = href_list["unbanpage"]
		var/admin_key = href_list["unbanadminkey"]
		unban(ban_id, player_key, player_ip, player_cid, role, page, admin_key)

	else if(href_list["unbanlog"])
		var/ban_id = href_list["unbanlog"]
		ban_log(ban_id)

	else if(href_list["beakerpanel"])
		beaker_panel_act(href_list)

	else if(href_list["reloadpolls"])
		GLOB.polls.Cut()
		GLOB.poll_options.Cut()
		load_poll_data()
		poll_list_panel()

	else if(href_list["newpoll"])
		poll_management_panel()

	else if(href_list["editpoll"])
		var/datum/poll_question/poll = locate(href_list["editpoll"]) in GLOB.polls
		poll_management_panel(poll)

	else if(href_list["deletepoll"])
		var/datum/poll_question/poll = locate(href_list["deletepoll"]) in GLOB.polls
		poll.delete_poll()
		poll_list_panel()

	else if(href_list["initializepoll"])
		poll_parse_href(href_list)

	else if(href_list["submitpoll"])
		var/datum/poll_question/poll = locate(href_list["submitpoll"]) in GLOB.polls
		poll_parse_href(href_list, poll)

	else if(href_list["clearpollvotes"])
		var/datum/poll_question/poll = locate(href_list["clearpollvotes"]) in GLOB.polls
		poll.clear_poll_votes()
		poll_management_panel(poll)

	else if(href_list["addpolloption"])
		var/datum/poll_question/poll = locate(href_list["addpolloption"]) in GLOB.polls
		poll_option_panel(poll)

	else if(href_list["editpolloption"])
		var/datum/poll_option/option = locate(href_list["editpolloption"]) in GLOB.poll_options
		var/datum/poll_question/poll = locate(href_list["parentpoll"]) in GLOB.polls
		poll_option_panel(poll, option)

	else if(href_list["deletepolloption"])
		var/datum/poll_option/option = locate(href_list["deletepolloption"]) in GLOB.poll_options
		var/datum/poll_question/poll = option.delete_option()
		poll_management_panel(poll)

	else if(href_list["submitoption"])
		var/datum/poll_option/option = locate(href_list["submitoption"]) in GLOB.poll_options
		var/datum/poll_question/poll = locate(href_list["submitoptionpoll"]) in GLOB.polls
		poll_option_parse_href(href_list, poll, option)

	else if(href_list["readcommends"])
		var/the_key = href_list["readcommends"]
		var/popup_window_data = "<center>[the_key]</center>"

		var/json_file = file("data/player_saves/[copytext(the_key,1,2)]/[the_key]/commends.json")
		if(!fexists(json_file))
			WRITE_FILE(json_file, "{}")
		var/list/json = json_decode(file2text(json_file))
		for(var/giver in json)
			popup_window_data += "[giver]: [json[giver]]<br>"

		var/datum/browser/noclose/popup = new(usr, "commendscheck", "", 370, 220)
		popup.set_content(popup_window_data)
		popup.open()

	else if(href_list["cursemenu"])
		var/the_key = href_list["cursemenu"]
		var/popup_window_data = "<center>[the_key]</center>"

		var/json_file = file("data/player_saves/[copytext(the_key,1,2)]/[the_key]/curses.json")
		if(!fexists(json_file))
			WRITE_FILE(json_file, "{}")
		var/list/json = json_decode(file2text(json_file))
		for(var/curse in list("brokedick"))
			var/yes_cursed
			for(var/X in json)
				if(X == curse)
					yes_cursed = TRUE
					break
			if(yes_cursed)
				popup_window_data += "[curse] ENABLED<br>"
			else
				popup_window_data += "[curse] DISABLED<br>"

		var/datum/browser/noclose/popup = new(usr, "cursecheck", "", 370, 220)
		popup.set_content(popup_window_data)
		popup.open()

	else if(href_list["adminbirdletter"])
		if(!check_rights(R_ADMIN))
			return
		var/mob/M = locate(href_list["adminbirdletter"])
		usr.client.send_bird_letter(M)

/datum/admins/proc/HandleCMode()
	if(!check_rights(R_ADMIN))
		return

	var/dat = {"<B>What mode do you wish to play?</B><HR>"}
	for(var/mode in config.modes)
		dat += {"<A href='byond://?src=[REF(src)];[HrefToken()];c_mode2=[mode]'>[config.mode_names[mode]]</A><br>"}
	dat += {"<A href='byond://?src=[REF(src)];[HrefToken()];c_mode2=secret'>Secret</A><br>"}
	dat += {"<A href='byond://?src=[REF(src)];[HrefToken()];c_mode2=random'>Random</A><br>"}
	dat += {"Now: [GLOB.master_mode]"}
	usr << browse(dat, "window=c_mode")

/datum/admins/proc/HandleFSecret()
	if(!check_rights(R_ADMIN))
		return

	if(SSticker.HasRoundStarted())
		return alert(usr, "The game has already started.", null, null, null, null)
	if(GLOB.master_mode != "secret")
		return alert(usr, "The game mode has to be secret!", null, null, null, null)
	var/dat = {"<B>What game mode do you want to force secret to be? Use this if you want to change the game mode, but want the players to believe it's secret. This will only work if the current game mode is secret.</B><HR>"}
	for(var/mode in config.modes)
		dat += {"<A href='byond://?src=[REF(src)];[HrefToken()];f_secret2=[mode]'>[config.mode_names[mode]]</A><br>"}
	dat += {"<A href='byond://?src=[REF(src)];[HrefToken()];f_secret2=secret'>Random (default)</A><br>"}
	dat += {"Now: [GLOB.secret_force_mode]"}
	usr << browse(dat, "window=f_secret")
