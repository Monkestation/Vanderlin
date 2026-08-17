/datum/preference/list_type/role_setting/picker/accepted_species
	savefile_key = "accepted_species"
	savefile_identifier = PREF_CHARACTER
	category = "relations"
	can_randomize = FALSE
	setting_display_name = "Accepted Species"
	max_lines = 20
	is_role = FALSE
	should_apply = TRUE

/datum/preference/list_type/role_setting/picker/accepted_species/build_lists()
	if(!length(picker_options))
		for(var/species_type in GLOB.roundstart_species)
			picker_options |= GLOB.species_list[species_type]

/datum/preference/list_type/role_setting/picker/accepted_species/create_default_value()
	return list() // empty = no restriction

/datum/preference/list_type/role_setting/picker/accepted_species/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.accepted_family_species = value

/datum/preference/list_type/role_setting/picker/accepted_species/handle_link(datum/preferences/prefs, mob/user)
	var/list/species_options = list()
	for(var/id in GLOB.roundstart_species)
		var/species_type = GLOB.species_list[id]
		var/datum/species/S = new species_type()
		species_options[S.name] = "[species_type]"

	var/list/current = prefs.read_preference(/datum/preference/list_type/role_setting/picker/accepted_species)
	var/result = browser_input_list(user, "TOGGLE ACCEPTED SPECIES", "BLOOD OF MANY PEOPLES", species_options, null)
	if(!result)
		return

	var/chosen = species_options[result]
	if(chosen in current)
		current -= chosen
		to_chat(user, span_notice("Removed [result] from accepted species."))
	else
		current += chosen
		to_chat(user, span_notice("Added [result] to accepted species."))

	prefs.write_preference(/datum/preference/list_type/role_setting/picker/accepted_species, current)
