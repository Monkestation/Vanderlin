/datum/preference/numeric/mastervol
	savefile_key = "mastervol"
	savefile_identifier = PREF_PLAYER
	category = "audio"
	can_randomize = FALSE
	should_update_preview = FALSE
	minimum = 0
	maximum = 100
	step = 1

/datum/preference/numeric/mastervol/create_default_value(datum/preferences/prefs)
	return 50
