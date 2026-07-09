/datum/preference/toggle
	var/default_value = TRUE
	abstract_type = /datum/preference/toggle

/datum/preference/toggle/create_default_value(datum/preferences/prefs)
	return default_value

/datum/preference/toggle/deserialize(input, datum/preferences/prefs)
	return !!input

/datum/preference/toggle/is_valid(value, datum/preferences/prefs)
	return value == TRUE || value == FALSE
