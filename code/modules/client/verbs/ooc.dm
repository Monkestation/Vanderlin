GLOBAL_VAR_INIT(normal_ooc_colour, "#4972bc")
GLOBAL_VAR_INIT(OOC_COLOR, normal_ooc_colour)//If this is null, use the CSS for OOC. Otherwise, use a custom colour.

#define MAX_PRONOUNS 4
// This list is non-exhaustive
GLOBAL_LIST_INIT(oocpronouns_valid, list(
	"he", "him", "his",
	"she","her","hers",
	"hyr", "hyrs",
	"they", "them", "their","theirs",
	"it", "its",
	"xey", "xe", "xem", "xyr", "xyrs",
	"ze", "zir", "zirs",
	"ey", "em", "eir", "eirs",
	"fae", "faer", "faers",
	"ve", "ver", "vis", "vers",
	"ne", "nem", "nir", "nirs"
))

// at least one is required
GLOBAL_LIST_INIT(oocpronouns_required, list(
	"he", "her", "she", "they", "them", "it", "fae", "its"
))

//client/verb/ooc(msg as text)

/client/verb/ooc(msg as text)
	set name = "OOC" //Gave this shit a shorter name so you only have to time out "ooc" rather than "ooc message" to use it --NeoFite
	set category = "OOC"
	set hidden = 1
	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return

	if(!mob)
		return

	/*
	if(get_playerquality(ckey) <= -5)
		to_chat(src, span_danger("I can't use that."))
		return
	*/

	if(!holder)
		if(!GLOB.ooc_allowed)
			to_chat(src, span_danger("OOC is globally muted."))
			return
		if(!GLOB.dooc_allowed && (mob.stat == DEAD))
			to_chat(usr, span_danger("OOC for dead mobs has been turned off."))
			return
		if(prefs.muted & MUTE_OOC)
			to_chat(src, span_danger("I cannot use OOC (muted)."))
			return
	if(is_misc_banned(ckey, BAN_MISC_OOC))
		to_chat(src, span_danger("I have been banned from OOC."))
		return
	if(QDELETED(src))
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	var/raw_msg = msg

	if(!msg)
		return

	msg = emoji_parse(msg)
	msg = parsemarkdown_basic(msg, limited = TRUE, barebones = TRUE)


	if(!holder)
		if(handle_spam_prevention(msg,MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>FOOL</B>")
			log_admin("[key_name(src)] has attempted to advertise in OOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in OOC: [msg]")
			return

	if(!(prefs.chat_toggles & CHAT_OOC))
		to_chat(src, span_danger("I have OOC muted."))
		return

	mob.log_talk(raw_msg, LOG_OOC)

	var/keyname = get_display_ckey(ckey)
	var/color2use = prefs.voice_color
	var/admin_message_color = prefs.ooccolor
	if(!color2use)
		color2use = "#FFFFFF"
	else
		color2use = "#[color2use]"
	var/chat_color = "#c5c5c5"
	var/msg_to_send = ""

	for(var/client/C in GLOB.clients)
		var/pre_keyfield = C.holder ? "[keyname]([key])" : keyname
		var/keyfield = conditional_tooltip_alt(pre_keyfield, prefs.oocpronouns, length(prefs.oocpronouns) && !is_misc_banned(ckey, BAN_MISC_OOCPRONOUNS))
		if(C.prefs.chat_toggles & CHAT_OOC)
			msg_to_send = "<font color='[color2use]'><EM>[keyfield]:</EM></font> <font color='[chat_color]'><span class='message linkify'>[msg]</span></font>"
			if(holder)
				msg_to_send = "<font color='[color2use]'><EM>[keyfield]:</EM></font> <font color='[admin_message_color ? admin_message_color : GLOB.OOC_COLOR]'><span class='message linkify'>[msg]</span></font>"
			to_chat(C, msg_to_send)


/client/proc/lobbyooc(msg as text)
	set category = "OOC"
	set name = "OOC"
	set desc = "Talk with the other players."

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return

	if(!mob)
		return

		/*
	if(get_playerquality(ckey) <= -5)
		to_chat(src, span_danger("I can't use that."))
		return
	*/

	if(!holder)
		if(prefs.muted & MUTE_OOC)
			to_chat(src, span_danger("I cannot use OOC (muted)."))
			return
	if(is_misc_banned(ckey, BAN_MISC_OOC))
		to_chat(src, span_danger("I have been banned from OOC."))
		return
	if(QDELETED(src))
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	var/raw_msg = msg

	if(!msg)
		return

	msg = emoji_parse(msg)


	if(!holder)
		if(handle_spam_prevention(msg,MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>FOOL</B>")
			log_admin("[key_name(src)] has attempted to advertise in OOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in OOC: [msg]")
			return

	if(!(prefs.chat_toggles & CHAT_OOC))
		to_chat(src, span_danger("I have OOC muted."))
		return

	mob.log_talk(raw_msg, LOG_OOC)

	var/keyname = get_display_ckey(ckey)
	//The linkify span classes and linkify=TRUE below make ooc text get clickable chat href links if you pass in something resembling a url
	var/color2use = prefs.voice_color
	if(!color2use)
		color2use = "#FFFFFF"
	else
		color2use = "#[color2use]"
	var/chat_color = "#c5c5c5"
	var/msg_to_send = ""
	var/admin_message_color = prefs.ooccolor

	for(var/client/C in GLOB.clients)
		var/real_key = C.holder ? "([key])" : ""
		if(C.prefs.chat_toggles & CHAT_OOC)
			if(!C.holder)
				if(SSticker.current_state != GAME_STATE_FINISHED && !istype(C.mob, /mob/dead/new_player))
					continue

			msg_to_send = "<font color='[color2use]'><EM>[keyname][real_key]:</EM></font> <font color='[chat_color]'><span class='message linkify'>[msg]</span></font>"
			if(holder)
				msg_to_send = "<font color='[color2use]'><EM>[keyname][real_key]:</EM></font> <font color='[admin_message_color ? admin_message_color : GLOB.OOC_COLOR]'><span class='message linkify'>[msg]</span></font>"

			to_chat(C, msg_to_send)


/proc/toggle_ooc(toggle = null)
	if(toggle != null) //if we're specifically en/disabling ooc
		if(toggle != GLOB.ooc_allowed)
			GLOB.ooc_allowed = toggle
		else
			return
	else //otherwise just toggle it
		GLOB.ooc_allowed = !GLOB.ooc_allowed
	message_admins("<B>The OOC channel has been globally [GLOB.ooc_allowed ? "enabled" : "disabled"].</B>")

/proc/toggle_looc(toggle = null)
	if(toggle != null) //if we're specifically en/disabling ooc
		if(toggle != GLOB.looc_allowed)
			GLOB.looc_allowed = toggle
		else
			return
	else //otherwise just toggle it
		GLOB.looc_allowed = !GLOB.looc_allowed
	message_admins("<B>The LOOC channel has been globally [GLOB.looc_allowed ? "enabled" : "disabled"].</B>")

/proc/toggle_dooc(toggle = null)
	if(toggle != null)
		if(toggle != GLOB.dooc_allowed)
			GLOB.dooc_allowed = toggle
		else
			return
	else
		GLOB.dooc_allowed = !GLOB.dooc_allowed

// OOC colors require a refactoring

/client/proc/set_ooc(newColor as color)
	set name = "Set Default OOC Color"
	set desc = ""
	set category = "OOC.Admin"
	set hidden = FALSE
	if(!holder)
		return
	GLOB.OOC_COLOR = sanitize_ooccolor(newColor)
	if(!check_rights(0))
		return

/client/proc/reset_ooc()
	set name = "Reset Default OOC Color"
	set desc = ""
	set category = "OOC.Admin"
	set hidden = FALSE
	if(!holder)
		return
	if(!check_rights(0))
		return
	GLOB.OOC_COLOR = GLOB.normal_ooc_colour

//Checks admin notice
/client/verb/admin_notice()
	set name = "Show Admin Notice"
	set category = "Admin"
	set desc ="Check the admin notice if it has been set"
	set hidden = 1
	if(!holder)
		return
	if(!check_rights(0))
		return
	if(GLOB.admin_notice)
		to_chat(src, "<span class='boldnotice'>Admin Notice:</span>\n \t [GLOB.admin_notice]")
	else
		to_chat(src, "<span class='notice'>There are no admin notices at the moment.</span>")

#ifdef TESTSERVER
/client/verb/smiteselfverily()
	set name = "KillSelf"
	set category = "DEBUGTEST"

	var/confirm = alert(src, "Should I really kill myself?", "Feed the crows", "Yes", "No")
	if(confirm == "Yes")
		log_admin("[key_name(usr)] used killself.")
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] used killself.</span>")
		mob.death()
#endif

/mob/dead/new_player/verb/togglobb()
	set name = "SilenceLobbyMusic"
	set category = "Preferences.Sound"
	stop_sound_channel(CHANNEL_LOBBYMUSIC)

/proc/CheckJoinDate(ckey)
	var/list/http = world.Export("http://byond.com/members/[ckey]?format=text")
	if(!http)
		log_world("Failed to connect to byond member page to age check [ckey]")
		return "2022"
	var/F = file2text(http["CONTENT"])
	if(F)
		var/regex/R = regex("joined = \"(\\d{4})")
		if(R.Find(F))
			. = R.group[1]
		else
			return "2022" //can't find join date, either a scuffed name or a guest but let it through anyway

/proc/CheckIPCountry(ipaddress)
	set background = 1
	if(!ipaddress)
		return
	var/list/vl = world.Export("http://ip-api.com/json/[ipaddress]")
	if (!("CONTENT" in vl) || vl["STATUS"] != "200 OK")
		return
	var/jd = html_encode(file2text(vl["CONTENT"]))
	var/parsed = ""
	var/pos = 1
	var/search = findtext(jd, "country", pos)
	parsed += copytext(jd, pos, search)
	if(search)
		pos = search
		search = findtext(jd, ",", pos+1)
		if(search)
			return lowertext(copytext(jd, pos+9, search))

/client/verb/fix_chat()
	set name = "Fix Chat"
	set category = "OOC.Fix"
	if (!chatOutput || !istype(chatOutput))
		var/action = alert(src, "Invalid Chat Output data found!\nRecreate data?", "Wot?", "Recreate Chat Output data", "Cancel")
		if (action != "Recreate Chat Output data")
			return
		chatOutput = new /datum/chatOutput(src)
		chatOutput.start()
		action = alert(src, "Goon chat reloading, wait a bit and tell me if it's fixed", "", "Fixed", "Nope")
		if (action == "Fixed")
			log_game("GOONCHAT: [key_name(src)] Had to fix their goonchat by re-creating the chatOutput datum")
		else
			chatOutput.load()
			action = alert(src, "How about now? (give it a moment (it may also try to load twice))", "", "Yes", "No")
			if (action == "Yes")
				log_game("GOONCHAT: [key_name(src)] Had to fix their goonchat by re-creating the chatOutput datum and forcing a load()")
			else
				action = alert(src, "Welp, I'm all out of ideas. Try closing byond and reconnecting.\nWe could also disable fancy chat and re-enable oldchat", "", "Thanks anyways", "Switch to old chat")
				if (action == "Switch to old chat")
					winset(src, "output", "is-visible=true;is-disabled=false")
					winset(src, "browseroutput", "is-visible=false")
				log_game("GOONCHAT: [key_name(src)] Failed to fix their goonchat window after recreating the chatOutput and forcing a load()")

	else if (chatOutput.loaded)
		var/action = alert(src, "ChatOutput seems to be loaded\nDo you want me to force a reload, wiping the chat log or just refresh the chat window because it broke/went away?", "Hmmm", "Force Reload", "Refresh", "Cancel")
		switch (action)
			if ("Force Reload")
				chatOutput.loaded = FALSE
				chatOutput.start() //this is likely to fail since it asks , but we should try it anyways so we know.
				action = alert(src, "Goon chat reloading, wait a bit and tell me if it's fixed", "", "Fixed", "Nope")
				if (action == "Fixed")
					log_game("GOONCHAT: [key_name(src)] Had to fix their goonchat by forcing a start()")
				else
					chatOutput.load()
					action = alert(src, "How about now? (give it a moment (it may also try to load twice))", "", "Yes", "No")
					if (action == "Yes")
						log_game("GOONCHAT: [key_name(src)] Had to fix their goonchat by forcing a load()")
					else
						action = alert(src, "Welp, I'm all out of ideas. Try closing byond and reconnecting.\nWe could also disable fancy chat and re-enable oldchat", "", "Thanks anyways", "Switch to old chat")
						if (action == "Switch to old chat")
							winset(src, "output", "is-visible=true;is-disabled=false")
							winset(src, "browseroutput", "is-visible=false")
						log_game("GOONCHAT: [key_name(src)] Failed to fix their goonchat window forcing a start() and forcing a load()")

			if ("Refresh")
				chatOutput.showChat()
				action = alert(src, "Goon chat refreshing, wait a bit and tell me if it's fixed", "", "Fixed", "Nope, force a reload")
				if (action == "Fixed")
					log_game("GOONCHAT: [key_name(src)] Had to fix their goonchat by forcing a show()")
				else
					chatOutput.loaded = FALSE
					chatOutput.load()
					action = alert(src, "How about now? (give it a moment)", "", "Yes", "No")
					if (action == "Yes")
						log_game("GOONCHAT: [key_name(src)] Had to fix their goonchat by forcing a load()")
					else
						action = alert(src, "Welp, I'm all out of ideas. Try closing byond and reconnecting.\nWe could also disable fancy chat and re-enable oldchat", "", "Thanks anyways", "Switch to old chat")
						if (action == "Switch to old chat")
							winset(src, "output", "is-visible=true;is-disabled=false")
							winset(src, "browseroutput", "is-visible=false")
						log_game("GOONCHAT: [key_name(src)] Failed to fix their goonchat window forcing a show() and forcing a load()")
		return

	else
		chatOutput.start()
		var/action = alert(src, "Manually loading Chat, wait a bit and tell me if it's fixed", "", "Fixed", "Nope")
		if (action == "Fixed")
			log_game("GOONCHAT: [key_name(src)] Had to fix their goonchat by manually calling start()")
		else
			chatOutput.load()
			alert(src, "How about now? (give it a moment (it may also try to load twice))", "", "Yes", "No")
			if (action == "Yes")
				log_game("GOONCHAT: [key_name(src)] Had to fix their goonchat by manually calling start() and forcing a load()")
			else
				action = alert(src, "Welp, I'm all out of ideas. Try closing byond and reconnecting.\nWe could also disable fancy chat and re-enable oldchat", "", "Thanks anyways", "Switch to old chat")
				if (action == "Switch to old chat")
					winset(src, "output", list2params(list("on-show" = "", "is-disabled" = "false", "is-visible" = "true")))
					winset(src, "browseroutput", "is-disabled=true;is-visible=false")
				log_game("GOONCHAT: [key_name(src)] Failed to fix their goonchat window after manually calling start() and forcing a load()")

/client/proc/validate_oocpronouns(value)
	value = lowertext(value)

	if (!value || trim(value) == "")
		return TRUE

	// staff/donators can choose whatever pronouns they want given, you know, we trust them to use them like a normal person
	if (usr && is_admin(usr) || patreon.is_donator() || twitch.is_donator())
		return TRUE

	var/pronouns = splittext(value, "/")
	if (length(pronouns) > MAX_PRONOUNS)
		to_chat(usr, span_warning("You can only set up to [MAX_PRONOUNS] different pronouns."))
		return FALSE


	for (var/pronoun in pronouns)
		// pronouns can end in "self" or "selfs" so allow those
		// if has "self" or "selfs" at the end, remove it
		if (endswith(pronoun, "selfs"))
			pronoun = copytext(pronoun, 1, length(pronoun) - 5)
		else if (endswith(pronoun, "self"))
			pronoun = copytext(pronoun, 1, length(pronoun) - 4)
		pronoun = trim(pronoun)

		if (!(pronoun in GLOB.oocpronouns_valid))
			to_chat(usr, span_warning("Invalid pronoun: [pronoun]. Valid pronouns are: [GLOB.oocpronouns_valid.Join(", ")]"))
			return FALSE

	if (length(pronouns) != length(uniqueList(pronouns)))
		to_chat(usr, span_warning("You cannot use the same pronoun multiple times."))
		return FALSE

	for (var/pronoun in GLOB.oocpronouns_required)
		if (pronoun in pronouns)
			return TRUE

	to_chat(usr, span_warning("You must include at least one of the following pronouns: [GLOB.oocpronouns_required.Join(", ")]"))
	// Someone may yell at me i dont know
	return FALSE

/client/verb/setoocpronouns()
	set name = "Set OOC Pronouns"
	set category = "OOC"
	set desc = "Set the pronouns you want to use in OOC messages."

	if(is_misc_banned(ckey, BAN_MISC_OOCPRONOUNS))
		to_chat(src, span_danger("I have been banned from setting my OOC pronouns."))
		return

	var/old_pronouns = prefs.oocpronouns
	to_chat(src, span_notice("You can set up to [MAX_PRONOUNS] different pronouns, separated by slashes (/)."))
	if (prefs.oocpronouns)
		to_chat(src, span_notice("Your current OOC pronouns are: [prefs.oocpronouns]"))
	else
		to_chat(src, span_notice("You have not set any OOC pronouns yet."))

	if (usr && is_admin(usr))
		to_chat(src, span_notice("As staff, you can set this field however you like. But please use it in good faith."))

	var/new_pronouns = input("Enter your OOC pronouns (separated by slashes):", "Set OOC Pronouns", prefs.oocpronouns) as text|null
	if (isnull(new_pronouns))
		return
	if (!validate_oocpronouns(new_pronouns))
		return
	message_admins("OOC pronouns set by [usr] ([usr.ckey]) from [html_encode(old_pronouns)] to: [html_encode(new_pronouns)]")
	log_game("OOC pronouns set by [usr] ([usr.ckey]) from [html_encode(old_pronouns)] to: [html_encode(new_pronouns)]")
	prefs.oocpronouns = new_pronouns
	prefs.save_preferences()
	if (new_pronouns == "")
		to_chat(src, span_notice("Your OOC pronouns have been cleared."))
		return
	to_chat(src, span_notice("Your OOC pronouns have been set to: [new_pronouns]"))


/client/verb/motd()
	set name = "MOTD"
	set category = "OOC"
	set desc ="Check the Message of the Day"
	set hidden = 1
	if(!holder)
		return
	if(!check_rights(0))
		return
	var/motd = global.config.motd
	if(motd)
		to_chat(src, "<div class=\"motd\">[motd]</div>", handle_whitespace=FALSE)
	else
		to_chat(src, "<span class='notice'>The Message of the Day has not been set.</span>")

/client/proc/self_playtime()
	set name = "View tracked playtime"
	set category = "OOC"
	set desc = ""

	if(!CONFIG_GET(flag/use_exp_tracking))
		to_chat(usr, "<span class='notice'>Sorry, tracking is currently disabled.</span>")
		return

	var/list/body = list()
	body += "<html><head><title>Playtime for [key]</title></head><BODY><BR>Playtime:"
	body += get_exp_report()
	body += "</BODY></HTML>"
	usr << browse(body.Join(), "window=playerplaytime[ckey];size=550x615")

/client/proc/ignore_key(client, displayed_key)
	var/client/C = client
	if(C.key in prefs.ignoring)
		prefs.ignoring -= C.key
	else
		prefs.ignoring |= C.key
	to_chat(src, "You are [(C.key in prefs.ignoring) ? "now" : "no longer"] ignoring [displayed_key] on the OOC channel.")
	prefs.save_preferences()

/client/verb/select_ignore()
	set name = "Ignore Player"
	set category = "OOC"
	set desc ="Ignore a player's messages on the OOC channel"
	set hidden = 1
	if(!holder)
		return

	var/see_ghost_names = isobserver(mob)
	var/list/choices = list()
	var/displayed_choicename = ""
	for(var/client/C in GLOB.clients)
		if(C.holder?.fakekey)
			displayed_choicename = C.holder.fakekey
		else
			displayed_choicename = C.key
		if(isobserver(C.mob) && see_ghost_names)
			choices["[C.mob]([displayed_choicename])"] = C
		else
			choices[displayed_choicename] = C
	choices = sortList(choices)
	var/selection = input("Please, select a player!", "Ignore", null, null) as null|anything in choices
	if(!selection || !(selection in choices))
		return
	displayed_choicename = selection // ckey string
	selection = choices[selection] // client
	if(selection == src)
		to_chat(src, "You can't ignore myself.")
		return
	ignore_key(selection, displayed_choicename)

/client/proc/show_previous_roundend_report()
	set name = "Your Last Round"
	set category = "OOC"
	set desc = ""

	SSticker.show_roundend_report(src, TRUE)

/client/verb/fit_viewport()
	set name = "Fit Viewport"
	set category = "Preferences.Options"
	set desc = ""
	set hidden = 1
	if(!holder)
		return
	// Fetch aspect ratio
	var/view_size = getviewsize(view)
	var/aspect_ratio = view_size[1] / (view_size[2] / 1.3)

	// Calculate desired pixel width using window size and aspect ratio
	var/sizes = params2list(winget(src, "mainwindow.split;mapwindow", "size"))
	var/map_size = splittext(sizes["mapwindow.size"], "x")
	var/height = text2num(map_size[2])
	var/desired_width = round(height * aspect_ratio)
	if (text2num(map_size[1]) == desired_width)
		// Nothing to do
		return

	var/split_size = splittext(sizes["mainwindow.split.size"], "x")
	var/split_width = text2num(split_size[1])

	// Calculate and apply a best estimate
	// +4 pixels are for the width of the splitter's handle
	var/pct = 100 * (desired_width + 4) / split_width
	winset(src, "mainwindow.split", "splitter=[pct]")

	// Apply an ever-lowering offset until we finish or fail
	var/delta
	for(var/safety in 1 to 10)
		var/after_size = winget(src, "mapwindow", "size")
		map_size = splittext(after_size, "x")
		var/got_width = text2num(map_size[1])

		if (got_width == desired_width)
			// success
			return
		else if (isnull(delta))
			// calculate a probable delta value based on the difference
			delta = 100 * (desired_width - got_width) / split_width
		else if ((delta > 0 && got_width > desired_width) || (delta < 0 && got_width < desired_width))
			// if we overshot, halve the delta and reverse direction
			delta = -delta/2

		pct += delta
		winset(src, "mainwindow.split", "splitter=[pct]")


/client/verb/policy()
	set name = "Show Policy"
	set desc = ""
	set category = "OOC.Links"
	set hidden = 1
	if(!holder)
		return

	//Collect keywords
	var/list/keywords = mob.get_policy_keywords()
	var/header = get_policy(POLICY_VERB_HEADER)
	var/list/policytext = list(header,"<hr>")
	var/anything = FALSE
	for(var/keyword in keywords)
		var/p = get_policy(keyword)
		if(p)
			policytext += p
			policytext += "<hr>"
			anything = TRUE
	if(!anything)
		policytext += "No related rules found."

	usr << browse(policytext.Join(""),"window=policy")

#undef MAX_PRONOUNS
