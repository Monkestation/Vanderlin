/datum/essence_storage
	var/list/stored_essences = list() // essence_type = amount
	var/max_total_capacity = 100
	var/max_essence_types = 10
	var/atom/parent_atom // Reference to the object this storage belongs to

/datum/essence_storage/New(atom/parent)
	. = ..()
	if(parent)
		parent_atom = parent

/datum/essence_storage/Destroy(force)
	parent_atom = null
	return ..()

/datum/essence_storage/proc/add_essence(essence_type, amount)
	var/current_total = get_total_stored()
	if(current_total + amount > max_total_capacity)
		return FALSE // Not enough space
	if(stored_essences.len >= max_essence_types && !stored_essences[essence_type])
		return FALSE // Too many essence types

	var/was_new_type = !stored_essences[essence_type]

	if(stored_essences[essence_type])
		stored_essences[essence_type] += amount
	else
		stored_essences[essence_type] = amount

	update_icon_and_overlays()

	on_essence_added(essence_type, amount, was_new_type)

	return TRUE

/datum/essence_storage/proc/remove_essence(essence_type, amount)
	if(!stored_essences[essence_type] || stored_essences[essence_type] < amount)
		return 0

	stored_essences[essence_type] -= amount
	var/was_removed_completely = FALSE

	if(stored_essences[essence_type] <= 0)
		stored_essences -= essence_type
		was_removed_completely = TRUE

	update_icon_and_overlays()
	on_essence_removed(essence_type, amount, was_removed_completely)

	return amount

/datum/essence_storage/proc/get_essence_amount(essence_type)
	return stored_essences[essence_type] || 0

/datum/essence_storage/proc/get_total_stored()
	var/total = 0
	for(var/essence_type in stored_essences)
		total += stored_essences[essence_type]
	return total

/datum/essence_storage/proc/get_available_space()
	return max_total_capacity - get_total_stored()

/datum/essence_storage/proc/has_essence(essence_type, amount = 1)
	return get_essence_amount(essence_type) >= amount

/datum/essence_storage/proc/transfer_to(datum/essence_storage/target, essence_type, amount)
	if(!has_essence(essence_type, amount))
		return 0

	var/transferred = remove_essence(essence_type, amount)
	if(transferred > 0)
		if(!target.add_essence(essence_type, transferred))
			add_essence(essence_type, transferred)
			return 0

		on_essence_transferred_out(essence_type, transferred, target)
		target.on_essence_transferred_in(essence_type, transferred, src)

	return transferred

/datum/essence_storage/proc/update_icon_and_overlays()
	if(!parent_atom)
		return
	parent_atom.update_appearance(UPDATE_ICON)

/datum/essence_storage/proc/on_essence_added(essence_type, amount, was_new_type)
	parent_atom.on_transfer_in(essence_type, amount, null)

/datum/essence_storage/proc/on_essence_removed(essence_type, amount, was_removed_completely)

/datum/essence_storage/proc/on_essence_transferred_out(essence_type, amount, datum/essence_storage/target)

/datum/essence_storage/proc/on_essence_transferred_in(essence_type, amount, datum/essence_storage/source)
	parent_atom.on_transfer_in(essence_type, amount, source)

/datum/essence_storage/proc/force_visual_update()
	update_icon_and_overlays()

/datum/essence_storage/proc/set_parent(atom/new_parent)
	parent_atom = new_parent
	update_icon_and_overlays()
