/client/proc/memory_profiler()
	set category = "Debug"
	set name = "Memory Profiler"
	set desc = "Browse the byond_memprofile heap census: instance counts, list owners, var rows, retained size and round-over-round diffs."

	if(!check_rights(R_DEBUG))
		return

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Memory Profiler")
	MemProfiler.ui_interact(usr)


/client/proc/memory_profile_census()
	set category = "Debug"
	set name = "Memory Census (Text)"
	set desc = "Run a full heap census and print it to chat and world.log. Freezes the server for several seconds."

	if(!check_rights(R_DEBUG))
		return

	if(!MemProfiler.enabled)
		to_chat(src, span_warning("byond_memprofile is unavailable: [MemProfiler.error || "unknown reason"]"), type = MESSAGE_TYPE_DEBUG)
		return

	if(tgui_alert(src, "A census walks the entire heap. The server will freeze for several seconds. Continue?", "Memory Census", list("Run it", "Cancel")) != "Run it")
		return

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Memory Census (Text)")
	var/report = MemProfiler.run_extension(src, "text census", CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(memprofile_census)))
	if(!length(report))
		to_chat(src, span_warning("Memory census returned nothing: [MemProfiler.last_error || "unknown reason"]"), type = MESSAGE_TYPE_DEBUG)
		return

	for(var/line in splittext(report, "\n"))
		SEND_TEXT(world.log, line)

	to_chat(src, fieldset_block("Memory Census", "<pre>[html_encode(report)]</pre>", "boxed_message purple_box"), avoid_highlighting = TRUE, type = MESSAGE_TYPE_DEBUG)


/client/proc/memory_profile_dump()
	set category = "Debug"
	set name = "Memory Profile Dump"
	set desc = "Stream a full census or list table to a JSON Lines file and download it. Freezes the server while it walks and writes."

	if(!check_rights(R_DEBUG))
		return

	if(!MemProfiler.enabled)
		to_chat(src, span_warning("byond_memprofile is unavailable: [MemProfiler.error || "unknown reason"]"), type = MESSAGE_TYPE_DEBUG)
		return

	var/kind = tgui_alert(src, "Dump which report? A census dump is always complete; a list dump is capped unless you pick \"all\".", "Memory Profile Dump", list("Census", "Lists", "Cancel"))
	if(!kind || kind == "Cancel")
		return

	var/rows
	if(kind == "Lists")
		rows = tgui_input_list(src, "How many rows? \"all\" can run to hundreds of megabytes on a live world.", "Memory Profile Dump", MemProfiler.dump_row_options)
		if(isnull(rows))
			return

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Memory Profile Dump")
	if(!MemProfiler.dump_to_file(src, LOWER_TEXT(kind), rows))
		to_chat(src, span_warning("Memory profile dump failed: [MemProfiler.last_error || "unknown reason"]"), type = MESSAGE_TYPE_DEBUG)
		return

	MemProfiler.download_dump(src, length(MemProfiler.dumps))
