/obj/abstract/visual_ui_element/console_input
	name = "Console Input"
	icon = 'icons/visual_ui/quake_console.dmi'
	icon_state = "quake_input"
	layer = VISUAL_UI_BUTTON
	mouse_opacity = 1
	offset_x = -190
	offset_y = -215

	///modifiers
	var/shift_down = FALSE
	var/ctrl_down = FALSE
	var/alt_down = FALSE

	var/input_text = ""
	var/cursor_position = 0
	var/cursor_visible = TRUE
	var/cursor_blink_timer
	var/focused = FALSE  // Whether this console is currently focused

	/// List of available base commands for tab completion
	var/list/base_commands = list()
	/// List of secondary arguments for the current command
	var/list/secondary_args = list()
	/// List of tertiary arguments for the current command and subcommand
	var/list/tertiary_args = list()
	/// Current tab completion suggestions
	var/list/completion_suggestions = list()
	/// Current position in the tab completion suggestions
	var/completion_index = 0
	/// Stored text before tab completion
	var/pre_completion_text = ""
	/// Whether a prediction is currently shown
	var/showing_prediction = FALSE
	/// Current prediction text
	var/prediction_text = ""

/obj/abstract/visual_ui_element/console_input/New(turf/loc, datum/visual_ui/P)
	. = ..()
	update_ui_screen_loc()
	cursor_blink_timer = addtimer(CALLBACK(src, PROC_REF(blink_cursor)), 5, TIMER_STOPPABLE|TIMER_LOOP) ///I'm really NGMI
	initialize_commands()


/obj/abstract/visual_ui_element/console_input/proc/initialize_commands()
	base_commands = list()
	for(var/datum/console_command/command in GLOB.console_commands)
		base_commands += command.command_key

/obj/abstract/visual_ui_element/console_input/proc/get_secondary_args(command_key)
	var/datum/console_command/found_command
	for(var/datum/console_command/command in GLOB.console_commands)
		if(command.command_key == command_key)
			found_command = command
			break

	if(!found_command)
		return list()

	if(istype(found_command) && found_command.get_secondary_args(get_user()))
		return found_command.get_secondary_args(get_user())

	return list()

/obj/abstract/visual_ui_element/console_input/proc/get_tertiary_args(command_key, secondary_arg)
	var/datum/console_command/found_command
	for(var/datum/console_command/command in GLOB.console_commands)
		if(command.command_key == command_key)
			found_command = command
			break

	if(!found_command)
		return list()

	if(istype(found_command) && found_command.get_tertiary_args(secondary_arg))
		return found_command.get_tertiary_args(secondary_arg)

	return list()

/obj/abstract/visual_ui_element/console_input/proc/blink_cursor()
	cursor_visible = !cursor_visible
	UpdateIcon()

/obj/abstract/visual_ui_element/console_input/UpdateIcon(appear = FALSE)
	cut_overlays()
	var/display_text = input_text

	var/full_display = display_text
	if(showing_prediction && prediction_text && cursor_position == length(input_text))
		full_display = display_text + "<span style='color:#006600;'>[prediction_text]</span>"

	if(cursor_visible && focused)  // Only show cursor when focused
		if(cursor_position >= length(input_text))
			display_text = display_text + "_"
			if(showing_prediction && prediction_text)
				display_text = display_text + "<span style='color:#006600;'>[prediction_text]</span>"
		else
			display_text = copytext(display_text, 1, cursor_position + 1) + "_" + copytext(display_text, cursor_position + 1)
	else
		display_text = full_display

	// Input text
	var/image/text_image = image(icon = null)
	text_image.maptext = MAPTEXT_VATICANUS("<span style='color:#00FF00'>>[display_text]</span>")
	text_image.maptext_width = 380
	text_image.maptext_height = 32
	text_image.maptext_x = 8
	text_image.maptext_y = 8
	add_overlay(text_image)

/obj/abstract/visual_ui_element/console_input/proc/set_text(new_text)
	input_text = new_text
	cursor_position = length(input_text)
	reset_completion()
	update_prediction()
	UpdateIcon()

/obj/abstract/visual_ui_element/console_input/proc/focus()
	// Get all console inputs and unfocus them first
	var/mob/user = get_user()
	if(user)
		for(var/obj/abstract/visual_ui_element/console_input/other_input in user.client?.screen)
			if(other_input != src)
				other_input.unfocus()

	focused = TRUE
	UpdateIcon()
	if(user)
		user.focus = src

	if(user?.client)
		user.client.set_macros(TRUE, TRUE)

/obj/abstract/visual_ui_element/console_input/proc/unfocus()
	focused = FALSE
	UpdateIcon()
	shift_down = FALSE
	ctrl_down = FALSE
	alt_down = FALSE
	var/mob/user_mob = get_user()
	if(!user_mob)
		return
	user_mob.focus = user_mob
	if(user_mob.client)
		user_mob.client.set_macros(skip_macro_mode = TRUE)

/obj/abstract/visual_ui_element/console_input/Click(location, control, params)
	focus()
	return TRUE

/obj/abstract/visual_ui_element/console_input/proc/handle_tab_completion()
	if(!focused || !length(input_text))
		return FALSE

	if(completion_index == 0)
		pre_completion_text = input_text

	var/list/matches = list()

	// Parse input with quote awareness
	var/list/input_parts = parse_quoted_arguments(input_text)
	var/parts_count = length(input_parts)

	var/ends_with_space = (length(input_text) > 0 && input_text[length(input_text)] == " ")

	if(parts_count == 1 && !ends_with_space)
		var/current_word = input_parts[1]
		for(var/command in base_commands)
			if(findtext(command, current_word, 1, length(current_word) + 1) == 1)
				matches += command
	else if((parts_count == 1 && ends_with_space) || (parts_count == 2 && !ends_with_space))
		var/base_command = input_parts[1]
		var/current_word = ""
		if(parts_count == 2)
			current_word = input_parts[2]

		var/list/possible_args = get_secondary_args(base_command)
		for(var/arg in possible_args)
			if(findtext(arg, current_word, 1, length(current_word) + 1) == 1)
				matches += arg
	else if((parts_count == 2 && ends_with_space) || (parts_count == 3 && !ends_with_space))
		var/base_command = input_parts[1]
		var/secondary_arg = input_parts[2]
		var/current_word = ""
		if(parts_count == 3)
			current_word = input_parts[3]

		var/list/possible_args = get_tertiary_args(base_command, secondary_arg)
		for(var/arg in possible_args)
			if(findtext(arg, current_word, 1, length(current_word) + 1) == 1)
				matches += arg
	else if(parts_count > 3)
		var/base_command = input_parts[1]
		var/secondary_arg = input_parts[2]
		var/current_word = input_parts[3]

		var/list/possible_args = get_tertiary_args(base_command, secondary_arg)
		for(var/arg in possible_args)
			if(findtext(arg, current_word, 1, length(current_word) + 1) == 1)
				matches += arg

	if(!length(matches))
		return FALSE

	if(!length(completion_suggestions) || !comparison_list(completion_suggestions, matches))
		completion_suggestions = matches
		completion_index = 1
	else
		completion_index = (completion_index % length(completion_suggestions)) + 1

	// Apply the completion, preserving quotes where needed
	var/new_text = apply_completion_with_quotes(input_parts, completion_suggestions[completion_index], ends_with_space)

	input_text = new_text
	cursor_position = length(input_text)

	showing_prediction = FALSE
	prediction_text = ""

	UpdateIcon()
	update_prediction()

	return TRUE

/obj/abstract/visual_ui_element/console_input/proc/apply_completion_with_quotes(list/input_parts, completion, ends_with_space)
	var/new_text = ""
	// Check if we need to quote the completion (if it contains spaces)
	var/needs_quotes = findtext(completion, " ") > 0

	if(length(input_parts) == 1 && !ends_with_space)
		// Completing the command
		new_text = completion
	else if(length(input_parts) == 1 && ends_with_space)
		// Adding second argument
		new_text = input_parts[1] + " "
		if(needs_quotes)
			new_text += "\"" + completion + "\""
		else
			new_text += completion
	else if(length(input_parts) == 2 && !ends_with_space)
		// Completing second argument
		new_text = input_parts[1] + " "
		if(needs_quotes)
			new_text += "\"" + completion + "\""
		else
			new_text += completion
	else if(length(input_parts) == 2 && ends_with_space)
		// Adding third argument
		new_text = input_parts[1] + " " + input_parts[2] + " "
		if(needs_quotes)
			new_text += "\"" + completion + "\""
		else
			new_text += completion
	else if(length(input_parts) >= 3)
		// Handle more complex cases
		new_text = input_parts[1] + " " + input_parts[2] + " "

		if(needs_quotes)
			new_text += "\"" + completion + "\""
		else
			new_text += completion

		if(length(input_parts) > 3)
			for(var/i = 4, i <= length(input_parts), i++)
				new_text += " " + input_parts[i]

	return new_text

/obj/abstract/visual_ui_element/console_input/proc/parse_quoted_arguments(text)
	var/list/result = list()
	var/current_arg = ""
	var/in_quotes = FALSE

	for(var/i = 1, i <= length(text), i++)
		var/char = text[i]

		if(char == "\"" && (i == 1 || text[i-1] != "\\"))
			in_quotes = !in_quotes
			continue

		if(char == " " && !in_quotes)
			if(length(current_arg) > 0)
				result += current_arg
				current_arg = ""
			continue

		current_arg += char

	if(length(current_arg) > 0)
		result += current_arg

	return result

/obj/abstract/visual_ui_element/console_input/proc/reset_completion()
	completion_suggestions = list()
	completion_index = 0
	pre_completion_text = ""

/obj/abstract/visual_ui_element/console_input/proc/update_prediction()
	// Reset prediction
	showing_prediction = FALSE
	prediction_text = ""

	if(cursor_position != length(input_text) || !length(input_text))
		return

	// Parse input with quote awareness
	var/list/input_parts = parse_quoted_arguments(input_text)
	var/parts_count = length(input_parts)

	if(parts_count == 1)
		// Predict base command
		var/current_word = input_parts[1]
		for(var/command in base_commands)
			if(findtext(command, current_word, 1, length(current_word) + 1) == 1 && command != current_word)
				prediction_text = copytext(command, length(current_word) + 1)
				showing_prediction = TRUE
				break
	else if(parts_count == 2)
		var/base_command = input_parts[1]
		var/current_word = input_parts[2]

		var/list/possible_args = get_secondary_args(base_command)
		for(var/arg in possible_args)
			if(findtext(arg, current_word, 1, length(current_word) + 1) == 1 && arg != current_word)
				prediction_text = copytext(arg, length(current_word) + 1)
				showing_prediction = TRUE
				break
	else if(parts_count >= 3)
		var/base_command = input_parts[1]
		var/secondary_arg = input_parts[2]
		var/current_word = input_parts[3]

		var/list/possible_args = get_tertiary_args(base_command, secondary_arg)
		for(var/arg in possible_args)
			if(findtext(arg, current_word, 1, length(current_word) + 1) == 1 && arg != current_word)
				prediction_text = copytext(arg, length(current_word) + 1)
				showing_prediction = TRUE
				break

	UpdateIcon()

/obj/abstract/visual_ui_element/console_input/proc/apply_prediction()
	if(showing_prediction && prediction_text)
		input_text += prediction_text
		cursor_position = length(input_text)
		showing_prediction = FALSE
		prediction_text = ""
		UpdateIcon()
		return TRUE
	return FALSE

/obj/abstract/visual_ui_element/console_input/proc/handle_keydown(key)
	if(!focused)
		return FALSE

	switch(key)
		if("Shift")
			shift_down = TRUE
			return TRUE
		if("Ctrl")
			ctrl_down = TRUE
			return TRUE
		if("Alt")
			alt_down = TRUE
			return TRUE
		if("Tab")
			return handle_tab_completion()

	return TRUE

/obj/abstract/visual_ui_element/console_input/proc/handle_keyup(key)
	if(!focused)
		return FALSE

	if(key == "`")
		return TRUE

	if(key == "Tab")
		return TRUE

	switch(key)
		if("Shift")
			shift_down = FALSE
			return TRUE
		if("Ctrl")
			ctrl_down = FALSE
			return TRUE
		if("Alt")
			alt_down = FALSE
			return TRUE

	var/special_key = FALSE
	switch(key)
		if("Backspace", "Back")
			special_key = TRUE
			if(cursor_position > 0)
				input_text = copytext(input_text, 1, cursor_position) + copytext(input_text, cursor_position + 1)
				cursor_position--
			reset_completion()
			update_prediction()
		if("Delete")
			special_key = TRUE
			if(cursor_position < length(input_text))
				input_text = copytext(input_text, 1, cursor_position + 1) + copytext(input_text, cursor_position + 2)
			reset_completion()
		if("Left", "West")
			special_key = TRUE
			cursor_position = max(0, cursor_position - 1)
			showing_prediction = FALSE
		if("Right", "East")
			special_key = TRUE
			if(cursor_position == length(input_text) && showing_prediction)
				apply_prediction()
				update_prediction()
			else
				cursor_position = min(length(input_text), cursor_position + 1)
				showing_prediction = FALSE
		if("Home")
			special_key = TRUE
			cursor_position = 0
			showing_prediction = FALSE
		if("End")
			special_key = TRUE
			cursor_position = length(input_text)
			update_prediction() // Update prediction when moving to end
		if("Up", "North")
			special_key = TRUE
			var/datum/visual_ui/console/console = parent
			if(istype(console) && console.history_position < length(console.command_history))
				console.history_position++
				set_text(console.command_history[console.history_position])
		if("Down", "South")
			special_key = TRUE
			var/datum/visual_ui/console/console = parent
			if(istype(console))
				if(console.history_position > 1)
					console.history_position--
					set_text(console.command_history[console.history_position])
				else if(console.history_position == 1)
					console.history_position = 0
					set_text(console.current_input)
		if("Enter", "Return")
			special_key = TRUE
			var/datum/visual_ui/console/console = parent
			if(istype(console))
				console.submit_command(input_text)
		if("Escape")
			special_key = TRUE
			var/datum/visual_ui/console/console = parent
			if(istype(console))
				console.close_console()

	if(special_key)
		var/datum/visual_ui/console/console = parent
		if(istype(console))
			console.current_input = input_text

		UpdateIcon()
		return TRUE

	// Check for character input (not special keys) shit code to hell
	if((length(key) == 1 && key != " ") || key == "Space")
		var/char_to_add = key
		if(key != "Space")
			if(shift_down)
				switch(key)
					if("1") char_to_add = "!"
					if("2") char_to_add = "@"
					if("3") char_to_add = "#"
					if("4") char_to_add = "$"
					if("5") char_to_add = "%"
					if("6") char_to_add = "^"
					if("7") char_to_add = "&"
					if("8") char_to_add = "*"
					if("9") char_to_add = "("
					if("0") char_to_add = ")"
					if("-") char_to_add = "_"
					if("=") char_to_add = "+"
					if("\[") char_to_add = "{"
					if("]") char_to_add = "}"
					if("\\") char_to_add = "|"
					if(";") char_to_add = ":"
					if("'") char_to_add = "\""
					if(",") char_to_add = "<"
					if(".") char_to_add = ">"
					if("/") char_to_add = "?"
					if("`") char_to_add = "~"
					else char_to_add = uppertext(char_to_add)
			else
				char_to_add = lowertext(char_to_add)

		if(key == "Space")
			char_to_add = " "
			if(ctrl_down && apply_prediction())
				return TRUE

		input_text = copytext(input_text, 1, cursor_position + 1) + char_to_add + copytext(input_text, cursor_position + 1)
		cursor_position++
		reset_completion()
		update_prediction()

		var/datum/visual_ui/console/console = parent
		if(istype(console))
			console.current_input = input_text

		UpdateIcon()
		return TRUE

	return FALSE

/obj/abstract/visual_ui_element/console_input/Destroy()
	unfocus()
	return ..()

// Helper function to compare lists
/proc/comparison_list(list/a, list/b)
	if(length(a) != length(b))
		return FALSE

	for(var/i = 1, i <= length(a), i++)
		if(a[i] != b[i])
			return FALSE

	return TRUE
