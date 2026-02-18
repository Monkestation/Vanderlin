//////////////////////////
/////Initial Building/////
//////////////////////////

/proc/make_datum_references_lists()
	init_quirk_registry()
	//underwear
	init_sprite_accessory_subtypes(/datum/sprite_accessory/underwear, GLOB.underwear_list, GLOB.underwear_m, GLOB.underwear_f)
	//undershirt
	init_sprite_accessory_subtypes(/datum/sprite_accessory/undershirt, GLOB.undershirt_list, GLOB.undershirt_m, GLOB.undershirt_f)

	//Species
	for(var/datum/species/species as anything in subtypesof(/datum/species))
		species = new species()
		GLOB.species_list[species.id] = species.type

		if(species.check_roundstart_eligible())
			GLOB.roundstart_species += species.id

	sortTim(GLOB.species_list, GLOBAL_PROC_REF(cmp_text_dsc))
	sortTim(GLOB.roundstart_species, GLOBAL_PROC_REF(cmp_text_dsc))

	//Surgery steps
	for(var/path in subtypesof(/datum/surgery_step))
		GLOB.surgery_steps += new path()
	sortTim(GLOB.surgery_steps, GLOBAL_PROC_REF(cmp_typepaths_asc))

	//Surgeries
	for(var/path in subtypesof(/datum/surgery))
		GLOB.surgeries_list += new path()
	sortTim(GLOB.surgeries_list, GLOBAL_PROC_REF(cmp_typepaths_asc))

	// Keybindings
	init_keybindings()

	init_molten_recipes()
	init_slapcraft_steps()
	init_slapcraft_recipes()
	init_curse_names()

	GLOB.emote_list = init_emote_list()

	// Faiths
	for(var/datum/faith/faith as anything in subtypesof(/datum/faith))
		if(IS_ABSTRACT(faith))
			continue

		faith = new faith()
		GLOB.faith_list[faith.type] = faith

	// Inquisition Hermes list
	for(var/path in subtypesof(/datum/inqports)) // Why is this here
		var/datum/inqports/inqports = new path()
		GLOB.inqsupplies[path] = inqports

	// Patron Gods
	for(var/datum/patron/patron as anything in subtypesof(/datum/patron))
		if(IS_ABSTRACT(patron))
			continue

		patron = new patron()

		GLOB.patron_list[patron.type] = patron

		LAZYINITLIST(GLOB.patrons_by_faith[patron.associated_faith])

		GLOB.patrons_by_faith[patron.associated_faith][patron.type] = patron

//creates every subtype of prototype (excluding prototype) and adds it to list L.
//if no list/L is provided, one is created.
/proc/init_subtypes(prototype, list/L)
	if(!istype(L))
		L = list()
	for(var/path in subtypesof(prototype))
		L += new path()
	return L

//returns a list of paths to every subtype of prototype (excluding prototype)
//if no list/L is provided, one is created.
/proc/init_paths(prototype, list/L)
	if(!istype(L))
		L = list()
		for(var/path in subtypesof(prototype))
			L+= path
		return L

/// Functions like init_subtypes, but uses the subtype's path as a key for easy access
/proc/init_subtypes_w_path_keys(prototype, list/L)
	if(!istype(L))
		L = list()
	for(var/path as anything in subtypesof(prototype))
		L[path] = new path()
	return L

/proc/init_curse_names()
	GLOB.curse_names = list()
	for(var/datum/curse/curse_type as anything in subtypesof(/datum/curse))
		if(IS_ABSTRACT(curse_type))
			continue
		GLOB.curse_names |= initial(curse_type.name)
		GLOB.curse_names[initial(curse_type.name)] = new curse_type
