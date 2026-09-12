/datum/preference/choiced/family_mode
	savefile_key = "family_mode"
	savefile_identifier = PREF_CHARACTER
	category = "relations"
	can_randomize = FALSE

/datum/preference/choiced/family_mode/init_possible_values(datum/preferences/prefs)
	return list(
		"[FAMILY_NONE]",
		"[FAMILY_PARTIAL]",
		"[FAMILY_NEWLYWED]",
		"[FAMILY_FULL]",
	)

/datum/preference/choiced/family_mode/create_default_value()
	return FAMILY_NONE

/datum/preference/choiced/family_mode/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.familytree_pref = value

/datum/preference/choiced/family_mode/handle_link(datum/preferences/prefs, mob/user)
	var/list/labelled = list(
		"None (disabled)" = "[FAMILY_NONE]",
		"Partial (join a house)" = "[FAMILY_PARTIAL]",
		"Newlywed (spouse only)" = "[FAMILY_NEWLYWED]",
		"Full (found a house)" = "[FAMILY_FULL]",
	)
	var/current = prefs.read_preference(/datum/preference/choiced/family_mode)
	var/result = browser_input_list(user, "SELECT YOUR HERO'S BOND", "BLOOD IS THICKER THAN WATER", labelled, current)
	if(!result)
		return
	prefs.write_preference(/datum/preference/choiced/family_mode, labelled[result])
	to_chat(user, span_purple("Family mode set to: [labelled[result]]"))
	to_chat(user, span_notice("\
		[FAMILY_NONE] — disabled.\n\
		[FAMILY_PARTIAL] — join a local house as a child or aunt/uncle.\n\
		[FAMILY_NEWLYWED] — get a spouse; setspouse takes priority.\n\
		[FAMILY_FULL] — become a house founder; setspouse blocks unknown matches.\
	"))
