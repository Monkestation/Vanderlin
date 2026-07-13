/datum/preference/choiced/joblessrole
	savefile_key = "joblessrole"
	savefile_identifier = PREF_CHARACTER
	category = "character"
	can_randomize = FALSE

/datum/preference/choiced/joblessrole/init_possible_values(datum/preferences/prefs)
	return list(BERANDOMJOB, RETURNTOLOBBY)

/datum/preference/choiced/joblessrole/create_default_value(datum/preferences/prefs)
	return RETURNTOLOBBY

/datum/preference/choiced/joblessrole/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	return
