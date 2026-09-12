/datum/preference/toggle/wants_adoption
	savefile_key = "wants_adoption"
	savefile_identifier = PREF_CHARACTER
	category = "relations"
	default_value = FALSE

/datum/preference/toggle/wants_adoption/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.family_adoption_pref = value
