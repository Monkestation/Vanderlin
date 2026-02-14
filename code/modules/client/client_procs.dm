	////////////
	//SECURITY//
	////////////
#define UPLOAD_LIMIT		1048576	//Restricts client uploads to the server to 1MB //Could probably do with being lower.

GLOBAL_LIST_INIT(blacklisted_builds, list(
	"1407" = "bug preventing client display overrides from working leads to clients being able to see things/mobs they shouldn't be able to see",
	"1408" = "bug preventing client display overrides from working leads to clients being able to see things/mobs they shouldn't be able to see",
	"1428" = "bug causing right-click menus to show too many verbs that's been fixed in version 1429",

	))

GLOBAL_LIST_EMPTY(respawntimes)
GLOBAL_LIST_EMPTY(respawncounts)

#define LIMITER_SIZE	5
#define CURRENT_SECOND	1
#define SECOND_COUNT	2
#define CURRENT_MINUTE	3
#define MINUTE_COUNT	4
#define ADMINSWARNED_AT	5
	/*
	When somebody clicks a link in game, this Topic is called first.
	It does the stuff in this proc and  then is redirected to the Topic() proc for the src=[0xWhatever]
	(if specified in the link). ie locate(hsrc).Topic()

	Such links can be spoofed.

	Because of this certain things MUST be considered whenever adding a Topic() for something:
		- Can it be fed harmful values which could cause runtimes?
		- Is the Topic call an admin-only thing?
		- If so, does it have checks to see if the person who called it (usr.client) is an admin?
		- Are the processes being called by Topic() particularly laggy?
		- If so, is there any protection against somebody spam-clicking a link?
	If you have any  questions about this stuff feel free to ask. ~Carn
	*/

/client
	var/commendedsomeone
	var/atom/movable/movingmob
	var/whitelisted = 2
	var/list/job_priority_boosts = list()

/client/Topic(href, href_list, hsrc, hsrc_command)
	if(!usr || usr != mob)	//stops us calling Topic for somebody else's client. Also helps prevent usr=null
		return

#ifndef TESTING
	if (LOWER_TEXT(hsrc_command) == "_debug") //disable the integrated byond vv in the client side debugging tools since it doesn't respect vv read protections
		return
#endif

	// asset_cache
	var/asset_cache_job
	if(href_list["asset_cache_confirm_arrival"])
		asset_cache_job = round(text2num(href_list["asset_cache_confirm_arrival"]))
		//because we skip the limiter, we have to make sure this is a valid arrival and not somebody tricking us
		//	into letting append to a list without limit.
		if (asset_cache_job > 0 && asset_cache_job <= last_asset_job && !(asset_cache_job in completed_asset_jobs))
			completed_asset_jobs += asset_cache_job
			return

	var/atom/ref = locate(href_list["src"])
	if(!holder && (href_list["window_id"] != "statbrowser") && !istype(ref, /datum/native_say))
		var/mtl = CONFIG_GET(number/minute_topic_limit)
		if (mtl)
			var/minute = round(world.time, 1 MINUTES)
			if (!topiclimiter)
				topiclimiter = new(LIMITER_SIZE)
			if (minute != topiclimiter[CURRENT_MINUTE])
				topiclimiter[CURRENT_MINUTE] = minute
				topiclimiter[MINUTE_COUNT] = 0
			topiclimiter[MINUTE_COUNT] += 1
			if (topiclimiter[MINUTE_COUNT] > mtl)
				var/msg = "Your previous action was ignored because you've done too many in a minute."
				if (minute != topiclimiter[ADMINSWARNED_AT]) //only one admin message per-minute. (if they spam the admins can just boot/ban them)
					topiclimiter[ADMINSWARNED_AT] = minute
					msg += " Administrators have been informed."
					log_game("[key_name(src)] Has hit the per-minute topic limit of [mtl] topic calls in a given game minute")
					message_admins("[ADMIN_LOOKUPFLW(usr)] [ADMIN_KICK(usr)] Has hit the per-minute topic limit of [mtl] topic calls in a given game minute")
				to_chat(src, span_danger("[msg]"))
				return

		var/stl = CONFIG_GET(number/second_topic_limit)
		if (stl)
			var/second = round(world.time, 1 SECONDS)
			if (!topiclimiter)
				topiclimiter = new(LIMITER_SIZE)
			if (second != topiclimiter[CURRENT_SECOND])
				topiclimiter[CURRENT_SECOND] = second
				topiclimiter[SECOND_COUNT] = 0
			topiclimiter[SECOND_COUNT] += 1
			if (topiclimiter[SECOND_COUNT] > stl)
				to_chat(src, span_danger("Your previous action was ignored because you've done too many in a second"))
				return

	// Tgui Topic middleware
	if(tgui_Topic(href_list))
		return

	if(href_list["reload_statbrowser"])
		stat_panel.reinitialize()

	//Logs all hrefs, except chat pings
	if(!(href_list["_src_"] == "chat" && href_list["proc"] == "ping" && LAZYLEN(href_list) == 2))
		log_href("[src] (usr:[usr]\[[COORD(usr)]\]) : [hsrc ? "[hsrc] " : ""][href]")

	//byond bug ID:2256651
	if (asset_cache_job && (asset_cache_job in completed_asset_jobs))
		to_chat(src, "<span class='danger'>An error has been detected in how my client is receiving resources. Attempting to correct.... (If you keep seeing these messages you might want to close byond and reconnect)</span>")
		src << browse("...", "window=asset_cache_browser")

	// Keypress passthrough
	if(href_list["__keydown"])
		var/keycode = browser_keycode_to_byond(href_list["__keydown"])
		if(keycode)
			keyDown(keycode)
		return
	if(href_list["__keyup"])
		var/keycode = browser_keycode_to_byond(href_list["__keyup"])
		if(keycode)
			keyUp(keycode)
		return

	// ANSWER SCHIZOHELP
	if(href_list["schizohelp"])
		var/datum/schizohelp/schizo = locate(href_list["schizohelp"])
		var/again = (href_list["ask_again"]) ? TRUE : FALSE
		answer_schizohelp(schizo, again)
		return

	// ASK AGAIN SCHIZOHELP
	if(href_list["ask_again"])
		var/datum/schizohelp/schizo = locate(href_list["ask_again"])
		var/mob/voice = locate(href_list["voice"])
		if(QDELETED(schizo) || !voice.client)
			return
		var/msg = input("Ask again:", "To the voice of a [schizo.voice_names[voice.client.ckey]]") as text|null
		if(msg)
			mob.schizohelp(msg, TRUE, voice, schizo)
			schizo.asked_again = TRUE
			return

	// LIKE SCHIZOHELP
	if(href_list["like"])
		var/datum/schizohelp/schizo = locate(href_list["src"])
		var/mob/voice = locate(href_list["like"])
		if(schizo && voice && voice.client)
			var/voice_ckey = voice.client.ckey
			if(!schizo.voted[voice_ckey])
				schizo.voted[voice_ckey] = list()
			// has this player already voted on THIS voice's answer?
			if(!(schizo.voted[voice_ckey][src.ckey]))
				schizo.voted[voice_ckey][src.ckey] = "like"

				to_chat(src, span_notice("You liked the answer of a [schizo.voice_names[voice.client.ckey]]"))
				to_chat(voice.client, span_notice("Your answer to [schizo.rng_name] was liked."))
				update_mentor_stat(voice.client.ckey, "likes", 1, voice)
				var/now = world.time
				var/last_like_from_player = voice.client.real_like_cooldowns[src.ckey]

				//Limit of 35 Real likes per Round aka 5 Triumphs
				if(voice.client.real_likes_received >= 35)
					return
				//Can't give real likes for the same voice without a 10 Minutes cooldown
				if(last_like_from_player && now - last_like_from_player < 10 MINUTES)
					return

				voice.client.real_like_cooldowns[src.ckey] = now
				voice.client.real_likes_received  += 1

				update_mentor_stat(voice.client.ckey, "real_likes", 1, voice)
			else
				to_chat(src, span_warning("You already voted on the [schizo.voice_names[voice.client.ckey]] answer!"))
		return

	// DISLIKE SCHIZOHELP
	if(href_list["dislike"])
		var/datum/schizohelp/schizo = locate(href_list["src"])
		var/mob/voice = locate(href_list["dislike"])
		if(schizo && voice && voice.client)
			var/voice_ckey = voice.client.ckey
			if(!schizo.voted[voice_ckey])
				schizo.voted[voice_ckey] = list()
			// has this player already voted on THIS voice's answer?
			if(!(schizo.voted[voice_ckey][src.ckey]))
				schizo.voted[voice_ckey][src.ckey] = "dislike"
				to_chat(src, span_notice("You disliked the answer of a [schizo.voice_names[voice.client.ckey]]."))
				to_chat(voice.client, span_notice("Your answer to [schizo.rng_name] was disliked"))
				update_mentor_stat(voice.client.ckey, "dislikes", 1, voice)
			else
				to_chat(src, span_warning("You already voted on the [schizo.voice_names[voice.client.ckey]] answer!"))
		return

	if(href_list["delete_painting"])
		if(!holder)
			return
		var/title = href_list["id"]
		if(!title)
			return
		if(alert("Are you sure you want to delete the painting '[title]'?", "Confirm Deletion", "Yes", "No") == "Yes")
			if(SSpaintings.del_player_painting(title))
				message_admins("[key_name_admin(src)] has deleted player made painting called: '[title]'")
				SSpaintings.update_paintings()
				manage_paintings()

	if(href_list["delete_book"])
		if(!holder)
			return
		var/title = href_list["id"]
		var/author = href_list["author_ckey"]
		if(!title)
			return
		var/real_title = url_decode(title)
		if(alert("Are you sure you want to delete the book '[real_title]'?", "Confirm Deletion", "Yes", "No") == "Yes")
			if(SSlibrarian.del_player_book(title, author))
				message_admins("[key_name_admin(src)] has deleted player made book called: '[real_title]' by [author]")
				manage_books()

	if(href_list["show_book"])
		if(!holder)
			return
		var/title = href_list["id"]
		if(!title)
			return
		show_book_content(title)

	// Admin PM
	if(href_list["priv_msg"])
		cmd_admin_pm(href_list["priv_msg"],null)
		return

	if(href_list["playerlist"])
		if(SSticker.current_state != GAME_STATE_FINISHED)
			return
		view_rogue_manifest()
		return

	if(href_list["commendsomeone"])
		commendation_popup(TRUE)
		return

	if(href_list["viewstats"])
		show_round_stats(href_list["featured_stat"])
		return

	if(href_list["select_featured_stat"])
		select_featured_stat()
		return

	if(href_list["viewinfluences"])
		var/debug_mode = text2num(href_list["debug"])
		show_influences(debug_mode)
		return

	if(href_list["viewchronicle"])
		var/tab = href_list["chronicletab"] || "The Realm"
		show_chronicle(tab)
		return

	switch(href_list["_src_"])
		if("holder")
			hsrc = holder
		if("usr")
			hsrc = mob
		if("prefs")
			if (inprefs)
				return
			inprefs = TRUE
			. = prefs.process_link(usr,href_list)
			inprefs = FALSE
			return
		if("vars")
			return view_var_Topic(href,href_list,hsrc)
		if("chat")
			return chatOutput.Topic(href, href_list)

	switch(href_list["action"])
		if("openLink")
			src << link(href_list["link"])

	if(hsrc)
		var/datum/real_src = hsrc
		if(QDELETED(real_src))
			return

	//fun fact: Topic() acts like a verb and is executed at the end of the tick like other verbs. So we have to queue it if the server is
	//overloaded
	if(hsrc && hsrc != holder && DEFAULT_TRY_QUEUE_VERB(VERB_CALLBACK(src, PROC_REF(_Topic), hsrc, href, href_list)))
		return

	..()	//redirect to hsrc.Topic()

/client/proc/set_right_click_menu_mode(ctrl_only)

	if(ctrl_only)
		winset(src, "mapwindow.map", "right-click=true")
		winset(src, "CtrlUp", "is-disabled=false")
		winset(src, "Ctrl", "is-disabled=false")
	else
		winset(src, "mapwindow.map", "right-click=false")
		winset(src, "default.Ctrl", "is-disabled=true")
		winset(src, "default.CtrlUp", "is-disabled=true")

/client/proc/commendation_popup(intentional = FALSE)
	if(SSticker.current_state != GAME_STATE_FINISHED)
		return
	if(commendedsomeone)
		return
	if(!intentional)
		if(browser_alert(src, "DOES ANY SOUL DESERVE COMMENDATION?", "THE CURTAINS CLOSE", reverseRange(DEFAULT_INPUT_CHOICES), 20 SECONDS) != CHOICE_YES)
			return
	var/list/selections = GLOB.character_ckey_list.Copy()
	if(!selections.len)
		return
	var/list/selection_w_title = list()
	var/list/human_mobs = GLOB.human_list.Copy()
	for(var/real_name in selections)
		var/ckey =  GLOB.character_ckey_list[real_name]
		var/mob/living/carbon/human/H
		for(var/mob/mob in human_mobs)
			if(mob?.real_name == real_name)
				H = mob
				break
		if(QDELETED(H) || !istype(H))
			selection_w_title[real_name] = ckey
		else
			selection_w_title["[real_name], [H.get_role_title()]"] = ckey
	if(!selection_w_title)
		ASYNC {
			browser_alert(src, "this dude really playing VANDERLIN all by themself lmfaoooo")
		}
	var/selection = browser_input_list(src, "WHO RECIEVES YOUR COMMENDATION?", null, shuffle(selection_w_title), pick(selection_w_title))
	if(!selection)
		return
	if(commendedsomeone)
		return
	var/theykey = selection_w_title[selection]
	if(theykey == ckey)
		ASYNC {
			browser_alert(src,"YOU MAY NOT COMMEND YOURSELF", "THE EGO")
		}
		return
	if(theykey)
		commendedsomeone = TRUE
		add_commend(theykey, ckey)
		to_chat(src, "You have COMMENDED [selection].")
		log_game("COMMEND: [ckey] commends [theykey].")
		log_admin("COMMEND: [ckey] commends [theykey].")
	return

///dumb workaround because byond doesnt seem to recognize the Topic() typepath for /datum/proc/Topic() from the client Topic,
///so we cant queue it without this
/client/proc/_Topic(datum/hsrc, href, list/href_list)
	return hsrc.Topic(href, href_list)

/client/proc/is_content_unlocked()
	if(!prefs.unlock_content)
		to_chat(src, "Become a BYOND member to access member-perks and features, as well as support the engine that makes this game possible. Only 10 bucks for 3 months! <a href=\"https://secure.byond.com/membership\">Click Here to find out more</a>.")
		return 0
	return 1
/*
* Call back proc that should be checked in all paths where a client can send messages
*
* Handles checking for duplicate messages and people sending messages too fast
*
* The first checks are if you're sending too fast, this is defined as sending
* SPAM_TRIGGER_AUTOMUTE messages in
* 5 seconds, this will start supressing my messages,
* if you send 2* that limit, you also get muted
*
* The second checks for the same duplicate message too many times and mutes
* you for it
*/
/client/proc/handle_spam_prevention(message, mute_type)

	//Increment message count
	total_message_count += 1

	//store the total to act on even after a reset
	var/cache = total_message_count

	if(total_count_reset <= world.time)
		total_message_count = 0
		total_count_reset = world.time + (5 SECONDS)

	//If they're really going crazy, mute them
	if(cache >= SPAM_TRIGGER_AUTOMUTE * 2)
		total_message_count = 0
		total_count_reset = 0
		cmd_admin_mute(src, mute_type, 1)
		return 1

	//Otherwise just supress the message
	else if(cache >= SPAM_TRIGGER_AUTOMUTE)
		return 1


	if(CONFIG_GET(flag/automute_on) && !holder && last_message == message)
		src.last_message_count++
		if(src.last_message_count >= SPAM_TRIGGER_AUTOMUTE)
			to_chat(src, "<span class='danger'>I have exceeded the spam filter limit for identical messages. An auto-mute was applied.</span>")
			cmd_admin_mute(src, mute_type, 1)
			return 1
		if(src.last_message_count >= SPAM_TRIGGER_WARNING)
			to_chat(src, "<span class='danger'>I am nearing the spam filter limit for identical messages.</span>")
			return 0
	else
		last_message = message
		src.last_message_count = 0
		return 0
/*
//This stops files larger than UPLOAD_LIMIT being sent from client to server via input(), client.Import() etc.
/client/AllowUpload(filename, filelength)
	if(filelength > UPLOAD_LIMIT)
		to_chat(src, "<font color='red'>Error: AllowUpload(): File Upload too large. Upload Limit: [UPLOAD_LIMIT/1024]KiB.</font>")
		return 0
	return 1
*/

	///////////
	//CONNECT//
	///////////

/client/New(TopicData)
	var/tdata = TopicData //save this for later use
	TopicData = null							//Prevent calls to client.Topic from connect

	if(connection != "seeker" && connection != "web")//Invalid connection type.
		return null

	GLOB.clients += src
	GLOB.keys_by_ckey[ckey] = key
	GLOB.directory[ckey] = src

	stat_panel = new(src, "statbrowser")
	stat_panel.subscribe(src, PROC_REF(on_stat_panel_message))

	chatOutput = new /datum/chatOutput(src)
	spawn(5) // Goonchat does some non-instant checks in start()
		chatOutput.start()

	GLOB.ahelp_tickets.ClientLogin(src)
	var/connecting_admin = FALSE //because de-admined admins connecting should be treated like admins.
	//Admin Authorisation
	holder = GLOB.admin_datums[ckey]

	if(holder)
		GLOB.admins |= src
		holder.owner = src
		connecting_admin = TRUE
	else if(GLOB.deadmins[ckey])
		add_verb(src, /client/proc/readmin)
		connecting_admin = TRUE

	if(CONFIG_GET(flag/autoadmin))
		if(!GLOB.admin_datums[ckey])
			var/datum/admin_rank/autorank
			for(var/datum/admin_rank/R in GLOB.admin_ranks)
				if(R.name == CONFIG_GET(string/autoadmin_rank))
					autorank = R
					break
			if(!autorank)
				to_chat(world, "Autoadmin rank not found")
			else
				new /datum/admins(autorank, ckey)

	if(CONFIG_GET(flag/enable_localhost_rank) && !connecting_admin)
		var/localhost_addresses = list("127.0.0.1", "::1")
		if(isnull(address) || (address in localhost_addresses))
			var/datum/admin_rank/localhost_rank = new("!localhost!", R_EVERYTHING, R_DBRANKS, R_EVERYTHING) //+EVERYTHING -DBRANKS *EVERYTHING
			new /datum/admins(localhost_rank, ckey, 1, 1)

	// Init donator data, used by prefs
	patreon = new(src)
	twitch = new(src)
	native_say = new(src)

	//preferences datum - also holds some persistent data for the client (because we may as well keep these datums to a minimum)
	prefs = GLOB.preferences_datums[ckey]
	if(prefs)
		prefs.parent = src
	else
		prefs = new /datum/preferences(src)
		GLOB.preferences_datums[ckey] = prefs
	if(!holder)
		prefs.chat_toggles &= ~CHAT_GHOSTEARS
		prefs.chat_toggles &= ~CHAT_GHOSTWHISPER
		prefs.save_preferences()
	prefs.last_ip = address				//these are gonna be used for banning
	prefs.last_id = computer_id			//these are gonna be used for banning
	fps = prefs.clientfps

	if(fexists(roundend_report_file()))
		add_verb(src, /client/proc/show_previous_roundend_report)

	var/full_version = "[byond_version].[byond_build ? byond_build : "xxx"]"
	log_access("Login: [key_name(src)] from [address ? address : "localhost"]-[computer_id] || BYOND v[full_version]")

	var/alert_mob_dupe_login = FALSE
	if(CONFIG_GET(flag/log_access))
		for(var/I in GLOB.clients)
			if(!I || I == src)
				continue
			var/client/C = I
			if(holder && C.holder)
				if(check_rights_for(C, R_ADMIN))
					to_chat(C, "Admin Login: [key]")
			if(C.key && (C.key != key) )
				var/matches
				if( (C.address == address) )
					matches += "IP ([address])"
				if( (C.computer_id == computer_id) )
					if(matches)
						matches += " and "
					matches += "ID ([computer_id])"
					alert_mob_dupe_login = TRUE
				if(matches)
					if(C)
						message_admins("<span class='danger'><B>Notice: </B></span><span class='notice'>[key_name_admin(src)] has the same [matches] as [key_name_admin(C)].</span>")
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(C)].")
					else
						message_admins("<span class='danger'><B>Notice: </B></span><span class='notice'>[key_name_admin(src)] has the same [matches] as [key_name_admin(C)] (no longer logged in). </span>")
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(C)] (no longer logged in).")

	show_popup_menus = FALSE

	if(holder)
		show_popup_menus = TRUE

	set_right_click_menu_mode(TRUE)

	var/reconnecting = FALSE
	if(GLOB.player_details[ckey])
		reconnecting = TRUE
		player_details = GLOB.player_details[ckey]
		player_details.byond_version = full_version
		player_details.byond_build = byond_build
	else
		player_details = new(ckey)
		player_details.byond_version = full_version
		player_details.byond_build = byond_build
		GLOB.player_details[ckey] = player_details


	. = ..()	//calls mob.Login()

	if (byond_version >= 512)
		if (!byond_build || byond_build < 1386)
			message_admins("<span class='adminnotice'>[key_name(src)] has been detected as spoofing their byond version. Connection rejected.</span>")
			add_system_note("Spoofed-Byond-Version", "Detected as using a spoofed byond version.")
			log_access("Failed Login: [key] - Spoofed byond version")
			qdel(src)

		if (num2text(byond_build) in GLOB.blacklisted_builds)
			log_access("Failed login: [key] - blacklisted byond version")
			to_chat(src, "<span class='danger'>My version of byond is blacklisted.</span>")
			to_chat(src, "<span class='danger'>Byond build [byond_build] ([byond_version].[byond_build]) has been blacklisted for the following reason: [GLOB.blacklisted_builds[num2text(byond_build)]].</span>")
			to_chat(src, "<span class='danger'>Please download a new version of byond. If [byond_build] is the latest, you can go to <a href=\"https://secure.byond.com/download/build\">BYOND's website</a> to download other versions.</span>")
			if(connecting_admin)
				to_chat(src, "As an admin, you are being allowed to continue using this version, but please consider changing byond versions")
			else
				qdel(src)
				return

	if(SSinput.initialized)
		set_macros()
		update_movement_keys()

	// Initialize stat panel
	stat_panel.initialize(
		inline_html = file("html/statbrowser.html"),
		inline_js = file("html/statbrowser.js"),
		inline_css = file("html/statbrowser.css"),
	)
	addtimer(CALLBACK(src, PROC_REF(check_panel_loaded)), 30 SECONDS)

//	chatOutput.start() // Starts the chat
	INVOKE_ASYNC(src, PROC_REF(acquire_dpi))

	if(alert_mob_dupe_login)
		spawn()
			alert(mob, "You have logged in already with another key this round, please log out of this one NOW or risk being banned!")

	connection_time = world.time
	connection_realtime = world.realtime
	connection_timeofday = world.timeofday
	winset(src, null, "command=\".configure graphics-hwmode on\"")
	var/cev = CONFIG_GET(number/client_error_version)
	var/ceb = CONFIG_GET(number/client_error_build)
	var/cwv = CONFIG_GET(number/client_warn_version)
	if (byond_version < cev || byond_build < ceb)		//Out of date client.
		to_chat(src, "<span class='danger'><b>My version of BYOND is too old:</b></span>")
		to_chat(src, CONFIG_GET(string/client_error_message))
		to_chat(src, "Your version: [byond_version].[byond_build]")
		to_chat(src, "Required version: [cev].[ceb] or later")
		to_chat(src, "Visit <a href=\"https://secure.byond.com/download\">BYOND's website</a> to get the latest version of BYOND.")
		if (connecting_admin)
			to_chat(src, "Because you are an admin, you are being allowed to walk past this limitation, But it is still STRONGLY suggested you upgrade")
		else
			qdel(src)
			return 0
	else if (byond_version < cwv)	//We have words for this client.
		if(CONFIG_GET(flag/client_warn_popup))
			var/msg = "<b>My version of byond may be getting out of date:</b><br>"
			msg += CONFIG_GET(string/client_warn_message) + "<br><br>"
			msg += "Your version: [byond_version]<br>"
			msg += "Required version to remove this message: [cwv] or later<br>"
			msg += "Visit <a href=\"https://secure.byond.com/download\">BYOND's website</a> to get the latest version of BYOND.<br>"
			src << browse(msg, "window=warning_popup")
		else
			to_chat(src, "<span class='danger'><b>My version of byond may be getting out of date:</b></span>")
			to_chat(src, CONFIG_GET(string/client_warn_message))
			to_chat(src, "Your version: [byond_version]")
			to_chat(src, "Required version to remove this message: [cwv] or later")
			to_chat(src, "Visit <a href=\"https://secure.byond.com/download\">BYOND's website</a> to get the latest version of BYOND.")

	if(connection == "web" && !connecting_admin)
		if(!CONFIG_GET(flag/allow_webclient))
			to_chat(src, "Web client is disabled")
			qdel(src)
			return 0
		if(CONFIG_GET(flag/webclient_only_byond_members) && !IsByondMember())
			to_chat(src, "Sorry, but the web client is restricted to byond members only.")
			qdel(src)
			return 0

	if((world.address == address || !address) && !GLOB.host)
		GLOB.host = key
		world.update_status()

	if(holder)
		add_admin_verbs()
		to_chat(src, get_message_output("memo"))
		adminGreet()
	if(mob && reconnecting)
		var/area/joined_area = get_area(mob.loc)
		if(joined_area)
			joined_area.reconnect_game(mob)

	add_verbs_from_config()
	var/cached_player_age = set_client_age_from_db(tdata) //we have to cache this because other shit may change it and we need it's current value now down below.
	if(isnum(cached_player_age) && cached_player_age == -1) //first connection
		player_age = 0
	var/nnpa = CONFIG_GET(number/notify_new_player_age)
	if(isnum(cached_player_age) && cached_player_age == -1) //first connection
		if(nnpa >= 0)
			message_admins("New user: [key_name_admin(src)] [ADMIN_PP(mob)] is connecting here for the first time.")
			if(CONFIG_GET(flag/irc_first_connection_alert))
				send2irc_adminless_only("New-user", "[key_name(src)] is connecting for the first time!")
	else if(isnum(cached_player_age) && cached_player_age < nnpa)
		message_admins("New user: [key_name_admin(src)] just connected with an age of [cached_player_age] day[(player_age==1?"":"s")]")
	if(CONFIG_GET(flag/use_account_age_for_jobs) && account_age >= 0)
		player_age = account_age
	if(account_age >= 0 && account_age < nnpa)
		message_admins("[key_name_admin(src)] (IP: [address], ID: [computer_id]) is a new BYOND account [account_age] day[(account_age==1?"":"s")] old, created on [account_join_date].")
		if (CONFIG_GET(flag/irc_first_connection_alert))
			send2irc_adminless_only("new_byond_user", "[key_name(src)] (IP: [address], ID: [computer_id]) is a new BYOND account [account_age] day[(account_age==1?"":"s")] old, created on [account_join_date].")
	get_message_output("watchlist entry", ckey)
	check_overwatch()
	validate_key_in_db()

	// If we aren't already generating a ban cache, fire off a build request
	// This way hopefully any users of request_ban_cache will never need to yield
	if(!ban_cache_start && SSban_cache?.query_started)
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(build_ban_cache), src)

	send_resources()


	generate_clickcatcher()
	apply_clickcatcher()

	if(prefs.toggles & TOGGLE_FULLSCREEN)
		toggle_fullscreeny(TRUE)
	else
		toggle_fullscreeny(FALSE)

	if(ckey in GLOB.clientmessages)
		for(var/message in GLOB.clientmessages[ckey])
			to_chat(src, message)
		GLOB.clientmessages.Remove(ckey)

	if(CONFIG_GET(flag/autoconvert_notes))
		convert_notes_sql(ckey)


	to_chat(src, get_message_output("message", ckey))

	update_ambience_pref()

	//This is down here because of the browse() calls in tooltip/New()
	if(!tooltips)
		tooltips = new /datum/tooltip(src)

	var/list/topmenus = GLOB.menulist[/datum/verbs/menu]
	for(var/thing in topmenus)
		var/datum/verbs/menu/topmenu = thing
		var/topmenuname = "[topmenu]"
		if(topmenuname == "[topmenu.type]")
			var/list/tree = splittext(topmenuname, "/")
			topmenuname = tree[tree.len]
		winset(src, "[topmenu.type]", "parent=menu;name=[url_encode(topmenuname)]")
		var/list/entries = topmenu.Generate_list(src)
		for(var/child in entries)
			winset(src, "[child]", "[entries[child]]")
			if(!ispath(child, /datum/verbs/menu))
				var/procpath/verbpath = child
				if (copytext(verbpath.name,1,2) != "@")
					new child(src)

	for(var/thing in prefs.menuoptions)
		var/datum/verbs/menu/menuitem = GLOB.menulist[thing]
		if (menuitem)
			menuitem.Load_checked(src)


	if(byond_version >= 516) // Enable 516 compat browser storage mechanisms
		winset(src, null, "browser-options=byondstorage,find,devtools")

	loot_panel = new(src)

	view_size = new(src, getScreenSize())
	view_size.resetFormat()
	view_size.setZoomMode()
	fit_viewport()
	SSjob.load_player_boosts(ckey)
	enable_seasonal_buys()

	Master.UpdateTickRate()

//////////////
//DISCONNECT//
//////////////

/client/Del()
	if(!gc_destroyed)
		gc_destroyed = world.time
		if (!QDELING(src))
			stack_trace("Client does not purport to be QDELING, this is going to cause bugs in other places!")

		// Yes this is the same as what's found in qdel(). Yes it does need to be here
		// Get off my back
		SEND_SIGNAL(src, COMSIG_PARENT_QDELETING, TRUE)
		Destroy() //Clean up signals and timers.
	return ..()

/client/Destroy()
	STOP_PROCESSING(SSmousecharge, src)
	if(holder)
		for(var/I in GLOB.clients)
			if(!I || I == src)
				continue
			var/client/C = I
			if(C.holder)
				if(check_rights_for(C, R_ADMIN))
					to_chat(C, "Admin Logout: [ckey]")
		adminGreet(1)
		holder.owner = null
		GLOB.admins -= src

	GLOB.clients -= src
	GLOB.directory -= ckey

	log_access("Logout: [key_name(src)]")
	GLOB.ahelp_tickets.ClientLogout(src)

	if(length(credits))
		QDEL_LIST(credits)

	QDEL_NULL(loot_panel)

	if(player_details)
		player_details.achievements.save()

	if(movingmob != null)
		movingmob.client_mobs_in_contents -= mob
		UNSETEMPTY(movingmob.client_mobs_in_contents)

	QDEL_LIST_ASSOC_VAL(char_render_holders)

	SSjob.save_player_boosts(ckey)
	SSambience.remove_ambience_client(src)
	SSmouse_entered.hovers -= src
	seen_messages = null
	Master.UpdateTickRate()
	..() //Even though we're going to be hard deleted there are still some things that want to know the destroy is happening
	return QDEL_HINT_HARDDEL_NOW

/client/proc/set_client_age_from_db(connectiontopic)
	if (IsGuestKey(src.key))
		return
	if(!SSdbcore.Connect())
		return
	var/datum/DBQuery/query_get_related_ip = SSdbcore.NewQuery(
		"SELECT ckey FROM [format_table_name("player")] WHERE ip = INET_ATON(:address) AND ckey != :ckey",
		list("address" = address, "ckey" = ckey)
	)
	if(!query_get_related_ip.Execute())
		qdel(query_get_related_ip)
		return
	related_accounts_ip = ""
	while(query_get_related_ip.NextRow())
		related_accounts_ip += "[query_get_related_ip.item[1]], "
	qdel(query_get_related_ip)
	var/datum/DBQuery/query_get_related_cid = SSdbcore.NewQuery(
		"SELECT ckey FROM [format_table_name("player")] WHERE computerid = :computerid AND ckey != :ckey",
		list("computerid" = computer_id, "ckey" = ckey)
	)
	if(!query_get_related_cid.Execute())
		qdel(query_get_related_cid)
		return
	related_accounts_cid = ""
	while (query_get_related_cid.NextRow())
		related_accounts_cid += "[query_get_related_cid.item[1]], "
	qdel(query_get_related_cid)
	var/admin_rank = "Player"
	if (src.holder && src.holder.rank)
		admin_rank = src.holder.rank.name
	else
		if (!GLOB.deadmins[ckey] && check_randomizer(connectiontopic))
			return

	var/new_player
	var/datum/DBQuery/query_client_in_db = SSdbcore.NewQuery(
		"SELECT 1 FROM [format_table_name("player")] WHERE ckey = :ckey",
		list("ckey" = ckey)
	)
	if(!query_client_in_db.Execute())
		qdel(query_client_in_db)
		return
	if(!query_client_in_db.NextRow())
		if (CONFIG_GET(flag/panic_bunker) && !holder && !GLOB.deadmins[ckey])
			log_access("Failed Login: [key] - New account attempting to connect during panic bunker")
			message_admins("<span class='adminnotice'>Failed Login: [key] - New account attempting to connect during panic bunker</span>")
			to_chat(src, CONFIG_GET(string/panic_bunker_message))
			var/list/connectiontopic_a = params2list(connectiontopic)
			var/list/panic_addr = CONFIG_GET(string/panic_server_address)
			if(panic_addr && !connectiontopic_a["redirect"])
				var/panic_name = CONFIG_GET(string/panic_server_name)
				to_chat(src, "<span class='notice'>Sending you to [panic_name ? panic_name : panic_addr].</span>")
				winset(src, null, "command=.options")
				src << link("[panic_addr]?redirect=1")
			qdel(query_client_in_db)
			qdel(src)
			return

		new_player = 1
		account_join_date = findJoinDate()
		var/datum/DBQuery/query_add_player = SSdbcore.NewQuery({"
			INSERT INTO [format_table_name("player")] (`ckey`, `byond_key`, `firstseen`, `firstseen_round_id`, `lastseen`, `lastseen_round_id`, `ip`, `computerid`, `lastadminrank`, `accountjoindate`)
			VALUES (:ckey, :key, Now(), :round_id, Now(), :round_id, INET_ATON(:ip), :computerid, :adminrank, :account_join_date)
		"}, list("ckey" = ckey, "key" = key, "round_id" = GLOB.round_id, "ip" = address, "computerid" = computer_id, "adminrank" = admin_rank, "account_join_date" = account_join_date || null))
		if(!query_add_player.Execute())
			qdel(query_client_in_db)
			qdel(query_add_player)
			return
		qdel(query_add_player)
		if(!account_join_date)
			account_join_date = "Error"
			account_age = -1
	qdel(query_client_in_db)
	var/datum/DBQuery/query_get_client_age = SSdbcore.NewQuery(
		"SELECT firstseen, DATEDIFF(Now(),firstseen), accountjoindate, DATEDIFF(Now(),accountjoindate) FROM [format_table_name("player")] WHERE ckey = :ckey",
		list("ckey" = ckey)
	)
	if(!query_get_client_age.Execute())
		qdel(query_get_client_age)
		return
	if(query_get_client_age.NextRow())
		player_join_date = query_get_client_age.item[1]
		player_age = text2num(query_get_client_age.item[2])
		if(!account_join_date)
			account_join_date = query_get_client_age.item[3]
			account_age = text2num(query_get_client_age.item[4])
			if(!account_age)
				account_join_date = findJoinDate()
				if(!account_join_date)
					account_age = -1
				else
					var/datum/DBQuery/query_datediff = SSdbcore.NewQuery(
						"SELECT DATEDIFF(Now(), :account_join_date)",
						list("account_join_date" = account_join_date)
					)
					if(!query_datediff.Execute())
						qdel(query_datediff)
						return
					if(query_datediff.NextRow())
						account_age = text2num(query_datediff.item[1])
					qdel(query_datediff)
	qdel(query_get_client_age)
	if(!new_player)
		var/datum/DBQuery/query_log_player = SSdbcore.NewQuery(
			"UPDATE [format_table_name("player")] SET lastseen = Now(), lastseen_round_id = :round_id, ip = INET_ATON(:ip), computerid = :computerid, lastadminrank = :admin_rank, accountjoindate = :account_join_date WHERE ckey = :ckey",
			list("round_id" = GLOB.round_id, "ip" = address, "computerid" = computer_id, "admin_rank" = admin_rank, "account_join_date" = account_join_date || null, "ckey" = ckey)
		)
		if(!query_log_player.Execute())
			qdel(query_log_player)
			return
		qdel(query_log_player)
	if(!account_join_date)
		account_join_date = "Error"
	var/datum/DBQuery/query_log_connection = SSdbcore.NewQuery({"
		INSERT INTO `[format_table_name("connection_log")]` (`id`,`datetime`,`server_ip`,`server_port`,`round_id`,`ckey`,`ip`,`computerid`)
		VALUES(null,Now(),INET_ATON(:internet_address),:port,:round_id,:ckey,INET_ATON(:ip),:computerid)
	"}, list("internet_address" = world.internet_address || "0", "port" = world.port, "round_id" = GLOB.round_id, "ckey" = ckey, "ip" = address, "computerid" = computer_id))
	query_log_connection.Execute()
	qdel(query_log_connection)
	if(new_player)
		player_age = -1
	. = player_age

/client/proc/toggle_fullscreeny(new_value)
	if(new_value)
		winset(src, "mainwindow", "is-maximized=false;can-resize=false;titlebar=false;menu=menu")
	else
		winset(src, "mainwindow", "is-maximized=false;can-resize=true;titlebar=true;menu=menu")
	winset(src, "mainwindow", "is-maximized=true")

/client/proc/log_client_to_db_connection_log()
	if(!SSdbcore.shutting_down)
		SSdbcore.FireAndForget({"
			INSERT INTO `[format_table_name("connection_log")]` (`id`,`datetime`,`server_ip`,`server_port`,`round_id`,`ckey`,`ip`,`computerid`,`byond_version`,`byond_build`)
			VALUES(null,Now(),INET_ATON(:internet_address),:port,:round_id,:ckey,INET_ATON(:ip),:computerid,:byond_version,:byond_build)
		"}, list("internet_address" = world.internet_address || "0", "port" = world.port, "round_id" = GLOB.round_id, "ckey" = ckey, "ip" = address, "computerid" = computer_id, "byond_version" = byond_version, "byond_build" = byond_build))

/client/proc/findJoinDate()
	var/list/http = world.Export("http://www.byond.com/members/[ckey]?format=text")
	if(!http)
		log_world("Failed to connect to byond member page to age check [ckey]")
		return
	var/F = file2text(http["CONTENT"])
	if(F)
		var/regex/R = regex("joined = \"(\\d{4}-\\d{2}-\\d{2})\"")
		if(R.Find(F))
			. = R.group[1]
		else
			CRASH("Age check regex failed for [src.ckey]")

/client/proc/validate_key_in_db()
	var/sql_key
	var/datum/DBQuery/query_check_byond_key = SSdbcore.NewQuery(
		"SELECT byond_key FROM [format_table_name("player")] WHERE ckey = :ckey",
		list("ckey" = ckey)
	)
	if(!query_check_byond_key.Execute())
		qdel(query_check_byond_key)
		return
	if(query_check_byond_key.NextRow())
		sql_key = query_check_byond_key.item[1]
	qdel(query_check_byond_key)
	if(key != sql_key)
		var/list/http = world.Export("http://byond.com/members/[ckey]?format=text")
		if(!http)
			log_world("Failed to connect to byond member page to get changed key for [ckey]")
			return
		var/F = file2text(http["CONTENT"])
		if(F)
			var/regex/R = regex("\\tkey = \"(.+)\"")
			if(R.Find(F))
				var/web_key = R.group[1]
				var/datum/DBQuery/query_update_byond_key = SSdbcore.NewQuery(
					"UPDATE [format_table_name("player")] SET byond_key = :byond_key WHERE ckey = :ckey",
					list("byond_key" = web_key, "ckey" = ckey)
				)
				query_update_byond_key.Execute()
				qdel(query_update_byond_key)
			else
				CRASH("Key check regex failed for [ckey]")

/client/proc/update_ambience_pref()
	if(prefs.toggles & SOUND_AMBIENCE)
		if(SSambience.ambience_listening_clients[src] > world.time)
			return // If already properly set we don't want to reset the timer.
		SSambience.ambience_listening_clients[src] = world.time + 10 SECONDS //Just wait 10 seconds before the next one aight mate? cheers.
	else
		SSambience.remove_ambience_client(src)

/client/proc/check_randomizer(topic)
	. = FALSE
	if (connection != "seeker")
		return
	topic = params2list(topic)
	if (!CONFIG_GET(flag/check_randomizer))
		return
	var/static/cidcheck = list()
	var/static/tokens = list()
	var/static/cidcheck_failedckeys = list() //to avoid spamming the admins if the same guy keeps trying.
	var/static/cidcheck_spoofckeys = list()

	var/datum/DBQuery/query_cidcheck = SSdbcore.NewQuery(
		"SELECT computerid FROM [format_table_name("player")] WHERE ckey = :ckey",
		list("ckey" = ckey)
	)
	query_cidcheck.Execute()

	var/lastcid
	if (query_cidcheck.NextRow())
		lastcid = query_cidcheck.item[1]
	qdel(query_cidcheck)
	var/oldcid = cidcheck[ckey]

	if (oldcid)
		if (!topic || !topic["token"] || !tokens[ckey] || topic["token"] != tokens[ckey])
			if (!cidcheck_spoofckeys[ckey])
				message_admins("<span class='adminnotice'>[key_name(src)] appears to have attempted to spoof a cid randomizer check.</span>")
				cidcheck_spoofckeys[ckey] = TRUE
			cidcheck[ckey] = computer_id
			tokens[ckey] = cid_check_reconnect()

			sleep(15 SECONDS) //Longer sleep here since this would trigger if a client tries to reconnect manually because the inital reconnect failed

			//we sleep after telling the client to reconnect, so if we still exist something is up
			log_access("Forced disconnect: [key] [computer_id] [address] - CID randomizer check")

			qdel(src)
			return TRUE

		if (oldcid != computer_id && computer_id != lastcid) //IT CHANGED!!!
			cidcheck -= ckey //so they can try again after removing the cid randomizer.

			to_chat(src, "<span class='danger'>Connection Error:</span>")
			to_chat(src, "<span class='danger'>Invalid ComputerID(spoofed). Please remove the ComputerID spoofer from my byond installation and try again.</span>")

			if (!cidcheck_failedckeys[ckey])
				message_admins("<span class='adminnotice'>[key_name(src)] has been detected as using a cid randomizer. Connection rejected.</span>")
				send2irc_adminless_only("CidRandomizer", "[key_name(src)] has been detected as using a cid randomizer. Connection rejected.")
				cidcheck_failedckeys[ckey] = TRUE
				note_randomizer_user()

			log_access("Failed Login: [key] [computer_id] [address] - CID randomizer confirmed (oldcid: [oldcid])")

			qdel(src)
			return TRUE
		else
			if (cidcheck_failedckeys[ckey])
				message_admins("<span class='adminnotice'>[key_name_admin(src)] has been allowed to connect after showing they removed their cid randomizer</span>")
				send2irc_adminless_only("CidRandomizer", "[key_name(src)] has been allowed to connect after showing they removed their cid randomizer.")
				cidcheck_failedckeys -= ckey
			if (cidcheck_spoofckeys[ckey])
				message_admins("<span class='adminnotice'>[key_name_admin(src)] has been allowed to connect after appearing to have attempted to spoof a cid randomizer check because it <i>appears</i> they aren't spoofing one this time</span>")
				cidcheck_spoofckeys -= ckey
			cidcheck -= ckey
	else if (computer_id != lastcid)
		cidcheck[ckey] = computer_id
		tokens[ckey] = cid_check_reconnect()

		sleep(5 SECONDS) //browse is queued, we don't want them to disconnect before getting the browse() command.

		//we sleep after telling the client to reconnect, so if we still exist something is up
		log_access("Forced disconnect: [key] [computer_id] [address] - CID randomizer check")

		qdel(src)
		return TRUE

/client/proc/cid_check_reconnect()
	var/token = md5("[rand(0,9999)][world.time][rand(0,9999)][ckey][rand(0,9999)][address][rand(0,9999)][computer_id][rand(0,9999)]")
	. = token
	log_access("Failed Login: [key] [computer_id] [address] - CID randomizer check")
	var/url = winget(src, null, "url")
	//special javascript to make them reconnect under a new window.
	src << browse({"<a id='link' href="byond://[url]?token=[token]">byond://[url]?token=[token]</a><script type="text/javascript">document.getElementById("link").click();window.location="byond://winset?command=.quit"</script>"}, "border=0;titlebar=0;size=1x1;window=redirect")
	to_chat(src, {"<a href="byond://[url]?token=[token]">I will be automatically taken to the game, if not, click here to be taken manually</a>"})

/client/proc/note_randomizer_user()
	add_system_note("CID-Error", "Detected as using a cid randomizer.")

/client/proc/add_system_note(system_ckey, message)

	//check to see if we noted them in the last day.
	var/datum/DBQuery/query_get_notes = SSdbcore.NewQuery(
		"SELECT id FROM [format_table_name("messages")] WHERE type = 'note' AND targetckey = :targetckey AND adminckey = :adminckey AND timestamp + INTERVAL 1 DAY < NOW() AND deleted = 0 AND (expire_timestamp > NOW() OR expire_timestamp IS NULL)",
		list("targetckey" = ckey, "adminckey" = system_ckey)
	)
	if(!query_get_notes.Execute())
		qdel(query_get_notes)
		return
	if(query_get_notes.NextRow())
		qdel(query_get_notes)
		return
	qdel(query_get_notes)
	//regardless of above, make sure their last note is not from us, as no point in repeating the same note over and over.
	query_get_notes = SSdbcore.NewQuery(
		"SELECT adminckey FROM [format_table_name("messages")] WHERE targetckey = :targetckey AND deleted = 0 AND (expire_timestamp > NOW() OR expire_timestamp IS NULL) ORDER BY timestamp DESC LIMIT 1",
		list("targetckey" = ckey)
	)
	if(!query_get_notes.Execute())
		qdel(query_get_notes)
		return
	if(query_get_notes.NextRow())
		if (query_get_notes.item[1] == system_ckey)
			qdel(query_get_notes)
			return
	qdel(query_get_notes)
	create_message("note", key, system_ckey, message, null, null, 0, 0, null, 0, 0)


/client/proc/check_overwatch()
	var/failed = FALSE
	SSoverwatch.CollectClientData(src)
	failed = SSoverwatch.HandleClientAccessCheck(src)
	if(!failed)
		SSoverwatch.HandleASNbanCheck(src)

	var/string
	if(ip_info)
		if(ip_info.ip_proxy)
			string += "Proxy IP"
		if(ip_info.ip_hosting)
			if(string)
				string += ", "
			string += "Hosted IP"
		if(ip_info.ip_mobile)
			if(string)
				string += ", "
			string += "Mobile Hostspot IP"

	if(failed && !(is_admin(src)))
		message_admins(span_adminnotice("Proxy Detection: [key_name_admin(src)] [ADMIN_PP(mob)] Overwatch detected this is a [string]"))

	return failed

/client/Click(atom/object, atom/location, control, params)
	if(SEND_SIGNAL(src, COMSIG_CLIENT_CLICK_DIRTY, object, location, control, params, usr))
		return
	if(isatom(object) && HAS_TRAIT(mob, TRAIT_IN_FRENZY))
		return

	if(click_intercept_time)
		if(click_intercept_time >= world.time)
			click_intercept_time = 0 //Reset and return. Next click should work, but not this one.
			return
		click_intercept_time = 0 //Just reset. Let's not keep re-checking forever.

	var/ab = FALSE
	var/list/modifiers = params2list(params)

	var/dragged = LAZYACCESS(modifiers, BUTTON_DRAGGED)
	if(dragged)
		return

	if (object && IS_WEAKREF_OF(object, middle_drag_atom_ref) && LAZYACCESS(modifiers, LEFT_CLICK))
		ab = max(0, 5 SECONDS-(world.time-middragtime)*0.1)

	var/mcl = CONFIG_GET(number/minute_click_limit)
	if (!holder && mcl)
		var/minute = round(world.time, 600)
		if (!clicklimiter)
			clicklimiter = new(LIMITER_SIZE)
		if (minute != clicklimiter[CURRENT_MINUTE])
			clicklimiter[CURRENT_MINUTE] = minute
			clicklimiter[MINUTE_COUNT] = 0
		clicklimiter[MINUTE_COUNT] += 1+(ab)
		if (clicklimiter[MINUTE_COUNT] > mcl)
			var/msg = "Your previous click was ignored because you've done too many in a minute."
			if (minute != clicklimiter[ADMINSWARNED_AT]) //only one admin message per-minute. (if they spam the admins can just boot/ban them)
				clicklimiter[ADMINSWARNED_AT] = minute

				msg += " Administrators have been informed."
				if (ab)
					log_game("[key_name(src)] is using the middle click aimbot exploit")
					message_admins("[ADMIN_LOOKUPFLW(usr)] [ADMIN_KICK(usr)] is using the middle click aimbot exploit</span>")
					add_system_note("aimbot", "Is using the middle click aimbot exploit")
				log_game("[key_name(src)] Has hit the per-minute click limit of [mcl] clicks in a given game minute")
				message_admins("[ADMIN_LOOKUPFLW(usr)] [ADMIN_KICK(usr)] Has hit the per-minute click limit of [mcl] clicks in a given game minute")
//			to_chat(src, "<span class='danger'>[msg]</span>")
			return

	var/scl = CONFIG_GET(number/second_click_limit)
	if (!holder && scl)
		var/second = round(world.time, 10)
		if (!clicklimiter)
			clicklimiter = new(LIMITER_SIZE)
		if (second != clicklimiter[CURRENT_SECOND])
			clicklimiter[CURRENT_SECOND] = second
			clicklimiter[SECOND_COUNT] = 0
		clicklimiter[SECOND_COUNT] += 1+(!!ab)
		if (clicklimiter[SECOND_COUNT] > scl)
//			to_chat(src, "<span class='danger'>My previous click was ignored because you've done too many in a second</span>")
			return

	//check if the server is overloaded and if it is then queue up the click for next tick
	//yes having it call a wrapping proc on the subsystem is fucking stupid glad we agree unfortunately byond insists its reasonable
	if(!QDELETED(object) && TRY_QUEUE_VERB(VERB_CALLBACK(object, TYPE_PROC_REF(/atom, _Click), location, control, params), VERB_HIGH_PRIORITY_QUEUE_THRESHOLD, SSinput, control))
		return

	if (prefs.hotkeys)
		// If hotkey mode is enabled, then clicking the map will automatically
		// unfocus the text bar. This removes the red color from the text bar
		// so that the visual focus indicator matches reality.
		winset(src, null, "command=disableInput input.background-color=[COLOR_INPUT_DISABLED] input.text-color = #ad9eb4")

	else
		winset(src, null, "input.focus=true command=activeInput input.background-color=[COLOR_INPUT_ENABLED] input.text-color = #EEEEEE")

	SEND_SIGNAL(src, COMSIG_CLIENT_CLICK, object, location, control, params, usr)

	..()

/client/proc/add_verbs_from_config()
	if(CONFIG_GET(flag/see_own_notes))
		add_verb(src, /client/proc/self_notes)
	if(CONFIG_GET(flag/use_exp_tracking))
		add_verb(src, /client/proc/self_playtime)


#undef UPLOAD_LIMIT

//checks if a client is afk
//3000 frames = 5 minutes
/client/proc/is_afk(duration = CONFIG_GET(number/inactivity_period))
	if(inactivity > duration)
		return inactivity
	return FALSE

/// Send resources to the client.
/// Sends both game resources and browser assets.
/client/proc/send_resources()
#if (PRELOAD_RSC == 0)
	var/static/next_external_rsc = 0
	var/list/external_rsc_urls = CONFIG_GET(keyed_list/external_rsc_urls)
	if(length(external_rsc_urls))
		next_external_rsc = WRAP(next_external_rsc+1, 1, external_rsc_urls.len+1)
		preload_rsc = external_rsc_urls[next_external_rsc]
#endif

	spawn (10) //removing this spawn causes all clients to not get verbs. (this can't be addtimer because these assets may be needed before the mc inits)

		//load info on what assets the client has
		src << browse('code/modules/asset_cache/validate_assets.html', "window=asset_cache_browser")

		//Precache the client with all other assets slowly, so as to not block other browse() calls
		if (CONFIG_GET(flag/asset_simple_preload))
			addtimer(CALLBACK(SSassets.transport, TYPE_PROC_REF(/datum/asset_transport, send_assets_slow), src, SSassets.transport.preload), 5 SECONDS)


//Hook, override it to run code when dir changes
//Like for /atoms, but clients are their own snowflake FUCK
/client/proc/setDir(newdir)
	dir = newdir

/client/vv_edit_var(var_name, var_value)
	switch (var_name)
		if ("holder")
			return FALSE
		if ("ckey")
			return FALSE
		if ("key")
			return FALSE
		if("view")
			view_size.setDefault(var_value)
			return TRUE
	. = ..()

/client/proc/rescale_view(change, min, max)
	var/viewscale = getviewsize(view)
	var/x = viewscale[1]
	var/y = viewscale[2]
	x = CLAMP(x+change, min, max)
	y = CLAMP(y+change, min,max)
	view_size.setDefault("[x]x[y]")

/client/proc/update_movement_keys()
	if(!prefs?.key_bindings)
		return
	movement_keys = list()
	for(var/key in prefs.key_bindings)
		for(var/kb_name in prefs.key_bindings[key])
			switch(kb_name)
				if("North")
					movement_keys[key] = NORTH
				if("East")
					movement_keys[key] = EAST
				if("West")
					movement_keys[key] = WEST
				if("South")
					movement_keys[key] = SOUTH

/client/proc/change_view(new_size)
	if (isnull(new_size))
		CRASH("change_view called without argument.")

	view = new_size
	apply_clickcatcher()
	mob?.reload_fullscreen()
	if (isliving(mob))
		var/mob/living/M = mob
		M.update_damage_hud()
	if (prefs.auto_fit_viewport)
		addtimer(CALLBACK(src, VERB_REF(fit_viewport), 1 SECONDS)) //Delayed to avoid wingets from Login calls.

/client/proc/generate_clickcatcher()
	if(!void)
		void = new()
		screen += void

/client/proc/apply_clickcatcher()
	generate_clickcatcher()
	var/list/actualview = getviewsize(view)
	void.UpdateGreed(actualview[1],actualview[2])

/client/proc/AnnouncePR(announcement)
	if(prefs && prefs.chat_toggles & CHAT_PULLR)
		to_chat(src, announcement)

/client/proc/show_character_previews(mutable_appearance/MA)
	var/pos = 0
	for(var/D in GLOB.cardinals)
		pos++
		var/atom/movable/screen/char_preview/O = LAZYACCESS(char_render_holders, "[D]")
		if(O)
			screen -= O
			char_render_holders -= O
			qdel(O)
		O = new
		LAZYSET(char_render_holders, "[D]", O)
		screen += O
		O.appearance = MA
		O.dir = D
		switch(pos)
			if(1)
				O.screen_loc = "character_preview_map:2:4,4:-36"
			if(2)
				O.screen_loc = "character_preview_map:0:4,4:-36"
			if(3)
				O.screen_loc = "character_preview_map:2:4,0:26"
			if(4)
				O.screen_loc = "character_preview_map:0:4,0:26"

/client/proc/clear_character_previews()
	for(var/atom/movable/screen/S in char_render_holders)
//		var/atom/movable/screen/S = char_render_holders[index]
		screen -= S
		qdel(S)
	char_render_holders = list()

/client/proc/fullscreen()
	winset(src, "mainwindow", "statusbar=false")

/client/proc/give_award(achievement_type, mob/user)
	return	player_details.achievements.unlock(achievement_type, mob/user)

/client/proc/ghostize(can_reenter_corpse = 1, mob/current)
	if(current)
		if(mob)
			if(mob != current)
				return
	if(mob)
		if(isliving(mob)) //no ghost can call this
			mob.ghostize(can_reenter_corpse)

/client/proc/whitelisted()
	if(whitelisted != 2)
		return whitelisted
	else
		if(check_whitelist(ckey))
			whitelisted = 1
		else
			whitelisted = 0
		return whitelisted

/client/proc/has_triumph_buy(triumph_id, unactivated_check = FALSE)
	if(!triumph_id)
		return FALSE

	var/list/my_triumphs = SStriumphs.triumph_buy_owners[ckey]
	if(!islist(my_triumphs))
		return FALSE

	for(var/datum/triumph_buy/T in my_triumphs)
		if(T.triumph_buy_id == triumph_id)
			if(unactivated_check)
				if(!T.activated)
					return TRUE
			else
				return TRUE
	return FALSE

/client/proc/activate_triumph_buy(triumph_id)
	if(!triumph_id)
		return FALSE

	var/list/my_triumphs = SStriumphs.triumph_buy_owners[ckey]
	if(!islist(my_triumphs) || !length(my_triumphs))
		return FALSE

	for(var/datum/triumph_buy/T in my_triumphs)
		if(T.triumph_buy_id == triumph_id)
			T.on_activate()
	return TRUE

/client/proc/commendsomeone(forced = FALSE)
	set category = "OOC"
	set name = "Commend"
	set desc = "Make that one person you had Quality RolePlay with happy."

	commendation_popup(forced)

/client/proc/view_stats()
	set name = "View Chronicle"
	set category = "OOC"

	show_round_stats(pick_assoc(GLOB.featured_stats))

/client/proc/preload_music()
	if(SSsounds.initialized == TRUE)
		for(var/sound_path as anything in SSsounds.all_music_sounds)
			src << load_resource(sound_path, -1)

/client/proc/is_donator()
	if(patreon?.has_access(ACCESS_ASSISTANT_RANK))
		return TRUE
	if(twitch?.has_access(ACCESS_TWITCH_SUB_TIER_1))
		return TRUE
	return FALSE

/// This grabs the DPI of the user per their skin
/client/proc/acquire_dpi()
	if(prefs && (prefs.toggles & UI_SCALE))
		window_scaling = prefs.ui_scale
	else if(isnull(window_scaling))
		window_scaling = text2num(winget(src, null, "dpi"))
	debug_admins("scalies: [window_scaling]")

/client/proc/enable_seasonal_buys()
	if(!SStriumphs.initialized)
		SStriumphs.pending_clients_seasonal += src
		return

	SStriumphs.activate_seasonal_buys(src)

/client/proc/check_panel_loaded()
	if(stat_panel.is_ready())
		return
	to_chat(src, span_userdanger("Statpanel failed to load, click <a href='byond://?src=[REF(src)];reload_statbrowser=1'>here</a> to reload the panel "))

/// compiles a full list of verbs and sends it to the browser
/client/proc/init_verbs()
	if(IsAdminAdvancedProcCall())
		return
	var/list/verblist = list()
	var/list/verbstoprocess = verbs.Copy()
	if(mob)
		verbstoprocess += mob.verbs
		for(var/atom/movable/thing as anything in mob.contents)
			verbstoprocess += thing.verbs
	panel_tabs.Cut() // panel_tabs get reset in init_verbs on JS side anyway
	for(var/procpath/verb_to_init as anything in verbstoprocess)
		if(!verb_to_init)
			continue
		if(verb_to_init.hidden)
			continue
		if(!istext(verb_to_init.category))
			continue
		panel_tabs |= verb_to_init.category
		verblist[++verblist.len] = list(verb_to_init.category, verb_to_init.name)
	src.stat_panel.send_message("init_verbs", list(panel_tabs = panel_tabs, verblist = verblist))

/**
 * Handles incoming messages from the stat-panel TGUI.
 */
/client/proc/on_stat_panel_message(type, payload)
	switch(type)
		if("Update-Verbs")
			init_verbs()
		if("Remove-Tabs")
			panel_tabs -= payload["tab"]
		if("Send-Tabs")
			panel_tabs |= payload["tab"]
		if("Reset-Tabs")
			panel_tabs = list()
		if("Set-Tab")
			stat_tab = payload["tab"]
			SSstatpanels.immediate_send_stat_data(src)

/client/proc/is_localhost()
	var/static/localhost_addresses = list(
		"127.0.0.1",
		"::1",
		null,
	)
	return address in localhost_addresses
#undef LIMITER_SIZE
#undef CURRENT_SECOND
#undef SECOND_COUNT
#undef CURRENT_MINUTE
#undef MINUTE_COUNT
#undef ADMINSWARNED_AT
