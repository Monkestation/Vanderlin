/datum/preference/choiced/patron
	savefile_key = "selected_patron"
	savefile_identifier = PREF_CHARACTER
	category = "character"
	can_randomize = FALSE

/datum/preference/choiced/patron/init_possible_values(datum/preferences/prefs)
	var/list/out = list()
	for (var/T in GLOB.patron_list)
		out += T
	return out

/datum/preference/choiced/patron/is_valid(value, datum/preferences/prefs)
	var/datum/patron/patron = deserialize(value, prefs)
	if(length(patron.allowed_races) && !(prefs?.pref_species.id in patron.allowed_races))
		return FALSE
	return TRUE

/datum/preference/choiced/patron/create_default_value(datum/preferences/prefs)
	return /datum/patron/divine/astrata

/datum/preference/choiced/patron/serialize(input)
	if (istype(input, /datum/patron))
		var/datum/patron/patron = input
		return "[patron.type]"
	return "[input]"

/datum/preference/choiced/patron/deserialize(input, datum/preferences/prefs)
	var/path = ispath(input) ? input : text2path(input)
	if (!(path in GLOB.patron_list))
		return create_default_value(prefs)
	return GLOB.patron_list[path]

/datum/preference/choiced/patron/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.set_patron(value)

/datum/preference/choiced/patron/handle_link(datum/preferences/prefs, mob/user)
	var/datum/patron/pref_patron = prefs.read_preference(/datum/preference/choiced/patron)
	var/list/patrons_named = list()
	for(var/datum/patron/patron as anything in GLOB.patrons_by_faith[pref_patron.associated_faith || /datum/patron/divine/astrata::associated_faith])
		patron = GLOB.patron_list[patron]
		if(!patron.preference_accessible(prefs))
			continue
		if(!is_valid(patron.type, prefs))
			continue
		var/pref_name = patron.display_name ? patron.display_name : patron.name
		patrons_named[pref_name] = patron

	if(length(patrons_named))
		var/datum/faith/current_faith = GLOB.faith_list[pref_patron.associated_faith] || GLOB.faith_list[/datum/patron/divine/astrata::associated_faith]
		var/god_input = browser_input_list(user, "SELECT YOUR HERO'S PATRON GOD", uppertext("\The [current_faith.name]"), patrons_named, pref_patron)
		if(god_input)
			var/datum/patron/patron = patrons_named[god_input]
			prefs.write_preference(/datum/preference/choiced/patron, patron.type)

	pref_patron = prefs.read_preference(/datum/preference/choiced/patron)
	to_chat(user, "<font color='purple'>Patron: [pref_patron]</font>")
	to_chat(user, "<font color='purple'>Domain: [pref_patron.domain]</font>")
	to_chat(user, "<font color='purple'>Background: [pref_patron.desc]</font>")
	to_chat(user, "<font color='purple'>Flawed aspects: [pref_patron.flaws]</font>")
	to_chat(user, "<font color='purple'>Likely Worshippers: [pref_patron.worshippers]</font>")
	to_chat(user, "<font color='red'>Considers these to be Sins: [pref_patron.sins]</font>")
	to_chat(user, "<font color='white'>Blessed with boon(s): [pref_patron.boons]</font>")
