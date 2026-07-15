/datum/preference/list_type/culinary_preferences
	savefile_key = "culinary_preferences"
	savefile_identifier = PREF_CHARACTER

/datum/preference/list_type/culinary_preferences/create_default_value(datum/preferences/prefs)
	return list(
		CULINARY_RANDOM_PREFERENCES = FALSE,
		CULINARY_FAVOURITE_FOOD = null,
		CULINARY_FAVOURITE_DRINK = null,
		CULINARY_HATED_FOOD = null,
		CULINARY_HATED_DRINK = null,
	)

/datum/preference/list_type/culinary_preferences/apply_to_human(mob/living/carbon/human/H, list/value)
	H.client?.prefs?.validate_culinary_preferences()
	H.culinary_preferences = value.Copy()
	if(has_world_trait(/datum/world_trait/exotic_tastes))
		H.culinary_preferences[CULINARY_RANDOM_PREFERENCES] = TRUE
	if(H.culinary_preferences[CULINARY_RANDOM_PREFERENCES])
		var/datum/preferences/prefs = H.client?.prefs
		if(prefs)
			H.culinary_preferences[CULINARY_FAVOURITE_FOOD] = prefs.get_random_food()
			H.culinary_preferences[CULINARY_FAVOURITE_DRINK] = prefs.get_random_drink()
			H.culinary_preferences[CULINARY_HATED_FOOD] = prefs.get_random_hated_food()
			H.culinary_preferences[CULINARY_HATED_DRINK] = prefs.get_random_hated_drink()
