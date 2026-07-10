/datum/preference/choiced/ghost_form
	savefile_key = "ghost_form"
	savefile_identifier = PREF_PLAYER
	category = "ghost"
	can_randomize = FALSE
	should_update_preview = FALSE

/datum/preference/choiced/ghost_form/init_possible_values(datum/preferences/prefs)
	return GLOB.ghost_forms

/datum/preference/choiced/ghost_form/create_default_value(datum/preferences/prefs)
	return "ghost"
