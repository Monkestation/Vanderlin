
/datum/preference/choiced
	var/list/cached_values
	/// Feature name shown in the UI for main feature prefs.
	var/main_feature_name
	/// Whether to auto-generate icons for each choice.
	var/should_generate_icons = FALSE

	abstract_type = /datum/preference/choiced

/// Returns the full list of possible values (cached after first call).
/datum/preference/choiced/proc/get_choices(datum/preferences/prefs)
	SHOULD_NOT_OVERRIDE(TRUE)
	if (isnull(cached_values) || !dynamic)
		cached_values = init_possible_values(prefs)
		ASSERT(cached_values.len)
	return cached_values

/// Returns all choices in serialised form.
/datum/preference/choiced/proc/get_choices_serialized()
	SHOULD_NOT_OVERRIDE(TRUE)
	var/list/out = list()
	for (var/c in get_choices())
		out += serialize(c)
	return out

/// Override this to return the list of valid choices.
/datum/preference/choiced/proc/init_possible_values(datum/preferences/prefs)
	CRASH("`init_possible_values(datum/preferences/prefs)` not implemented on [type]!")

/datum/preference/choiced/is_valid(value, datum/preferences/prefs)
	return value in get_choices(prefs)

/datum/preference/choiced/deserialize(input, datum/preferences/prefs)
	return sanitize_inlist(input, get_choices(prefs), create_default_value(prefs))

/datum/preference/choiced/create_default_value(datum/preferences/prefs)
	return pick(get_choices(prefs))

/datum/preference/choiced/compile_constant_data()
	var/list/data = list()
	var/list/choices = list()
	for (var/c in get_choices())
		choices += c
	data["choices"] = choices
	if (!isnull(main_feature_name))
		data["name"] = main_feature_name
	return data
