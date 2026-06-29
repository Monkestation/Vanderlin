/datum/preference/color/detail_color
	savefile_key = "detail_color"
	savefile_identifier = PREF_CHARACTER
	category = "appearance"
	can_randomize = TRUE

/datum/preference/color/detail_color/create_default_value(datum/preferences/prefs)
	return "000000"

/datum/preference/color/detail_color/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.detail_color = value
	H.update_body()
