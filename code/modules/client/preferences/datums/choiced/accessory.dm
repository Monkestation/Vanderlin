/datum/preference/choiced/accessory
	savefile_key = "accessory"
	savefile_identifier = PREF_CHARACTER
	category = "appearance"
	can_randomize = TRUE

/datum/preference/choiced/accessory/init_possible_values(datum/preferences/prefs)
	return list("Nothing")

/datum/preference/choiced/accessory/create_default_value(datum/preferences/prefs)
	return "Nothing"

/datum/preference/choiced/accessory/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.accessory = value
