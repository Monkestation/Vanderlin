/datum/preference/choiced/ui_theme
	savefile_key = "ui_theme"
	savefile_identifier = PREF_PLAYER
	category = "ui"
	can_randomize = FALSE
	should_update_preview = FALSE

/datum/preference/choiced/ui_theme/init_possible_values(datum/preferences/prefs)
	return list(UI_PREFERENCE_LIGHT_MODE, UI_PREFERENCE_DARK_MODE)

/datum/preference/choiced/ui_theme/create_default_value(datum/preferences/prefs)
	return UI_PREFERENCE_LIGHT_MODE
