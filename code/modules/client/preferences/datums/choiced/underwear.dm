/datum/preference/choiced/underwear
	savefile_key = "underwear"
	savefile_identifier = PREF_CHARACTER
	category = "appearance"
	can_randomize = TRUE

/datum/preference/choiced/underwear/init_possible_values(datum/preferences/prefs)
	return GLOB.underwear_list

/datum/preference/choiced/underwear/create_default_value(datum/preferences/prefs)
	return "Nude"

/datum/preference/choiced/underwear/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.underwear = value
