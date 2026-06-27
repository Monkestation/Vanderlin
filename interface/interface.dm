//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki()
	set name = "Wiki"
	set desc = ""
	set hidden = 1

	var/wikiurl = CONFIG_GET(string/wikiurl)
	if(!wikiurl)
		to_chat(src, "<span class='danger'>The wiki URL is not set in the server configuration.</span>")
		return

	if(tgui_alert(src, "This will open the wiki in your browsaer. Are you sure?", null, DEFAULT_INPUT_CHOICES) != CHOICE_YES)
		return

	src << link(wikiurl)

/client/verb/forum()
	set name = "forum"
	set desc = ""
	set hidden = 1

	var/forumurl = CONFIG_GET(string/forumurl)
	if(!forumurl)
		to_chat(src, "<span class='danger'>The forum URL is not set in the server configuration.</span>")
		return

	if(tgui_alert(src, "This will open the forum in your browser. Are you sure?", null, DEFAULT_INPUT_CHOICES) != CHOICE_YES)
		return

	src << link(forumurl)

/client/verb/rules()
	set name = "Rules"
	set desc = ""
	set hidden = 1

	var/rulesurl = CONFIG_GET(string/rulesurl)
	if(!rulesurl)
		to_chat(src, "<span class='danger'>The rules URL is not set in the server configuration.</span>")
		return

	if(tgui_alert(src, "This will open the rules in your browser. Are you sure?", null, DEFAULT_INPUT_CHOICES) != CHOICE_YES)
		return

	src << link(rulesurl)

/client/verb/github()
	set name = "Github"
	set desc = ""
	set hidden = 1

	var/githuburl = CONFIG_GET(string/githuburl)
	if(!githuburl)
		to_chat(src, "<span class='danger'>The Github URL is not set in the server configuration.</span>")
		return

	if(tgui_alert(src, "This will open the Github repository in your browser. Are you sure?", null, DEFAULT_INPUT_CHOICES) != CHOICE_YES)
		return

	src << link(githuburl)

/client/verb/reportissue()
	set name = "report-issue"
	set desc = "Report an issue"
	set hidden = 1

	if(!CONFIG_GET(string/githuburl))
		to_chat(src, span_danger("The Github URL is not set in the server configuration."))
		return

	if(!CONFIG_GET(string/issue_key))
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

	var/datum/bug_report/reporter = new()
	reporter.ui_interact(mob)

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

/client/verb/list_test_merges()
	set name = "List Test Merges"
	set desc = "See active Test Merges"
	set category = "OOC.Links"

	if(length(GLOB.current_tms)) // is there even any text here? gotta check.
		to_chat(src, span_notice(GLOB.current_tms))
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

	if(winget(src, "mapwindow.map", "zoom-mode") == "normal")
		to_chat(src, "Pixel-perfect... OK")
		winset(src, "mapwindow.map", "zoom-mode=distort")
	else
		to_chat(src, "Anti-aliased... OK")
		winset(src, "mapwindow.map", "zoom-mode=normal")

/client/verb/ui_scaling()
	set name = "UI Scaling"
	set category = "Preferences.Options"
	if(prefs)
		var/current_scaling = window_scaling * 100
		var/new_scaling = input(usr, "Enter UI Scaling (Your current scaling is [current_scaling]%). Cancel to reset to native scaling.", "New UI Scaling", window_scaling * 100) as null|num
		if(!isnull(new_scaling))
			prefs.preference_set_flag(/datum/preference/bitwise/toggles, UI_SCALE)
			window_scaling = new_scaling / 100
			prefs.write_preference(/datum/preference/numeric/ui_scale, window_scaling)
			prefs.save_preferences()
			to_chat(src, span_notice("UI Scaling set to [window_scaling * 100]%. Changes take effect when opening new windows."))
		else
			prefs.preference_clear_flag(/datum/preference/bitwise/toggles, UI_SCALE)
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
		prefs.write_preference(/datum/preference/numeric/clientfps, clamp(newfps, 1, 1000))
		fps = prefs.read_preference(/datum/preference/numeric/clientfps)
		prefs.save_preferences()

/client/verb/changelog()
	set name = "Changelog"
	set category = "OOC"

	if(!GLOB.changelog_tgui)
		GLOB.changelog_tgui = new /datum/changelog()

	GLOB.changelog_tgui.ui_interact(mob)

	if(prefs.lastchangelog != GLOB.changelog_hash)
		prefs.lastchangelog = GLOB.changelog_hash
		prefs.save_preferences()
		stat_panel.send_message("read_changelog")

/client/verb/do_rp_prompt()
	set name = "Lore Primer"
	set category = "OOC.Links"
	var/list/dat = list()
	dat += GLOB.roleplay_readme
	if(dat)
		var/datum/browser/popup = new(usr, "Primer", "VANDERLIN", 650, 900)
		popup.set_content(dat.Join())
		popup.open()
