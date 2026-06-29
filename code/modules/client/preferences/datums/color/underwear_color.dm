/datum/preference/color/underwear_color
	savefile_key = "underwear_color"
	savefile_identifier = PREF_CHARACTER
	category = "appearance"
	allows_nulls = TRUE
	default_null = TRUE
	can_randomize = TRUE

/datum/preference/color/underwear_color/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.underwear_color = value
