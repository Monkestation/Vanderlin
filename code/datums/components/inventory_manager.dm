/datum/component/ai_inventory_manager
	/// list(ai_item_category_flag = list(obj/item = slot_bitflag))
	var/alist/inventory_map

	/// list(slot_bitflag = obj/item), only slots containing a storage container
	var/alist/container_refs

	/// Cached flat list of all slot bitflags to iterate, built once
	var/static/alist/all_slot_flags

	/// What was in each hand before we drew a consumable, keyed by hand slot flag
	var/obj/item/cached_inactive_hand
	var/obj/item/cached_active_hand

/datum/component/ai_inventory_manager/Initialize(mapload)
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE

	_build_slot_flag_list()
	inventory_map = alist()
	for(var/ai_item_type in GLOB.ai_item_flags)
		inventory_map[ai_item_type] = list()

	container_refs = alist()

	RegisterSignal(parent, COMSIG_MOB_EQUIPPED_ITEM, PROC_REF(on_equip))
	RegisterSignal(parent, COMSIG_MOB_UNEQUIPPED_ITEM, PROC_REF(on_unequip))
	RegisterSignal(parent, COMSIG_MOB_DROPITEM, PROC_REF(on_drop))

	full_reappraise()

/datum/component/ai_inventory_manager/Destroy()
	for(var/slot in container_refs)
		UnregisterSignal(container_refs[slot], COMSIG_QDELETING)

	for(var/cat in inventory_map)
		for(var/obj/item/it as anything in inventory_map[cat])
			UnregisterSignal(it, COMSIG_QDELETING)

	container_refs = null
	inventory_map = null
	return ..()

/datum/component/ai_inventory_manager/proc/_build_slot_flag_list()
	if(all_slot_flags)
		return

	all_slot_flags = alist()
	for(var/i in 0 to SLOTS_AMT - 1)
		var/flag = (1 << i)
		if(flag & AI_INVENTORY_WATCHED_SLOTS)
			all_slot_flags += flag

/datum/component/ai_inventory_manager/proc/full_reappraise()
	var/mob/living/carbon/human/managing = parent

	for(var/slot in container_refs)
		UnregisterSignal(container_refs[slot], COMSIG_QDELETING)
	container_refs = alist()
	for(var/cat in inventory_map)
		for(var/obj/item/it as anything in inventory_map[cat])
			UnregisterSignal(it, COMSIG_QDELETING)
		inventory_map[cat] = list()

	for(var/slot_flag in all_slot_flags)
		var/obj/item/candidate = managing.get_item_by_slot(slot_flag)
		if(!candidate)
			continue
		_try_register_container(slot_flag, candidate)
		if(!candidate.atom_storage)
			_classify_item(candidate, slot_flag)

	for(var/slot_flag in container_refs)
		var/obj/item/container = container_refs[slot_flag]
		var/datum/storage/storage = container.atom_storage
		if(storage)
			_appraise_storage(storage, slot_flag)

/// Scan inside a single storage component and classify contents
/datum/component/ai_inventory_manager/proc/_appraise_storage(datum/storage/storage, slot_flag)
	for(var/obj/item/item in storage.return_inv(FALSE))
		_classify_item(item, slot_flag)

/// Register a container slot and watch it for deletion
/datum/component/ai_inventory_manager/proc/_try_register_container(slot_flag, obj/item/candidate)
	if(!candidate.atom_storage)
		return

	container_refs[slot_flag] = candidate

	RegisterSignal(candidate, COMSIG_QDELETING, PROC_REF(on_container_delete), override = TRUE)
	RegisterSignal(candidate, COMSIG_STORAGE_STORED_ITEM, PROC_REF(on_storage_added), override = TRUE)

/datum/component/ai_inventory_manager/proc/on_storage_added(datum/source, obj/item/inserted)
	SIGNAL_HANDLER

	for(var/slot_flag in container_refs)
		if(container_refs[slot_flag] == source)
			_classify_item(inserted, slot_flag)
			return

/// Classify a single item into all matching categories
/datum/component/ai_inventory_manager/proc/_classify_item(obj/item/item, slot_flag)
	RegisterSignal(item, COMSIG_QDELETING, PROC_REF(on_item_delete), override = TRUE)

	for(var/ai_flag in GLOB.ai_item_flags)
		if(ai_flag & item.flags_ai_inventory)
			inventory_map[ai_flag][item] = slot_flag

/datum/component/ai_inventory_manager/proc/on_equip(datum/source, obj/item/equipment, slot)
	SIGNAL_HANDLER

	if(!(slot & AI_INVENTORY_WATCHED_SLOTS))
		return

	// Partial rescan: just this slot
	_purge_slot(slot)
	_try_register_container(slot, equipment)

	var/datum/storage/storage = equipment.atom_storage
	if(storage)
		_appraise_storage(storage, slot)
	else
		_classify_item(equipment, slot)

/datum/component/ai_inventory_manager/proc/on_unequip(datum/source, obj/item/equipment, slot)
	SIGNAL_HANDLER

	if(!(slot & AI_INVENTORY_WATCHED_SLOTS))
		return

	_purge_slot(slot)
	if(slot in container_refs)
		UnregisterSignal(container_refs[slot], COMSIG_QDELETING)
		container_refs -= slot

/datum/component/ai_inventory_manager/proc/on_drop(datum/source, obj/item/dropped)
	SIGNAL_HANDLER

	_remove_item(dropped)

/datum/component/ai_inventory_manager/proc/on_item_delete(datum/source, force)
	SIGNAL_HANDLER

	UnregisterSignal(source, COMSIG_QDELETING)
	_remove_item(source)

/datum/component/ai_inventory_manager/proc/on_container_delete(datum/source, force)
	SIGNAL_HANDLER

	for(var/slot_flag in container_refs)
		if(container_refs[slot_flag] == source)
			_purge_slot(slot_flag)
			container_refs -= slot_flag
			return

/// Remove all inventory_map entries for a given slot bitflag
/datum/component/ai_inventory_manager/proc/_purge_slot(slot_flag)
	for(var/category in inventory_map)
		for(var/obj/item/item as anything in inventory_map[category])
			if(inventory_map[category][item] == slot_flag)
				UnregisterSignal(item, COMSIG_QDELETING)
				inventory_map[category] -= item

/datum/component/ai_inventory_manager/proc/_remove_item(obj/item/item)
	UnregisterSignal(item, COMSIG_QDELETING)

	for(var/category in inventory_map)
		if(item in inventory_map[category])
			inventory_map[category] -= item

/datum/component/ai_inventory_manager/proc/get_item(category)
	RETURN_TYPE(/obj/item)
	var/list/items = inventory_map[category]

	if(!length(items))
		return null

	return items[1]

/datum/component/ai_inventory_manager/proc/get_item_slot(obj/item/item, category)
	return inventory_map[category]?[item]

/datum/component/ai_inventory_manager/proc/find_space_for(obj/item/to_stow)
	for(var/slot_flag in container_refs)
		var/obj/item/container = container_refs[slot_flag]
		var/datum/storage/storage = container.atom_storage
		if(storage.can_insert(to_stow, messages = FALSE))
			return slot_flag
	return 0

/datum/component/ai_inventory_manager/proc/draw_item(obj/item/drawn_item, category)
	var/mob/living/carbon/human/managing = parent

	cached_active_hand = managing.get_active_held_item()
	cached_inactive_hand = managing.get_inactive_held_item()

	if(istype(cached_active_hand, /obj/item/offhand))
		var/datum/component/two_handed/twohanded = cached_inactive_hand.GetComponent(/datum/component/two_handed)
		twohanded.unwield(managing)
		cached_active_hand = null

	if(istype(cached_inactive_hand, /obj/item/offhand))
		var/datum/component/two_handed/twohanded = cached_active_hand.GetComponent(/datum/component/two_handed)
		twohanded.unwield(managing)
		cached_inactive_hand = null

	if(!_make_hand_free())
		return FALSE

	var/slot_flag = get_item_slot(drawn_item, category)
	if(!slot_flag)
		return FALSE

	var/obj/item/container = container_refs[slot_flag]
	if(!container)
		return FALSE

	var/datum/storage/storage = container.atom_storage
	if(!storage)
		return FALSE
	storage.attempt_remove(drawn_item, get_turf(managing))

	return managing.put_in_active_hand(drawn_item)

/datum/component/ai_inventory_manager/proc/restore_hands()
	if(!cached_active_hand && !cached_inactive_hand)
		return
	var/mob/living/carbon/human/managing = parent

	var/obj/item/active   = managing.get_active_held_item()
	var/obj/item/inactive = managing.get_inactive_held_item()

	// Snapshot and clear FIRST to prevent reentrant calls from re-running
	var/obj/item/want_active = cached_active_hand
	var/obj/item/want_inactive = cached_inactive_hand
	cached_active_hand = null
	cached_inactive_hand = null

	if(active && active != want_active && active != want_inactive)
		if(!stow_item(active))
			managing.dropItemToGround(active)

	if(inactive && inactive != want_active && inactive != want_inactive)
		if(!stow_item(inactive))
			managing.dropItemToGround(inactive)

	if(want_active && !managing.get_active_held_item())
		managing.put_in_active_hand(want_active)

	if(want_inactive && !managing.get_inactive_held_item())
		managing.swap_hand()
		managing.put_in_active_hand(want_inactive)
		managing.swap_hand()

/datum/component/ai_inventory_manager/proc/_make_hand_free()
	var/mob/living/carbon/human/managing = parent
	if(!managing.get_active_held_item())
		return TRUE
	managing.swap_hand()
	if(!managing.get_active_held_item())
		return TRUE
	var/obj/item/blocking = managing.get_active_held_item()
	if(stow_item(blocking))
		return TRUE
	managing.dropItemToGround(blocking)
	return TRUE

/datum/component/ai_inventory_manager/proc/stow_item(obj/item/stowed)
	var/mob/living/carbon/human/managing = parent
	if(stowed.loc != managing)
		return FALSE
	var/slot_flag = find_space_for(stowed)
	if(!slot_flag)
		return FALSE
	var/obj/item/container = container_refs[slot_flag]
	var/datum/storage/storage = container.atom_storage
	if(storage.attempt_insert(stowed, managing))
		_classify_item(stowed, slot_flag)
	return TRUE

/// Remove an empty container from inventory tracking and drop it on the ground
/datum/component/ai_inventory_manager/proc/drop_empty_container(obj/item/reagent_containers/container)
	var/mob/living/carbon/human/managing = parent
	_remove_item(container)

	if(container.loc == managing)
		managing.dropItemToGround(container)
		return

	for(var/slot_flag in container_refs)
		var/obj/item/storage_item = container_refs[slot_flag]
		var/datum/storage/storage = storage_item.atom_storage
		if(!storage)
			continue
		if(container in storage.return_inv(FALSE))
			storage.attempt_remove(container, get_turf(managing))
			break

/// Returns the actual usable item (may differ from what's in inventory_map)
/datum/component/ai_inventory_manager/proc/draw_usable_item(obj/item/drawn_item, category)
	var/mob/living/carbon/human/managing = parent

	if(istype(drawn_item, /obj/item/natural/bundle))
		var/obj/item/natural/bundle/bundle = drawn_item

		if(!bundle.stacktype || bundle.amount <= 0)
			return null

		// by spawning the stacktype item and putting it in hand (we don't use the actual handler because of random npc bs)
		if(!_make_hand_free())
			return null

		var/turf/T = get_turf(managing)
		var/obj/item/extracted = new bundle.stacktype(T)

		if(!managing.put_in_active_hand(extracted))
			qdel(extracted)
			return null

		if(bundle.amount == 1)
			_remove_item(bundle)
			var/slot_flag = null
			for(var/sf in container_refs)
				var/obj/slot = container_refs[sf]
				var/datum/storage/storage = slot.atom_storage
				if(storage && storage.return_inv(FALSE))
					slot_flag = sf
					break
			if(slot_flag)
				var/obj/item = container_refs[slot_flag]
				var/datum/storage/storage = item.atom_storage
				storage?.attempt_remove(bundle, get_turf(managing))
			qdel(bundle)
		else
			bundle.amount--
			bundle.update_bundle()

		return extracted

	if(!draw_item(drawn_item, category))
		return null

	return drawn_item
