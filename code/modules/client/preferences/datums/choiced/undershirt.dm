/datum/preference/choiced/undershirt
	savefile_key = "undershirt"
	savefile_identifier = PREF_CHARACTER
	category = "appearance"
	can_randomize = TRUE

/datum/preference/choiced/undershirt/init_possible_values(datum/preferences/prefs)
	return GLOB.undershirt_list

/datum/preference/choiced/undershirt/create_default_value(datum/preferences/prefs)
	return "Nude"

/datum/preference/choiced/undershirt/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.undershirt = value
