/datum/preference/choiced/UI_style
	savefile_key = "UI_style"
	savefile_identifier = PREF_PLAYER
	category = "ui"
	can_randomize = FALSE
	should_update_preview = FALSE

/datum/preference/choiced/UI_style/init_possible_values(datum/preferences/prefs)
	return GLOB.available_ui_styles

/datum/preference/choiced/UI_style/create_default_value(datum/preferences/prefs)
	return GLOB.available_ui_styles[1]
