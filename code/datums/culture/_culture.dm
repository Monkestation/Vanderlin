// Cultural background for character prefs
/datum/culture
	abstract_type = /datum/culture
	var/name = "culture"
	var/description = "A culture"
	/// string to add before examine strings, should include spaces
	var/pre_append = ""

/datum/culture/proc/is_selectable(datum/preferences/prefs)
	return TRUE

/datum/culture/proc/examined_string()
	return "[pre_append][name]"

// basically a stub for subtype iteration
/datum/culture/universal
	abstract_type = /datum/culture/universal
	name = "univerisal culture"
	description = "A universal culture"

// A culture associated with specific species
/datum/culture/species
	abstract_type = /datum/culture/species
	name = "species culture"
	description = "A species culture"
	var/list/species = list()

/datum/culture/species/is_selectable(datum/preferences/prefs)
	if(!prefs?.pref_species || !length(species))
		return FALSE
	return prefs.pref_species.id in species
