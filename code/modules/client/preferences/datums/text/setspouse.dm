/datum/preference/text/setspouse
	savefile_key = "setspouse"
	savefile_identifier = PREF_CHARACTER
	category = "character"
	can_randomize = FALSE
	maximum_value_length = MAX_NAME_LEN

/datum/preference/text/setspouse/create_default_value(datum/preferences/prefs)
	return ""

/datum/preference/text/setspouse/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.setspouse = value

/datum/preference/text/setspouse/handle_link(datum/preferences/prefs, mob/user)
	var/newspouse = browser_input_text(user, "INPUT THE IDENTITY OF ANOTHER HERO", "TIL DEATH DO US PART")
	if(newspouse)
		prefs.write_preference(/datum/preference/text/setspouse, newspouse)
	else
		prefs.write_preference(/datum/preference/text/setspouse, null)
