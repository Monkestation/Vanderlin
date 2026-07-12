/datum/preference/choiced/age
	savefile_key = "age"
	savefile_identifier = PREF_CHARACTER
	category = "character"

/datum/preference/choiced/age/init_possible_values(datum/preferences/prefs)
	var/datum/species/base_species = /datum/species/human/northern
	if(prefs)
		base_species = prefs.read_preference(/datum/preference/choiced/species)
	var/datum/species/S = new base_species
	var/list/ages = list()
	ages = S.possible_ages
	qdel(S)
	return ages

/datum/preference/choiced/age/create_informed_default_value(datum/preferences/prefs)
	var/datum/species/S = prefs.pref_species
	if (S && S.possible_ages && S.possible_ages.len)
		return S.possible_ages[1]
	return AGE_ADULT

/datum/preference/choiced/age/deserialize(input, datum/preferences/prefs)
	// Ages are species-dependent; validate against the species' list if available.
	var/datum/species/S = prefs?.pref_species
	var/list/valid = (S && S.possible_ages && S.possible_ages.len) ? S.possible_ages : get_choices(prefs)
	return sanitize_inlist(input, valid, create_informed_default_value(prefs))

/datum/preference/choiced/age/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.age = value

/datum/preference/choiced/age/handle_link(datum/preferences/prefs, mob/user)
	var/new_age = browser_input_list(user, "SELECT YOUR HERO'S AGE", "YILS DEAD", prefs.pref_species.possible_ages, prefs.read_preference(/datum/preference/choiced/age))
	if(new_age)
		prefs.write_preference(/datum/preference/choiced/age, new_age)
		prefs.reset_jobs(user)
