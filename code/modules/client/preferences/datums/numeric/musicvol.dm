/datum/preference/numeric/musicvol
	savefile_key = "musicvol"
	savefile_identifier = PREF_PLAYER
	category = "audio"
	can_randomize = FALSE
	should_update_preview = FALSE
	minimum = 0
	maximum = 100
	step = 1

/datum/preference/numeric/musicvol/create_default_value(datum/preferences/prefs)
	return 50
