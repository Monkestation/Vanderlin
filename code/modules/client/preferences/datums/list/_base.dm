
/datum/preference/list_type
	abstract_type = /datum/preference/list_type
	can_randomize = FALSE
	should_update_preview = FALSE

/datum/preference/list_type/serialize(list/input)
	if (!islist(input))
		return list()
	return input.Copy()

/datum/preference/list_type/deserialize(list/input, datum/preferences/prefs)
	if (!islist(input))
		return create_default_value(prefs)
	return input.Copy()

/datum/preference/list_type/is_valid(value)
	return islist(value)

/datum/preference/list_type/create_default_value(datum/preferences/prefs)
	return list()

/datum/preference/list_type/apply_to_human(mob/living/carbon/human/H, value)
	return
