/datum/preference/choiced/domhand
	savefile_key = "domhand"
	savefile_identifier = PREF_CHARACTER
	category = "character"

/datum/preference/choiced/domhand/init_possible_values(datum/preferences/prefs)
	return list(1, 2)

/datum/preference/choiced/domhand/create_default_value(datum/preferences/prefs)
	return 2

/datum/preference/choiced/domhand/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.domhand = value

/datum/preference/choiced/domhand/handle_link(datum/preferences/prefs, mob/user)
	if(prefs.read_preference(/datum/preference/choiced/domhand) == 1)
		prefs.write_preference(/datum/preference/choiced/domhand, 2)
	else
		prefs.write_preference(/datum/preference/choiced/domhand, 1)
