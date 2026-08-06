/datum/preference/choiced/faith
	savefile_key = "faith"
	savefile_identifier = PREF_CHARACTER
	category = "character"
	can_randomize = TRUE

/datum/preference/choiced/faith/init_possible_values()
	var/list/out = list()
	for(var/T in GLOB.faith_list)
		out += T
	return out

/datum/preference/choiced/faith/create_default_value(datum/preferences/prefs)
	return /datum/patron/divine/astrata::associated_faith

/datum/preference/choiced/faith/serialize(input)
	if(istype(input, /datum/faith))
		var/datum/faith/faith = input
		return "[faith.type]"
	return "[input]"

/datum/preference/choiced/faith/deserialize(input, datum/preferences/prefs)
	var/path = ispath(input) ? input : text2path(input)
	if(!(path in GLOB.faith_list))
		return create_default_value(prefs)
	return GLOB.faith_list[path]

/datum/preference/choiced/faith/apply_to_human(mob/living/carbon/human/H, value)
	return // on the fourth day god said let their be shitcode

/datum/preference/choiced/faith/handle_link(datum/preferences/prefs, mob/user)
	var/list/faiths_named = list()
	for(var/T in GLOB.faith_list)
		var/datum/faith/faith = GLOB.faith_list[T]
		if(!faith.preference_accessible(prefs))
			continue
		faiths_named["\The [faith.name]"] = faith

	var/datum/faith/current_faith = prefs.read_preference(/datum/preference/choiced/faith)
	var/faith_input = browser_input_list(user, "SELECT YOUR HERO'S BELIEF", "PUPPETS ON STRINGS", faiths_named, "\The [current_faith.name]")
	if(!faith_input)
		return

	var/datum/faith/chosen_faith = faiths_named[faith_input]
	to_chat(user, "<font color='purple'>Faith: [chosen_faith.name]</font>")
	to_chat(user, "<font color='purple'>Background: [chosen_faith.desc]</font>")
	prefs.write_preference(/datum/preference/choiced/faith, chosen_faith)

	// Reset patron to the godhead of the new faith, or a valid one if godhead is null.
	// This keeps faith and patron in sync I HATE IT I HATE IT I HATE IT I HATE IT
	var/datum/patron/new_patron = GLOB.patron_list[chosen_faith.godhead] || GLOB.patron_list[pick(GLOB.patrons_by_faith[chosen_faith.type])]
	prefs.write_preference(/datum/preference/choiced/patron, new_patron.type)
