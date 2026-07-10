/datum/preference/numeric/tip_delay
	savefile_key = "tip_delay"
	savefile_identifier = PREF_PLAYER
	category = "gameplay"
	can_randomize = FALSE
	should_update_preview = FALSE
	minimum = 100
	maximum = 5000
	step = 100

/datum/preference/numeric/tip_delay/create_default_value(datum/preferences/prefs)
	return 500
