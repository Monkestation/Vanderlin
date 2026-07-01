// https://www.youtube.com/watch?v=bIiIrXM7BUA
/datum/preference/numeric/rival_count
	savefile_key = "rival_count"
	savefile_identifier = PREF_CHARACTER
	category = "character"
	should_update_preview = FALSE
	can_randomize = FALSE
	minimum = 0
	maximum = 5

/datum/preference/numeric/rival_count/create_default_value()
	return 1

/datum/preference/numeric/rival_count/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	return
