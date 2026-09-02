/datum/preference/choiced/gender_choice
	savefile_key = "gender_choice"
	savefile_identifier = PREF_CHARACTER
	category = "character"
	can_randomize = FALSE

/datum/preference/choiced/gender_choice/init_possible_values(datum/preferences/prefs)
	return list(ANY_GENDER, SAME_GENDER, DIFFERENT_GENDER)

/datum/preference/choiced/gender_choice/create_default_value(datum/preferences/prefs)
	return ANY_GENDER

/datum/preference/choiced/gender_choice/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.gender_choice_pref = value

/datum/preference/choiced/gender_choice/handle_link(datum/preferences/prefs, mob/user)
	// If pronouns are neutral, lock to ANY_GENDER
	if(prefs.read_preference(/datum/preference/choiced/pronouns) == THEY_THEM || prefs.read_preference(/datum/preference/choiced/pronouns) == IT_ITS)
		to_chat(user, span_warning("With neutral pronouns, you may only choose [ANY_GENDER]."))
		prefs.write_preference(/datum/preference/choiced/gender_choice, ANY_GENDER)
	else
		var/list/gender_choice_option_list = list(ANY_GENDER, SAME_GENDER, DIFFERENT_GENDER)
		var/new_gender_choice  = browser_input_list(user, "SELECT YOUR HERO'S PREFERENCE", "TO LOVE AND TO CHERISH", gender_choice_option_list, prefs.read_preference(/datum/preference/choiced/gender_choice))
		if(new_gender_choice)
			prefs.write_preference(/datum/preference/choiced/gender_choice, new_gender_choice)
