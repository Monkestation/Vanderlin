/datum/preference/text/setparent
	savefile_key = "setparent"
	savefile_identifier = PREF_CHARACTER
	category = "character"
	can_randomize = FALSE
	maximum_value_length = MAX_NAME_LEN

/datum/preference/text/setparent/create_default_value()
	return ""

/datum/preference/text/setparent/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.setparent = value

/datum/preference/text/setparent/handle_link(datum/preferences/prefs, mob/user)
	var/newspouse = browser_input_text(user, "INPUT THE IDENTITY OF YOUR PARENTS", "WHO YOU LOOK UP TO")
	if(newspouse)
		prefs.write_preference(/datum/preference/text/setparent, newspouse)
	else
		prefs.write_preference(/datum/preference/text/setparent, null)
