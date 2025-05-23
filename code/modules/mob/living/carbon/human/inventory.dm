/mob/living/carbon/human/can_equip(obj/item/I, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	return dna?.species?.can_equip(I, slot, disable_warning, src, bypass_equip_delay_self)

// Return the item currently in the slot ID
/mob/living/carbon/human/get_item_by_slot(slot_id)
	switch(slot_id)
		if(SLOT_BACK)
			return back
		if(SLOT_WEAR_MASK)
			return wear_mask
		if(SLOT_NECK)
			return wear_neck
		if(SLOT_HANDCUFFED)
			return handcuffed
		if(SLOT_LEGCUFFED)
			return legcuffed
		if(SLOT_BELT)
			return belt
		if(SLOT_RING)
			return wear_ring
		if(SLOT_WRISTS)
			return wear_wrists
		if(SLOT_MOUTH)
			return mouth
		if(SLOT_SHIRT)
			return wear_shirt
		if(SLOT_CLOAK)
			return cloak
		if(SLOT_BACK_R)
			return backr
		if(SLOT_BACK_L)
			return backl
		if(SLOT_BELT_L)
			return beltl
		if(SLOT_BELT_R)
			return beltr
		if(SLOT_GLOVES)
			return gloves
		if(SLOT_HEAD)
			return head
		if(SLOT_SHOES)
			return shoes
		if(SLOT_ARMOR)
			return wear_armor
		if(SLOT_PANTS)
			return wear_pants
		if(SLOT_L_STORE)
			return l_store
		if(SLOT_R_STORE)
			return r_store
		if(SLOT_S_STORE)
			return s_store
	return null

/mob/living/carbon/human/get_slot_by_item(obj/item/looking_for)
	if(looking_for == back)
		return SLOT_BACK

	if(looking_for == wear_mask)
		return SLOT_WEAR_MASK

	if(looking_for == wear_neck)
		return SLOT_NECK

	if(looking_for == handcuffed)
		return SLOT_HANDCUFFED

	if(looking_for == legcuffed)
		return SLOT_LEGCUFFED

	if(looking_for == belt)
		return SLOT_BELT

	if(looking_for == wear_ring)
		return SLOT_RING

	if(looking_for == wear_wrists)
		return SLOT_WRISTS

	if(looking_for == mouth)
		return SLOT_MOUTH

	if(looking_for == wear_shirt)
		return SLOT_SHIRT

	if(looking_for == cloak)
		return SLOT_CLOAK

	if(looking_for == backr)
		return SLOT_BACK_R

	if(looking_for == backl)
		return SLOT_BACK_L

	if(looking_for == beltl)
		return SLOT_BELT_L

	if(looking_for == beltr)
		return SLOT_BELT_R

	if(looking_for == gloves)
		return SLOT_GLOVES

	if(looking_for == head)
		return SLOT_HEAD

	if(looking_for == shoes)
		return SLOT_SHOES

	if(looking_for == wear_armor)
		return SLOT_ARMOR

	if(looking_for == wear_pants)
		return SLOT_PANTS

	if(looking_for == l_store)
		return SLOT_L_STORE

	if(looking_for == r_store)
		return SLOT_R_STORE

	if(looking_for == s_store)
		return SLOT_S_STORE

	return ..()

/mob/living/carbon/human/proc/get_all_slots()
	. = get_head_slots() | get_body_slots()

/mob/living/carbon/human/proc/get_body_slots()
	return list(
		back,
		s_store,
		handcuffed,
		legcuffed,
		wear_armor,
		gloves,
		shoes,
		belt,
		wear_ring,
		wear_wrists,
		l_store,
		r_store,
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
		back,
		belt,
		l_store,
		r_store,
		s_store,
		backr,
		backl,
		beltr,
		beltl,
		mouth
		)

//This is an UNSAFE proc. Use mob_can_equip() before calling this one! Or rather use equip_to_slot_if_possible() or advanced_equip_to_slot_if_possible()
// Initial is used to indicate whether or not this is the initial equipment (job datums etc) or just a player doing it
/mob/living/carbon/human/equip_to_slot(obj/item/I, slot, initial)
	if(!..()) //a check failed or the item has already found its slot
		return

	var/not_handled = FALSE //Added in case we make this type path deeper one day
	switch(slot)
		if(SLOT_BELT)

			belt = I
			update_inv_belt()
		if(SLOT_RING)
			wear_ring = I
			update_inv_wear_id()
		if(SLOT_WRISTS)

			wear_wrists = I
			update_inv_wrists()
		if(SLOT_HEAD)

			head = I
			update_inv_head()
		if(SLOT_GLOVES)

			gloves = I
			update_inv_gloves()
		if(SLOT_SHOES)

			shoes = I
			update_inv_shoes()
		if(SLOT_ARMOR)

			wear_armor = I
			if(I.flags_inv & HIDEJUMPSUIT)
				update_inv_shirt()
			if(wear_armor.breakouttime) //when equipping a straightjacket
				ADD_TRAIT(src, TRAIT_RESTRAINED, SUIT_TRAIT)
				stop_pulling() //can't pull if restrained
				update_action_buttons_icon() //certain action buttons will no longer be usable.
			update_inv_armor()
		if(SLOT_PANTS)

			wear_pants = I
			update_inv_pants()
		if(SLOT_SHIRT)

			wear_shirt = I
			update_inv_shirt()
		if(SLOT_CLOAK)

			cloak = I
			update_inv_cloak()
		if(SLOT_BELT_L)
			beltl = I
			update_inv_belt()
		if(SLOT_BELT_R)
			beltr = I
			update_inv_belt()
		if(SLOT_BACK_R)

			backr = I
			update_inv_back()
		if(SLOT_BACK_L)

			backl = I
			update_inv_back()
		if(SLOT_L_STORE)
			l_store = I
			update_inv_pockets()
		if(SLOT_R_STORE)
			r_store = I
			update_inv_pockets()
		if(SLOT_S_STORE)
			s_store = I
			update_inv_s_store()
		if(SLOT_MOUTH)

			mouth = I
			update_inv_mouth()
		if(SLOT_IN_BACKPACK)
			not_handled = TRUE
			if(beltr)
				testing("insert1")
				if(SEND_SIGNAL(beltr, COMSIG_TRY_STORAGE_INSERT, I, src, TRUE))
					not_handled = FALSE
			if(beltl && not_handled)
				testing("insert2")
				if(SEND_SIGNAL(beltl, COMSIG_TRY_STORAGE_INSERT, I, src, TRUE))
					not_handled = FALSE
			if(belt && not_handled)
				testing("insert3")
				if(SEND_SIGNAL(belt, COMSIG_TRY_STORAGE_INSERT, I, src, TRUE))
					not_handled = FALSE
		else
			not_handled = TRUE
//		else
//			to_chat(src, "<span class='danger'>I am trying to equip this item to an unsupported inventory slot. Report this to a coder!</span>")

	//Item is handled and in slot, valid to call callback, for this proc should always be true
	if(!not_handled)
		I.equipped(src, slot, initial)
		check_armor_class()


	if(hud_used)
		hud_used.throw_icon?.update_icon()
		hud_used.give_intent?.update_icon()

	return not_handled //For future deeper overrides

/mob/living/carbon/human/equipped_speed_mods()
	. = ..()
	for(var/sloties in get_all_slots())
		var/obj/item/thing = sloties
		. += thing?.slowdown

/mob/living/carbon/human/doUnEquip(obj/item/I, force, newloc, no_move, invdrop = TRUE, silent = FALSE)
	var/index = get_held_index_of_item(I)
	. = ..() //See mob.dm for an explanation on this and some rage about people copypasting instead of calling ..() like they should.
	if(!. || !I)
		return
	if(index && !QDELETED(src) && dna.species.mutanthands) //hand freed, fill with claws, skip if we're getting deleted.
		put_in_hand(new dna.species.mutanthands(), index)
	if(I == wear_armor)
		if(s_store && invdrop)
			dropItemToGround(s_store, TRUE, silent = silent) //It makes no sense for your suit storage to stay on you if you drop your suit.
		if(wear_armor.breakouttime) //when unequipping a straightjacket
			REMOVE_TRAIT(src, TRAIT_RESTRAINED, SUIT_TRAIT)
			drop_all_held_items() //suit is restraining
			update_action_buttons_icon() //certain action buttons may be usable again.
		wear_armor = null
		if(!QDELETED(src)) //no need to update we're getting deleted anyway
			if(I.flags_inv & HIDEJUMPSUIT)
				update_inv_w_uniform()
			update_inv_armor()
	else if(I == wear_pants)
		if(invdrop)
			if(r_store)
				dropItemToGround(r_store, TRUE, silent = silent) //Again, makes sense for pockets to drop.
			if(l_store)
				dropItemToGround(l_store, TRUE, silent = silent)
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
			update_inv_wear_id()
	else if(I == wear_wrists)
		wear_wrists = null
		if(!QDELETED(src))
			update_inv_wrists()
	else if(I == r_store)
		r_store = null
		if(!QDELETED(src))
			update_inv_pockets()
	else if(I == l_store)
		l_store = null
		if(!QDELETED(src))
			update_inv_pockets()
	else if(I == s_store)
		s_store = null
		if(!QDELETED(src))
			update_inv_s_store()
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
//	if(!QDELETED(src))
//		if(I.eweight)
//			encumbrance -= I.eweight
//			if(encumbrance < 0)
//				encumbrance = 0

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

/mob/living/carbon/human/proc/equipOutfit(outfit, visualsOnly = FALSE)
	var/datum/outfit/O = null

	if(ispath(outfit))
		O = new outfit
	else
		O = outfit
		if(!istype(O))
			return 0
	if(!O)
		return 0

	return O.equip(src, visualsOnly)


//delete all equipment without dropping anything
/mob/living/carbon/human/proc/delete_equipment()
	for(var/slot in get_all_slots())//order matters, dependant slots go first
		qdel(slot)
	for(var/obj/item/I in held_items)
		qdel(I)

/mob/living/carbon/human/proc/smart_equipbag() // take most recent item out of bag or place held item in bag
	if(incapacitated(ignore_grab = TRUE))
		return
	var/obj/item/thing = get_active_held_item()
	var/obj/item/equipped_back = get_item_by_slot(SLOT_BACK)
	if(!equipped_back) // We also let you equip a backpack like this
		if(!thing)
			to_chat(src, "<span class='warning'>I have no backpack to take something out of!</span>")
			return
		if(equip_to_slot_if_possible(thing, SLOT_BACK))
			update_inv_hands()
		return
	if(!SEND_SIGNAL(equipped_back, COMSIG_CONTAINS_STORAGE)) // not a storage item
		if(!thing)
			equipped_back.attack_hand(src)
		else
			to_chat(src, "<span class='warning'>I can't fit anything in!</span>")
		return
	if(thing) // put thing in backpack
		if(!SEND_SIGNAL(equipped_back, COMSIG_TRY_STORAGE_INSERT, thing, src))
			to_chat(src, "<span class='warning'>I can't fit anything in!</span>")
		return
	if(!equipped_back.contents.len) // nothing to take out
		to_chat(src, "<span class='warning'>There's nothing in your backpack to take out!</span>")
		return
	var/obj/item/stored = equipped_back.contents[equipped_back.contents.len]
	if(!stored || stored.on_found(src))
		return
	stored.attack_hand(src) // take out thing from backpack
	return

/mob/living/carbon/human/proc/smart_equipbelt() // put held thing in belt or take most recent item out of belt
	if(incapacitated(ignore_grab = TRUE))
		return
	var/obj/item/thing = get_active_held_item()
	var/obj/item/equipped_belt = get_item_by_slot(SLOT_BELT)
	if(!equipped_belt) // We also let you equip a belt like this
		if(!thing)
			to_chat(src, "<span class='warning'>I have no belt to take something out of!</span>")
			return
		if(equip_to_slot_if_possible(thing, SLOT_BELT))
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
