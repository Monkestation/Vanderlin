/datum/preference/color/nickname_color
	savefile_key = "nickname_color"
	savefile_identifier = PREF_CHARACTER
	category = "character"
	can_randomize = FALSE
	should_update_preview = FALSE

/datum/preference/color/nickname_color/create_default_value(datum/preferences/prefs)
	return "ffffff"

/datum/preference/color/nickname_color/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.nickname_color = value

/datum/preference/color/nickname_color/handle_link(datum/preferences/prefs, mob/user)
	var/new_color = input(user, "Choose your nickname colour:", "Game Preference", prefs.read_preference(/datum/preference/color/nickname_color)) as color|null
	if(new_color)
		prefs.write_preference(/datum/preference/color/nickname_color, sanitize_color(new_color))