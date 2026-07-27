
/datum/preference/numeric
	var/minimum
	var/maximum
	var/step = 1

	abstract_type = /datum/preference/numeric

/datum/preference/numeric/deserialize(input, datum/preferences/prefs)
	if (istext(input))
		input = text2num(input)
	return sanitize_float(input, minimum, maximum, step, create_default_value(prefs))

/datum/preference/numeric/serialize(input)
	return sanitize_float(input, minimum, maximum, step, create_default_value())

/datum/preference/numeric/create_default_value(datum/preferences/prefs)
	return rand(minimum, maximum)

/datum/preference/numeric/is_valid(value, datum/preferences/prefs)
	return isnum(value) && value >= round(minimum, step) && value <= round(maximum, step)

/datum/preference/numeric/compile_constant_data()
	return list("minimum" = minimum, "maximum" = maximum, "step" = step)
