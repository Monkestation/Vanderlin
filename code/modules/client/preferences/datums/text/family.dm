/datum/preference/text/family
	savefile_key = "family"
	savefile_identifier = PREF_CHARACTER
	category = "character"
	can_randomize = FALSE
	maximum_value_length = MAX_NAME_LEN

/datum/preference/text/family/create_default_value(datum/preferences/prefs)
	return FAMILY_NONE

/datum/preference/text/family/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.familytree_pref = value

/datum/preference/text/family/handle_link(datum/preferences/prefs, mob/user)
	var/list/famtree_options_list = list(FAMILY_NONE, FAMILY_PARTIAL, FAMILY_NEWLYWED, FAMILY_FULL, "EXPLAIN THIS TO ME")
	var/new_family = browser_input_list(user, "SELECT YOUR HERO'S BOND", "BLOOD IS THICKER THAN WATER", famtree_options_list, prefs.read_preference(/datum/preference/text/family))
	if(new_family == "EXPLAIN THIS TO ME")
		to_chat(user, span_purple("\
		--[FAMILY_NONE] will disable this feature.<br>\
		--[FAMILY_PARTIAL] will assign you as a progeny of a local house based on your species. This feature will instead assign you as a aunt or uncle to a local family if your older than ADULT.<br>\
		--[FAMILY_NEWLYWED] assigns you a spouse without adding you to a family. Setspouse will prioritize pairing you with another newlywed with the same name as your setspouse.<br>\
		--[FAMILY_FULL] will attempt to assign you as matriarch or patriarch of one of the local houses of the kingdom/town. Setspouse will will prevent \
		players with the setspouse = None from matching with you unless their name equals your setspouse."))

	else if(new_family)
		prefs.write_preference(/datum/preference/text/family, new_family)
