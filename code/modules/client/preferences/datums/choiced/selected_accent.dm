/datum/preference/choiced/selected_accent
	savefile_key = "selected_accent"
	savefile_identifier = PREF_CHARACTER
	category = "character"
	should_apply = FALSE

/datum/preference/choiced/selected_accent/init_possible_values(datum/preferences/prefs)
	return GLOB.accent_list

/datum/preference/choiced/selected_accent/create_default_value(datum/preferences/prefs)
	return ACCENT_DEFAULT

/datum/preference/choiced/selected_accent/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.accent = value

/datum/preference/choiced/selected_accent/handle_link(datum/preferences/prefs, mob/user)
	if(length(prefs.pref_species.multiple_accents))
		prefs.change_accent = TRUE
	else
		prefs.change_accent = FALSE
	if(!prefs.donator && !prefs.change_accent)
		to_chat(user, "Sorry, this option is Donator-exclusive or unavailable to your race.")
		prefs.write_preference(/datum/preference/choiced/selected_accent, ACCENT_DEFAULT)
		return
	var/accent
	if(prefs.donator)
		accent = browser_input_list(user, "CHOOSE YOUR HERO'S ACCENT", "VOICE OF THE WORLD", GLOB.accent_list, prefs.read_preference(/datum/preference/choiced/selected_accent))
		if(accent)
			prefs.write_preference(/datum/preference/choiced/selected_accent, accent)
	else if(prefs.change_accent)
		accent = browser_input_list(user, "CHOOSE YOUR HERO'S ACCENT", "VOICE OF THE WORLD", prefs.pref_species.multiple_accents, prefs.read_preference(/datum/preference/choiced/selected_accent))
		if(accent)
			prefs.write_preference(/datum/preference/choiced/selected_accent, prefs.pref_species.multiple_accents[accent])
