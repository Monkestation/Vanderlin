GLOBAL_VAR_INIT(total_runtimes, GLOB.total_runtimes || 0)
GLOBAL_VAR_INIT(total_runtimes_skipped, 0)

#ifdef USE_CUSTOM_ERROR_HANDLER
#define ERROR_USEFUL_LEN 2

/world/Error(exception/E, datum/e_src)
	GLOB.total_runtimes++

	if(!istype(E)) //Something threw an unusual exception
		log_world("uncaught runtime error: [E]")
		return ..()

	//this is snowflake because of a byond bug (ID:2306577)
	// do not attempt to call non-builtin procs in this block OR BEFORE IT
	if(copytext(E.name, 1, 32) == "Maximum recursion level reached")//32 == length() of that string + 1
		var/list/proc_path_to_count = list()
		var/crashed = FALSE
		try
			var/callee/stack_entry = caller
			while(!isnull(stack_entry))
				proc_path_to_count[stack_entry.proc] += 1
				stack_entry = stack_entry.caller
		catch
			//union job. avoids crashing the stack again
			//I just do not trust this construct to work reliably
			crashed = TRUE

		var/list/split = splittext(E.desc, "\n")
		for (var/i in 1 to split.len)
			if (split[i] != "" || copytext(split[1], 1, 2) != "  ")
				split[i] = "  [split[i]]"
		split += "--Stack Info [crashed ? "(Crashed, may be missing info)" : ""]:"
		for(var/path in proc_path_to_count)
			split += "  [path] = [proc_path_to_count[path]]"
		E.desc = jointext(split, "\n")
		SEND_TEXT(world.log, "\[[time2text(world.timeofday,"hh:mm:ss")]\] Runtime Error: [E.name]\n[E.desc]")
		//log to world while intentionally triggering the byond bug. this does not DO anything, it just errors
		//(seemingly because of the extra proc call to logger inside log_world interestingly enough)
		log_world("runtime error: [E.name]\n[E.desc]")
		//if we got to here without silently ending, the byond bug has been fixed.
		log_world("The \"bug\" with recursion runtimes has been fixed. Please remove the snowflake check from world/Error in [__FILE__]:[__LINE__]")
		return //this will never happen.

	// Proc calls are allowed past this point
	else if(copytext(E.name, 1, 18) == "Out of resources!")//18 == length() of that string + 1
		log_world("BYOND out of memory. Restarting ([E?.file]:[E?.line])")
		TgsEndProcess()
		. = ..()
		Reboot(reason = 1)
		return

	if (islist(stack_trace_storage))
		for (var/line in splittext(E.desc, "\n"))
			if (text2ascii(line) != 32)
				stack_trace_storage += line

	var/static/list/error_last_seen = list()
	var/static/list/error_cooldown = list() /* Error_cooldown items will either be positive(cooldown time) or negative(silenced error)
												If negative, starts at -1, and goes down by 1 each time that error gets skipped*/

	if(!error_last_seen) // A runtime is occurring too early in start-up initialization
		return ..()

	var/erroruid = "[E.file][E.line]"
	var/last_seen = error_last_seen[erroruid]
	var/cooldown = error_cooldown[erroruid] || 0

	if(last_seen == null)
		error_last_seen[erroruid] = world.time
		last_seen = world.time

	if(cooldown < 0)
		error_cooldown[erroruid]-- //Used to keep track of skip count for this error
		GLOB.total_runtimes_skipped++
		return //Error is currently silenced, skip handling it
	//Handle cooldowns and silencing spammy errors
	var/silencing = FALSE

	// We can runtime before config is initialized because BYOND initialize objs/map before a bunch of other stuff happens.
	// This is a bunch of workaround code for that. Hooray!
	var/configured_error_cooldown
	var/configured_error_limit
	var/configured_error_silence_time
	if(config && config.entries)
		configured_error_cooldown = CONFIG_GET(number/error_cooldown)
		configured_error_limit = CONFIG_GET(number/error_limit)
		configured_error_silence_time = CONFIG_GET(number/error_silence_time)
	else
		var/datum/config_entry/CE = /datum/config_entry/number/error_cooldown
		configured_error_cooldown = initial(CE.config_entry_value)
		CE = /datum/config_entry/number/error_limit
		configured_error_limit = initial(CE.config_entry_value)
		CE = /datum/config_entry/number/error_silence_time
		configured_error_silence_time = initial(CE.config_entry_value)


	//Each occurence of a unique error adds to its cooldown time...
	cooldown = max(0, cooldown - (world.time - last_seen)) + configured_error_cooldown
	// ... which is used to silence an error if it occurs too often, too fast
	if(cooldown > configured_error_cooldown * configured_error_limit)
		cooldown = -1
		silencing = TRUE
		spawn(0)
			usr = null
			sleep(configured_error_silence_time)
			var/skipcount = abs(error_cooldown[erroruid]) - 1
			error_cooldown[erroruid] = 0
			if(skipcount > 0)
				SEND_TEXT(world.log, "\[[time_stamp()]] Skipped [skipcount] runtimes in [E.file],[E.line].")
				GLOB.error_cache.log_error(E, skip_count = skipcount)

	error_last_seen[erroruid] = world.time
	error_cooldown[erroruid] = cooldown

	var/list/usrinfo = null
	var/locinfo
	if(istype(usr))
		usrinfo = list("  usr: [key_name(usr)]")
		locinfo = loc_name(usr)
		if(locinfo)
			usrinfo += "  usr.loc: [locinfo]"
	// The proceeding mess will almost definitely break if error messages are ever changed
	var/list/splitlines = splittext(E.desc, "\n")
	var/list/desclines = list()
	if(LAZYLEN(splitlines) > ERROR_USEFUL_LEN) // If there aren't at least three lines, there's no info
		for(var/line in splitlines)
			if(LAZYLEN(line) < 3 || findtext(line, "source file:") || findtext(line, "usr.loc:"))
				continue
			if(findtext(line, "usr:"))
				if(usrinfo)
					desclines.Add(usrinfo)
					usrinfo = null
				continue // Our usr info is better, replace it

			if(copytext(line, 1, 3) != "  ")
				desclines += ("  " + line) // Pad any unpadded lines, so they look pretty
			else
				desclines += line
	if(usrinfo) //If this info isn't null, it hasn't been added yet
		desclines.Add(usrinfo)
	if(silencing)
		desclines += "  (This error will now be silenced for [DisplayTimeText(configured_error_silence_time)])"
	if(GLOB.error_cache)
		GLOB.error_cache.log_error(E, desclines)

	var/main_line = "\[[time_stamp()]\] Runtime in [E.file],[E.line]: [E]"
	#ifdef LOWMEMORYMODE
		to_chat(world, span_danger(main_line))
	#endif
	SEND_TEXT(world.log, main_line)
	for(var/line in desclines)
		SEND_TEXT(world.log, line)

#ifdef UNIT_TESTS
	if(GLOB.current_test)
		//good day, sir
		GLOB.current_test.Fail("[main_line]\n[desclines.Join("\n")]")
#endif


	// This writes the regular format (unwrapping newlines and inserting timestamps as needed).
	log_runtime("runtime error: [E.name]\n[E.desc]")
	var/list/extra_data = list()
	if(locinfo)
		extra_data["user_location"] = locinfo

	send_to_glitchtip(E, extra_data)
#endif

#undef ERROR_USEFUL_LEN


/datum/config_entry/string/glitchtip_dsn
	config_entry_value = ""

/datum/config_entry/string/glitchtip_environment
	config_entry_value = "production"

/proc/generate_simple_uuid()
	var/uuid = ""
	for(var/i = 1 to 32)
		uuid += pick("0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f")
		if(i == 8 || i == 12 || i == 16 || i == 20)
			uuid += "-"
	return uuid

/proc/send_to_glitchtip(exception/E, list/extra_data = null)
	#ifndef SPACEMAN_DMM
	#ifndef OPENDREAM
	if(!CONFIG_GET(string/glitchtip_dsn))
		return
	var/glitchtip_dsn = CONFIG_GET(string/glitchtip_dsn)
	//! Parse DSN to extract components
	//! Format: https://key@host/project_id
	var/dsn_clean = replacetext(glitchtip_dsn, "https://", "")
	var/at_pos = findtext(dsn_clean, "@")
	var/slash_pos = findtext(dsn_clean, "/", at_pos)
	if(!at_pos || !slash_pos)
		log_runtime("Invalid Glitchtip DSN format")
		return
	var/key = copytext(dsn_clean, 1, at_pos)
	var/host = copytext(dsn_clean, at_pos + 1, slash_pos)
	var/project_id = copytext(dsn_clean, slash_pos + 1)

	// Build Glitchtip/Sentry event payload
	var/list/event_data = list()
	event_data["event_id"] = generate_simple_uuid()
	event_data["timestamp"] = time_stamp_metric()
	event_data["level"] = "error"
	event_data["platform"] = "other"
	event_data["server_name"] = world.name
	event_data["environment"] = CONFIG_GET(string/glitchtip_environment)

	//! SDK information
	event_data["sdk"] = list(
		"name" = "byond-glitchtip",
		"version" = "1.0.0"
	)

	//! Exception data - Glitchtip expects this format
	var/list/exception_data = list()
	exception_data["type"] = "BYOND Runtime Error"
	exception_data["value"] = E.name
	exception_data["module"] = E.file

	// Build stack trace using caller/callee chain
	var/list/frames = list()

	// Add the error location as the first frame
	var/list/error_frame = list()
	error_frame["filename"] = E.file || "unknown"
	error_frame["lineno"] = E.line || 0
	error_frame["function"] = "runtime_error"
	error_frame["in_app"] = TRUE
	frames += list(error_frame)

	// Walk the call stack using callee objects
	var/frame_count = 0
	var/max_frames = 50 // Prevent infinite loops or excessive data
	for(var/callee/p = caller; p && frame_count < max_frames; p = p.caller)
		frame_count++
		var/proc_name = "unknown"
		var/file_name = "unknown"
		var/line_num = 0

		if(p.proc)
			proc_name = "[p.proc.type]"
			// Clean up the proc name if it has path separators
			var/slash_pos_inner = findtext(proc_name, "/", -1)
			if(slash_pos_inner && slash_pos_inner < length(proc_name))
				proc_name = copytext(proc_name, slash_pos_inner + 1)

		// Get file and line information if available
		if(p.file)
			file_name = p.file
			line_num = p.line || 0

		if(findtext(file_name, "master.dm") && (proc_name == "Loop" || proc_name == "StartProcessing"))
			break

		var/list/frame = list()
		frame["filename"] = file_name
		frame["lineno"] = line_num
		frame["function"] = proc_name
		frame["in_app"] = TRUE

		// Collect all available variables for this frame
		var/list/frame_vars = list()

		// Add context variables
		if(p.src)
			frame_vars["src"] = "[p.src]"
		if(p.usr)
			frame_vars["usr"] = "[p.usr]"

		// Add procedure arguments
		if(length(p.args))
			for(var/i = 1; i <= length(p.args); i++)
				var/datum/arg_value = p.args[i]
				var/arg_string = "null"

				// Not so sanely convert argument to string representation
				try
					if(arg_value == null)
						arg_string = "null"
					else if(isnum(arg_value))
						arg_string = "[arg_value]"
					else if(istext(arg_value))
						// URL decode if it looks like URL-encoded data
						var/decoded_value = arg_value
						if(findtext(arg_value, "%") || findtext(arg_value, "&") || findtext(arg_value, "="))
							decoded_value = url_decode(arg_value)

						if(length(decoded_value) > 200)
							arg_string = "\"[copytext(decoded_value, 1, 198)]...\""
						else
							arg_string = "\"[decoded_value]\""
					else if(islist(arg_value))
						// Handle lists by showing summary and contents
						var/list/L = arg_value
						if(length(L) == 0)
							arg_string = "list(empty)"
						else
							arg_string = "list([length(L)] items)"

							// Build contents string
							var/list/content_items = list()
							var/max_list_items = 20 // Prevent too long contents
							var/items_to_show = min(length(L), max_list_items)

							for(var/j = 1; j <= items_to_show; j++)
								var/datum/item = L[j]
								var/item_string = "null"

								try
									if(item == null)
										item_string = "null"
									else if(isnum(item))
										item_string = "[item]"
									else if(istext(item))
										// URL decode as a treat
										var/decoded_item = item
										if(findtext(item, "%") || findtext(item, "&") || findtext(item, "="))
											decoded_item = url_decode(item)

										if(length(decoded_item) > 50)
											item_string = "\"[copytext(decoded_item, 1, 48)]...\""
										else
											item_string = "\"[decoded_item]\""
									else if(istype(item))
										var/item_type_name = "[item.type]"
										var/slash_pos_item = findtext(item_type_name, "/", -1)
										if(slash_pos_item && slash_pos_item < length(item_type_name))
											item_type_name = copytext(item_type_name, slash_pos_item + 1)
										item_string = "[item_type_name]([item])"
									else
										item_string = "[item]"
								catch
									item_string = "<error>"

								content_items += item_string

							var/contents_string = jointext(content_items, ", ")
							if(length(L) > max_list_items)
								contents_string += ", ... and [length(L) - max_list_items] more"

							frame_vars["arg[i]_contents"] = contents_string
					else if(istype(arg_value))
						var/type_name = "[arg_value.type]"
						var/slash_pos_obj = findtext(type_name, "/", -1)
						if(slash_pos_obj && slash_pos_obj < length(type_name))
							type_name = copytext(type_name, slash_pos_obj + 1)
						arg_string = "[type_name]: [arg_value]"
					else
						arg_string = "[arg_value]"
				catch
					arg_string = "<error converting arg>"

				frame_vars["arg[i]"] = arg_string

		if(length(frame_vars))
			frame["vars"] = frame_vars

		frames += list(frame)

	exception_data["stacktrace"] = list("frames" = frames)
	event_data["exception"] = list("values" = list(exception_data))

	// User context
	if(istype(usr))
		var/list/user_data = list()
		user_data["id"] = usr.key
		user_data["username"] = usr.name
		if(usr.client)
			user_data["ip_address"] = usr.client.address
		event_data["user"] = user_data

	if(extra_data)
		event_data["extra"] = extra_data

	// Tags for filtering in Glitchtip
	event_data["tags"] = list(
		"server" = world.name,
		"file" = E.file,
		"line" = "[E.line]",
		"byond_version" = world.byond_version
	)

	event_data["fingerprint"] = list("[E.file]:[E.line]", E.name)

	send_glitchtip_request(event_data, host, project_id, key)
	#endif
	#endif

/proc/send_glitchtip_request(list/event_data, host, project_id, key)
	var/glitchtip_url = "https://[host]/api/[project_id]/store/"
	var/json_payload = json_encode(event_data)

	//! Glitchtip/Sentry auth header - According to docs this needs to be like this
	var/auth_header = "Sentry sentry_version=7, sentry_client=byond-glitchtip/1.0.0, sentry_key=[key], sentry_timestamp=[time_stamp_metric()]"

	var/datum/http_request/request = new()
	request.prepare(RUSTG_HTTP_METHOD_POST, glitchtip_url, json_payload, list(
		"X-Sentry-Auth" = auth_header,
		"Content-Type" = "application/json",
		"User-Agent" = "byond-glitchtip/1.0.0"
	))
	request.begin_async()
