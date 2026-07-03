/datum/preference/choiced/gender
	savefile_key = "gender"
	savefile_identifier = PREF_CHARACTER
	category = "character"
	priority = PREF_PRIORITY_GENDER

/datum/preference/choiced/gender/init_possible_values(datum/preferences/prefs)
	return list(MALE, FEMALE, PLURAL)

/datum/preference/choiced/gender/create_default_value(datum/preferences/prefs)
	return MALE

/datum/preference/choiced/gender/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	var/old_gender = H.gender
	H.gender = value
	H.dna?.species?.on_gender_update(H, old_gender)

/datum/preference/choiced/gender/handle_link(datum/preferences/prefs, mob/user)
	var/pickedGender = MALE
	if(prefs.read_preference(/datum/preference/choiced/gender) == MALE)
		pickedGender = FEMALE
	if(pickedGender && pickedGender != prefs.read_preference(/datum/preference/choiced/gender))
		prefs.write_preference(/datum/preference/choiced/gender, pickedGender)
		prefs.write_preference(/datum/preference/text/real_name, prefs.pref_species.random_name(prefs.read_preference(/datum/preference/choiced/gender), TRUE))
		prefs.reset_jobs(user)
		prefs.randomise_appearance_prefs(RANDOMIZE_UNDERWEAR | RANDOMIZE_HAIRSTYLE)
		prefs.write_preference(/datum/preference/choiced/accessory, "Nothing")
		prefs.write_preference(/datum/preference/choiced/detail, "Nothing")
