#define NO_ADMINS_ONLINE_MESSAGE "Adminhelps are also sent through TGS to services like IRC and Discord. If no admins are available in game, sending an adminhelp might still be noticed and responded to."

/client/verb/who()
	set name = "Whom"
	set category = "OOC"

	var/msg = ""

	var/list/Lines = list()

	var/wled = 0
	if(holder)
		to_chat(src, "<span class='info'>Loading Whom, please wait...</span>")
		for(var/client/C in GLOB.clients)
			var/entry = "<span class='info'>\t[C.key]"
			if(C.holder && C.holder.fakekey)
				entry += " <i>(as [C.holder.fakekey])</i>"
			if (isnewplayer(C.mob))
				entry += " - <font color='darkgray'><b>In Lobby</b></font>"

			else
				if(ishuman(C.mob))
					var/mob/living/carbon/human/H = C.mob
					entry += " - Playing as [C.mob.real_name][H.job ? " ([H.job])" : ""]"
				else
					entry += " - Playing as [C.mob.real_name]"
				switch(C.mob.stat)
					if(UNCONSCIOUS,HARD_CRIT)
						entry += " - <font color='darkgray'><b>UNCON</b></font>"
					if(DEAD)
						if(isobserver(C.mob))
							var/mob/dead/observer/O = C.mob
							if(O.started_as_observer)
								entry += " - <font color='gray'>Observing</font>"
							else
								entry += " - <b>GHOST</b>"
						else
							entry += " - <b>DEAD</b>"
				if(C.mob.mind)
					if(C.mob.mind.special_role)
						entry += " - <b><font color='red'>[C.mob.mind.special_role]</font></b>"
			entry += "</span>"
			Lines += entry
	else
		for(var/client/C in GLOB.clients)
			var/usedkey = get_display_ckey(C.key)
			Lines += "<span class='info'>[usedkey]</span>"
	for(var/line in sortList(Lines))
		msg += "[line]\n"
	msg += "<b>Players at the table:</b> [length(Lines)]"
	if(holder)
		msg += "<br><b>Whitelisted players:</b> [wled]"
	to_chat(src, msg)

/client/verb/adminwho()
	set category = "Admin"
	set name = "Adminwho"

	var/list/lines = list()
	var/payload_string = generate_adminwho_string()
	var/header = (payload_string == NO_ADMINS_ONLINE_MESSAGE) ? "No Admins Currently Online" : "Current Admins:"

	lines += span_bold(header)
	lines += payload_string

	var/codermonkey_string = generate_codemonkey_string()
	if(!isnull(codermonkey_string))
		lines += span_bold("Current Non-Admin Staff:")
		lines += span_boldnotice("Non-admin staff are unable to handle adminhelp tickets.")
		lines += codermonkey_string

	var/finalized_string = span_notice(jointext(lines, "\n"))
	to_chat(src, finalized_string)

/// Proc that generates the applicable string to dispatch to the client for adminwho.
/client/proc/generate_adminwho_string()
	var/list/list_of_admins = get_list_of_admins()
	if(isnull(list_of_admins))
		return NO_ADMINS_ONLINE_MESSAGE

	var/list/message_strings = list()
	if(isnull(holder))
		message_strings += get_general_adminwho_information(list_of_admins)
		message_strings += NO_ADMINS_ONLINE_MESSAGE
	else
		message_strings += get_sensitive_adminwho_information(list_of_admins)

	return jointext(message_strings, "\n")

/// Proc that generates the applicable string to dispatch to the client for adminwho,
/// but only for maintainers/debuggers/etc without R_ADMIN.
/client/proc/generate_codemonkey_string()
	var/list/list_of_admins = get_list_of_admins(coders = TRUE)
	if(isnull(list_of_admins))
		return
	return jointext(get_codermonkey_adminwho_information(list_of_admins), "\n")

/// Proc that returns a list of cliented admins. Remember that this list can contain nulls!
/// Also, will return null if we don't have any admins.
/proc/get_list_of_admins(coders = FALSE)
	var/returnable_list = list()

	for(var/client/admin in GLOB.admins)
		var/okay = check_rights_for(admin, R_ADMIN)
		if(coders)
			okay = !okay
		if(!okay)
			continue
		returnable_list += admin

	if(length(returnable_list) == 0)
		return null

	return returnable_list

/// Proc that will return the applicable display name, linkified or not, based on the input client reference.
/proc/get_linked_admin_name(client/admin)
	return admin

/// Proc that gathers adminwho information for a general player, which will only give information if an admin isn't AFK, and handles potential fakekeying.
/// Will return a list of strings.
/proc/get_general_adminwho_information(list/checkable_admins)
	var/returnable_list = list()

	for(var/client/admin in checkable_admins)
		if(admin.is_afk() || !isnull(admin.holder.fakekey))
			continue //Don't show afk or fakekeyed admins to adminwho

		returnable_list += "• [get_linked_admin_name(admin)] is a [admin.holder.rank.name]"

	return returnable_list

/// Proc that gathers adminwho information for a general player, but only returns "adminless" admins, usually coders/debuggers and such.
/proc/get_codermonkey_adminwho_information(list/checkable_admins)
	var/returnable_list = list()

	for(var/client/admin in checkable_admins)
		if(check_rights_for(admin, R_ADMIN))
			continue //Don't show afk or fakekeyed admins to adminwho

		returnable_list += "• [admin] is a [admin.holder.rank.name]"

	return returnable_list

/// Proc that gathers adminwho information for admins, which will contain information on if the admin is AFK, readied to join, etc. Only arg is a list of clients to use.
/// Will return a list of strings.
/proc/get_sensitive_adminwho_information(list/checkable_admins)
	var/returnable_list = list()

	for(var/client/admin in checkable_admins)
		var/list/admin_strings = list()

		admin_strings += "• [get_linked_admin_name(admin)] is a [admin.holder.rank.name]"

		if(admin.holder.fakekey)
			admin_strings += "<i>(as [admin.holder.fakekey])</i>"

		if(isobserver(admin.mob))
			admin_strings += "- Observing"
		else if(isnewplayer(admin.mob))
			if(SSticker.current_state <= GAME_STATE_PREGAME)
				var/mob/dead/new_player/lobbied_admin = admin.mob
				if(lobbied_admin.ready == PLAYER_READY_TO_PLAY)
					admin_strings += "- Lobby (Readied)"
				else
					admin_strings += "- Lobby (Not Readied)"
			else
				admin_strings += "- Lobby"
		else
			admin_strings += "- Playing"

		if(admin.is_afk())
			admin_strings += "(AFK)"

		returnable_list += jointext(admin_strings, " ")

	return returnable_list

#undef NO_ADMINS_ONLINE_MESSAGE
