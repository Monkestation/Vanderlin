/// How many dumps to remember before the oldest scrolls off the panel.
#define MEMPROFILER_DUMP_HISTORY 20

/datum/memprofiler/proc/run_extension(client/user, kind, datum/callback/report_call)
	var/refusal = unavailable_reason()
	if(refusal)
		last_error = "[kind]: [refusal]"
		return null

	capture_in_progress = TRUE
	last_error = null
	rustg_time_reset("memprofiler")
	var/result
	try
		result = report_call.Invoke()
	catch(var/exception/capture_exception)
		result = null
		last_error = "[kind]: [capture_exception]"
	var/duration = round(rustg_time_milliseconds("memprofiler") / 100, 0.1)
	capture_in_progress = FALSE

	report_meta[kind] = list(
		"captured_at" = time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss"),
		"captured_by" = user?.ckey || "server",
		"duration_ds" = duration,
	)

	if(user)
		message_admins(span_adminnotice("[key_name_admin(user)] ran a memory profiler [kind] ([DisplayTimeText(duration)] of frozen server)."))
		log_admin("[key_name(user)] ran a memory profiler [kind] ([duration]ds).")

	return result
/datum/memprofiler/proc/validate_report(kind, result)
	if(!islist(result))
		last_error ||= "[kind]: the extension returned nothing"
		return null
	var/list/report = result
	if(!report["ok"])
		last_error = "[kind]: [report["error"] || "unknown error"]"
		return null
	last_error = null
	return report

/datum/memprofiler/proc/capture_census(client/user)
	var/list/report = validate_report("census", run_extension(user, "census", CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(memprofile_census_json))))
	if(isnull(report))
		return FALSE
	census = report
	return TRUE

/datum/memprofiler/proc/capture_lists(client/user, rows)
	rows = clamp(text2num(rows) || panel_row_options[2], panel_row_options[1], panel_row_options[length(panel_row_options)])
	var/list/report = validate_report("lists", run_extension(user, "lists", CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(memprofile_lists_json), rows)))
	if(isnull(report))
		return FALSE
	lists_report = report
	return TRUE

/datum/memprofiler/proc/capture_vars(client/user)
	var/list/report = validate_report("vars", run_extension(user, "vars", CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(memprofile_var_histogram_json))))
	if(isnull(report))
		return FALSE
	vars_report = report
	return TRUE

/datum/memprofiler/proc/set_baseline(client/user)
	var/list/report = validate_report("diff", run_extension(user, "diff", CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(memprofile_diff_json))))
	if(isnull(report))
		return FALSE
	baseline_at = time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")
	baseline_by = user ? user.ckey : "server"
	diff_report = null
	return TRUE

/datum/memprofiler/proc/capture_diff(client/user)
	var/list/report = validate_report("diff", run_extension(user, "diff", CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(memprofile_diff_json))))
	if(isnull(report))
		return FALSE
	diff_report = report
	baseline_at = time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")
	baseline_by = user ? user.ckey : "server"
	return TRUE

/datum/memprofiler/proc/capture_compat(client/user)
	var/list/report = validate_report("compat", run_extension(user, "compat", CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(memprofile_byond_compat_json))))
	if(isnull(report))
		return FALSE
	compat_report = report
	return TRUE

/datum/memprofiler/proc/drain_debug(client/user)
	var/refusal = unavailable_reason()
	if(refusal)
		last_error = "debug drain: [refusal]"
		return FALSE
	debug_text = memprofile_debug()
	return TRUE

/datum/memprofiler/proc/clear_state(client/user)
	var/refusal = unavailable_reason()
	if(refusal)
		last_error = "clear: [refusal]"
		return FALSE
	memprofile_clear()
	baseline_at = null
	baseline_by = null
	diff_report = null
	debug_text = null
	last_error = null
	if(user)
		log_admin("[key_name(user)] cleared the memory profiler baseline.")
	return TRUE

/datum/memprofiler/proc/dump_to_file(client/user, kind, rows)
	if(!(kind in list("census", "lists")))
		last_error = "dump: [kind] is not a dumpable report"
		return FALSE
	var/refusal = unavailable_reason()
	if(refusal)
		last_error = "dump: [refusal]"
		return FALSE

	var/timestamp = time2text(world.timeofday, "YYYY-MM-DD_hh-mm-ss")
	var/friendly_name = "memprofile-[kind]-round-[GLOB.round_id || "unknown"]-[timestamp].jsonl"
	var/path = "[GLOB.log_directory]/profiler/[friendly_name]"
	// The extension writes this file itself and will not create the directory on the way,
	// so touch it through rust_g first - that does create_dir_all on the parent.
	rustg_file_write("", path)

	var/list/receipt
	switch(kind)
		if("census")
			receipt = validate_report("census dump", run_extension(user, "census dump", CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(memprofile_census_json), path)))
		if("lists")
			if(rows != "all")
				rows = clamp(text2num(rows) || dump_row_options[1], dump_row_options[1], 100000)
			receipt = validate_report("lists dump", run_extension(user, "lists dump", CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(memprofile_lists_json), rows, path)))

	if(isnull(receipt))
		fdel(path)
		return FALSE

	dumps += list(list(
		"path" = path,
		"name" = friendly_name,
		"kind" = kind,
		"rows" = receipt["rows"],
		"total" = receipt["total"],
		"truncated" = receipt["truncated"],
		// BYOND numbers go fuzzy past 2^24, so a multi-megabyte size here is an estimate.
		// It is a "should you really click download" hint, not an accounting figure.
		"size" = fexists(path) ? num2text(length(file(path)), 16) : "0",
		"at" = time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss"),
	))
	if(length(dumps) > MEMPROFILER_DUMP_HISTORY)
		dumps.Cut(1, length(dumps) - MEMPROFILER_DUMP_HISTORY + 1)

	message_admins(span_adminnotice("[key_name_admin(user)] dumped a memory profiler [kind] to [friendly_name]."))
	return TRUE

/// Hand one of this round's dumps to an admin as a download.
/datum/memprofiler/proc/download_dump(client/user, index)
	index = text2num(index)
	if(!isnum(index) || index < 1 || index > length(dumps))
		return FALSE
	var/list/entry = dumps[index]
	if(!fexists(entry["path"]))
		to_chat(user, span_warning("[entry["name"]] is gone from disk."), type = MESSAGE_TYPE_DEBUG)
		return FALSE
	if(user.file_spam_check())
		return FALSE
	DIRECT_OUTPUT(user, ftp(file(entry["path"]), entry["name"]))
	log_admin("[key_name(user)] downloaded the memory profiler dump [entry["name"]].")
	return TRUE

#undef MEMPROFILER_DUMP_HISTORY
