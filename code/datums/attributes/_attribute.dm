/datum/attribute
	/// Name of the attribute
	var/name = null
	/// Description of the attribute
	var/desc = "Alan, please add details."
	/// Icon
	var/icon = 'icons/ui_icons/attributes.dmi'
	/// Icon state
	var/icon_state = "none"

/datum/attribute/proc/description_from_level(level)
	return "FUCK"

/datum/attribute/proc/on_level_change(mob/owner, new_level, old_level)
	return
