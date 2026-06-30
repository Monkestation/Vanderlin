/datum/preference/choiced/ghost_accs
	savefile_key = "ghost_accs"
	savefile_identifier = PREF_PLAYER
	category = "ghost"
	can_randomize = FALSE
	should_update_preview = FALSE

/datum/preference/choiced/ghost_accs/init_possible_values(datum/preferences/prefs)
	return GLOB.ghost_accs_options

/datum/preference/choiced/ghost_accs/create_default_value(datum/preferences/prefs)
	return GHOST_ACCS_DEFAULT_OPTION
