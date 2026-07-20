/datum/preference/choiced/socks
	savefile_key = "socks"
	savefile_identifier = PREF_CHARACTER
	category = "appearance"
	can_randomize = TRUE

/datum/preference/choiced/socks/init_possible_values(datum/preferences/prefs)
	return list("Nude")

/datum/preference/choiced/socks/create_default_value(datum/preferences/prefs)
	return "Nude"

/datum/preference/choiced/socks/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.socks = value
