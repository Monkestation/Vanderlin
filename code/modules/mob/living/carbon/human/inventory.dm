/mob/living/carbon/human/can_equip(obj/item/I, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	return dna?.species?.can_equip(I, slot, disable_warning, src, bypass_equip_delay_self)

// Return the item currently in the slot ID
/mob/living/carbon/human/get_item_by_slot(slot_id)
	switch(slot_id)
		if(ITEM_SLOT_MASK)
			return wear_mask
		if(ITEM_SLOT_NECK)
			return wear_neck
		if(ITEM_SLOT_HANDCUFFED)
			return handcuffed
		if(ITEM_SLOT_LEGCUFFED)
			return legcuffed
		if(ITEM_SLOT_BELT)
			return belt
		if(ITEM_SLOT_RING)
			return wear_ring
		if(ITEM_SLOT_WRISTS)
			return wear_wrists
		if(ITEM_SLOT_MOUTH)
			return mouth
		if(ITEM_SLOT_SHIRT)
			return wear_shirt
		if(ITEM_SLOT_CLOAK)
			return cloak
		if(ITEM_SLOT_BACK_R)
			return backr
		if(ITEM_SLOT_BACK_L)
			return backl
		if(ITEM_SLOT_BELT_L)
			return beltl
		if(ITEM_SLOT_BELT_R)
			return beltr
		if(ITEM_SLOT_GLOVES)
			return gloves
		if(ITEM_SLOT_HEAD)
			return head
		if(ITEM_SLOT_SHOES)
			return shoes
		if(ITEM_SLOT_ARMOR)
			return wear_armor
		if(ITEM_SLOT_PANTS)
			return wear_pants
	return null

/mob/living/carbon/human/get_slot_by_item(obj/item/looking_for)
	if(looking_for == wear_mask)
		return ITEM_SLOT_MASK

	if(looking_for == wear_neck)
		return ITEM_SLOT_NECK

	if(looking_for == handcuffed)
		return ITEM_SLOT_HANDCUFFED

	if(looking_for == legcuffed)
		return ITEM_SLOT_LEGCUFFED

	if(looking_for == belt)
		return ITEM_SLOT_BELT

	if(looking_for == wear_ring)
		return ITEM_SLOT_RING

	if(looking_for == wear_wrists)
		return ITEM_SLOT_WRISTS

	if(looking_for == mouth)
		return ITEM_SLOT_MOUTH

	if(looking_for == wear_shirt)
		return ITEM_SLOT_SHIRT

	if(looking_for == cloak)
		return ITEM_SLOT_CLOAK

	if(looking_for == backr)
		return ITEM_SLOT_BACK_R

	if(looking_for == backl)
		return ITEM_SLOT_BACK_L

	if(looking_for == beltl)
		return ITEM_SLOT_BELT_L

	if(looking_for == beltr)
		return ITEM_SLOT_BELT_R

	if(looking_for == gloves)
		return ITEM_SLOT_GLOVES

	if(looking_for == head)
		return ITEM_SLOT_HEAD

	if(looking_for == shoes)
		return ITEM_SLOT_SHOES

	if(looking_for == wear_armor)
		return ITEM_SLOT_ARMOR

	if(looking_for == wear_pants)
		return ITEM_SLOT_PANTS

	if(looking_for == beltl)
		return ITEM_SLOT_BELT_L

	if(looking_for == beltr)
		return ITEM_SLOT_BELT_R

	return ..()

/mob/living/carbon/human/proc/get_all_slots()
	. = get_head_slots() | get_body_slots()

/mob/living/carbon/human/proc/get_body_slots()
	return list(
		handcuffed,
		legcuffed,
		wear_armor,
		gloves,
		shoes,
		belt,
		wear_ring,
		wear_wrists,
		wear_pants,
		wear_shirt,
		cloak,
		backr,
		backl,
		beltr,
		beltl,
		mouth
		)

/mob/living/carbon/human/proc/get_head_slots()
	return list(
		head,
		wear_mask,
		wear_neck,
		mouth,
		)

/mob/living/carbon/human/proc/get_storage_slots()
	return list(
		belt,
		backr,
		backl,
		beltr,
		beltl,
		mouth
		)

//This is an UNSAFE proc. Use mob_can_equip() before calling this one! Or rather use equip_to_slot_if_possible() or advanced_equip_to_slot_if_possible()
// Initial is used to indicate whether or not this is the initial equipment (job datums etc) or just a player doing it
/mob/living/carbon/human/equip_to_slot(obj/item/equipping, slot, initial = FALSE, redraw_mob = FALSE)
	if(!..()) //a check failed or the item has already found its slot
		return

	var/not_handled = FALSE //Added in case we make this type path deeper one day
	switch(slot)
		if(ITEM_SLOT_BELT)
			if(belt)
				return
			belt = equipping
			update_inv_belt()
		if(ITEM_SLOT_RING)
			if(wear_ring)
				return
			wear_ring = equipping
			update_inv_ring()
		if(ITEM_SLOT_WRISTS)
			if(wear_wrists)
				return
			wear_wrists = equipping
			update_inv_wrists()
		if(ITEM_SLOT_HEAD)
			if(head)
				return
			head = equipping
			update_inv_head()
		if(ITEM_SLOT_GLOVES)
			if(gloves)
				return
			gloves = equipping
			update_inv_gloves()
		if(ITEM_SLOT_SHOES)
			if(shoes)
				return
			shoes = equipping
			update_inv_shoes()
		if(ITEM_SLOT_ARMOR)
			if(wear_armor)
				return
			wear_armor = equipping
			if(equipping.flags_inv & HIDEJUMPSUIT)
				update_inv_shirt()
			if(wear_armor.breakouttime) //when equipping a straightjacket
				ADD_TRAIT(src, TRAIT_RESTRAINED, SUIT_TRAIT)
				stop_pulling() //can't pull if restrained
				update_mob_action_buttons() //certain action buttons will no longer be usable.
			update_inv_armor()
		if(ITEM_SLOT_PANTS)
			if(wear_pants)
				return
			wear_pants = equipping
			update_inv_pants()
		if(ITEM_SLOT_SHIRT)
			if(wear_shirt)
				return
			wear_shirt = equipping
			update_inv_shirt()
		if(ITEM_SLOT_CLOAK)
			if(cloak)
				return
			cloak = equipping
			update_inv_cloak()
		if(ITEM_SLOT_BELT_L)
			if(beltl)
				return
			beltl = equipping
			update_inv_belt()
		if(ITEM_SLOT_BELT_R)
			if(beltr)
				return
			beltr = equipping
			update_inv_belt()
		if(ITEM_SLOT_BACK_R)
			if(backr)
				return
			backr = equipping
			update_inv_back()
		if(ITEM_SLOT_BACK_L)
			if(backl)
				return
			backl = equipping
			update_inv_back()
		if(ITEM_SLOT_MOUTH)
			if(mouth)
				return
			mouth = equipping
			update_inv_mouth()
		if(ITEM_SLOT_BACKPACK)
			not_handled = TRUE
			if(beltr)
				if(SEND_SIGNAL(beltr, COMSIG_TRY_STORAGE_INSERT, equipping, src, TRUE))
					not_handled = FALSE
			if(beltl && not_handled)
				if(SEND_SIGNAL(beltl, COMSIG_TRY_STORAGE_INSERT, equipping, src, TRUE))
					not_handled = FALSE
			if(belt && not_handled)
				if(SEND_SIGNAL(belt, COMSIG_TRY_STORAGE_INSERT, equipping, src, TRUE))
					not_handled = FALSE
			if(backr && not_handled)
				if(SEND_SIGNAL(backr, COMSIG_TRY_STORAGE_CAN_INSERT, equipping, src, TRUE))
					not_handled = FALSE
			if(backl && not_handled)
				if(SEND_SIGNAL(backl, COMSIG_TRY_STORAGE_CAN_INSERT, equipping, src, TRUE))
					not_handled = FALSE
		else
			not_handled = TRUE

	//Item is handled and in slot, valid to call callback, for this proc should always be true
	if(!not_handled)
		equipping.equipped(src, slot, initial)
		check_armor_class()

	if(hud_used)
		hud_used.throw_icon?.update_appearance(UPDATE_ICON_STATE)
		hud_used.give_intent?.update_appearance(UPDATE_ICON_STATE)

	return not_handled //For future deeper overrides

/mob/living/carbon/human/equipped_speed_mods()
	. = ..()
	for(var/obj/item/thing in get_all_slots())
		. += thing?.slowdown

/mob/living/carbon/human/doUnEquip(obj/item/I, force, newloc, no_move, invdrop = TRUE, silent = FALSE)
	var/index = get_held_index_of_item(I)
	. = ..() //See mob.dm for an explanation on this and some rage about people copypasting instead of calling ..() like they should.
	if(!. || !I)
		return
	if(index && !QDELETED(src) && dna.species.mutanthands) //hand freed, fill with claws, skip if we're getting deleted.
		put_in_hand(new dna.species.mutanthands(), index)
	I.screen_loc = null
	if(I == wear_armor)
		if(wear_armor.breakouttime) //when unequipping a straightjacket
			REMOVE_TRAIT(src, TRAIT_RESTRAINED, SUIT_TRAIT)
			drop_all_held_items() //suit is restraining
			update_mob_action_buttons() //certain action buttons may be usable again.
		wear_armor = null
		if(!QDELETED(src)) //no need to update we're getting deleted anyway
			update_inv_armor()
	else if(I == wear_pants)
		wear_pants = null
		if(!QDELETED(src))
			update_inv_pants()
	else if(I == gloves)
		gloves = null
		if(!QDELETED(src))
			update_inv_gloves()
	else if(I == shoes)
		shoes = null
		if(!QDELETED(src))
			update_inv_shoes()
	else if(I == belt)
		if(beltr || beltl)
			dropItemToGround(beltr, TRUE, silent = FALSE)
			dropItemToGround(beltl, TRUE, silent = FALSE)
		belt = null
		if(!QDELETED(src))
			update_inv_belt()
	else if(I == wear_ring)
		wear_ring = null
		if(!QDELETED(src))
			update_inv_ring()
	else if(I == wear_wrists)
		wear_wrists = null
		if(!QDELETED(src))
			update_inv_wrists()
	else if(I == wear_shirt)
		wear_shirt = null
		if(!QDELETED(src))
			update_inv_shirt()
	else if(I == beltl)
		beltl = null
		if(!QDELETED(src))
			update_inv_belt()
	else if(I == beltr)
		beltr = null
		if(!QDELETED(src))
			update_inv_belt()
	else if(I == backl)
		backl = null
		if(!QDELETED(src))
			update_inv_back()
	else if(I == backr)
		backr = null
		if(!QDELETED(src))
			update_inv_back()
	else if(I == cloak)
		cloak = null
		if(!QDELETED(src))
			update_inv_cloak()
	else if(I == mouth)
		mouth = null
		if(!QDELETED(src))
			update_inv_mouth()
	check_armor_class()
	update_reflection()

/mob/living/carbon/human/wear_mask_update(obj/item/I, toggle_off = 1)
	if((I.flags_inv & (HIDEHAIR|HIDEFACIALHAIR)) || (initial(I.flags_inv) & (HIDEHAIR|HIDEFACIALHAIR)))
		update_body()
	if(I.flags_inv & HIDEEYES)
		update_inv_wear_mask()
	check_armor_class()
	..()

/mob/living/carbon/human/head_update(obj/item/I, forced)
	if((I.flags_inv & (HIDEHAIR|HIDEFACIALHAIR)) || forced)
		update_body()
	else
		var/obj/item/clothing/C = I
		if(istype(C) && C.dynamic_hair_suffix)
			update_body()
	if(I.flags_inv & HIDEEYES || forced)
		update_inv_wear_mask()
	if(I.flags_inv & HIDEEARS || forced)
		update_body()
	check_armor_class()
	..()

/mob/living/carbon/human/proc/equipOutfit(outfit, visuals_only = FALSE)
	var/datum/outfit/O = null

	if(ispath(outfit))
		O = new outfit
	else
		O = outfit
		if(!istype(O))
			return 0
	if(!O)
		return 0

	return O.equip(src, visuals_only)


//delete all equipment without dropping anything
/mob/living/carbon/human/proc/delete_equipment()
	for(var/slot in get_all_slots())//order matters, dependant slots go first
		qdel(slot)
	for(var/obj/item/I in held_items)
		qdel(I)

/mob/living/carbon/human/proc/smart_equipbag(slot_id) // take most recent item out of bag or place held item in bag
	if(incapacitated())
		return
	var/obj/item/thing = get_active_held_item()
	var/obj/item/equipped_back = get_item_by_slot(slot_id)
	if(!equipped_back) // We also let you equip a backpack like this
		if(!thing)
			to_chat(src, span_warning("I have no backpack to take something out of!"))
			return
		if(equip_to_slot_if_possible(thing, slot_id))
			update_inv_hands()
		return
	// Since you have to take off /obj/item/storage/backpack/backpack to access the inventory we handle it differently:
	if(istype(equipped_back, /obj/item/storage/backpack/backpack))
		if(thing) // Check for held item, if there is one, don't let them insert it in the backpack
			to_chat(src, span_warning("I need to take my backpack off first"))
			return
		equipped_back.attack_hand(src) // If there is no held item, take off the backpack by invoking attack_hand
		return
	if(!SEND_SIGNAL(equipped_back, COMSIG_CONTAINS_STORAGE)) // not a storage item
		if(!thing)
			equipped_back.attack_hand(src)
		else
			to_chat(src, span_warning("I can't fit anything in!"))
		return
	if(thing) // put thing in backpack
		if(!SEND_SIGNAL(equipped_back, COMSIG_TRY_STORAGE_INSERT, thing, src))
			to_chat(src, span_warning("I can't fit anything in!"))
		return
	if(!equipped_back.contents.len) // nothing to take out
		to_chat(src, span_warning("There's nothing in your backpack to take out!"))
		return
	var/obj/item/stored = equipped_back.contents[equipped_back.contents.len]
	if(!stored || stored.on_found(src))
		return
	stored.attack_hand(src) // take out thing from backpack
	return

/mob/living/carbon/human/proc/smart_equipbelt() // put held thing in belt or take most recent item out of belt
	if(incapacitated(IGNORE_GRAB))
		return
	var/obj/item/thing = get_active_held_item()
	var/obj/item/equipped_belt = get_item_by_slot(ITEM_SLOT_BELT)
	if(!equipped_belt) // We also let you equip a belt like this
		if(!thing)
			to_chat(src, "<span class='warning'>I have no belt to take something out of!</span>")
			return
		if(equip_to_slot_if_possible(thing, ITEM_SLOT_BELT))
			update_inv_hands()
		return
	if(!SEND_SIGNAL(equipped_belt, COMSIG_CONTAINS_STORAGE)) // not a storage item
		if(!thing)
			equipped_belt.attack_hand(src)
		else
			to_chat(src, "<span class='warning'>I can't fit anything in!</span>")
		return
	if(thing) // put thing in belt
		if(!SEND_SIGNAL(equipped_belt, COMSIG_TRY_STORAGE_INSERT, thing, src))
			to_chat(src, "<span class='warning'>I can't fit anything in!</span>")
		return
	if(!equipped_belt.contents.len) // nothing to take out
		to_chat(src, "<span class='warning'>There's nothing in your belt to take out!</span>")
		return
	var/obj/item/stored = equipped_belt.contents[equipped_belt.contents.len]
	if(!stored || stored.on_found(src))
		return
	stored.attack_hand(src) // take out thing from belt
	return
