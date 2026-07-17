/datum/preference/choiced/culture
	savefile_key = "culture"
	savefile_identifier = PREF_CHARACTER
	category = "character"

/datum/preference/choiced/culture/init_possible_values(datum/preferences/prefs)
	// Returns a list of typepath strings for all /datum/culture subtypes.
	var/list/out = list()
	for (var/datum/culture/T as anything in subtypesof(/datum/culture))
		if (IS_ABSTRACT(T))
			continue
		out += T
	return out

/datum/preference/choiced/culture/create_default_value(datum/preferences/prefs)
	return /datum/culture/universal/ambiguous

/datum/preference/choiced/culture/serialize(input)
	if (istype(input, /datum/culture))
		var/datum/culture/culture = input
		return "[culture.type]"
	return "[input]"

/datum/preference/choiced/culture/deserialize(input, datum/preferences/prefs)
	var/path = ispath(input) ? input : text2path(input)
	return sanitize_inlist(path, get_choices(), create_default_value(prefs))

/datum/preference/choiced/culture/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.culture = GLOB.culture_singletons[value]

/datum/preference/choiced/culture/handle_link(datum/preferences/prefs, mob/user)
	var/list/cultures = list()
	for(var/culture_type in GLOB.culture_singletons)
		var/datum/culture/culture = GLOB.culture_singletons[culture_type]
		if(!culture.is_selectable(prefs))
			continue
		cultures[culture.name] += culture.type
	var/choice = browser_input_list(user, "CHOOSE YOUR HERO'S CULTURE", "CULTURE", cultures)
	if(!choice)
		return
	prefs.write_preference(/datum/preference/choiced/culture, cultures[choice])
	var/datum/culture/pref_culture = prefs.read_preference(/datum/preference/choiced/culture)
	to_chat(user, span_notice("[pref_culture::name]"))
	to_chat(user, span_notice("[pref_culture::description]"))
