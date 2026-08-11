/**
 * Storage for storing organs
 *
 * The chest and the head will have this to store all organs, this replaces organ removal and insertion surgeries.
 */
/datum/storage/organ
	boxes_type = /atom/movable/screen/storage/organ
	closer_type = /atom/movable/screen/close/organ

	animated = FALSE

	screen_max_columns = 2
	screen_max_rows = 6

	// Emulate old storage
	grid_width_override = 32
	grid_height_override = 32
	does_hover = FALSE

	rustle_sound = list('sound/gore/organ1.ogg', 'sound/gore/organ2.ogg')

/datum/storage/organ/mouth
	screen_max_columns = 1
	screen_max_rows = 3

/datum/storage/organ/head
	screen_max_columns = 2
	screen_max_rows = 4

/datum/storage/organ/New(atom/parent, screen_max_rows, screen_max_columns, max_slots, max_specific_storage, max_total_storage, surgery_requirements)
	if(!isbodypart(parent))
		stack_trace("Storage datum ([type]) created with a [isnull(parent) ? "null parent" : "invalid parent ([parent.type])"]!")
		qdel(src)
		return
	return ..()

// Due to bodyparts moving, opening when attached to a mob with be handled by carbon mousedrop.
// All direct access (ie bodyparts) on floor will be handled here.

// The below two overrides are due to embedded objects, simply we do not want to put them inside or show them in the storage.
// This would be an issue for any storages placed on bodyparts but I chose to only handle in organ storage
// as doing otherwise would slow down every storage, we can cross that bridge when or if we need to.

/datum/storage/organ/handle_enter(datum/source, obj/item/arrived)
	if(arrived.is_embedded)
		return
	return ..()

/datum/storage/organ/return_inv(recursive)
	var/list/ret = list()

	// Bodyparts should only contain items if they don't something is wrong
	for(var/obj/item/found_item in real_location)
		if(!(found_item.item_flags & IN_STORAGE))
			continue

		ret |= found_item
		if(recursive && found_item.atom_storage)
			ret |= found_item.atom_storage.return_inv(recursive = TRUE)

	return ret

/datum/storage/organ/can_interact(mob/user, messages)
	// no parent call as equipped access doesn't apply
	var/obj/item/bodypart/container = parent
	return container.return_surgical_state() & SURGERY_SKIN_OPEN

// This isn't can_interact since external organs ignore it
/// Returns true if the bodypart is not bone encased or the bone is sawn
/datum/storage/organ/proc/cavity_accessible()
	var/obj/item/bodypart/container = parent
	if(!(container.bodypart_flags & BODYPART_BONE_ENCASED))
		return TRUE

	return (container.return_surgical_state() & SURGERY_BONE_SAWED)

/datum/storage/organ/can_insert(obj/item/to_insert, mob/user, messages, force, list/modifiers)
	. = ..()
	if(!.)
		return

	if(!cavity_accessible())
		if(messages)
			user.balloon_alert(user, "bone in the way!")
		return FALSE

	var/obj/item/bodypart/container = parent
	var/organ_volume = container.get_cavity_volume()

	if(container.max_cavity_volume && (organ_volume + to_insert.w_class >= container.max_cavity_volume))
		if(messages)
			user.balloon_alert(user, "cavity full!")
		return FALSE

	if(container.max_cavity_item_size && (to_insert.w_class > container.max_cavity_item_size))
		if(messages)
			user.balloon_alert(user, "too large!")
		return FALSE

/datum/storage/organ/can_remove(obj/item/to_remove, mob/user, messages)
	. = ..()
	if(!.)
		return

	if(!isorgan(to_remove))
		if(!cavity_accessible())
			if(messages)
				user.balloon_alert(user, "bone in the way!")
			return FALSE
		return TRUE

	var/obj/item/organ/removed_organ = to_remove
	if(!(removed_organ.organ_flags & ORGAN_EXTERNAL) && !cavity_accessible())
		if(messages)
			user.balloon_alert(user, "bone in the way!")
		return FALSE
	if(!(removed_organ.organ_flags & ORGAN_CUT_AWAY))
		if(messages)
			user.balloon_alert(user, "not cut away!")
		return FALSE

// We force items to act like 1 x 1 grid objects so we only need a single overlay
/datum/storage/organ/get_bound_underlay(grid_width, grid_height, enchanted)
	return mutable_appearance(boxes.icon, "organ_block_red", layer = boxes.layer + 0.01, plane = boxes.plane)
