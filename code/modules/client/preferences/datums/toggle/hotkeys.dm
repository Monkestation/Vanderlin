/datum/preference/toggle/hotkeys
	savefile_key = "hotkeys"
	savefile_identifier = PREF_PLAYER
	category = "chat"
	can_randomize = FALSE
	should_update_preview = FALSE
	default_value = TRUE

/datum/preference/toggle/hotkeys/handle_link(datum/preferences/prefs, mob/user)
	prefs.toggle_preference(/datum/preference/toggle/hotkeys)
	if(prefs.read_preference(/datum/preference/toggle/hotkeys))
		winset(user, null, "input.focus=true command=activeInput input.background-color=[COLOR_INPUT_ENABLED]  input.text-color = #EEEEEE")
	else
		winset(user, null, "input.focus=true command=activeInput input.background-color=[COLOR_INPUT_DISABLED]  input.text-color = #ad9eb4")
