/obj/item/clothing/face/spectacles
	name = "spectacles"
	icon_state = "glasses"
	break_sound = "glassbreak"
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	max_integrity = 20
	integrity_failure = 0.5
	resistance_flags = FIRE_PROOF
	body_parts_covered = EYES
//	block2add = FOV_BEHIND

/obj/item/clothing/face/spectacles/golden
	name = "golden spectacles"
	icon_state = "goggles"
	break_sound = "glassbreak"
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	max_integrity = 35
	integrity_failure = 0.5
	resistance_flags = FIRE_PROOF
	body_parts_covered = EYES

/obj/item/clothing/face/spectacles/Crossed(mob/crosser)
	if(isliving(crosser) && !obj_broken)
		take_damage(11, BRUTE, "blunt", 1)
	..()

/obj/item/clothing/face/spectacles/inqglasses
	name = "crimson spectacles"
	desc = "Spectacles evoking the stained glass of Grenzelhoftian cathedrals. See all evil."
	icon_state = "bglasses"

/obj/item/clothing/face/spectacles/sglasses
	name = "smokey onyxa spectacles"
	desc = "Death has come to your little town, Sheriff. Now, you can either ignore it, or you can help me to stop it."
	icon_state = "sglasses"

/obj/item/clothing/face/spectacles/inq
	name = "inquisitorial spectacles"
	icon_state = "bglasses"
	desc = "Spectacles evoking the stained glass of Grenzelhoftian cathedrals. See all evil."
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	max_integrity = 300
	integrity_failure = 0.5
	resistance_flags = FIRE_PROOF
	body_parts_covered = EYES
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HEAD
	anvilrepair = /datum/skill/craft/armorsmithing
	var/lensmoved = TRUE // starts with the lenses out of the way, night vision being off.

/obj/item/clothing/face/spectacles/inq/examine(mob/user) // informs inquisition members of the night vision functionality.
	. = ..()
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		. += span_info("These spectacles posess photosensitive lenses. The user may slide them into place for short-range dark-vision.")
		. += span_warning("Use the Middle Mouse Button on the glasses, with your jump, bite, etc.. intents OFF to (de)activate nightvision.")

/obj/item/clothing/face/spectacles/inq/spawnpair
	lensmoved = TRUE

/obj/item/clothing/face/spectacles/inq/equipped(mob/user, slot)
	..()

	if(slot & ITEM_SLOT_MASK || slot & ITEM_SLOT_HEAD)
		if(!lensmoved)
			ADD_TRAIT(user, TRAIT_NOCSHADES, "redlens")
			return

/obj/item/clothing/face/spectacles/inq/MiddleClick(mob/user, params)
	. = ..()
	if(!lensmoved)
		to_chat(user, span_info("You discreetly slide the inner lenses out of the way."))
		REMOVE_TRAIT(user, TRAIT_NOCSHADES, "redlens")
		lensmoved = TRUE
		user.update_sight()
		return
	to_chat(user, span_info("You discreetly slide the inner lenses back into place."))
	ADD_TRAIT(user, TRAIT_NOCSHADES, "redlens")
	lensmoved = FALSE
	user.update_sight()

/obj/item/clothing/face/spectacles/inq/dropped(mob/user, slot)
	..()
	if(!(slot & ITEM_SLOT_MASK) || slot & ITEM_SLOT_HEAD)
		if(!lensmoved)
			REMOVE_TRAIT(user, TRAIT_NOCSHADES, "redlens")
			user.update_sight()
			lensmoved = TRUE // set the night vision to off, to avoid weirdness
			return



/obj/item/clothing/face/sack
	name = "sack mask"
	desc = "A brown sack with eyeholes cut into it."
	icon_state = "sackmask"
	blocksound = SOFTHIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	max_integrity = 200
	prevent_crits = list(BCLASS_BLUNT)
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	flags_inv = HIDEFACE|HIDEHAIR|HIDEEARS
	body_parts_covered = FACE|HEAD
	block2add = FOV_BEHIND
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	armor = ARMOR_PADDED
	sewrepair = TRUE

/obj/item/clothing/face/sack/psy
	name = "psydonian sack mask"
	desc = "An ordinary brown sack. This one has eyeholes cut into it, bearing a crude chalk drawing of Psydon's cross upon its visage. Unsettling for most."
	icon_state = "sackmask_psy"

/obj/item/clothing/face/antiq
	name = "Antiquarian's Hood"
	desc = "The mechanisms inside hum in a strange, mechanical unison - Glowing Gems radiate a dull light outwards, piercing the dark. You have a feeling that this mask has seen things you wouldn't believe."
	icon_state = "antiqmask"
	blocksound = SOFTHIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	max_integrity = 400 // Respect the drip.
	sellprice = 300 // Strange foreign device, BOY do I want to sell the shit outta THAT.
	prevent_crits = list(BCLASS_BLUNT)
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	flags_inv = HIDEFACE|HIDEHAIR|HIDEEARS
	body_parts_covered = FACE|HEAD
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	armor = ARMOR_PADDED
	sewrepair = TRUE

/obj/item/clothing/face/facemask/steel/confessor
	name = "strange mask"
	desc = "It is said that the original version of this mask was used for obscure rituals in Grenzelhoft, and now it has been repurposed as a veil for the cunning hand of the Ordo Venatari. Others say it is a piece of heresy, a necessary evil, capable of keeping its user safe from vile magicks. You can taste copper whenever you draw breath."
	icon_state = "confessormask"
	max_integrity = 200
	equip_sound = 'sound/items/confessormaskon.ogg'
	melting_material = /datum/material/steel
	melt_amount = 75
	var/worn = FALSE
	slot_flags = ITEM_SLOT_MASK

/obj/item/clothing/face/facemask/steel/confessor/examine(mob/user) // informs inquisition members that nocshades can be installed in the mask.
	. = ..()
	if(HAS_TRAIT(user, TRAIT_INQUISITION) && !istype(src, /obj/item/clothing/face/facemask/steel/confessor/lensed))
		. += span_info("This mask may have nocshades installed into it.")


/obj/item/clothing/face/facemask/steel/confessor/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(user.wear_mask == src)
		worn = TRUE

/obj/item/clothing/face/facemask/steel/confessor/dropped(mob/user)
	. = ..()
	if(worn)
		playsound(user, 'sound/items/confessormaskoff.ogg', 80)
		worn = FALSE


/obj/item/clothing/face/facemask/steel/confessor/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(istype(I, /obj/item/clothing/face/spectacles/inq))
		user.visible_message(span_warning("[user] starts to insert [I]'s lenses into [src]."))
		if(do_after(user, 4 SECONDS))
			var/obj/item/clothing/face/facemask/steel/confessor/lensed/P = new /obj/item/clothing/face/facemask/steel/confessor/lensed(get_turf(src.loc))
			if(user.is_holding(src))
				user.dropItemToGround(src)
				user.put_in_hands(P)
			P.update_integrity(src.atom_integrity)
			qdel(src)
			qdel(I)
		else
			user.visible_message(span_warning("[user] stops inserting the lenses into [src]."))
		return

/obj/item/clothing/face/facemask/steel/confessor/lensed
	name = "stranger mask"
	desc = " It is said that the original version of this mask was used for obscure rituals in Grenzelhoft, and now it has been repurposed as a veil for the cunning hand of the Ordo Venatari. Others say it is a piece of heresy, a necessary evil, capable of keeping its user safe from vile magicks. You can taste copper whenever you draw breath."
	icon_state = "confessormask_lens"
	var/lensmoved = TRUE

/obj/item/clothing/face/facemask/steel/confessor/lensed/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		. += span_info("This mask contains noc-shades, which provide the user with short-range dark-vision when activated.")
		. += span_warning("Use the Middle Mouse Button on the glasses, with your jump, bite, etc.. intents OFF to (de)activate nightvision.")

/obj/item/clothing/face/facemask/steel/confessor/lensed/equipped(mob/user, slot)
	..()
	if(slot & ITEM_SLOT_MASK || slot & ITEM_SLOT_HEAD)
		if(!lensmoved)
			ADD_TRAIT(user, TRAIT_NOCSHADES, "redlens")
			user.update_sight()
			return

/obj/item/clothing/face/facemask/steel/confessor/lensed/MiddleClick(mob/user, params)
	. = ..()
	if(!lensmoved)
		to_chat(user, span_info("You discreetly slide the inner lenses out of the way."))
		REMOVE_TRAIT(user, TRAIT_NOCSHADES, "redlens")
		lensmoved = TRUE
		user.update_sight()
		return
	to_chat(user, span_info("You discreetly slide the inner lenses back into place."))
	ADD_TRAIT(user, TRAIT_NOCSHADES, "redlens")
	lensmoved = FALSE
	user.update_sight()

/obj/item/clothing/face/facemask/steel/confessor/lensed/dropped(mob/user, slot)
	..()
	if(!(slot & ITEM_SLOT_MASK) || slot & ITEM_SLOT_HEAD)
		if(!lensmoved)
			REMOVE_TRAIT(user, TRAIT_NOCSHADES, "redlens")
			user.update_sight()
			lensmoved = TRUE // set the night vision to off, to avoid weirdness
			return
