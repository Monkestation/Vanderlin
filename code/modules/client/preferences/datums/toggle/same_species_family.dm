/datum/preference/toggle/same_species_family
	savefile_key = "same_species_family"
	savefile_identifier = PREF_CHARACTER
	category = "relations"
	default_value = FALSE

/datum/preference/toggle/same_species_family/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.same_species_family = value
