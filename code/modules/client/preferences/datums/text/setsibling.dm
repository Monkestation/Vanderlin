/datum/preference/text/setsibling
	savefile_key = "setsibling"
	savefile_identifier = PREF_CHARACTER
	category = "character"
	can_randomize = FALSE
	maximum_value_length = MAX_NAME_LEN

/datum/preference/text/setsibling/create_default_value(datum/preferences/prefs)
	return ""

/datum/preference/text/setsibling/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.setsibling = value

/datum/preference/text/setsibling/handle_link(datum/preferences/prefs, mob/user)
	var/newsibling = browser_input_text(user, "INPUT THE IDENTITY OF ANOTHER HERO", "TIES THAT BIND")
	if(newsibling)
		prefs.write_preference(/datum/preference/text/setsibling, newsibling)
	else
		prefs.write_preference(/datum/preference/text/setsibling, null)
