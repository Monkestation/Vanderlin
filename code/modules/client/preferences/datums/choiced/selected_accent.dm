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
	var/list/available = list(ACCENT_DEFAULT)

	if(length(prefs.pref_species.multiple_accents))
		for(var/accent_name in prefs.pref_species.multiple_accents)
			available |= accent_name

	var/culture_type = prefs.read_preference(/datum/preference/choiced/culture)
	if(culture_type)
		var/datum/culture/culture_datum = GLOB.culture_singletons[culture_type]
		if(culture_datum && culture_datum.accent)
			available |= culture_datum.accent

	if(length(available) > 1)
		prefs.change_accent = TRUE
	else
		prefs.change_accent = FALSE

	if(!prefs.donator && !prefs.change_accent)
		to_chat(user, "Sorry, this option is Donator-exclusive or unavailable to your race and culture.")
		prefs.write_preference(/datum/preference/choiced/selected_accent, ACCENT_DEFAULT)
		return
	var/accent
	if(prefs.donator)
		for(var/accent_name in GLOB.accent_list)
			available |= accent_name
		accent = browser_input_list(user, "CHOOSE YOUR HERO'S ACCENT", "VOICE OF THE WORLD", available, prefs.read_preference(/datum/preference/choiced/selected_accent))
		if(accent)
			prefs.write_preference(/datum/preference/choiced/selected_accent, accent)
	else if(prefs.change_accent)
		accent = browser_input_list(user, "CHOOSE YOUR HERO'S ACCENT", "VOICE OF THE WORLD", available, prefs.read_preference(/datum/preference/choiced/selected_accent))
		if(accent)
			prefs.write_preference(/datum/preference/choiced/selected_accent, accent)

