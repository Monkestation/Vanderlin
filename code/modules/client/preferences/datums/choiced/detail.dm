/datum/preference/choiced/detail
	savefile_key = "detail"
	savefile_identifier = PREF_CHARACTER
	category = "appearance"
	can_randomize = TRUE

/datum/preference/choiced/detail/init_possible_values(datum/preferences/prefs)
	return list("Nothing")

/datum/preference/choiced/detail/create_default_value(datum/preferences/prefs)
	return "Nothing"

/datum/preference/choiced/detail/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.detail = value
