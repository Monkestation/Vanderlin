/datum/preference/numeric/ui_scale
	savefile_key = "ui_scale"
	savefile_identifier = PREF_PLAYER
	category = "ui"
	can_randomize = FALSE
	should_update_preview = FALSE
	minimum = 0.25
	maximum = 5
	step = 0.25

/datum/preference/numeric/ui_scale/create_default_value(datum/preferences/prefs)
	return 1
