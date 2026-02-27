//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki(query as text)
	set name = "Wiki"
	set desc = ""
	set category = "OOC.Links"
	var/wikiurl = CONFIG_GET(string/wikiurl)
	if(wikiurl)
		if(query)
			var/output = wikiurl + "?title=Special%3ASearch&search=" + query
			src << link(output)
		else if (query != null)
			src << link(wikiurl)
	else
		to_chat(src, "<span class='danger'>The wiki URL is not set in the server configuration.</span>")
	return

/client/verb/forum()
	set name = "forum"
	set desc = ""
	set hidden = 1
	var/forumurl = CONFIG_GET(string/forumurl)
	if(forumurl)
		if(alert("This will open the forum in your browser. Are you sure?",,"Yes","No")!="Yes")
			return
		src << link(forumurl)
	else
		to_chat(src, "<span class='danger'>The forum URL is not set in the server configuration.</span>")
	return

/client/verb/rules()
	set name = "Rules"
	set desc = ""
	set category = "OOC.Links"
	var/rulesurl = CONFIG_GET(string/rulesurl)
	if(rulesurl)
		if(alert("This will open the rules in your browser. Are you sure?",,"Yes","No")!="Yes")
			return
		src << link(rulesurl)
	else
		to_chat(src, "<span class='danger'>The rules URL is not set in the server configuration.</span>")
	return

/client/verb/github()
	set name = "Github"
	set desc = ""
	set category = "OOC.Links"
	var/githuburl = CONFIG_GET(string/githuburl)
	if(githuburl)
		if(browser_alert(src, "This will open the Github repository in your browser. Are you sure?", null, DEFAULT_INPUT_CHOICES) != CHOICE_YES)
			return
		src << link(githuburl)
	else
		to_chat(src, "<span class='danger'>The Github URL is not set in the server configuration.</span>")
	return

/client/verb/mentorhelp()
	set name = "Mentorhelp"
	set desc = ""
	set category = "Admin"
	if(mob)
		var/msg = input("Say your meditation:", "Voices in your head") as text|null
		if(msg)
			mob.schizohelp(msg)
	else
		to_chat(src, span_danger("You can't currently use Mentorhelp in the main menu."))

/client/verb/mentor_stats()
	set name = "Mentor Statistics"
	set desc = ""
	set category = "Admin"
	check_mentor_stats_menu(src.ckey)

/client/verb/reportissue()
	set name = "Report a bug"
	set desc = "Report a bug"
	set category = "OOC.Links"

	var/githuburl = CONFIG_GET(string/githuburl)
	if(!githuburl)
		to_chat(src, span_danger("The Github URL is not set in the server configuration."))
		return
	var/issue_key = CONFIG_GET(string/issue_key)
	if(!issue_key)
		to_chat(src, span_danger("Issue Reporting is not properly configured."))
		return
	var/testmerge_data = GLOB.revdata.testmerge
	var/has_testmerge_data = (length(testmerge_data) != 0)

	var/message = "This will start reporting an issue, gathering some information from the server and your client, before submitting it to github."
	if(has_testmerge_data)
		message += "<br>The following experimental changes are active and may be the cause of any new or sudden issues:<br>"
		message += GLOB.revdata.GetTestMergeInfo(FALSE)

	if(browser_alert(src, message, "Report Issue", DEFAULT_INPUT_CHOICES) != CHOICE_YES)
		return

	// Keep a static version of the template to avoid reading file
	var/static/issue_template = file2text(".github/ISSUE_TEMPLATE/bug_report.md")

	// Get a local copy of the template for modification
	var/local_template = issue_template

	local_template = replacetext(local_template, "## Map:\n", "## Map:\n[SSmapping.config.map_name]")

	// Insert round
	if(GLOB.round_id)
		local_template = replacetext(local_template, "## Round ID:\n", "## Round ID:\n[GLOB.round_id]")

	// Insert testmerges
	if(length(GLOB.revdata.testmerge))
		var/list/all_tms = list()
		for(var/datum/tgs_revision_information/test_merge/tm as anything in GLOB.revdata.testmerge)
			all_tms += "- \[[tm.title]\]([githuburl]/pull/[tm.number])"
		var/all_tms_joined = all_tms.Join("\n") // for some reason this can't go in the []
		local_template = replacetext(local_template, "## Testmerges:\n", "## Testmerges:\n[all_tms_joined]")

	var/issue_title = browser_input_text(src, "Please give the issue a title", "Issue Title")
	if(!issue_title)
		return
	var/user_description = browser_input_text(src, "Please describe the issue you are reporting", "Issue Body", multiline = TRUE)
	if(!user_description)
		return

	local_template = replacetext(local_template, "## Reproduction:\n", "## Reproduction:\n[user_description]")

	var/list/client_info = list()
	client_info += "BYOND: [byond_version].[byond_build]"
	client_info += "Ckey: [ckey]"

	local_template = replacetext(local_template, "## Client Information:\n", "## Client Information:\n[client_info.Join("\n")]")

	var/list/body_structure = list(
		"title" = issue_title,
		"body" = local_template,
	)
	var/datum/http_request/issue_report = new
	rustg_file_write(local_template, "[GLOB.log_directory]/issue_reports/[ckey]-[world.time]-[SANITIZE_FILENAME(issue_title)].txt")
	message_admins("BUGREPORT: Bug report filed by [ADMIN_LOOKUPFLW(src)], Title: [strip_html(issue_title)]")
	issue_report.prepare(
		RUSTG_HTTP_METHOD_POST,
		"https://api.github.com/repos/[CONFIG_GET(string/issue_slug)]/issues",
		json_encode(body_structure), //this is slow slow slow but no other options buckaroo
		list(
			"Accept"="application/vnd.github+json",
			"Authorization"="Bearer [issue_key]",
			"X-GitHub-Api-Version"="2022-11-28"
		)
	)
	to_chat(src, span_notice("Sending issue report..."))
	//SEND_SOUND(src, 'sound/misc/compiler-stage1.ogg')
	issue_report.begin_async()
	UNTIL(issue_report.is_complete() || !src) //Client fuckery.
	var/datum/http_response/issue_response = issue_report.into_response()
	if(issue_response.errored || issue_response.status_code != 201)
		//SEND_SOUND(src, 'sound/misc/compiler-failure.ogg')
		to_chat(src, "[span_alertwarning("Bug report FAILED!")]\n\
		[span_warning("Please adminhelp immediately!")]\n\
		[span_notice("Code:[issue_response.status_code || "9001 CATASTROPHIC ERROR"]")]")

		log_runtime(
			"Failed to send issue report. errored=[issue_response.errored], status_code=[isnull(issue_response.status_code) ? "(null)" : issue_response.status_code]",
			list(
				"status_code" = issue_response.status_code,
				"errored" = issue_response.errored,
				"headers" = issue_response.headers?.Copy(),
				"error" = issue_response.error,
				"body" = issue_report.body,
			)
		)

		return
	//SEND_SOUND(src, 'sound/misc/compiler-stage2.ogg')
	to_chat(src, span_notice("Bug submitted successfully."))

/client/verb/list_test_merges()
	set name = "List Test Merges"
	set desc = "See active Test Merges"
	set category = "OOC.Links"

	var/testmerge_text = GLOB.revdata.GetTestMergeInfo()

	if(length(testmerge_text)) // is there even any text here? gotta check.
		to_chat(src, span_notice(testmerge_text))
		return

	to_chat(src, span_notice("No Test Merges active!"))


/client/verb/check_role_bans()
	set name = "Check Role Bans"
	set desc = ""
	set category = "OOC"

	var/datum/role_bans/bans = get_role_bans_for_ckey(ckey)
	var/list/dat = list()
	for(var/datum/role_ban_instance/instance as anything in bans.bans)
		if(!instance.permanent && world.realtime >= instance.apply_date + instance.duration)
			dat += "<b>EXPIRED</b><BR>"
		var/list/ban_string =  instance.get_ban_string_list()
		dat += ban_string.Join("<BR>")
		dat += "<HR>"
	var/datum/browser/popup = new(usr, "check_role_bans", "Role Bans", 550, 500)
	popup.set_content(dat.Join())
	popup.open()

/client/verb/set_fixed()
	set name = "IconSize"
	set category = "Preferences.Options"

	if(winget(src, "mapwindow.map", "icon-size") == "64")
		to_chat(src, "Stretch-to-fit... OK")
		winset(src, "mapwindow.map", "icon-size=0")
	else
		to_chat(src, "64x... OK")
		winset(src, "mapwindow.map", "icon-size=64")

/client/verb/set_stretch()
	set name = "IconScaling"
	set category = "Preferences.Options"
	if(prefs)
		if(prefs.crt == TRUE)
			to_chat(src, "CRT mode is on.")
			winset(src, "mapwindow.map", "zoom-mode=blur")
			return
	if(winget(src, "mapwindow.map", "zoom-mode") == "normal")
		to_chat(src, "Pixel-perfect... OK")
		winset(src, "mapwindow.map", "zoom-mode=distort")
	else
		to_chat(src, "Anti-aliased... OK")
		winset(src, "mapwindow.map", "zoom-mode=normal")

/client/verb/crtmode()
	set category = "Preferences.Options"
	set name = "ToggleCRT"
	if(!prefs)
		return
	if(prefs.crt == TRUE)
		winset(src, "mapwindow.map", "zoom-mode=normal")
		prefs.crt = FALSE
		prefs.save_preferences()
		to_chat(src, "CRT... OFF")
		for(var/atom/movable/screen/scannies/S in screen)
			S.alpha = 0
	else
		winset(src, "mapwindow.map", "zoom-mode=blur")
		prefs.crt = TRUE
		prefs.save_preferences()
		to_chat(src, "CRT... ON")
		for(var/atom/movable/screen/scannies/S in screen)
			S.alpha = 70

/client/verb/ui_scaling()
	set name = "UI Scaling"
	set category = "Preferences.Options"
	if(prefs)
		var/current_scaling = window_scaling * 100
		var/new_scaling = input(usr, "Enter UI Scaling (Your current scaling is [current_scaling]%). Cancel to reset to native scaling.", "New UI Scaling", window_scaling * 100) as null|num
		if(!isnull(new_scaling))
			prefs.toggles |= UI_SCALE
			window_scaling = new_scaling / 100
			prefs.ui_scale = window_scaling
			prefs.save_preferences()
			to_chat(src, span_notice("UI Scaling set to [window_scaling * 100]%. Changes take effect when opening new windows."))
		else
			prefs.toggles &= ~UI_SCALE
			window_scaling = text2num(winget(src, null, "dpi"))
			to_chat(src, span_notice("UI Scaling reset to native [window_scaling * 100]%. Changes take effect when opening new windows."))
		native_say?.refresh_channels()

/client/verb/keybind_menu()
	set category = "Preferences.Options"
	set name = "Adjust Keybinds"
	if(!prefs)
		return
	prefs.set_keybinds(usr)

/client/verb/changefps()
	set category = "Preferences.Options"
	set name = "ChangeFPS"
	if(!prefs)
		return
	var/newfps = input(usr, "Enter new FPS", "New FPS", 100) as null|num
	if (!isnull(newfps))
		prefs.clientfps = clamp(newfps, 1, 1000)
		fps = prefs.clientfps
		prefs.save_preferences()

/client/verb/changelog()
	set name = "Changelog"
	set category = "OOC.Links"

	if(!GLOB.changelog_browser)
		GLOB.changelog_browser = new /datum/changelog()

	var/datum/browser/log = new(usr, "changelog", "CHANGES OF THE WORLD", 680, 650)
	log.set_content(GLOB.changelog_browser.built_html)
	log.open()

	if(prefs.lastchangelog != GLOB.changelog_hash)
		prefs.lastchangelog = GLOB.changelog_hash
		prefs.save_preferences()

/client/verb/do_rp_prompt()
	set name = "Lore Primer"
	set category = "OOC.Links"
	var/list/dat = list()
	dat += GLOB.roleplay_readme
	if(dat)
		var/datum/browser/popup = new(usr, "Primer", "VANDERLIN", 650, 900)
		popup.set_content(dat.Join())
		popup.open()
