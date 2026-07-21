/datum/preference/color
	abstract_type = /datum/preference/color

/datum/preference/color/deserialize(input, datum/preferences/prefs)
	if (!allows_nulls || input)
		return sanitize_hexcolor(input)
	return null

/datum/preference/color/create_default_value(datum/preferences/prefs)
	if (default_null)
		return null
	return random_color()

/datum/preference/color/serialize(input)
	if (!allows_nulls || input)
		return sanitize_hexcolor(input)
	return null

/datum/preference/color/is_valid(value, datum/preferences/prefs)
	if (!allows_nulls || value)
		return findtext(value, GLOB.is_color)
	return TRUE
