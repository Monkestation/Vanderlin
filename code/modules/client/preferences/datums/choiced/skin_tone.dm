/datum/preference/choiced/skin_tone
	savefile_key = "skin_tone"
	savefile_identifier = PREF_CHARACTER
	category = "appearance"
	can_randomize = TRUE

/datum/preference/choiced/skin_tone/init_possible_values(datum/preferences/prefs)
	// Flatten the assoc list returned by get_skin_list() into a plain list of
	// skin-tone values (the right-hand side of each entry).
	var/datum/species/base_species = /datum/species/human/northern
	if(prefs)
		base_species = prefs.read_preference(/datum/preference/choiced/species)
	var/list/skins = list()
	var/datum/species/S = new base_species
	var/list/assoc = S.get_skin_list()
	for (var/k in assoc)
		skins |= assoc[k]
	qdel(S)
	return skins

/datum/preference/choiced/skin_tone/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.skin_tone = value
	H.update_body()

/datum/preference/choiced/skin_tone/handle_link(datum/preferences/prefs, mob/user)
	var/list/listy = prefs.pref_species.get_skin_list()
	var/new_s_tone = browser_input_list(user, "CHOOSE YOUR HERO'S [uppertext(prefs.pref_species.skin_tone_wording)]", "THE SUN", listy)
	if(new_s_tone)
		prefs.write_preference(/datum/preference/choiced/skin_tone, listy[new_s_tone])
