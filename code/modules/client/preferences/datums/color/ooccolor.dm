/datum/preference/color/ooccolor
	savefile_key = "ooccolor"
	savefile_identifier = PREF_PLAYER
	category = "chat"
	can_randomize = FALSE
	should_update_preview = FALSE
	allows_nulls = TRUE
	default_null = TRUE

/datum/preference/color/ooccolor/handle_link(datum/preferences/prefs, mob/user)
	var/new_ooccolor = input(user, "Choose your OOC colour:", "Game Preference", prefs.read_preference(/datum/preference/color/ooccolor)) as color|null
	if(new_ooccolor)
		prefs.write_preference(/datum/preference/color/ooccolor, sanitize_color(new_ooccolor))
