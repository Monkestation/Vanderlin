/datum/preference/color/asaycolor
	savefile_key = "asaycolor"
	savefile_identifier = PREF_PLAYER
	category = "chat"
	can_randomize = FALSE
	should_update_preview = FALSE

/datum/preference/color/asaycolor/create_default_value(datum/preferences/prefs)
	return "ff4500"

/datum/preference/color/asaycolor/handle_link(datum/preferences/prefs, mob/user)
	var/new_asaycolor = input(user, "Choose your ASAY color:", "Game Preference", prefs.read_preference(/datum/preference/color/asaycolor)) as color|null
	if(new_asaycolor)
		prefs.write_preference(/datum/preference/color/asaycolor, sanitize_color(new_asaycolor))
