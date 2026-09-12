/datum/visual_ui/console
	uniqueID = "quake_console"
	x = "CENTER"
	y = "NORTH"

	display_with_parent = TRUE
	var/console_height = 14 // height in tiles
	var/console_open = FALSE
	var/list/command_history = list()
	var/history_position = 0
	var/current_input = ""
	var/animating = FALSE // Track animation state

	var/list/listeners = list()
	var/list/executors = list()
	var/list/executors_delayed = list()

	element_types_to_spawn = list(
		/obj/abstract/visual_ui_element/console_input,
		/obj/abstract/visual_ui_element/scrollable/console_output
	)

/datum/visual_ui/console/New(datum/mind/M)
	. = ..()
	hide()

/datum/visual_ui/console/proc/toggle(skip_animation = FALSE)
	if(animating)
		return
	if(console_open)
		close_console(skip_animation)
	else
		open_console(skip_animation)

/datum/visual_ui/console/proc/open_console(skip_animation = FALSE)
	if(console_open || animating)
		return

	console_open = TRUE
	active = TRUE // Set UI to active

	display() // Show console elements immediately
	var/obj/abstract/visual_ui_element/console_input/input = locate(/obj/abstract/visual_ui_element/console_input) in elements
	if(input)
		input.focus()

/datum/visual_ui/console/display()
	if(animating)
		return
	. = ..()

/datum/visual_ui/console/proc/close_console(skip_animation = FALSE)
	if(!console_open || animating)
		return

	var/obj/abstract/visual_ui_element/console_input/input = locate(/obj/abstract/visual_ui_element/console_input) in elements
	if(input)
		input.unfocus()

	if(skip_animation)
		console_open = FALSE
		hide()
		return

	animating = TRUE

	var/offscreen_offset = (console_height * 32)

	// Create temporary images for smooth animation
	var/list/animation_images = list()
	var/mob/user = get_user()

	if(user?.client)
		for(var/obj/abstract/visual_ui_element/element in elements)
			var/image/img = image(element.icon, element, element.icon_state, element.layer)
			img.appearance = element.appearance
			#ifndef OPENDREAM
			img.screen_loc = element.screen_loc
			#endif

			img.pixel_y = 0

			user.client.images += img
			animation_images[element] = img

			element.invisibility = INVISIBILITY_ABSTRACT


		for(var/obj/abstract/visual_ui_element/element in animation_images)
			var/image/img = animation_images[element]
			animate(img, pixel_y = offscreen_offset, time = 0.3 SECONDS)

	spawn(0.3 SECONDS)//this is a spawn because of pregame
		finish_close_animation(animation_images)

/datum/visual_ui/console/proc/finish_open_animation(list/animation_images)
	animating = FALSE

	// Reset element positions
	for(var/obj/abstract/visual_ui_element/element in elements)
		element.offset_y = element.initial_offset_y
		element.update_ui_screen_loc()
		element.invisibility = 0

	var/mob/user = get_user()
	if(user?.client)
		for(var/obj/abstract/visual_ui_element/element in animation_images)
			user.client.images -= animation_images[element]

	var/obj/abstract/visual_ui_element/console_input/input = locate(/obj/abstract/visual_ui_element/console_input) in elements
	if(input)
		input.focus()

/datum/visual_ui/console/proc/finish_close_animation(list/animation_images)
	animating = FALSE
	console_open = FALSE

	// Remove animation images
	var/mob/user = get_user()
	if(user?.client)
		for(var/obj/abstract/visual_ui_element/element in animation_images)
			user.client.images -= animation_images[element]

	hide()

/datum/visual_ui/console/proc/submit_command(text)
	if(!text || text == "")
		return

	// Add to history
	command_history.Insert(1, text)
	if(command_history.len > 50) // Limit history length
		command_history.Cut(51)

	history_position = 0
	current_input = ""

	// Process command
	var/obj/abstract/visual_ui_element/scrollable/console_output/output = locate(/obj/abstract/visual_ui_element/scrollable/console_output) in elements
	if(output)
		output.add_line("> [text]")
		process_command(text, output)

	var/obj/abstract/visual_ui_element/console_input/input = locate(/obj/abstract/visual_ui_element/console_input) in elements
	if(input)
		input.set_text("")
		input.focus()

/datum/visual_ui/console/proc/process_command(text, obj/abstract/visual_ui_element/scrollable/console_output/output)
	// Parse the command text respecting quotes
	var/list/arg_list = parse_command_arguments(text)

	if(!length(arg_list))
		return

	var/command = arg_list[1]
	arg_list.Cut(1, 2)
	var/executed = FALSE

	for(var/datum/console_command/listed_command in GLOB.console_commands)
		if(command != listed_command.command_key)
			continue
		if(!listed_command.can_execute(get_user(), arg_list, output))
			continue
		listed_command.execute(output, arg_list)
		if(listed_command.notify_admins)
			var/string = "[get_user()] ran command [listed_command.command_key] with args:"
			string += arg_list.Join(", ")
			log_admin(string)
			message_admins(string)

		executed = TRUE
		break

	if(!executed)
		try_proccall(command, arg_list, output)

/datum/visual_ui/console/proc/parse_command_arguments(text)
	var/list/result = list()
	var/current_arg = ""
	var/in_quotes = FALSE

	for(var/i = 1, i <= length(text), i++)
		var/char = text[i]

		// Handle quote character
		if(char == "\"" && (i == 1 || text[i-1] != "\\"))
			in_quotes = !in_quotes
			continue

		// Handle spaces
		if(char == " " && !in_quotes)
			if(length(current_arg) > 0)
				result += current_arg
				current_arg = ""
			continue

		if(char == "\\" && i < length(text) && text[i+1] == "\"")
			current_arg += "\""
			i++
			continue

		current_arg += char

	// Add the last argument if there is one
	if(length(current_arg) > 0)
		result += current_arg

	return result

/datum/visual_ui/console/proc/try_proccall(procname, list/arg_list, obj/abstract/visual_ui_element/scrollable/console_output/output)
	var/mob/current = get_user()
	if(!current?.client || !check_rights(R_DEBUG, FALSE, current.client))
		output.add_line("Unknown command: [procname]")
		output.add_line("Type 'help' for available commands")
		return

	// Parse named arguments (key=value pairs)
	var/list/named_args = list()
	var/list/positional_args = list()

	for(var/arg in arg_list)
		if(findtext(arg, "="))
			var/list/key_val = splittext(arg, "=")
			if(length(key_val) == 2)
				named_args[key_val[1]] = convert_arg_type(key_val[2], current, current.client.holder?.marked_datum)
		else
			positional_args += convert_arg_type(arg, current, current.client.holder?.marked_datum)

	// Combine positional and named args
	var/list/final_args = positional_args.Copy()
	if(length(named_args))
		final_args += named_args

	// First try on the user's mob or marked datum
	var/mob/user = get_user()
	var/datum/marked_datum = user.client.holder?.marked_datum
	if(marked_datum)
		user = marked_datum
	var/proc_found = FALSE
	var/returnval

	if(hascall(user, procname))
		proc_found = TRUE
		returnval = WrapAdminProcCall(user, procname, final_args)
	else
		// Try global procs
		var/procpath = "/proc/[procname]"
		if(text2path(procpath))
			proc_found = TRUE
			returnval = WrapAdminProcCall(GLOBAL_PROC, procname, final_args)

	if(!proc_found)
		output.add_line("Unknown command or proc: [procname]")
		output.add_line("Type 'help' for available commands")
		return

	// Display return value
	var/return_text = user.client.get_callproc_returnval(returnval, procname)
	if(return_text)
		output.add_line(return_text)
		var/string = "[get_user()] ran proc [procname] with args:"
		for(var/arg in final_args)
			string += arg
		log_admin(string)
		message_admins(string)

/datum/visual_ui/console/proc/convert_arg_type(arg, mob/sender, datum/marked)
	switch(LOWER_TEXT(arg))
		if("src")
			return sender
		if("marked")
			return marked
		if("usr")
			return sender
		if("here")
			return get_turf(sender)
		if("loc")
			return sender?.loc

	if(isnum(arg) || isnum(text2num(arg)))
		return text2num(arg)

	var/path = text2path(arg)
	if(path)
		return path

	switch(LOWER_TEXT(arg))
		if("true", "yes", "on")
			return TRUE
		if("false", "no", "off")
			return FALSE
		if("null")
			return null

	// Check if it's a list (comma-separated)
	if(findtext(arg, ","))
		var/list/result = list()
		for(var/item in splittext(arg, ","))
			result += convert_arg_type(trim(item), sender, marked)
		return result

	// Default to string
	return arg

/datum/visual_ui/console/proc/setup_listen(signal, datum/listener)
	var/datum/weakref/ref = WEAKREF(listener)
	var/list/listened = list()
	var/obj/abstract/visual_ui_element/scrollable/console_output/output = locate(/obj/abstract/visual_ui_element/scrollable/console_output) in elements
	if(ref in listeners)
		listened = listeners[ref]
	if(signal in listened)
		UnregisterSignal(listener, signal)
		listeners[ref] -= signal
		output.add_line("Unregistered [signal] from [listener]")
		return
	listeners |= ref
	if(!length(listeners[ref]))
		listeners[ref] = list()
	listeners[ref] |= signal
	RegisterSignal(listener, signal, PROC_REF(output_data))
	output.add_line("Registed [signal] to [listener]")


/datum/visual_ui/console/proc/setup_execute(signal, datum/listener, list/arg_check)
	var/datum/weakref/ref = WEAKREF(listener)
	var/obj/abstract/visual_ui_element/scrollable/console_output/output = locate(/obj/abstract/visual_ui_element/scrollable/console_output) in elements
	var/list/listened = list()
	if(ref in executors)
		listened = executors[ref]
	if(signal in executors)
		UnregisterSignal(executors, signal)
		listened[ref] -= signal
		output.add_line("Unregistered [signal] from [listener]")
		return

	var/proc_protocall = arg_check[1]
	var/proc_found = FALSE
	if(hascall(listener, proc_protocall))
		proc_found = TRUE
	else
		// Try global procs
		var/procpath = "/proc/[proc_protocall]"
		if(text2path(procpath))
			proc_found = TRUE

	if(!proc_found)
		return

	executors |= ref
	if(!length(executors[ref]))
		executors[ref] = list()
	executors[ref] |= signal
	executors[ref][signal] = arg_check

	RegisterSignal(listener, signal, PROC_REF(trigger_proc))
	output.add_line("Registed [signal] to [listener] for proc [proc_protocall]")


/datum/visual_ui/console/proc/setup_execute_delayed(signal, datum/listener, list/arg_check)
	var/datum/weakref/ref = WEAKREF(listener)
	var/obj/abstract/visual_ui_element/scrollable/console_output/output = locate(/obj/abstract/visual_ui_element/scrollable/console_output) in elements
	var/list/listened = list()
	if(ref in executors_delayed)
		listened = executors_delayed[ref]
	if(signal in executors_delayed)
		UnregisterSignal(executors, signal)
		listened[ref] -= signal
		output.add_line("Unregistered [signal] from [listener]")
		return

	var/proc_protocall = arg_check[2]
	var/proc_found = FALSE
	if(hascall(listener, proc_protocall))
		proc_found = TRUE
	else
		// Try global procs
		var/procpath = "/proc/[proc_protocall]"
		if(text2path(procpath))
			proc_found = TRUE

	if(!proc_found)
		return

	executors_delayed |= ref
	if(!length(executors_delayed[ref]))
		executors_delayed[ref] = list()
	executors_delayed[ref] |= signal
	executors_delayed[ref][signal] = arg_check

	RegisterSignal(listener, signal, PROC_REF(trigger_proc_delayed))
	output.add_line("Registed [signal] to [listener] for proc [proc_protocall]")

/datum/visual_ui/console/proc/output_data(datum/source, ...)
	var/list/arguments = args.Copy(2, 0)
	var/obj/abstract/visual_ui_element/scrollable/console_output/output = locate(/obj/abstract/visual_ui_element/scrollable/console_output) in elements
	output.add_line("[source] triggered listen:")
	for(var/argument in arguments)
		if(islist(argument))
			var/list/list = argument
			output.add_line("  list(")
			for(var/thing in list)
				output.add_line("     [thing]")
			output.add_line("  )")
		else
			output.add_line("  [argument]")

/datum/visual_ui/console/proc/trigger_proc(datum/source, ...)
	var/sigtype = args[length(args)]
	var/mob/current = get_user()

	var/datum/weakref/ref = WEAKREF(source)
	var/list/registered = executors[ref]

	var/list/pre_parsed_args = registered[sigtype]

	var/procname = pre_parsed_args[1]
	pre_parsed_args -= procname

	// Parse named arguments (key=value pairs)
	var/list/named_args = list()
	var/list/positional_args = list()

	for(var/arg in pre_parsed_args)
		if(findtext(arg, "="))
			var/list/key_val = splittext(arg, "=")
			if(length(key_val) == 2)
				named_args[key_val[1]] = convert_arg_type(key_val[2], current, current.client.holder?.marked_datum)
		else
			positional_args += convert_arg_type(arg, current, current.client.holder?.marked_datum)

	// Combine positional and named args
	var/list/final_args = positional_args.Copy()
	if(length(named_args))
		final_args += named_args

	var/obj/abstract/visual_ui_element/scrollable/console_output/output = locate(/obj/abstract/visual_ui_element/scrollable/console_output) in elements
	var/returnval

	if(hascall(source, procname))
		returnval = WrapAdminProcCall(current, procname, final_args)
	else
		// Try global procs
		var/procpath = "/proc/[procname]"
		if(text2path(procpath))
			returnval = WrapAdminProcCall(GLOBAL_PROC, procname, final_args)

	// Display return value
	var/return_text = current.client.get_callproc_returnval(returnval, procname)
	if(return_text)
		output.add_line(return_text)


/datum/visual_ui/console/proc/trigger_proc_delayed(datum/source, ...)
	var/sigtype = args[length(args)]

	var/datum/weakref/ref = WEAKREF(source)
	var/list/registered = executors_delayed[ref]

	var/list/pre_parsed_args = registered[sigtype]

	var/procname = pre_parsed_args[2]
	var/timer = pre_parsed_args[1]
	pre_parsed_args -= procname
	pre_parsed_args -= timer

	addtimer(CALLBACK(src, PROC_REF(execute_delay),source ,procname, pre_parsed_args), text2num(timer) SECONDS)
	var/obj/abstract/visual_ui_element/scrollable/console_output/output = locate(/obj/abstract/visual_ui_element/scrollable/console_output) in elements
	output.add_line("[source] triggering [procname] in [timer] Seconds")

/datum/visual_ui/console/proc/execute_delay(datum/source, procname, list/pre_parsed_args)
	var/mob/current = get_user()
	// Parse named arguments (key=value pairs)
	var/list/named_args = list()
	var/list/positional_args = list()

	for(var/arg in pre_parsed_args)
		if(findtext(arg, "="))
			var/list/key_val = splittext(arg, "=")
			if(length(key_val) == 2)
				named_args[key_val[1]] = convert_arg_type(key_val[2], current, current.client.holder?.marked_datum)
		else
			positional_args += convert_arg_type(arg, current, current.client.holder?.marked_datum)

	// Combine positional and named args
	var/list/final_args = positional_args.Copy()
	if(length(named_args))
		final_args += named_args

	var/obj/abstract/visual_ui_element/scrollable/console_output/output = locate(/obj/abstract/visual_ui_element/scrollable/console_output) in elements
	var/returnval

	if(hascall(source, procname))
		returnval = WrapAdminProcCall(current, procname, final_args)
	else
		// Try global procs
		var/procpath = "/proc/[procname]"
		if(text2path(procpath))
			returnval = WrapAdminProcCall(GLOBAL_PROC, procname, final_args)

	// Display return value
	var/return_text = current.client.get_callproc_returnval(returnval, procname)
	if(return_text)
		output.add_line(return_text)
