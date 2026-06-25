/datum/preference/text/flavortext_display
	savefile_key = "flavortext_display"
	savefile_identifier = PREF_CHARACTER
	category = "character_ooc"
	can_randomize = FALSE
	maximum_value_length = 1024
	should_update_preview = FALSE

/datum/preference/text/flavortext_display/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.flavortext_display = value
