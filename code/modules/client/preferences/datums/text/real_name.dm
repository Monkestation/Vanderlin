/datum/preference/text/real_name
	savefile_key = "real_name"
	savefile_identifier = PREF_CHARACTER
	category = "character"
	priority = PREF_PRIORITY_NAMES
	can_randomize = TRUE
	maximum_value_length = MAX_NAME_LEN

/datum/preference/text/real_name/create_default_value(datum/preferences/prefs)
	return "Unknown"

/datum/preference/text/real_name/deserialize(input, datum/preferences/prefs)
	var/cleaned = reject_bad_name(..())
	return cleaned || "Unknown"

/datum/preference/text/real_name/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.real_name = value
	H.name = value

/datum/preference/text/real_name/handle_link(datum/preferences/prefs, mob/user)
	var/new_name = browser_input_text(user, "DECIDE YOUR HERO'S IDENTITY", "THE SELF", prefs.read_preference(/datum/preference/text/real_name), MAX_NAME_LEN, encode = FALSE)
	if(new_name)
		new_name = reject_bad_name(new_name)
		if(new_name)
			prefs.write_preference(/datum/preference/text/real_name, new_name)
		else
			to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>")
	GLOB.name_adjustments |= "[user] changed their characters name to [new_name]."
	log_character("[user] changed their characters name to [new_name].")
