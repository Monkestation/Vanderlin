GLOBAL_LIST_EMPTY(faith_list)

/datum/faith
	abstract_type = /datum/faith
	/// Name of the faith
	var/name
	/// Description of the faith
	var/desc = "A faith that believes in the power of reporting this issue on GitHub - You shouldn't be seeing this, someone forgot to set the description for this faith."
	/// Our "primary" patron god
	var/datum/patron/godhead = null

/datum/faith/proc/preference_accessible(datum/preferences/prefs)
	// Check if there is a patron we can use
	var/list/patrons = GLOB.patrons_by_faith[type]

	if(!length(patrons))
		return FALSE

	for(var/datum/patron/patron as anything in patrons)
		patron = GLOB.patron_list[patron]

		if(patron.preference_accessible(prefs))
			return TRUE

	return FALSE
