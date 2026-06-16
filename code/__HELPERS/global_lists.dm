//////////////////////////
/////Initial Building/////
//////////////////////////

/proc/make_datum_reference_lists()
	// Keybindings
	init_keybindings()

//creates every subtype of prototype (excluding prototype) and adds it to list L.
//if no list/L is provided, one is created.
/proc/init_subtypes(prototype, list/L, allow_abstract = TRUE)
	if(!istype(L))
		L = list()
	for(var/datum/path as anything in subtypesof(prototype))
		if(!allow_abstract && IS_ABSTRACT(path))
			continue
		L += new path()
	return L

//returns a list of paths to every subtype of prototype (excluding prototype)
//if no list/L is provided, one is created.
/proc/init_paths(prototype, list/L, allow_abstract = TRUE)
	if(!istype(L))
		L = list()
		for(var/datum/path as anything in subtypesof(prototype))
			if(!allow_abstract && IS_ABSTRACT(path))
				continue
			L += path
		return L

/// Functions like init_subtypes, but uses the subtype's path as a key for easy access
/proc/init_subtypes_w_path_keys(prototype, list/L, allow_abstract = TRUE)
	if(!istype(L))
		L = list()
	for(var/datum/path as anything in subtypesof(prototype))
		if(!allow_abstract && IS_ABSTRACT(path))
			continue
		L[path] = new path()
	return L
