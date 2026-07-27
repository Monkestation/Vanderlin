/datum/preference/toggle/was_divorced
	savefile_key = "was_divorced"
	savefile_identifier = PREF_CHARACTER
	category = "relations"
	default_value = FALSE

/datum/preference/toggle/was_divorced/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.was_divorced = value
