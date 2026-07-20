/obj/item/clothing/face/goggles
	name = "goggles"
	icon_state = "artigoggles"
	desc = "Protective goggles with green lenses. Perfect for staring into fires."
	resistance_flags = FIRE_PROOF
	slot_flags = list(ITEM_SLOT_HEAD, ITEM_SLOT_MASK)
	body_parts_covered = EYES
	toggle_icon_state = TRUE
	adjustable = CAN_CADJUST
	item_weight = 95 GRAMS

/obj/item/clothing/face/goggles/AdjustClothes(mob/user)
	if(loc == user)
		if(adjustable == CAN_CADJUST)
			adjustable = CADJUSTED
			if(toggle_icon_state)
				icon_state = "[initial(icon_state)]_t"
			flags_inv = null
			body_parts_covered = EYES
			REMOVE_TRAIT(user, TRAIT_ENGINEERING_GOGGLES, "[ref(src)]")
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_wear_mask()
				H.update_inv_head()
		else if(adjustable == CADJUSTED)
			ResetAdjust(user)
			ADD_TRAIT(user, TRAIT_ENGINEERING_GOGGLES, "[ref(src)]")
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_wear_mask()
					H.update_inv_head()
		user.regenerate_clothes()

/obj/item/clothing/face/goggles/dropped(mob/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_ENGINEERING_GOGGLES, "[ref(src)]")

/obj/item/clothing/face/goggles/equipped(mob/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_MASK)
		if(adjustable == CAN_CADJUST)
			ADD_TRAIT(user, TRAIT_ENGINEERING_GOGGLES, "[ref(src)]")
