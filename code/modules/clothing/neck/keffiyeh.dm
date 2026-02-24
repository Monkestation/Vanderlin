/obj/item/clothing/neck/keffiyeh
	name = "keffiyeh"
	desc = "An eastern scarf usually worn around the head and neck over a padded coif."
	icon = 'icons/roguetown/clothing/head.dmi'
	icon_state = "shalal"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi'
	dynamic_hair_suffix = ""
	dropshrink = 0.8
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HEAD
	blocksound = SOFTHIT
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	flags_inv = HIDEEARS|HIDEHAIR
	body_parts_covered = NECK|HAIR|EARS|HEAD
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	sewrepair = TRUE
	anvilrepair = null
	resistance_flags = FLAMMABLE // Made of leather
	color = CLOTHING_LINEN
	smeltresult = /obj/item/fertilizer/ash

	armor = ARMOR_PADDED_BAD
	prevent_crits = MINOR_CRITICALS
	armor = ARMOR_LEATHER_GOOD
	max_integrity = INTEGRITY_WORST

/obj/item/clothing/neck/keffiyeh/AdjustClothes(mob/user)
	if(loc == user)
		if(adjustable == CAN_CADJUST)
			adjustable = CADJUSTED
			if(toggle_icon_state)
				icon_state = "[initial(icon_state)]_t"
			flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
			body_parts_covered = NECK | HEAD | MOUTH | NOSE | EARS | HAIR
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_neck()
				H.update_inv_head()
		else if(adjustable == CADJUSTED)
			ResetAdjust(user)
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_neck()
					H.update_inv_head()
		user.regenerate_clothes()

/obj/item/clothing/neck/keffiyeh/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/neck/keffiyeh/colored/uncolored
	color = CLOTHING_LINEN

/obj/item/clothing/neck/keffiyeh/colored/red
	color = CLOTHING_BLOOD_RED

/obj/item/clothing/neck/keffiyeh/colored/yellow
	color = CLOTHING_PEAR_YELLOW

/obj/item/clothing/neck/keffiyeh/colored/orange
	color = CLOTHING_FYRITIUS_ORANGE

/obj/item/clothing/neck/keffiyeh/colored/green
	color = CLOTHING_BOG_GREEN

/obj/item/clothing/neck/keffiyeh/colored/blue
	color = CLOTHING_MAGE_BLUE

/obj/item/clothing/neck/keffiyeh/colored/purple
	color = CLOTHING_ROYAL_PURPLE

/obj/item/clothing/neck/keffiyeh/colored/black
	color = CLOTHING_ROYAL_BLACK

/obj/item/clothing/neck/keffiyeh/colored/white
	color = CLOTHING_ASH_GREY
