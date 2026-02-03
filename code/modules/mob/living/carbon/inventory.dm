/mob/living/carbon/get_item_by_slot(slot_id)
	switch(slot_id)
		if(ITEM_SLOT_MASK)
			return wear_mask
		if(ITEM_SLOT_NECK)
			return wear_neck
		if(ITEM_SLOT_HEAD)
			return head
		if(ITEM_SLOT_HANDCUFFED)
			return handcuffed
		if(ITEM_SLOT_LEGCUFFED)
			return legcuffed
	return null

/mob/living/carbon/get_slot_by_item(obj/item/looking_for)
	if(looking_for == backr)
		return ITEM_SLOT_BACK_R

	if(looking_for == backl)
		return ITEM_SLOT_BACK_L

	if(backr && (looking_for in backr))
		return ITEM_SLOT_BACK_R

	if(backl && (looking_for in backl))
		return ITEM_SLOT_BACK_L

	if(looking_for == wear_mask)
		return ITEM_SLOT_MASK

	if(looking_for == wear_neck)
		return ITEM_SLOT_NECK

	if(looking_for == head)
		return ITEM_SLOT_HEAD

	if(looking_for == handcuffed)
		return ITEM_SLOT_HANDCUFFED

	if(looking_for == legcuffed)
		return ITEM_SLOT_LEGCUFFED

	return ..()

/mob/living/carbon/proc/equip_in_one_of_slots(obj/item/I, list/slots, qdel_on_fail = 1)
	for(var/slot in slots)
		if(equip_to_slot_if_possible(I, slots[slot], qdel_on_fail = 0, disable_warning = TRUE))
			return slot
	if(qdel_on_fail)
		qdel(I)
	return null

//This is an UNSAFE proc. Use mob_can_equip() before calling this one! Or rather use equip_to_slot_if_possible() or advanced_equip_to_slot_if_possible()
/mob/living/carbon/equip_to_slot(obj/item/equipping, slot, initial = FALSE, redraw_mob = FALSE)
	if(!slot)
		return
	if(!istype(equipping))
		return

	var/index = get_held_index_of_item(equipping)
	if(index)
		held_items[index] = null

	if(equipping.pulledby)
		equipping.pulledby.stop_pulling()

	equipping.screen_loc = null
	if(client)
		client.screen -= equipping
	if(observers && observers.len)
		for(var/mob/dead/observe as anything in observers)
			if(observe.client)
				observe.client.screen -= equipping
	equipping.forceMove(src)
	equipping.plane = ABOVE_HUD_PLANE
	equipping.appearance_flags |= NO_CLIENT_COLOR
	var/not_handled = FALSE
	switch(slot)
		if(ITEM_SLOT_MASK)
			if(wear_mask)
				return
			wear_mask = equipping
			wear_mask_update(equipping, toggle_off = 0)
		if(ITEM_SLOT_HEAD)
			if(head)
				return
			head = equipping
			head_update(equipping)
		if(ITEM_SLOT_NECK)
			if(wear_neck)
				return
			wear_neck = equipping
			update_inv_neck(equipping)
		if(ITEM_SLOT_HANDCUFFED)
			set_handcuffed(equipping)
			update_handcuffed()
		if(ITEM_SLOT_LEGCUFFED)
			if(legcuffed)
				return
			legcuffed = equipping
			update_inv_legcuffed()
		if(ITEM_SLOT_HANDS)
			put_in_hands(equipping)
			update_inv_hands()
		if(ITEM_SLOT_BACKPACK)
			not_handled = TRUE
			if(backr)
				if(SEND_SIGNAL(backr, COMSIG_TRY_STORAGE_INSERT, equipping, src, TRUE, !initial)) // If inital is true, item is from job datum and should be silent
					not_handled = FALSE
			if(backl && not_handled)
				if(SEND_SIGNAL(backl, COMSIG_TRY_STORAGE_INSERT, equipping, src, TRUE, !initial)) // If inital is true, item is from job datum and should be silent
					not_handled = FALSE

		else
			not_handled = TRUE

	//Item has been handled at this point and equipped callback can be safely called
	//We cannot call it for items that have not been handled as they are not yet correctly
	//in a slot (handled further down inheritance chain, probably living/carbon/human/equip_to_slot
	if(!not_handled)
		equipping.equipped(src, slot)

	if(hud_used)
		hud_used.throw_icon?.update_appearance(UPDATE_ICON_STATE)
		hud_used.give_intent?.update_appearance(UPDATE_ICON_STATE)

	return not_handled

/mob/living/carbon/doUnEquip(obj/item/I, force, newloc, no_move, invdrop = TRUE, silent = FALSE)
	. = ..() //Sets the default return value to what the parent returns.
	if(!. || !I) //We don't want to set anything to null if the parent returned 0.
		return

	if(I == head)
		head = null
		if(!QDELETED(src))
			head_update(I)
	else if(I == wear_mask)
		wear_mask = null
		if(!QDELETED(src))
			wear_mask_update(I, toggle_off = 1)
	if(I == wear_neck)
		wear_neck = null
		if(!QDELETED(src))
			update_inv_neck(I)
	else if(I == handcuffed)
		set_handcuffed(null)
		if(buckled && buckled.buckle_requires_restraints)
			buckled.unbuckle_mob(src)
		if(!QDELETED(src))
			update_handcuffed()
	else if(I == legcuffed)
		legcuffed = null
		remove_movespeed_modifier(MOVESPEED_ID_LEGCUFF_SLOWDOWN, TRUE)
		if(!QDELETED(src))
			update_inv_legcuffed()

//handle stuff to update when a mob equips/unequips a mask.
/mob/living/proc/wear_mask_update(obj/item/I, toggle_off = 1)
	update_inv_wear_mask()

/mob/living/carbon/wear_mask_update(obj/item/I, toggle_off = 1)
	var/obj/item/clothing/C = I
	if(istype(C) && (C.tint || initial(C.tint)))
		update_tint()
	update_inv_wear_mask()

//handle stuff to update when a mob equips/unequips a headgear.
/mob/living/carbon/proc/head_update(obj/item/I, forced)
	if(istype(I, /obj/item/clothing))
		var/obj/item/clothing/C = I
		if(C.tint || initial(C.tint))
			update_tint()
		update_sight()
	if(I.flags_inv & HIDEMASK || forced)
		update_inv_wear_mask()
	update_inv_head()

/mob/living/carbon/proc/get_holding_bodypart_of_item(obj/item/I)
	var/index = get_held_index_of_item(I)
	return index && hand_bodyparts[index]

//GetAllContents that is reasonable for carbons
/mob/living/carbon/proc/get_all_gear()
	var/list/processing_list = get_equipped_items(include_pockets = TRUE) + held_items
	listclearnulls(processing_list) // handles empty hands
	var/i = 0
	while(i < length(processing_list))
		var/atom/A = processing_list[++i]
		var/datum/component/storage/STR = A.GetComponent(/datum/component/storage)
		if(STR)
			processing_list += STR.return_inv(TRUE)
	return processing_list

/mob/living/carbon/proc/get_most_expensive()
	var/atom/movable/most_expensive = null
	var/price = 0
	for(var/atom/movable/atom in get_all_gear())
		if(atom.sellprice > price)
			most_expensive = atom
			price = atom.sellprice
	return most_expensive
