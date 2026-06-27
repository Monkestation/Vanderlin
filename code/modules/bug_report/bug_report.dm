/datum/bug_report

/datum/bug_report/ui_state(mob/user)
	return GLOB.always_state

/datum/bug_report/ui_close(mob/user)
	qdel(src)

/datum/bug_report/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BugReport")
		ui.open()

/datum/bug_report/ui_data(mob/user)
	var/list/data = list()
	var/client/user_client = user.client
	data["byond"] = "[user_client.byond_version].[user_client.byond_build]"
	data["ckey"] = "[user_client.ckey]"
	return data

/datum/bug_report/ui_static_data(mob/user)
	var/list/data = list()
	data["roundid"] = GLOB.round_id || "Unknown"
	data["map"] = SSmapping.config.map_name
	return data

/datum/bug_report/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return TRUE

	if(action != "submit")
		return

	var/client/user_client = ui.user?.client
	if(!user_client)
		return

	var/githuburl = CONFIG_GET(string/githuburl)
	if(!githuburl)
		to_chat(user_client, span_danger("The Github URL is not set in the server configuration."))
		return

	var/issue_key = CONFIG_GET(string/issue_key)
	if(!issue_key)
		to_chat(user_client, span_danger("Issue Reporting is not properly configured."))
		return

	var/user_data = params["user_data"]
	var/ckey = user_data["ckey"]
	var/byond = user_data["byond"]
	var/round_id = user_data["round_id"]
	var/map = user_data["map"]

	var/report_title = params["report_title"]
	if(!report_title)
		to_chat(user_client, span_danger("Please enter a title"))
		return

	var/report_content = params["report_body"]
	if(!report_content)
		to_chat(user_client, span_danger("Please enter a body"))
		return

	var/severity = params["severity"]
	var/list/labels = params["labels"]

	if(severity != "Not set") // Value from TGUI
		labels += severity
	else
		severity = null

	// Keep a static version of the template to avoid reading file
	var/static/issue_template = file2text(".github/ISSUE_TEMPLATE/bug_report.md")

	// Get a local copy of the template for modification
	var/local_template = issue_template

	local_template = replacetext(local_template, "## Map:\n", "## Map:\n[map]")

	// Insert round
	if(round_id != "Unknown")
		local_template = replacetext(local_template, "## Round ID:\n", "## Round ID:\n[round_id]")

	// Insert testmerges
	if(length(GLOB.revdata.testmerge))
		var/list/all_tms = list()
		for(var/datum/tgs_revision_information/test_merge/tm as anything in GLOB.revdata.testmerge)
			all_tms += "- \[[tm.title]\]([githuburl]/pull/[tm.number])"
		var/all_tms_joined = all_tms.Join("\n") // for some reason this can't go in the []
		local_template = replacetext(local_template, "## Testmerges:\n", "## Testmerges:\n[all_tms_joined]")

	local_template = replacetext(local_template, "## Reproduction:\n", "## Reproduction:\n[report_content]")

	var/list/client_info = list()
	client_info += "BYOND: [byond]"
	client_info += "Ckey: [ckey]"

	local_template = replacetext(local_template, "## Client Information:\n", "## Client Information:\n[client_info.Join("\n")]")

	var/title_prefix = ""
	if(severity)
		title_prefix = "\[[severity]\] "

	var/issue_title = "[title_prefix][report_title]"

	var/list/body_structure = list(
		"title" = issue_title,
		"body" = local_template,
		"labels" = labels,
	)

	var/datum/http_request/issue_report = new
	rustg_file_write(local_template, "[GLOB.log_directory]/issue_reports/[ckey]-[world.time]-[SANITIZE_FILENAME(issue_title)].txt")
	message_admins("BUGREPORT: Bug report filed by [ADMIN_LOOKUPFLW(user_client)], Title: [strip_html(issue_title)]")
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
	to_chat(user_client, span_notice("Sending issue report..."))
	//SEND_SOUND(user_client, 'sound/misc/compiler-stage1.ogg')
	issue_report.begin_async()
	UNTIL(issue_report.is_complete() || !user_client) //Client fuckery.
	var/datum/http_response/issue_response = issue_report.into_response()
	if(issue_response.errored || issue_response.status_code != 201)
		//SEND_SOUND(user_client, 'sound/misc/compiler-failure.ogg')
		to_chat(user_client, "[span_alertwarning("Bug report FAILED!")]\n\
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
	//SEND_SOUND(user_client, 'sound/misc/compiler-stage2.ogg')
	to_chat(user_client, span_notice("Bug submitted successfully."))
	qdel(src)
