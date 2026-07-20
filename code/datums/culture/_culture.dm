/// Cultural background for character prefs
/datum/culture
	abstract_type = /datum/culture
	var/name = "culture"
	var/description = "A culture"
	/// string to add before examine strings, should include spaces
	var/pre_append = ""

/// If selectable based on preferences (remove when datumised prefs)
/datum/culture/proc/is_selectable(datum/preferences/prefs)
	return TRUE

/// Returned string for [human/examine()]
/datum/culture/proc/examined_string(mob/living/carbon/human/examined, mob/examiner)
	return "[pre_append][name]"

/// After job spawn we can do something, called from [job/after_spawn()]
/datum/culture/proc/on_after_spawn(mob/living/carbon/human/spawned)
	return

/// Cultures always available
/// basically a stub for subtype iteration
/datum/culture/universal
	abstract_type = /datum/culture/universal
	name = "univerisal culture"
	description = "A universal culture"

/// A culture associated with specific species
/datum/culture/species
	abstract_type = /datum/culture/species
	name = "species culture"
	description = "A species culture"
	var/list/species = list()

/datum/culture/species/is_selectable(datum/preferences/prefs)
	if(!length(species) || !prefs?.pref_species)
		return FALSE
	return prefs.pref_species.id in species
