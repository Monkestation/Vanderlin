/datum/preference/choiced/char_theme
	savefile_key = "char_theme"
	savefile_identifier = PREF_PLAYER
	category = "ui"
	can_randomize = FALSE
	should_update_preview = FALSE
	var/static/list/char_themes = list(
		"dusty",
		"grimshart",
		"paper",
		"parchment",
	)

/datum/preference/choiced/char_theme/init_possible_values(datum/preferences/prefs)
	return char_themes

/datum/preference/choiced/char_theme/create_default_value(datum/preferences/prefs)
	return "grimshart"
