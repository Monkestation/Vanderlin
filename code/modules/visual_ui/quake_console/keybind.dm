/datum/keybinding/client/toggle_console
	hotkey_keys = list("`", "F1") // Tilde key and F1 as alternate
	name = "toggle_console"
	full_name = "Toggle Console"
	description = "Toggles the Quake-style console"
	category = CATEGORY_CLIENT

/datum/keybinding/client/toggle_console/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	var/mob/M = user.mob
	if(isdead(M) && !M.mind)
		M.mind = new /datum/mind(M.key)
		M.mind.current_ghost = M

	if(!M || !M.mind)
		return FALSE

	var/datum/visual_ui/console/console
	if("quake_console" in M.mind.active_uis)
		console = M.mind.active_uis["quake_console"]
		console.toggle()
	else
		M.display_ui("quake_console")
		console = M.mind.active_uis["quake_console"]
		if(console)
			console.toggle()

	return TRUE

// Process input for console
/client/verb/console_input(input_text as text)
	set name = "Console Input"
	set hidden = 1

	var/mob/M = mob
	if(!M || !M.mind || !("quake_console" in M.mind.active_uis))
		return

	var/datum/visual_ui/console/console = M.mind.active_uis["quake_console"]
	if(!console || !console.console_open)
		return

	console.submit_command(input_text)

// Handle keyboard navigation in console history
/client/verb/console_key_input(key as text)
	set name = "Console Key Input"
	set hidden = 1

	var/mob/M = mob
	if(!M || !M.mind || !("quake_console" in M.mind.active_uis))
		return

	var/datum/visual_ui/console/console = M.mind.active_uis["quake_console"]
	if(!console || !console.console_open)
		return

	var/obj/abstract/visual_ui_element/console_input/input = locate(/obj/abstract/visual_ui_element/console_input) in console.elements
	if(!input)
		return

	switch(key)
		if("Up")
			// Navigate history upward
			if(console.history_position < console.command_history.len)
				console.history_position++
				if(console.history_position == 1)
					console.current_input = input.text
				input.set_text(console.command_history[console.history_position])
		if("Down")
			// Navigate history downward
			if(console.history_position > 0)
				console.history_position--
				if(console.history_position == 0)
					input.set_text(console.current_input)
				else
					input.set_text(console.command_history[console.history_position])
		if("Escape")
			// Close console
			console.close_console()
