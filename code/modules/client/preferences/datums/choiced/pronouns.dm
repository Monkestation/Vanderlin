/datum/preference/choiced/pronouns
	savefile_key = "pronouns"
	savefile_identifier = PREF_CHARACTER
	category = "character"

/datum/preference/choiced/pronouns/init_possible_values(datum/preferences/prefs)
	return list(HE_HIM, SHE_HER, THEY_THEM, IT_ITS)

/datum/preference/choiced/pronouns/create_default_value(datum/preferences/prefs)
	return HE_HIM

/datum/preference/choiced/pronouns/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.pronouns = value

/datum/preference/choiced/pronouns/handle_link(datum/preferences/prefs, mob/user)
	var/list/allowed_pronouns = prefs.pref_species.allowed_pronouns
	if(!allowed_pronouns || !length(allowed_pronouns))
		// fallback to the default pronouns list
		allowed_pronouns = PRONOUNS_LIST

	if(length(allowed_pronouns) == 1)
		prefs.write_preference(/datum/preference/choiced/pronouns, allowed_pronouns[1])
		to_chat(user, span_warning("This species can only use [prefs.read_preference(/datum/preference/choiced/pronouns)]."))
		return

	var/pronouns_input = browser_input_list(user, "CHOOSE HOW MORTALS REFER TO YOUR HERO", "DISOBEY SOCIAL NORMS", allowed_pronouns)
	if(pronouns_input)
		prefs.write_preference(/datum/preference/choiced/pronouns, pronouns_input)
		to_chat(user, span_warning("Your character's pronouns are now [prefs.read_preference(/datum/preference/choiced/pronouns)]."))
