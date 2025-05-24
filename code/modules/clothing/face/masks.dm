/obj/item/clothing/face/lordmask
	name = "golden halfmask"
	desc = "Half of your face turned gold."
	icon_state = "lmask"
	sellprice = 50

/obj/item/clothing/face/lordmask/l
	icon_state = "lmask_l"

/obj/item/clothing/face/lordmask/faceless
	name = "half-face"
	desc = "A face for the faceless."
	color = CLOTHING_SOOT_BLACK

/obj/item/clothing/face/lordmask/faceless/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/face/lordmask/faceless/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/face/facemask
	name = "iron mask"
	icon_state = "imask"
	desc = "A heavy iron mask that both conceals and protects the face."
	max_integrity = 100
	blocksound = PLATEHIT
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	armor = list("blunt" = 80, "slash" = 80, "stab" = 80,  "piercing" = 50, "fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_LASHING, BCLASS_BITE, BCLASS_TWIST, BCLASS_CUT, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_STAB)
	flags_inv = HIDEFACE
	body_parts_covered = FACE
	block2add = FOV_BEHIND
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	experimental_onhip = TRUE
	sewrepair = FALSE
	anvilrepair = /datum/skill/craft/armorsmithing
	clothing_flags = CANT_SLEEP_IN

/obj/item/clothing/face/shepherd/clothmask
	name = "cloth mask"
	icon_state = "clothm"
	desc = "A simple cloth mask that suppresses bad odors, or offers minor protection when doing dirty work such as mining or gravedigging."
	flags_inv = HIDEFACE|HIDEFACIALHAIR
	body_parts_covered = NECK|MOUTH
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	adjustable = CAN_CADJUST
	resistance_flags = FLAMMABLE
	toggle_icon_state = TRUE
	experimental_onhip = TRUE

/obj/item/clothing/face/facemask/prisoner
	clothing_flags = NONE //they're used to this being stuck on their face

/obj/item/clothing/face/facemask/prisoner/Initialize()
	. = ..()
	name = "cursed mask"
	desc = "We are often criminals in the eyes of the earth, not only for having committed crimes, but because we know that crimes have been committed."
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)
	flags_inv = HIDEFACIALHAIR //so prisoners can actually be identified

/obj/item/clothing/face/facemask/prisoner/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/face/facemask/steel
	name = "steel mask"
	icon_state = "smask"
	armor = list("blunt" = 100, "slash" = 100, "stab" = 100,  "piercing" = 80, "fire" = 0, "acid" = 0)
	desc = "A knightly steel mask that both conceals and protects the face. Usually paired with a bascinet."
	max_integrity = 300

/obj/item/clothing/face/facemask/shadowfacemask
	name = "anthraxi war mask"
	desc = "A metal mask resembling a spider's face. Such a visage haunts many an older dark elf's nitemares - while the younger generation simply scoffs at such relics."
	icon_state = "shadowfacemask"

/obj/item/clothing/face/shepherd
	name = "halfmask"
	icon_state = "shepherd"
	flags_inv = HIDEFACE|HIDEFACIALHAIR
	body_parts_covered = NECK|MOUTH
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	adjustable = CAN_CADJUST
	resistance_flags = FLAMMABLE
	toggle_icon_state = TRUE
	experimental_onhip = TRUE
	salvage_amount = 1
	gas_transfer_coefficient = 0.3

/obj/item/clothing/face/shepherd/AdjustClothes(mob/user)
	if(loc == user)
		if(adjustable == CAN_CADJUST)
			adjustable = CADJUSTED
			if(toggle_icon_state)
				icon_state = "[initial(icon_state)]_t"
			flags_inv = null
			body_parts_covered = NECK
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_wear_mask()
			gas_transfer_coefficient = 0
		else if(adjustable == CADJUSTED)
			ResetAdjust(user)
			flags_inv = HIDEFACE|HIDEFACIALHAIR
			body_parts_covered = NECK|MOUTH
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_wear_mask()
		user.regenerate_clothes()

/obj/item/clothing/face/shepherd/rag
	icon_state = "ragmask"

/obj/item/clothing/face/shepherd/shadowmask
	name = "purple halfmask"
	icon_state = "shadowmask"
	desc = "Tiny drops of white dye mark its front, not unlike teeth. A smile that leers from shadow."

/obj/item/clothing/face/feld
	name = "feldsher's mask"
	desc = "Three times the beaks means three times the doctor."
	icon_state = "feldmask"
	item_state = "feldmask"
	resistance_flags = FLAMMABLE
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	body_parts_covered = FACE|EARS|EYES|MOUTH|NECK
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	sewrepair = TRUE
	gas_transfer_coefficient = 0.3

/obj/item/clothing/face/phys
	name = "physicker's mask"
	desc = "Packed with herbs to conceal the rot."
	icon_state = "surgmask"
	item_state = "surgmask"
	resistance_flags = FLAMMABLE
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	body_parts_covered = FACE|EARS|EYES|MOUTH|NECK
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	sewrepair = TRUE
	gas_transfer_coefficient = 0.3

/obj/item/clothing/face/facemask/copper
	name = "copper mask"
	icon_state = "cmask"
	desc = "A heavy copper mask that conceals and protects the face, though not very effectively."
	max_integrity = 100
	blocksound = PLATEHIT
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	armor = list("blunt" = 50, "slash" = 50, "stab" = 50,  "piercing" = 50, "fire" = 0, "acid" = 0)
	flags_inv = HIDEFACE
	body_parts_covered = FACE
	block2add = FOV_BEHIND
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	experimental_onhip = TRUE
	sewrepair = FALSE
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/copper

//................ Druids Mask ............... //
/obj/item/clothing/face/druid
	name = "druids mask"
	desc = "Roots from a old oak-tree, shaped according to the wishes of Tree-father."
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi'
	icon_state = "dendormask"
	resistance_flags = FIRE_PROOF
	flags_inv = HIDEFACE
	body_parts_covered = FACE
	block2add = FOV_BEHIND
	slot_flags = ITEM_SLOT_MASK
	experimental_onhip = TRUE

	armor = ARMOR_WEAK
	prevent_crits = CUT_AND_MINOR_CRITS

/obj/item/clothing/face/skullmask
	name = "skull mask"
	icon_state = "skullmask"
	max_integrity = 100
	blocksound = PLATEHIT
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	resistance_flags = FIRE_PROOF
	armor = list("blunt" = 10, "slash" = 40, "stab" = 40,  "piercing" = 8, "fire" = 0, "acid" = 0)
	prevent_crits = null
	flags_inv = HIDEFACE
	body_parts_covered = FACE
	block2add = FOV_BEHIND
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	experimental_onhip = TRUE
	smeltresult = /obj/item/alch/bone

/obj/item/clothing/face/facemask/goldmask
	name = "gold mask"
	icon_state = "goldmask"
	max_integrity = 150
	sellprice = 100
	smeltresult = /obj/item/ingot/gold

