/datum/memprofiler/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MemoryProfiler")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/memprofiler/ui_state(mob/user)
	return ADMIN_STATE(R_DEBUG)

/datum/memprofiler/ui_static_data(mob/user)
	return list(
		"panel_row_options" = panel_row_options,
		"dump_row_options" = dump_row_options,
		"base_sizes" = base_sizes,
	)

/datum/memprofiler/ui_data(mob/user)
	return list(
		"enabled" = enabled,
		"error" = error,
		"last_error" = last_error,
		"busy" = capture_in_progress,
		"coverage" = coverage,
		"census" = census,
		"lists_report" = lists_report,
		"vars_report" = vars_report,
		"diff_report" = diff_report,
		"compat_report" = compat_report,
		"debug_text" = debug_text,
		"report_meta" = report_meta,
		"baseline_at" = baseline_at,
		"baseline_by" = baseline_by,
		"dumps" = dumps,
	)

/datum/memprofiler/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/client/user = ui?.user?.client
	if(!user)
		return

	switch(action)
		if("capture_census")
			capture_census(user)
			return TRUE
		if("capture_lists")
			capture_lists(user, params["rows"])
			return TRUE
		if("capture_vars")
			capture_vars(user)
			return TRUE
		if("set_baseline")
			set_baseline(user)
			return TRUE
		if("capture_diff")
			capture_diff(user)
			return TRUE
		if("capture_compat")
			capture_compat(user)
			return TRUE
		if("drain_debug")
			drain_debug(user)
			return TRUE
		if("clear")
			clear_state(user)
			return TRUE
		if("dump")
			dump_to_file(user, params["kind"], params["rows"])
			return TRUE
		if("download")
			download_dump(user, params["index"])
			return TRUE
