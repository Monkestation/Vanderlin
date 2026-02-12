////////////////////////////////
/proc/message_admins(msg)
	msg = span_admin("[span_prefix("ADMIN LOG: ")]<span class=\"message linkify\">[msg]</span>")
	for(var/client/C in GLOB.admins)
		if(check_rights_for(C, R_ADMIN))
			to_chat(C, msg)


/proc/relay_msg_admins(msg)
	msg = "<span class=\"admin\"><span class=\"prefix\">RELAY:</span> <span class=\"message linkify\">[msg]</span></span>"
	to_chat(GLOB.admins, msg)


///////////////////////////////////////////////////////////////////////////////////////////////Panels

/datum/admins/proc/show_player_panel(mob/M in GLOB.mob_list)
	set category = "Admin.Admin"
	set name = "Show Player Panel"
	set desc="Edit player (respawn, ban, heal, etc)"

	if(!check_rights())
		return

	show_player_panel_next(M)

/client/proc/show_player_panel_next(mob/M)
	holder?.show_player_panel_next(M)

/datum/admins/proc/show_player_panel_next(mob/M, clicked_flag = null)
	log_admin("[key_name(usr)] checked the individual player panel for [key_name(M)][isobserver(usr)?"":" while in game"].")

	if(!M)
		to_chat(usr, "<span class='warning'>I seem to be selecting a mob that doesn't exist anymore.</span>")
		return

	var/ui_theme = usr.client.prefs.ui_theme
	var/dark_ui = FALSE
	if(ui_theme == UI_PREFERENCE_DARK_MODE) // rewrite if you want to add more (yes it's ass)
		dark_ui = TRUE

	var/body = usr.client.prefs.get_ui_theme_stylesheet()
	body += "<head><title>Options for [M.key]</title><style>"
	body += "<style>"
	body += "html, body { height: 100%; margin: 0; padding: 0; overflow-x: hidden;}"
	body += "#container { display: flex; flex-direction: row; align-items: flex-start; width: 100%; overflow-x: hidden; flex-wrap: nowrap;background: [dark_ui ? "#121212" : "white"]; [dark_ui ? "color: #f0f0f0" : ""] }"
	body += "#left { flex: 2; padding-right: 10px; min-width: 0; background: [dark_ui ? "#121212" : "white"]; [dark_ui ? "color: #f0f0f0" : ""]}"
	body += "#skills-section, #quirks-section, #languages-section, #stats-section { display: none; background: [dark_ui ? "#121212" : "white"]; [dark_ui ? "color: #f0f0f0" : ""]; border: 1px solid black; padding: 10px; width: 100%; box-sizing: border-box; max-width: 100%; overflow-x: hidden; word-wrap: break-word; }"
	body += "#right { flex: 1; border-left: 2px solid black; padding-left: 10px; max-height: 500px; overflow-y: auto; width: 250px; min-width: 250px; box-sizing: border-box; position: relative;background: [dark_ui ? "#121212" : "white"]; [dark_ui ? "color: #f0f0f0" : ""] }"
	body += "#right-header { display: flex; justify-content: space-around; padding: 5px; background: background: [dark_ui ? "#121212" : "white"]; [dark_ui ? "color: #f0f0f0" : ""]; border-bottom: 2px solid black; position: sticky; top: 0; z-index: 10; }"
	body += "#right-header button { flex: 1; margin: 2px; padding: 5px; cursor: pointer; font-weight: bold; border: none; background-color: background: [dark_ui ? "#121212" : "white"]; [dark_ui ? "color: #f0f0f0" : ""]; border-radius: 5px; }"
	body += "#right-header button:hover { background: [dark_ui ? "#121212" : "white"]; [dark_ui ? "color: #f0f0f0" : ""]; }"

	body += "</style>"

	body += "<script>"
	body += "function toggleSection(section) {"
	body += "    localStorage.setItem('activeSection', section);"
	body += "    document.getElementById('skills-section').style.display = (section === 'skills') ? 'block' : 'none';"
	body += "    document.getElementById('languages-section').style.display = (section === 'languages') ? 'block' : 'none';"
	body += "	 document.getElementById('stats-section').style.display = (section === 'stats') ? 'block' : 'none';"
	body += "	 document.getElementById('quirks-section').style.display = (section === 'quirks') ? 'block' : 'none';"
	body += "}"

	body += "function refreshAndKeepSection(section) {"
	body += "    localStorage.setItem('activeSection', section);"
	body += "    location.reload();"
	body += "}"

	body += "window.onload = function() {"
	body += "    var activeSection = \"[clicked_flag]\";"
	body += "    if (activeSection !== \"0\" && activeSection !== \"\") {"
	body += "        toggleSection(activeSection);"
	body += "    }"
	body += "}"
	body += "</script>"

	body +="</head>"
	body += "<body><div id='container'>"
	body += "<div id='left'>"
	if(M.ckey)
		body += "<body>\[<A href='byond://?_src_=holder;[HrefToken()];ppbyckey=[M.ckey];ppbyckeyorigmob=[REF(M)]'>Find Updated Panel</A>\] <br>"

	body += "Options panel for <b>[M]</b>"
	if(M.client)
		body += " played by <b>[M.client]</b> "
		body += "\[<A href='?_src_=holder;[HrefToken()];editrights=[(GLOB.admin_datums[M.client.ckey] || GLOB.deadmins[M.client.ckey]) ? "rank" : "add"];key=[M.key]'>[M.client.holder ? M.client.holder.rank : "Player"]</A>\]"
		if(CONFIG_GET(flag/use_exp_tracking))
			body += "\[<A href='?_src_=holder;[HrefToken()];getplaytimewindow=[REF(M)]'>" + M.client.get_exp_living() + "</a>\]"

	if(isnewplayer(M))
		body += " <B>Hasn't Entered Game</B> "
	else
		body += " \[<A href='?_src_=holder;[HrefToken()];revive=[REF(M)]'>Heal</A>\] "

	if(M.client)
		body += "<br>\[<b>First Seen:</b> [M.client.player_join_date]\]"
		body += "<br>\[<b>Byond account registered on:</b> [M.client.account_join_date]\]"
		body += "<br>\[<b>IP:</b> [M.client.address]\]"
		body += "<br><br><b>CentCom Ban DB: </b> "
		if(CONFIG_GET(string/centcom_ban_db))
			body += "<a href='byond://?_src_=holder;[HrefToken()];centcomlookup=[M.client.ckey]'>Search</a>"
		else
			body += "<i>Disabled</i>"
		body += "<br><br><b>Show related accounts by:</b> "
		body += "\[ <a href='?_src_=holder;[HrefToken()];showrelatedacc=cid;client=[REF(M.client)]'>CID</a> | "
		body += "<a href='?_src_=holder;[HrefToken()];showrelatedacc=ip;client=[REF(M.client)]'>IP</a> \]"

		var/pq = get_playerquality(M.ckey, TRUE)
		var/pq_num = get_playerquality(M.ckey, FALSE)
		body += "<br><br>Player Quality: [pq] ([pq_num])"
		body += "<br><a href='?_src_=holder;[HrefToken()];editpq=add;mob=[REF(M)]'>\[Modify PQ\]</a> "
		body += "<a href='?_src_=holder;[HrefToken()];showpq=add;mob=[REF(M)]'>\[Check PQ\]</a> "
		body += "<br><a href='?_src_=holder;[HrefToken()];edittriumphs=add;mob=[REF(M)]'>\[Modify Triumphs\]</a> "
		body += "<a href='?_src_=holder;[HrefToken()];showtriumphs=add;mob=[REF(M)]'>\[Check Triumphs\]</a> "
		body += "<br>"
		body += "<a href='?_src_=holder;[HrefToken()];roleban=add;mob=[REF(M)]'>\[Role Ban Panel\]</a> "

		var/patron = ""
		if(isliving(M))
			var/mob/living/living = M
			patron = initial(living.patron.name)
		var/curse_string = ""
		var/job = ""
		if(ishuman(M))
			var/mob/living/carbon/human/human_mob = M
			curse_string = human_mob.curses.Join(", ")
			job = human_mob?.mind.assigned_role.title

		body += "<br><br>Current Patron: <a href='?_src_=holder;[HrefToken()];changepatron=add;mob=[REF(M)]'>\[[patron ? patron : "NA"]\]</a>"
		body += "<br>Current Curses: <a href='?_src_=holder;[HrefToken()];modifycurses=add;mob=[REF(M)]'>\[[curse_string ? curse_string : "NA"]\]</a>"
		body += "<br>Current Job: <a href='?_src_=holder;[HrefToken()];setjob=add;mob=[REF(M)]'>\[[job ? job : "NA"]\]</a>"

		var/full_version = "Unknown"
		if(M.client.byond_version)
			full_version = "[M.client.byond_version].[M.client.byond_build ? M.client.byond_build : "xxx"]"
		body += "<br>\[<b>Byond version:</b> [full_version]\]"

	body += "<br><br>\["
	body += "<a href='?_src_=vars;[HrefToken()];Vars=[REF(M)]'>VV</a> - "
	if(M.mind)
		body += "<a href='?_src_=holder;[HrefToken()];traitor=[REF(M)]'>TP</a> - "
	else
		body += "<a href='?_src_=holder;[HrefToken()];initmind=[REF(M)]'>Init Mind</a> - "
	body += "<a href='?priv_msg=[M.ckey]'>PM</a> - "
	body += "<a href='?_src_=holder;[HrefToken()];subtlemessage=[REF(M)]'>SM</a> - "
	body += "<a href='?_src_=holder;[HrefToken()];adminplayerobservefollow=[REF(M)]'>FLW</a> - "
	//Default to client logs if available
	var/source = LOGSRC_MOB
	if(M.client)
		source = LOGSRC_CLIENT
	body += "<a href='?_src_=holder;[HrefToken()];individuallog=[REF(M)];log_src=[source]'>LOGS</a>\] <br>"

	body += "<b>Mob type</b> = [M.type]<br><br>"

	body += "<A href='?_src_=holder;[HrefToken()];boot2=[REF(M)]'>Kick</A> | "
	if(M.client)
		body += "<A href='?_src_=holder;[HrefToken()];newbankey=[M.key];newbanip=[M.client.address];newbancid=[M.client.computer_id]'>Ban</A> | "
	else
		body += "<A href='?_src_=holder;[HrefToken()];newbankey=[M.key]'>Ban</A> | "

	body += "<A href='?_src_=holder;[HrefToken()];showmessageckey=[M.ckey]'>Notes | Messages | Watchlist</A> | "
	if(M.client)
		body += "\ <A href='?_src_=holder;[HrefToken()];sendbacktolobby=[REF(M)]'>Send back to Lobby</A> | "
		body += "<A href='?_src_=holder;[HrefToken()];cryomob=[REF(M)]'>CRYO</A>"
		var/muted = M.client.prefs.muted
		body += "<br><b>Mute: </b> "
		body += "\[<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_IC]'><font color='[(muted & MUTE_IC)?"red":"blue"]'>IC</font></a> | "
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_OOC]'><font color='[(muted & MUTE_OOC)?"red":"blue"]'>OOC</font></a> | "
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_PRAY]'><font color='[(muted & MUTE_PRAY)?"red":"blue"]'>PRAY</font></a> | "
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_ADMINHELP]'><font color='[(muted & MUTE_ADMINHELP)?"red":"blue"]'>ADMINHELP</font></a> | "
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_DEADCHAT]'><font color='[(muted & MUTE_DEADCHAT)?"red":"blue"]'>DEADCHAT</font></a> | "
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_LOOC]'><font color='[(muted & MUTE_LOOC)?"red":"blue"]'>LOOC</font></a> | "
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_MEDITATE]'><font color='[(muted & MUTE_MEDITATE)?"red":"blue"]'>Meditate</font></a>\]"
		body += "(<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_ALL]'><font color='[(muted & MUTE_ALL)?"red":"blue"]'>toggle all</font></a>)"

	body += "<br><br>"
	body += "<A href='?_src_=holder;[HrefToken()];jumpto=[REF(M)]'><b>Jump to</b></A> | "
	body += "<A href='?_src_=holder;[HrefToken()];getmob=[REF(M)]'>Get</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];sendmob=[REF(M)]'>Send To</A>"

	body += "<br><br>"
	body += "<A href='?_src_=holder;[HrefToken()];traitor=[REF(M)]'>Traitor panel</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];narrateto=[REF(M)]'>Narrate to</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];subtlemessage=[REF(M)]'>Subtle message</A> | "
	//body += "<A href='?_src_=holder;[HrefToken()];languagemenu=[REF(M)]'>Language Menu</A>"

	body += "</div>"

	body += "<div id='right'>"
	body += "<div id='right-header'>"
	body += "<button onclick=\"toggleSection('skills')\">Skills</button>"
	body += "<button onclick=\"toggleSection('languages')\">Languages</button>"
	body += "<button onclick=\"toggleSection('stats')\">Stats</button>"
	body += "<button onclick=\"toggleSection('quirks')\">Quirks</button>"
	body += "</div>"


	body += "<div id='skills-section'>"
	body += "<h3>Skills</h3><ul>"
	if(M.mind)
		for(var/skill_type in SSskills.all_skills)
			var/datum/skill/skill = GetSkillRef(skill_type)
			if(skill_type in M.skills?.known_skills)
				body += "<li>[initial(skill.name)]: [M.skills?.known_skills[skill_type]] "
			else
				body += "<li>[initial(skill.name)]: 0"
			body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];increase_skill=[REF(M)];skill=[skill.type]'>+</a> "
			body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];decrease_skill=[REF(M)];skill=[skill.type]'>-</a></li>"
	body += "</ul></div>"

	body += "<div id='languages-section'>"
	body += "<h3>Languages</h3><ul>"
	for(var/datum/language/ld as anything in GLOB.all_languages)
		body += "<li>[initial(ld.name)] - "
		if (M.mind?.language_holder?.has_language(ld))
			body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];remove_language=[REF(M)];language=[ld]'>Remove</a></li>"
		else
			body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];add_language=[REF(M)];language=[ld]'>Grant</a></li>"
	body += "</ul></div>"

	body += "<div id='stats-section'>"
	body += "<h3>Stats</h3><ul>"
	if(isliving(M))
		var/mob/living/living = M
		body += "<li>Strength: [living.STASTR] "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];add_stat=[REF(M)];stat=[STATKEY_STR]'>+</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];lower_stat=[REF(M)];stat=[STATKEY_STR]'>-</a>"
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];bulk_change=[REF(M)];stat=[STATKEY_STR]'> Bulk Change</a></li>"

		body += "<li>Perception: [living.STAPER] "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];add_stat=[REF(M)];stat=[STATKEY_PER]'>+</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];lower_stat=[REF(M)];stat=[STATKEY_PER]'>-</a>"
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];bulk_change=[REF(M)];stat=[STATKEY_PER]'> Bulk Change</a></li>"

		body += "<li>Endurance: [living.STAEND] "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];add_stat=[REF(M)];stat=[STATKEY_END]'>+</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];lower_stat=[REF(M)];stat=[STATKEY_END]'>-</a>"
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];bulk_change=[REF(M)];stat=[STATKEY_END]'> Bulk Change</a></li>"

		body += "<li>Constitution: [living.STACON] "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];add_stat=[REF(M)];stat=[STATKEY_CON]'>+</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];lower_stat=[REF(M)];stat=[STATKEY_CON]'>-</a>"
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];bulk_change=[REF(M)];stat=[STATKEY_CON]'> Bulk Change</a></li>"

		body += "<li>Intelligence: [living.STAINT] "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];add_stat=[REF(M)];stat=[STATKEY_INT]'>+</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];lower_stat=[REF(M)];stat=[STATKEY_INT]'>-</a>"
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];bulk_change=[REF(M)];stat=[STATKEY_INT]'> Bulk Change</a></li>"

		body += "<li>Speed: [living.STASPD] "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];add_stat=[REF(M)];stat=[STATKEY_SPD]'>+</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];lower_stat=[REF(M)];stat=[STATKEY_SPD]'>-</a>"
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];bulk_change=[REF(M)];stat=[STATKEY_SPD]'> Bulk Change</a></li>"

		body += "<li>Luck: [living.STALUC] "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];add_stat=[REF(M)];stat=[STATKEY_LCK]'>+</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];lower_stat=[REF(M)];stat=[STATKEY_LCK]'>-</a>"
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];bulk_change=[REF(M)];stat=[STATKEY_LCK]'> Bulk Change</a></li>"

	body += "</ul></div>"

	body += "<div id='quirks-section'>"
	body += "<h3>Quirks</h3><ul>"

	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		// Display current quirks
		if(length(H.quirks))
			body += "<h4>Current Quirks:</h4><ul>"
			for(var/datum/quirk/Q in H.quirks)
				body += "<li>[initial(Q.name)] ([Q.point_value] pts) "
				body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];remove_quirk=[REF(M)];quirk=[Q.type]'>Remove</a></li>"
			body += "</ul>"
		else
			body += "<p><i>No quirks</i></p>"

		// Add new quirk dropdown
		body += "<h4>Add Quirk:</h4>"
		body += "<select id='quirk-select'>"
		body += "<option value=''>-- Select Quirk --</option>"

		// Group quirks by category
		for(var/category in list(QUIRK_BOON, QUIRK_VICE, QUIRK_PECULIARITY))
			var/category_name = ""
			switch(category)
				if(QUIRK_BOON)
					category_name = "Boons"
				if(QUIRK_VICE)
					category_name = "Vices"
				if(QUIRK_PECULIARITY)
					category_name = "Peculiarities"

			body += "<optgroup label='[category_name]'>"
			for(var/quirk_data in GLOB.quirk_points_by_type[category])
				var/quirk_type = quirk_data["type"]
				var/quirk_name = quirk_data["name"]
				var/quirk_points = quirk_data["value"]
				body += "<option value='[quirk_type]'>[quirk_name] ([quirk_points] pts)</option>"
			body += "</optgroup>"

		body += "</select>"
		body += " <button class='skill-btn' onclick='addQuirk()'>Add</button>"

		// JavaScript for adding quirks
		body += "<script>"
		body += "function addQuirk() {"
		body += "    var select = document.getElementById('quirk-select');"
		body += "    var quirkType = select.value;"
		body += "    if(quirkType) {"
		body += "        window.location.href = '?_src_=holder;[HrefToken()];add_quirk=[REF(M)];quirk=' + encodeURIComponent(quirkType);"
		body += "    }"
		body += "}"
		body += "</script>"

	body += "</ul></div>"

	body += "</div>"
	body += "</div>"


	body += "<br>"
	body += "</body>"

	usr << browse(body, "window=adminplayeropts-[REF(M)];size=800x600")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Player Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/datum/admins/proc/admin_heal(mob/living/M in GLOB.mob_list)
	set name = "Heal Mob"
	set desc = "Heal a mob to full health"
	set category = "Admin.Admin"

	if(!check_rights())
		return
	M.revive(ADMIN_HEAL_ALL)
	message_admins("<span class='danger'>Admin [key_name_admin(usr)] healed / revived [key_name_admin(M)]!</span>")
	log_admin("[key_name(usr)] healed / Revived [key_name(M)].")

/datum/admins/proc/prompt_subclass(mob/living/mob in GLOB.mob_list)
	set name = "Trigger Subclass Menu"
	set desc = "Triggers the subclass menu of a mob."
	set category = "Admin.Admin"

	if(!check_rights())
		return
	if(tgui_alert(usr, "This will trigger a no adv class restriction triumph if the player has bought it.", "Confirm", list("Proceed", "Cancel")) != "Proceed")
		return FALSE

	SSrole_class_handler.setup_class_handler(mob)
	message_admins("<span class='danger'>Admin [key_name_admin(usr)] triggered the subclass menu on [key_name_admin(mob)]!</span>")
	log_admin("[key_name(usr)] triggered the subclass menu on [key_name(mob)].")

/datum/admins/proc/admin_curse(mob/living/carbon/human/M in GLOB.mob_list)
	set name = "Curse"
	set desc = "Curse or lift a curse from a character"
	set category = "GameMaster.Gods"
	if(!check_rights())
		return FALSE

	var/category = input("Category") as null|anything in list("Ten", "Inhuman", "Special")
	if(!category)
		return FALSE

	var/curse
	switch(category)
		if("Ten")
			curse = input("Curse") as null|anything in TEN_CURSES
		if("Inhuman")
			curse = input("Curse") as null|anything in INHUMEN_CURSES
		if("Special")
			curse = input("Curse") as null|anything in SPECIAL_CURSES

	if(!curse)
		return FALSE
	var/datum/curse/C = curse
	if(M.add_curse(C))
		message_admins(span_danger("Admin [key_name_admin(usr)] cursed [key_name_admin(M)] with [C.name]!"))
		log_admin("[key_name(usr)] cursed [key_name(M)] with [C.name].")
		return TRUE
	else if(M.remove_curse(C))
		message_admins(span_danger("Admin [key_name_admin(usr)] lifted [C.name] from [key_name_admin(M)]!"))
		log_admin("[key_name(usr)] lifted [C.name] from [key_name(M)].")
		return TRUE
	else
		return FALSE

/datum/admins/proc/checkpq(mob/living/M in GLOB.mob_list)
	set name = "Check PQ"
	set desc = "Check a mob's PQ"
	set category = null

	if(!check_rights())
		return

	if(!M.ckey)
		to_chat(src, "<span class='warning'>There is no ckey attached to this mob.</span>")
		return

	check_pq_menu(M.ckey)

/datum/admins/proc/checktriumphs(mob/living/M in GLOB.mob_list)
	set name = "Check Triumphs"
	set desc = "Check a mob's Triumphs"
	set category = null

	if(!check_rights())
		return

	if(!M.ckey)
		to_chat(src, "<span class='warning'>There is no ckey attached to this mob.</span>")
		return

	check_triumphs_menu(M.ckey)

/datum/admins/proc/admin_sleep(mob/living/M in GLOB.mob_list)
	set name = "Toggle Sleeping"
	set desc = "Toggle a mob's sleeping state"
	set category = "Admin.Admin"

	if(!check_rights())
		return

	var/S = M.IsSleeping()
	if(S)
		M.remove_status_effect(S)
		M.set_resting(FALSE, TRUE)
	else
		M.SetSleeping(999999)
	message_admins("<span class='danger'>Admin [key_name_admin(usr)] toggled [key_name_admin(M)]'s sleeping state!</span>")
	log_admin("[key_name(usr)] toggled [key_name(M)]'s sleeping state.")

/datum/admins/proc/start_vote()
	set name = "Start Vote"
	set desc = "Start a vote"
	set category = "GameMaster.Fun"

	if(!check_rights(R_POLL))
		to_chat(usr, "<span class='warning'>You do not have the rights to start a vote.</span>")
		return

	var/type = input("What kind of vote?") as null|anything in list("End Round", "Map", "Custom")
	switch(type)
		if("End Round")
			type = "endround"
		if("Map")
			type = "map"
		if("Custom")
			type = "custom"
	SSvote.initiate_vote(type, usr.key)

/datum/admins/proc/adjusttriumphs(mob/living/M in GLOB.mob_list)
	set name = "Adjust Triumphs"
	set desc = "Adjust a player's triumphs"
	set category = null

	if(!check_rights())
		return

	if(!M.ckey)
		to_chat(src, "<span class='warning'>There is no ckey attached to this mob.</span>")
		return

	var/ckey = lowertext(M.ckey)
	var/admin = lowertext(usr.key)

	if(!fexists("data/player_saves/[copytext(ckey,1,2)]/[ckey]/preferences.sav"))
		to_chat(src, "<span class='boldwarning'>User does not exist.</span>")
		return

	var/amt2change = input("How much to modify the triumphs by? (-100 to 100))") as null|num
	if(!check_rights(R_ADMIN,0))
		amt2change = CLAMP(amt2change, -100, 100)
	var/raisin = stripped_input("State a short reason for this change", "Game Master", "", null)
	if(!amt2change && !raisin)
		return
	M.adjust_triumphs(amt2change, FALSE, override_bonus = TRUE)
	to_chat(M.client, "<span class=\"admin\"><span class=\"prefix\">ADMIN LOG:</span> <span class=\"message linkify\">Your Triumphs has been adjusted by [amt2change] by [admin] for reason: [raisin]</span></span>")

/datum/admins/proc/adjustpq(mob/living/M in GLOB.mob_list)
	set name = "Adjust PQ"
	set desc = "Adjust a player's PQ"
	set category = null

	if(!check_rights())
		return

	if(!M.ckey)
		to_chat(src, "<span class='warning'>There is no ckey attached to this mob.</span>")
		return

	var/ckey = lowertext(M.ckey)
	var/admin = lowertext(usr.key)

	/*if(ckey == admin)
		to_chat(src, "<span class='boldwarning'>That's you!</span>")
		return
	*/
	if(!fexists("data/player_saves/[copytext(ckey,1,2)]/[ckey]/preferences.sav"))
		to_chat(src, "<span class='boldwarning'>User does not exist.</span>")
		return
	var/amt2change = input("How much to modify the PQ by? (20 to -20, or 0 to just add a note)") as null|num
	if(!check_rights(R_ADMIN,0))
		amt2change = CLAMP(amt2change, -20, 20)
	var/raisin = stripped_input("State a short reason for this change", "Game Master", "", null)
	if(!amt2change && !raisin)
		return
	adjust_playerquality(amt2change, ckey, admin, raisin)
	to_chat(M.client, "<span class=\"admin\"><span class=\"prefix\">ADMIN LOG:</span> <span class=\"message linkify\">Your PQ has been adjusted by [amt2change] by [admin] for reason: [raisin]</span></span>")

/datum/admins/proc/Game()
	if(!check_rights(0))
		return

	var/dat = "<html><meta charset='UTF-8'><head><title>Game Panel</title></head><body>"
	dat += {"
		<center><B>Game Panel</B></center><hr>\n
		"}
	if(GLOB.master_mode == "secret")
		dat += "<A href='byond://?src=[REF(src)];[HrefToken()];f_secret=1'>(Force Secret Mode)</A><br>"
	if(SSticker.IsRoundInProgress())
		dat += "<a href='byond://?src=[REF(src)];[HrefToken()];gamemode_panel=1'>(Game Mode Panel)</a><BR>"
	dat += {"
		<BR>
		<A href='byond://?src=[REF(src)];[HrefToken()];create_object=1'>Create Object</A><br>
		<A href='byond://?src=[REF(src)];[HrefToken()];quick_create_object=1'>Quick Create Object</A><br>
		<A href='byond://?src=[REF(src)];[HrefToken()];create_turf=1'>Create Turf</A><br>
		<A href='byond://?src=[REF(src)];[HrefToken()];create_mob=1'>Create Mob</A><br>
		"}

	if(marked_datum && istype(marked_datum, /atom))
		dat += "<A href='byond://?src=[REF(src)];[HrefToken()];dupe_marked_datum=1'>Duplicate Marked Datum</A><br>"

	dat += "</body></html>"
	usr << browse(dat, "window=admin2;size=240x280")
	return

#define REGULAR_RESTART "Regular Restart"
#define REGULAR_RESTART_DELAYED "Regular Restart (with delay)"
#define HARD_RESTART "Hard Restart (No Delay/Feedback Reason)"
#define HARDEST_RESTART "Hardest Restart (No actions, just reboot)"
#define TGS_RESTART "Server Restart (Kill and restart DD)"
/datum/admins/proc/restart()
	set category = "Server.Round Control"
	set name = "Reboot World"
	set desc = "Restarts the world immediately"
	if(!check_rights(R_SERVER))
		return

	if(SSticker.admin_delay_notice)
		if(alert(usr, "Are you sure? An admin has already delayed the round end for the following reason: [SSticker.admin_delay_notice]", "Confirmation", "Yes", "No") != "Yes")
			return FALSE

	var/list/options = list(REGULAR_RESTART, REGULAR_RESTART_DELAYED, HARD_RESTART, HARDEST_RESTART)
	if(world.TgsAvailable())
		options += TGS_RESTART

	var/result = input(usr, "Select reboot method", "World Reboot", options[1]) as null|anything in options
	if(!result)
		return

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Reboot World") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	var/init_by = "Initiated by [get_display_ckey(usr.ckey)]."
	switch(result)
		if(REGULAR_RESTART, REGULAR_RESTART_DELAYED)
			var/delay = 1
			if(result == REGULAR_RESTART_DELAYED)
				delay = input("What delay should the restart have (in seconds)?", "Restart Delay", 5) as num|null
				if(!delay)
					return FALSE
			SSplexora.restart_type = PLEXORA_SHUTDOWN_NORMAL
			SSplexora.restart_requester = usr
			SSticker.Reboot(init_by, "admin reboot - by [usr.key][usr.client.holder.fakekey ? " (stealth)" : ""]", delay SECONDS)
		if(HARD_RESTART)
			SSplexora.restart_type = PLEXORA_SHUTDOWN_HARD
			SSplexora.restart_requester = usr
			to_chat(world, "World reboot - [init_by]")
			world.Reboot()
		if(HARDEST_RESTART)
			SSplexora.restart_type = PLEXORA_SHUTDOWN_HARDEST
			SSplexora.restart_requester = usr
			to_chat(world, "Hard world reboot - [init_by]")
			world.Reboot(fast_track = TRUE)
		if(TGS_RESTART)
			SSplexora.restart_type = PLEXORA_SHUTDOWN_KILLDD
			SSplexora.restart_requester = usr
			to_chat(world, "Server restart - [init_by]")
			world.TgsEndProcess()

#undef REGULAR_RESTART
#undef REGULAR_RESTART_DELAYED
#undef HARD_RESTART
#undef HARDEST_RESTART
#undef TGS_RESTART

/datum/admins/proc/end_round()
	set category = "Server.Round Control"
	set name = "End Round"
	set desc = ""

	if (!usr.client.holder)
		return
	var/confirm = alert("End the round and restart the game world?", "End Round", "Yes", "Cancel")
	if(confirm == "Cancel")
		return
	if(confirm == "Yes")
		SSticker.force_ending = 1
		SSblackbox.record_feedback("tally", "admin_verb", 1, "End Round") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/datum/admins/proc/announce()
	set category = "GameMaster"
	set name = "OOC Announcement"
	set desc="Announce your desires to the world"
	if(!check_rights(0))
		return

	var/message = browser_input_text(usr, "Global message to send:", "Admin Announce")
	if(message)
		if(!check_rights(R_SERVER,0))
			message = adminscrub(message, 500)

		var/admin_name = span_adminannounce_big("[usr.client.holder.fakekey ? "Administrator" : usr.key] Announces:")
		var/message_to_announce = ("[span_adminannounce(message)]")
		to_chat(world, announcement_block("[admin_name] \n \n [message_to_announce]"))
		log_admin("Announce: [key_name(usr)] : [message]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Announce") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/set_admin_notice()
	set category = "GameMaster"
	set name = "Set Admin Notice"
	set desc ="Set an announcement that appears to everyone who joins the server. Only lasts this round"
	if(!check_rights(0))
		return

	var/new_admin_notice = input(src,"Set a public notice for this round. Everyone who joins the server will see it.\n(Leaving it blank will delete the current notice):","Set Notice",GLOB.admin_notice) as message|null
	if(new_admin_notice == null)
		return
	if(new_admin_notice == GLOB.admin_notice)
		return
	if(new_admin_notice == "")
		message_admins("[key_name(usr)] removed the admin notice.")
		log_admin("[key_name(usr)] removed the admin notice:\n[GLOB.admin_notice]")
	else
		message_admins("[key_name(usr)] set the admin notice.")
		log_admin("[key_name(usr)] set the admin notice:\n[new_admin_notice]")
		to_chat(world, "<span class='adminnotice'><b>Admin Notice:</b>\n \t [new_admin_notice]</span>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Set Admin Notice") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	GLOB.admin_notice = new_admin_notice
	return

/datum/admins/proc/toggleooc()
	set category = "OOC.Admin"
	set desc="Toggle dis bitch"
	set name="Toggle OOC"
	toggle_ooc()
	log_admin("[key_name(usr)] toggled OOC.")
	message_admins("[key_name_admin(usr)] toggled OOC.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle OOC", "[GLOB.ooc_allowed ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/datum/admins/proc/togglelooc()
	set category = "OOC.Admin"
	set desc="Toggle dis bitch"
	set name="Toggle LOOC"
	toggle_looc()
	log_admin("[key_name(usr)] toggled LOOC.")
	message_admins("[key_name_admin(usr)] toggled LOOC.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle LOOC", "[GLOB.ooc_allowed ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleoocdead()
	set category = "OOC.Admin"
	set desc="Toggle dis bitch"
	set name="Toggle Dead OOC"
	toggle_dooc()

	log_admin("[key_name(usr)] toggled OOC.")
	message_admins("[key_name_admin(usr)] toggled Dead OOC.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Dead OOC", "[GLOB.dooc_allowed ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/startnow()
	set category = "Server.Round Control"
	set desc="Start the round RIGHT NOW"
	set name="Start Now"
	if(SSticker.current_state == GAME_STATE_PREGAME || SSticker.current_state == GAME_STATE_STARTUP)
		SSticker.start_immediately = TRUE
		log_admin("[usr.key] has started the game.")
		var/msg = ""
		if(SSticker.current_state == GAME_STATE_STARTUP)
			msg = " (The server is still setting up, but the round will be \
				started as soon as possible.)"
		message_admins("<font color='blue'>\
			[usr.key] has started the game.[msg]</font>")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Start Now") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		return 1
	else
		to_chat(usr, "<font color='red'>Error: Start Now: Game has already started.</font>")

	return 0

/datum/admins/proc/toggleenter()
	set category = "Server.Round Control"
	set desc="People can't enter"
	set name="Toggle Entering"
	GLOB.enter_allowed = !( GLOB.enter_allowed )
	if (!( GLOB.enter_allowed ))
		to_chat(world, "<B>New players may no longer enter the game.</B>")
	else
		to_chat(world, "<B>New players may now enter the game.</B>")
	log_admin("[key_name(usr)] toggled new player game entering.")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] toggled new player game entering.</span>")
	world.update_status()
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Entering", "[GLOB.enter_allowed ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleAI()
	set category = "Server"
	set desc="People can't be AI"
	set name="Toggle AI"
	var/alai = CONFIG_GET(flag/allow_ai)
	CONFIG_SET(flag/allow_ai, !alai)
	if (alai)
		to_chat(world, "<B>The AI job is no longer chooseable.</B>")
	else
		to_chat(world, "<B>The AI job is chooseable now.</B>")
	log_admin("[key_name(usr)] toggled AI allowed.")
	world.update_status()
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle AI", "[!alai ? "Disabled" : "Enabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleaban()
	set category = "Server"
	set desc="Respawn basically"
	set name="Toggle Respawn"
	var/new_nores = !CONFIG_GET(flag/norespawn)
	CONFIG_SET(flag/norespawn, new_nores)
	if (!new_nores)
		to_chat(world, "<B>I may now respawn.</B>")
	else
		to_chat(world, "<B>I may no longer respawn :(</B>")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] toggled respawn to [!new_nores ? "On" : "Off"].</span>")
	log_admin("[key_name(usr)] toggled respawn to [!new_nores ? "On" : "Off"].")
	world.update_status()
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Respawn", "[!new_nores ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/delay()
	set category = "Server.Round Control"
	set desc="Delay the game start"
	set name="Delay pre-game"

	var/newtime = input("Set a new time in seconds. Set -1 for indefinite delay.","Set Delay",round(SSticker.GetTimeLeft()/10)) as num|null
	if(SSticker.current_state > GAME_STATE_PREGAME)
		return alert("Too late... The game has already started!")
	if(newtime)
		newtime = newtime*10
		SSticker.SetTimeLeft(newtime)
		if(newtime < 0)
			to_chat(world, "<b>The game start has been delayed.</b>")
			log_admin("[key_name(usr)] delayed the round start.")
		else
			to_chat(world, "<b>The game will start in [DisplayTimeText(newtime)].</b>")
			SEND_SOUND(world, sound('sound/blank.ogg'))
			log_admin("[key_name(usr)] set the pre-game delay to [DisplayTimeText(newtime)].")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Delay Game Start") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/accelerate_or_delay_round_end()
	set category = "Server.Round Control"
	set desc="Delay / Accelerate the round ending or vote time"
	set name="Delay / Accelerate the round ending or vote time"


	if(SSticker.current_state != GAME_STATE_PLAYING)
		return alert("This is only available while the game is in progress.")
	var/list/choices = list("Time before the round end vote.", "Time until the game ends.")
	var/choice = browser_input_list(src, "Choose what you want to adjust.", "Delay Tools", choices)
	var/number
	switch(choice)
		if("Time before the round end vote.")
			number = input(usr, "By how many minutes do you want to delay or accelerate it? (positive numbers delay, negative numbers accelerate)", "Time before the first round end vote.") as num
			if(number)
				if(number > 0)
					to_chat(world, "<b>The round end vote will now occur in [(GLOB.round_timer + (number * 1 MINUTES))/600] minutes instead of [GLOB.round_timer/600] minutes.</b>")
					log_admin("[key_name(usr)] delayed the round end vote by [number] minutes.")
					message_admins("[key_name(usr)] delayed the round end vote by [number] minutes.")
				else
					to_chat(world, "<b>The round end vote will now occur in [(GLOB.round_timer - (-number * 1 MINUTES))/600] minutes instead of [GLOB.round_timer/600] minutes.</b>")
					log_admin("[key_name(usr)] accelerated the round end vote by [-number] minutes.")
					message_admins("[key_name(usr)] accelerated the round end vote by [-number] minutes.")
				number *= 1 MINUTES
				GLOB.round_timer += number
				SSblackbox.record_feedback("tally", "admin_verb", 1, "Time before the round end vote triggered.")
		if("Time until the game ends.")
			number = input(usr, "By how many minutes do you want to delay or accelerate it? (positive numbers delay, negative numbers accelerate)", "Time until the round ends.") as num
			if(number)
				if(number > 0)
					to_chat(world, "<b>The round ending will now occur after an additional [number] minutes.</b>")
					log_admin("[key_name(usr)] delayed the round ending by [number] minutes.")
					message_admins("[key_name(usr)] delayed the round ending by [number] minutes.")
				else
					to_chat(world, "<b>The round ending has been accelerated by [-number] minutes.</b>")
					log_admin("[key_name(usr)] accelerated the round ending by [-number] minutes.")
					message_admins("[key_name(usr)] accelerated the round ending by [-number] minutes.")
				number *= 1 MINUTES
				SSgamemode.round_ends_at += number
				SSblackbox.record_feedback("tally", "admin_verb", 1, "Time until round ends triggered.")

////////////////////////////////////////////////////////////////////////////////////////////////ADMIN HELPER PROCS

/datum/admins/proc/spawn_atom(object as text)
	set category = "Debug.Spawn"
	set desc = ""
	set name = "Spawn"

	if(!check_rights(R_SPAWN) || !object)
		return

	var/list/preparsed = splittext(object,":")
	var/path = preparsed[1]
	var/amount = 1
	if(preparsed.len > 1)
		amount = CLAMP(text2num(preparsed[2]),1,ADMIN_SPAWN_CAP)

	var/atom/chosen = pick_closest_path(path)
	if(!chosen)
		return
	var/turf/T = get_turf(usr)

	if(ispath(chosen, /turf))
		T.ChangeTurf(chosen)
	else
		for(var/i in 1 to amount)
			var/atom/A = new chosen(T)
			A.flags_1 |= ADMIN_SPAWNED_1

	log_admin("[key_name(usr)] spawned [amount] x [chosen] at [AREACOORD(usr)]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Spawn Atom") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return initial(chosen.name)

/datum/admins/proc/podspawn_atom(object as text)
	set category = "Debug.Spawn"
	set desc = ""
	set name = "Podspawn"

	if(!check_rights(R_SPAWN))
		return

	var/chosen = pick_closest_path(object)
	if(!chosen)
		return
	var/turf/T = get_turf(usr)

	if(ispath(chosen, /turf))
		T.ChangeTurf(chosen)
	else
		var/obj/structure/closet/supplypod/centcompod/pod = new()
		var/atom/A = new chosen(pod)
		A.flags_1 |= ADMIN_SPAWNED_1
		new /obj/effect/DPtarget(T, pod)

	log_admin("[key_name(usr)] pod-spawned [chosen] at [AREACOORD(usr)]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Podspawn Atom") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/show_traitor_panel(mob/M in GLOB.mob_list)
	set category = "GameMaster.Antags"
	set desc = ""
	set name = "Show Traitor Panel"

	if(!istype(M))
		to_chat(usr, "This can only be used on instances of type /mob")
		return
	if(!M.mind)
		to_chat(usr, "This mob has no mind!")
		return

	M.mind.traitor_panel()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Traitor Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleguests()
	set category = "Server"
	set desc="Guests can't enter"
	set name="Toggle guests"
	var/new_guest_ban = !CONFIG_GET(flag/guest_ban)
	CONFIG_SET(flag/guest_ban, new_guest_ban)
	if (new_guest_ban)
		to_chat(world, "<B>Guests may no longer enter the game.</B>")
	else
		to_chat(world, "<B>Guests may now enter the game.</B>")
	log_admin("[key_name(usr)] toggled guests game entering [!new_guest_ban ? "" : "dis"]allowed.")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] toggled guests game entering [!new_guest_ban ? "" : "dis"]allowed.</span>")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Guests", "[!new_guest_ban ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/manage_free_slots()
	if(!check_rights())
		return
	var/datum/browser/browser = new(usr, "jobmanagement", "Manage Free Slots", 520)
	var/list/dat = list()
	var/count = 0

	if(!SSjob.initialized)
		alert(usr, "You cannot manage jobs before the job subsystem is initialized!")
		return

	dat += "<table>"

	for(var/datum/job/job as anything in SSjob.joinable_occupations)
		count++
		var/J_title = html_encode(job.title)
		var/J_opPos = html_encode(job.total_positions - (job.total_positions - job.current_positions))
		var/J_totPos = html_encode(job.total_positions)
		dat += "<tr><td>[J_title]:</td> <td>[J_opPos]/[job.total_positions < 0 ? " (unlimited)" : J_totPos]"

		dat += "</td>"
		dat += "<td>"
		if(job.total_positions >= 0)
			dat += "<A href='byond://?src=[REF(src)];[HrefToken()];customjobslot=[job.title]'>Custom</A> | "
			dat += "<A href='byond://?src=[REF(src)];[HrefToken()];addjobslot=[job.title]'>Add 1</A> | "
			if(job.total_positions > job.current_positions)
				dat += "<A href='byond://?src=[REF(src)];[HrefToken()];removejobslot=[job.title]'>Remove</A> | "
			else
				dat += "Remove | "
			if(job.enabled)
				dat += "<A href='byond://?src=[REF(src)];[HrefToken()];disablejob=[job.title]'>Disable</A> | "
			else
				dat += "<A href='byond://?src=[REF(src)];[HrefToken()];enablejob=[job.title]'>Enable</A> | "
			dat += "<A href='byond://?src=[REF(src)];[HrefToken()];unlimitjobslot=[job.title]'>Unlimit</A></td>"
		else
			dat += "<A href='byond://?src=[REF(src)];[HrefToken()];limitjobslot=[job.title]'>Limit</A></td>"

	browser.height = min(100 + count * 20, 650)
	browser.set_content(dat.Join())
	browser.open()

/datum/admins/proc/create_or_modify_area()
	set category = "Debug"
	set name = "Create or modify area"
	create_area(usr)

//
//
//ALL DONE
//*********************************************************************************************************
//TO-DO:
//
//

//RIP ferry snowflakes

//Kicks all the clients currently in the lobby. The second parameter (kick_only_afk) determins if an is_afk() check is ran, or if all clients are kicked
//defaults to kicking everyone (afk + non afk clients in the lobby)
//returns a list of ckeys of the kicked clients
/proc/kick_clients_in_lobby(message, kick_only_afk = 0)
	var/list/kicked_client_names = list()
	for(var/client/C in GLOB.clients)
		if(isnewplayer(C.mob))
			if(kick_only_afk && !C.is_afk()) //Ignore clients who are not afk
				continue
			if(message)
				to_chat(C, message)
			kicked_client_names.Add("[C.key]")
			qdel(C)
	return kicked_client_names

//returns 1 to let the dragdrop code know we are trapping this event
//returns 0 if we don't plan to trap the event
/datum/admins/proc/cmd_ghost_drag(mob/dead/observer/frommob, mob/tomob)

	//this is the exact two check rights checks required to edit a ckey with vv.
	if (!check_rights(R_VAREDIT,0) || !check_rights(R_SPAWN|R_DEBUG,0))
		return 0

	if (!frommob.ckey)
		return 0

	var/question = ""
	if (tomob.ckey)
		question = "This mob already has a user ([tomob.key]) in control of it! "
	question += "Are you sure you want to place [frommob.name]([frommob.key]) in control of [tomob.name]?"

	var/ask = alert(question, "Place ghost in control of mob?", "Yes", "No")
	if (ask != "Yes")
		return 1

	if (!frommob || !tomob) //make sure the mobs don't go away while we waited for a response
		return 1

	tomob.ghostize(0)

	message_admins("<span class='adminnotice'>[key_name_admin(usr)] has put [frommob.key] in control of [tomob.name].</span>")
	log_admin("[key_name(usr)] stuffed [frommob.key] into [tomob.name].")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Ghost Drag Control")

	tomob.ckey = frommob.ckey
	qdel(frommob)

	return 1

/client/proc/adminGreet(logout)
	if(SSticker.HasRoundStarted())
		var/string
		if(logout && CONFIG_GET(flag/announce_admin_logout))
			string = pick(
				"Admin logout: [key_name(src)]")
		else if(!logout && CONFIG_GET(flag/announce_admin_login) && (prefs.toggles & ANNOUNCE_LOGIN))
			string = pick(
				"Admin login: [key_name(src)]")
		if(string)
			message_admins("[string]")


/client/proc/returntolobby()
	set category = "Debug"
	set name = "Return to Lobby"

	var/mob/living/carbon/human/H = mob
	H.returntolobby()

/client/proc/spawn_liquid()
	set category = "Debug.Spawn"
	set name = "Spawn Liquid"
	set desc = "Spawns an amount of chosen liquid at your current location."

	var/choice
	var/valid_id
	while(!valid_id)
		choice = stripped_input(usr, "Enter the ID of the reagent you want to add.", "Search reagents")
		if(isnull(choice)) //Get me out of here!
			break
		if (!ispath(text2path(choice)))
			choice = pick_closest_path(choice, make_types_fancy(subtypesof(/datum/reagent)))
			if (ispath(choice))
				valid_id = TRUE
		else
			valid_id = TRUE
		if(!valid_id)
			to_chat(usr, span_warning("A reagent with that ID doesn't exist!"))
			return
	if(!choice)
		return
	var/volume = input(usr, "Volume:", "Choose volume") as num
	if(!volume)
		return
	if(volume >= 100000)
		to_chat(usr, span_warning("Please limit the volume to below 100000 units!"))
		return
	var/turf/epicenter = get_turf(mob)
	epicenter.add_liquid(choice, volume, FALSE, 300)
	message_admins("[ADMIN_LOOKUPFLW(usr)] spawned liquid at [epicenter.loc] ([choice] - [volume]).")
	log_admin("[key_name(usr)] spawned liquid at [epicenter.loc] ([choice] - [volume]).")

/client/proc/remove_liquid()
	set name = "Remove Liquids"
	set category = "GameMaster.Fun"
	set desc = "Fixes air in specified radius."
	var/turf/epicenter = get_turf(mob)

	var/range = input(usr, "Enter range:", "Range selection", 2) as num

	for(var/obj/effect/abstract/liquid_turf/liquid in range(range, epicenter))
		liquid.liquid_group.remove_any(liquid, liquid.liquid_group.reagents_per_turf)
		qdel(liquid)

	message_admins("[key_name_admin(usr)] removed liquids with range [range] in [epicenter.loc.name]")
	log_game("[key_name_admin(usr)] removed liquids with range [range] in [epicenter.loc.name]")

/client/proc/adjust_personal_see_leylines()
	set category = "GameMaster"
	set name = "Hide Current Z-Level Leylines"
	set desc = "Hides Leylines on the current z-level from your vision."

	toggled_leylines = !toggled_leylines
	mob.hud_used?.plane_masters_update()

/client/proc/spawn_pollution()
	set category = "Debug.Spawn"
	set name = "Spawn Pollution"
	set desc = "Spawns an amount of chosen pollutant at your current location."

	var/list/singleton_list = SSpollution.singletons
	var/choice = input(usr, "What type of pollutant would you like to spawn?", "Spawn Pollution") as null|anything in singleton_list
	if(!choice)
		return
	var/amount_choice = input(usr, "Amount of pollution", "Spawn Pollution") as num|null
	if(!amount_choice)
		return
	var/turf/epicenter = get_turf(mob)
	epicenter.pollute_turf(choice, amount_choice)
	message_admins("[ADMIN_LOOKUPFLW(usr)] spawned pollution at [epicenter.loc] ([choice] - [amount_choice]).")
	log_admin("[key_name(usr)] spawned pollution at [epicenter.loc] ([choice] - [amount_choice]).")

/datum/admins/proc/anoint_priest(mob/living/carbon/human/M in GLOB.human_list)
	set category = "GameMaster.Interactions"
	set name = "Anoint New Priest"
	set desc = "Choose a new priest. The previous one will be excommunicated."

	if(!check_rights())
		return
	if(!istype(M))
		return
	if(!M.mind)
		return
	if(is_priest_job(M.mind.assigned_role))
		return
	var/appointment_type = browser_alert(usr, "Are you sure you want to anoint [M.real_name] as the new Priest?", "Confirmation", DEFAULT_INPUT_CHOICES)
	if(appointment_type == CHOICE_NO)
		return

	var/datum/job/priest_job = SSjob.GetJobType(/datum/job/priest)
	//demote the old priest
	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		//TODO: this fucking sucks, just locate the priest
		if(!HL.mind)
			continue

		if(is_priest_job(HL.mind.assigned_role))
			HL.mind.set_assigned_role(/datum/job/villager)
			HL.job = "Ex-Priest"


			remove_verb(HL, /mob/living/carbon/human/proc/coronate_lord)
			remove_verb(HL, /mob/living/carbon/human/proc/churchexcommunicate)
			remove_verb(HL, /mob/living/carbon/human/proc/churchcurse)
			remove_verb(HL, /mob/living/carbon/human/proc/churchannouncement)
			priest_job?.remove_spells(HL)
			GLOB.excommunicated_players |= HL.real_name
			HL.cleric?.excommunicate()

	priest_job?.add_spells(M)
	M.mind.set_assigned_role(/datum/job/priest)
	M.job = "Priest"
	M.set_patron(/datum/patron/divine/astrata)
	var/holder = M.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_priest()
		devotion.grant_to(M)
	add_verb(M, /mob/living/carbon/human/proc/coronate_lord)
	add_verb(M, /mob/living/carbon/human/proc/churchexcommunicate)
	add_verb(M, /mob/living/carbon/human/proc/churchcurse)
	add_verb(M, /mob/living/carbon/human/proc/churchannouncement)
	removeomen(OMEN_NOPRIEST)
	priority_announce("Astrata has anointed [M.real_name] as the new head of the Church of the Ten!", title = "Astrata Shines!", sound = 'sound/misc/bell.ogg')

/datum/admins/proc/fix_death_area()
	set category = "GameMaster"
	set desc="Toggle dis bitch"
	set name="Fix Death Arena"
	SSdeath_arena.admin_reset()
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle LOOC", "[GLOB.ooc_allowed ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggle_debug_pathfinding()
	set category = "GameMaster"
	set desc="Pathfinding Debug"
	set name="Pathfinding Debug"
	var/mob/user = usr
	if(!user.client.holder)
		return

	if(!user.client.holder.path_debug)
		user.client.holder.path_debug = new(user.client.holder)
	else
		QDEL_NULL(user.client.holder.path_debug)

/datum/admins/proc/give_all_triumphs()
	set category = "GameMaster.Triumphs"
	set desc = "Triumph Giver"
	set name = "Give All Triumphs"

	var/mob/user = usr
	if(!user.client.holder)
		return
	var/answer = input(user, "ARE YOU ABSOLUTELY SURE? THIS WILL GIVE TRIUMPHS TO EVERYONE CONNECTED.", "TRIUMPHS") as anything in list("Yes", "No")
	if(answer != "Yes")
		return
	var/amount = input(user, "Choose the amount of triumphs", "Triumph Giver") as num|null
	if(!amount)
		return
	if(amount < 0)
		return

	var/reason = input(user, "Choose a reason", "Triumph Giver") as text|null

	for(var/client/client as anything in GLOB.clients)
		client.mob.adjust_triumphs(amount, reason = reason, override_bonus = TRUE)

/datum/admins/proc/change_skill_exp_modifier()
	set name = "Change Skill Experience Gain"
	set desc = "Changes the experience gain of either the adjust_experience proc, or add_sleep_experience proc."
	set category = "GameMaster"

	var/list/options = list("Adjust Experience Modifier", "Sleep Experience Modifier", "Both")

	var/type = browser_input_list(usr, "Change which modifier? \n The current value of adjust_experience_modifier is [GLOB.adjust_experience_modifier] \n The current value of sleep_experience_modifier is [GLOB.sleep_experience_modifier].", "Change Skill Experience Gain", options, "Both")
	var/modifier = input(usr, "Enter what the modifier should be, default is 1", "Change Skill Experience Gain", 1) as num
	switch(type)
		if("Adjust Experience Modifier")
			GLOB.adjust_experience_modifier = modifier
			message_admins("[key_name_admin(usr)] set the value of adjust_experience_modifier to [modifier].")
		if("Sleep Experience Modifier")
			GLOB.sleep_experience_modifier = modifier
			message_admins("[key_name_admin(usr)] set the value of sleep_experience_modifier to [modifier].")
		if("Both")
			GLOB.adjust_experience_modifier = modifier
			GLOB.sleep_experience_modifier = modifier
			message_admins("[key_name_admin(usr)] set the value of both adjust_experience_modifier and sleep_experience_modifier to [modifier].")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Change Skill Experience Gain")
