
/datum/runerituals
	abstract_type = /datum/runerituals
	var/category = "Rituals"
	var/name
	var/desc
	/// Assoc list of [typepath or list of typepaths] = count required
	var/list/required_atoms = list()
	/// Typepaths spawned at the ritual location on success (used by the base on_finished_recipe)
	var/list/result_atoms = list()
	/// Typepaths that are never matched even if they satisfy a required_atoms entry
	var/list/banned_atom_types = list()
	/// For summoning rituals: the mob typepath (or instance) to summon
	var/mob_to_summon
	/// If TRUE, this ritual is hidden from all player-facing lists
	var/blacklisted = FALSE
	/// Tier of this ritual. Used to gate availability based on the rune's tier.
	var/tier = 0

/// Called when all ingredients are present and the ritual fires.
/// Return a truthy value on success, FALSE on failure.
/datum/runerituals/proc/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	if(!length(result_atoms))
		return FALSE
	for(var/result in result_atoms)
		new result(loc)
	return TRUE

/// Returns a display string for a single required item typepath.
/datum/runerituals/proc/parse_required_item(atom/item_path, number_of_things = 1)
	if(ispath(item_path, /mob/living/carbon/human))
		return "bod[number_of_things > 1 ? "ies" : "y"]"
	if(ispath(item_path, /mob/living))
		return "carcass[number_of_things > 1 ? "es" : ""] of any kind"
	return "[initial(item_path.name)]\s"

/**
 * Deletes all non-living atoms in selected_atoms after a successful ritual.
 * To preserve a specific atom, remove it from selected_atoms before calling.
 */
/datum/runerituals/proc/cleanup_atoms(list/selected_atoms)
	SHOULD_CALL_PARENT(TRUE)
	for(var/atom/A as anything in selected_atoms)
		if(isliving(A))
			continue
		selected_atoms -= A
		qdel(A)
