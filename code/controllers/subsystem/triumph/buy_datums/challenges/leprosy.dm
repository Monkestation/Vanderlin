/datum/triumph_buy/leprosy
	name = "Leprosy"
	desc = "Become a leper. You will be hated, you will be shunned, you will bleed and you will be weak. But Pestra will take all your pain away."
	triumph_buy_id = TRIUMPH_BUY_LEPROSY
	triumph_cost = 0
	category = TRIUMPH_CAT_CHALLENGES
	visible_on_active_menu = TRUE
	manual_activation = TRUE

/datum/triumph_buy/leprosy/on_after_spawn(mob/living/carbon/human/H)
	. = ..()
	ADD_TRAIT(H, TRAIT_LEPROSY, TRIUMPH_TRAIT)
	ADD_TRAIT(H, TRAIT_NOPAIN, TRIUMPH_TRAIT)

	var/mask_item = H.get_item_by_slot(ITEM_SLOT_MASK)
	if(!istype(mask_item, /obj/item/clothing/face/facemask))
		var/obj/item/clothing/face/facemask/iron_mask = new()
		if(!H.equip_to_slot_if_possible(iron_mask, ITEM_SLOT_MASK, disable_warning = TRUE))
			if(!H.put_in_active_hand(iron_mask))
				iron_mask.forceMove(H.drop_location())

	on_activate()
