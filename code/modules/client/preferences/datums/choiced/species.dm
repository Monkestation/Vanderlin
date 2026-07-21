/datum/preference/choiced/species
	savefile_key = "species"
	savefile_identifier = PREF_CHARACTER
	category = "character"
	priority = PREF_PRIORITY_SPECIES

/datum/preference/choiced/species/init_possible_values(datum/preferences/prefs)
	var/list/out = list()
	for (var/id in GLOB.species_list)
		out += GLOB.species_list[id]
	return out

/datum/preference/choiced/species/apply_to_client(client/C, value)
	C.prefs.pref_species = new value

/datum/preference/choiced/species/create_default_value(datum/preferences/prefs)
	return /datum/species/human/northern

/datum/preference/choiced/species/serialize(input)
	if (ispath(input))
		var/datum/species/S = new input
		return S.id
	if (istype(input, /datum/species))
		var/datum/species/spec = input
		return spec.id
	return "[input]"

/datum/preference/choiced/species/deserialize(input, datum/preferences/prefs)
	var/species_type = GLOB.species_list[input]
	if (!species_type)
		species_type = /datum/species/human/northern
	return species_type

/datum/preference/choiced/species/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.set_species(value, FALSE, prefs)

/datum/preference/choiced/species/handle_link(datum/preferences/prefs, mob/user)
	prefs.write_preference(/datum/preference/choiced/selected_accent, ACCENT_DEFAULT)

	var/list/selectable = list()
	for(var/species_id in GLOB.roundstart_species)
		var/species_type = GLOB.species_list[species_id]

		var/datum/species/species = new species_type()
		if(!species.preference_accessible(prefs))
			continue

		selectable[species.name] = species.type

	var/result = browser_input_list(user, "SELECT YOUR HERO'S PEOPLE:", "VANDERLIN FAUNA", selectable, prefs.pref_species)

	if(result)
		var/species_type = selectable[result]

		prefs.pref_species = new species_type()

		to_chat(user, "<em>[prefs.pref_species.name]</em>")
		if(prefs.pref_species.desc)
			to_chat(user, "[prefs.pref_species.desc]")

		if(!length(prefs.pref_species.allowed_pronouns))
			to_chat(user, span_warning("This species does not have any allowed pronouns. Please contact a coder to add them."))
		else if (length(prefs.pref_species.allowed_pronouns) == 1)
			prefs.write_preference(/datum/preference/choiced/pronouns, prefs.pref_species.allowed_pronouns[1])
		else if(!(prefs.read_preference(/datum/preference/choiced/pronouns) in prefs.pref_species.allowed_pronouns))
			prefs.write_preference(/datum/preference/choiced/pronouns, prefs.pref_species.allowed_pronouns[1])

		//Now that we changed our species, we must verify that the mutant colour is still allowed.
		prefs.write_preference(/datum/preference/text/real_name, prefs.pref_species.random_name(prefs.read_preference(/datum/preference/choiced/gender), TRUE))
		prefs.reset_jobs(user)
		prefs.reset_patron(user)
		prefs.reset_culture(user)
		prefs.write_preference(/datum/preference/choiced/species, prefs.pref_species.id)
		prefs.randomise_appearance_prefs(~(RANDOMIZE_SPECIES))
		prefs.customizer_entries = list()
		prefs.validate_customizer_entries()
		prefs.reset_all_customizer_accessory_colors()
		prefs.randomize_all_customizer_accessories()
		prefs.write_preference(/datum/preference/choiced/accessory, "Nothing")
