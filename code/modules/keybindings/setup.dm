/client
	/// A rolling buffer of any keys held currently
	var/list/keys_held = list()
	///used to keep track of the current rolling buffer position
	var/current_key_address = 0
	/// These next two vars are to apply movement for keypresses and releases made while move delayed.
	/// Because discarding that input makes the game less responsive.
	/// On next move, add this dir to the move that would otherwise be done
	var/next_move_dir_add
	/// On next move, subtract this dir from the move that would otherwise be done
	var/next_move_dir_sub

// Set a client's focus to an object and override these procs on that object to let it handle keypresses

/datum/proc/key_down(key, client/user) // Called when a key is pressed down initially
	return
/datum/proc/key_up(key, client/user) // Called when a key is released
	return
/datum/proc/keyLoop(client/user) // Called once every frame
	set waitfor = FALSE
	return

// removes all the existing macros
/client/proc/erase_all_macros()
	var/erase_output = ""
	var/list/macro_set = params2list(winget(src, "default.*", "command")) // The third arg doesnt matter here as we're just removing them all
	for(var/k in 1 to length(macro_set))
		var/list/split_name = splittext(macro_set[k], ".")
		var/macro_name = "[split_name[1]].[split_name[2]]" // [3] is "command"
		erase_output = "[erase_output];[macro_name].parent=null"
	winset(src, null, erase_output)

/client/proc/set_macros(skip_chats = FALSE, skip_macro_mode = FALSE)
	set waitfor = FALSE

	//Reset
	keys_held.Cut()

	erase_all_macros()

	var/list/macro_set = SSinput.macro_set
	for(var/k in 1 to length(macro_set))
		var/key = macro_set[k]
		if(skip_chats && (key == "T" || key == "M" || key == "Tab"))//macros supercede internal key_downs and key_ups
			continue
		var/command = macro_set[key]
		winset(src, "default-[REF(key)]", "parent=default;name=[key];command=[command]")


	var/chat_handled = FALSE
	for(var/full_key in prefs.key_bindings)
		if(chat_handled)
			break
		for(var/kb_name in prefs.key_bindings[full_key])
			var/datum/keybinding/client/say/kb = GLOB.keybindings_by_name[kb_name]
			if(!istype(kb))
				continue
			chat_handled = TRUE
			winset(src, "default-[REF(full_key)]", "parent=default;name=[full_key];command=.open_say")
			break

	if(!skip_macro_mode)
		if(prefs.hotkeys)
			winset(src, null, "input.focus=true command=activeInput input.background-color=[COLOR_INPUT_ENABLED] input.text-color = #EEEEEE")
		else
			winset(src, null, "input.focus=true command=activeInput input.background-color=[COLOR_INPUT_DISABLED] input.text-color = #ad9eb4")
