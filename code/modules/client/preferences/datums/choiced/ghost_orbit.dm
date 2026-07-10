/datum/preference/choiced/ghost_orbit
	savefile_key = "ghost_orbit"
	savefile_identifier = PREF_PLAYER
	category = "ghost"
	can_randomize = FALSE
	should_update_preview = FALSE

/datum/preference/choiced/ghost_orbit/init_possible_values(datum/preferences/prefs)
	return GLOB.ghost_orbits

/datum/preference/choiced/ghost_orbit/create_default_value(datum/preferences/prefs)
	return GHOST_ORBIT_CIRCLE
