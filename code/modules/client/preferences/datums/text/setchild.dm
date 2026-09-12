/datum/preference/text/setchild
	savefile_key = "setchild"
	savefile_identifier = PREF_CHARACTER
	category = "character"
	can_randomize = FALSE
	maximum_value_length = MAX_NAME_LEN

/datum/preference/text/setchild/create_default_value()
	return ""

/datum/preference/text/setchild/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.setchild = value

/datum/preference/text/setchild/handle_link(datum/preferences/prefs, mob/user)
	var/newspouse = browser_input_text(user, "INPUT THE IDENTITY OF YOUR PROGENY", "RAISE THEM WELL")
	if(newspouse)
		prefs.write_preference(/datum/preference/text/setchild, newspouse)
	else
		prefs.write_preference(/datum/preference/text/setchild, null)
