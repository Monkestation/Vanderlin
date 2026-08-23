GLOBAL_REAL(MemProfiler, /datum/memprofiler)

/datum/memprofiler
	/// Did byond_memprofile load and resolve every byondcore address?
	VAR_FINAL/enabled = FALSE
	/// Why enable() gave up, if it did.
	VAR_FINAL/error
	/// Set while a heap walk is running. A walk blocks the whole server, but the text
	/// verbs sleep on a tgui_alert first, so two admins really can race for one.
	VAR_FINAL/capture_in_progress = FALSE
	/// Why the last capture failed, shown in the panel until the next one succeeds.
	VAR_FINAL/last_error

	/// Decoded coverage report, fetched once at enable(). Says which byondcore tables
	/// this build could actually scan - if "complete" is FALSE, every total is short.
	VAR_FINAL/list/coverage
	/// Decoded base-size legend, fetched once at enable(). What the crate charges for a
	/// row of each kind, read off its own constants rather than retyped here - the
	/// client entry alone is build-dependent, so a copy would be wrong on some builds.
	VAR_FINAL/list/base_sizes

	/// Last decoded memprofile_census_json() result.
	VAR_FINAL/list/census
	/// Last decoded memprofile_lists_json() result.
	VAR_FINAL/list/lists_report
	/// Last decoded memprofile_var_histogram_json() result.
	VAR_FINAL/list/vars_report
	/// Last decoded memprofile_diff_json() result.
	VAR_FINAL/list/diff_report
	/// Last decoded memprofile_byond_compat_json() result.
	VAR_FINAL/list/compat_report
	/// Last drained extension debug buffer.
	VAR_FINAL/debug_text

	/// Per-report metadata (who, when, how long), keyed by report kind.
	VAR_FINAL/list/report_meta
	/// Files written this round, newest last.
	VAR_FINAL/list/dumps

	/// When the crate's diff baseline was recorded, or null if there isn't one.
	VAR_FINAL/baseline_at
	/// Who recorded it.
	VAR_FINAL/baseline_by

	/// Row counts offered for the in-panel list table. Bigger than this and the tgui
	/// payload chokes the browser long before the extension complains.
	VAR_FINAL/list/panel_row_options = list(100, 500, 2000)
	/// Row counts offered when dumping lists to a file. "all" is only legal with a path.
	VAR_FINAL/list/dump_row_options = list(500, 5000, 25000, "all")

/datum/memprofiler/New()
	if(!isnull(MemProfiler))
		CRASH("Attempted to initialize /datum/memprofiler when global.MemProfiler is already set!")
	MemProfiler = src
	report_meta = list()
	dumps = list()
	base_sizes = list()
	enable()

/datum/memprofiler/proc/enable()
#ifndef OPENDREAM_REAL
	if(enabled)
		return TRUE
	if(!fexists(MEMPROFILE_DLL))
		error = "[MEMPROFILE_DLL] not found"
		SEND_TEXT(world.log, "Error initializing byond_memprofile: [error]")
		return FALSE

	var/init_result
	try
		init_result = memprofile_init()
	catch(var/exception/init_exception)
		error = "[init_exception]"
		SEND_TEXT(world.log, "Error initializing byond_memprofile: [error]")
		return FALSE

	if(length(init_result))
		error = init_result
		SEND_TEXT(world.log, "Error initializing byond_memprofile: [error]")
		return FALSE

	enabled = TRUE
	coverage = memprofile_coverage()
	var/list/legend = memprofile_base_sizes()
	base_sizes = legend?["ok"] ? legend["sizes"] : list()
	SEND_TEXT(world.log, "byond_memprofile initialized[islist(coverage) ? " (build [coverage["build"]])" : ""]")
	return TRUE
#else
	error = "OpenDream is not supported - byond_memprofile reads byondcore symbols"
	return FALSE
#endif

/datum/memprofiler/proc/unavailable_reason()
	if(!enabled)
		return error || "byond_memprofile is not initialized"
	if(capture_in_progress)
		return "a heap walk is already running"
	return null

/datum/memprofiler/vv_edit_var(var_name, var_value)
	return FALSE // no.

/datum/memprofiler/CanProcCall(procname)
	return FALSE // double no.
