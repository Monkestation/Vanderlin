/datum/preference/choiced/ghost_others
	savefile_key = "ghost_others"
	savefile_identifier = PREF_PLAYER
	category = "ghost"
	can_randomize = FALSE
	should_update_preview = FALSE

/datum/preference/choiced/ghost_others/init_possible_values(datum/preferences/prefs)
	return GLOB.ghost_others_options

/datum/preference/choiced/ghost_others/create_default_value(datum/preferences/prefs)
	return GHOST_OTHERS_DEFAULT_OPTION
