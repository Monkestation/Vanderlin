/datum/preference/bitwise
	abstract_type = /datum/preference/bitwise

	/// The default value of the full bitfield.
	var/default_value = 0

	/// The maximum valid value, all bits OR'd together.
	/// Must be set by subtypes.
	var/max_value = 0

/datum/preference/bitwise/create_default_value(datum/preferences/prefs)
	return default_value

/datum/preference/bitwise/deserialize(input, datum/preferences/prefs)
	if(!isnum(input))
		return default_value
	return input & max_value // mask off any bits we don't recognise

/datum/preference/bitwise/serialize(input)
	return input & max_value

/datum/preference/bitwise/is_valid(value, datum/preferences/prefs)
	return isnum(value)

/datum/preference/bitwise/apply_to_client(client/C, value)
	return

/datum/preference/bitwise/compile_constant_data()
	return list("default" = default_value, "max" = max_value)
