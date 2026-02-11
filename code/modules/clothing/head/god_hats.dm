/obj/item/clothing/head/padded/pestra
	name = "naga hood"
	desc = "Worn by the faithful of Pestra. Resembling the face of the Naga clothed in rot."
	icon_state = "pestrahood"
	icon = 'icons/roguetown/clothing/patron_hoods.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/patron_hoods.dmi'
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR

/obj/item/clothing/head/roguehood/nochood
	name = "moon hood"
	desc = "The face of the Moon Prince. Worn by the faithful of Noc."
	icon_state = "nochood"
	flags_inv = HIDEEARS|HIDEHAIR
	default_hidden = HIDEEARS|HIDEHAIR
	dropshrink = 0.8

	armor = ARMOR_WEAK
	prevent_crits = MINOR_CRITICALS
	salvage_amount = 1
	salvage_result = /obj/item/natural/silk

/obj/item/clothing/head/padded/deathface
	name = "death shroud"
	desc = "A Veil for those in service to the Veiled Lady. When inducted into the cult of Necra, the supplicant must make a talisman to hold the memory of a loved one since passed."
	icon_state = "deathface"
	flags_inv = HIDEEARS | HIDEHAIR | HIDEFACIALHAIR

	armor = ARMOR_WEAK
	prevent_crits = MINOR_CRITICALS

/obj/item/clothing/head/padded/deathshroud
	name = "death shroud"
	desc = "Worn by the faithful of Necra, or less savory individuals."
	icon_state = "necrahood"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR

/obj/item/clothing/head/padded/pestra
	name = "naga hood"
	desc = "Worn by the faithful of Pestra. Resembling the face of the Naga clothed in rot."
	icon_state = "pestrahood"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR

/obj/item/clothing/head/padded/abyssor
	name = "sea hood"
	desc = "A green hood worn by the faithful of Abyssor."
	icon_state = "abysshood"
	icon = 'icons/roguetown/clothing/patron_hoods.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/patron_robes.dmi'
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR

/obj/item/clothing/head/roguehood/eora
	name = "opera hood"
	desc = "A silver opera mask worn by the faithful of Eora, usually during their rituals. Comes with a hood that can be pulled up for warmth."
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	icon_state = "eorahood"
	bloody_icon = 'icons/effects/blood64x64.dmi'
	bloody_icon_state = "helmetblood_big"
	worn_x_dimension = 64
	worn_y_dimension = 64
	resistance_flags = FIRE_PROOF // Made of metal
	armor = ARMOR_WEAK
	salvage_result = NUTRITION_LEVEL_HUNGRY

/obj/item/clothing/head/roguehood/astrata
	name = "sun hood"
	desc = "Worn by the faithful of Astrata."
	icon_state = "astratahood"
	resistance_flags = FIRE_PROOF // Not the sun hat!

	armor = ARMOR_MINIMAL
	prevent_crits = MINOR_CRITICALS

/obj/item/clothing/head/roguehood/priest
	name = "solar visage"
	desc = "The sanctified headwear of the most devoted. The mask can be removed."
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	icon_state = "solar"
	dynamic_hair_suffix = "+generic"
	dropshrink = 0.8
	bloody_icon = 'icons/effects/blood64x64.dmi'
	bloody_icon_state = "helmetblood_big"
	worn_x_dimension = 64
	worn_y_dimension = 64
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	default_hidden = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	resistance_flags = FIRE_PROOF

	armor = ARMOR_WEAK
	body_parts_covered = FULL_HEAD | NECK
	prevent_crits = MINOR_CRITICALS

/obj/item/clothing/head/roguehood/priest/AdjustClothes(mob/user)
	if(loc == user)
		playsound(user, "rustle", 70, TRUE, -5)
		if(adjustable == CAN_CADJUST)
			adjustable = CADJUSTED
			if(toggle_icon_state)
				icon_state = "[initial(icon_state)]_t"
			flags_inv = HIDEEARS|HIDEHAIR
			body_parts_covered = NECK|HAIR|EARS|HEAD
			dynamic_hair_suffix = "+generic"
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_head()
		else if(adjustable == CADJUSTED)
			ResetAdjust(user)
			flags_inv = default_hidden
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_head()
		user.update_fov_angles()
		user.regenerate_clothes()

/obj/item/clothing/head/roguehood/priest/equipped(mob/user, slot)
	. = ..()
	if ((slot & ITEM_SLOT_HEAD) && istype(user))
		ADD_TRAIT(user, TRAIT_ANTIMAGIC,"Anti-Magic")
	else
		REMOVE_TRAIT(user, TRAIT_ANTIMAGIC,"Anti-Magic")

/obj/item/clothing/head/roguehood/priest/dropped(mob/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_ANTIMAGIC,"Anti-Magic")

/obj/item/clothing/head/roguehood/priest/pickup(mob/living/user)
	if((user.job != "Priest") && (user.job != "Priestess"))
		playsound(user, 'sound/misc/gods/astrata_omen.ogg', 80, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
		user.visible_message(span_reallybig("UNWORTHY HANDS TOUCH MY VISAGE, CEASE OR BE PUNISHED"))
		spawn(30)
			if(loc == user)
				user.adjust_divine_fire_stacks(3)
				user.IgniteMob()
		return
	else
		. = ..()

/obj/item/clothing/head/priestmask
	name = "solar visage"
	desc = "The sanctified helm of the most devoted. Thieves beware."
	icon_state = "priesthead"
	dynamic_hair_suffix = ""
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	resistance_flags = FIRE_PROOF

/obj/item/clothing/head/priestmask/pickup(mob/living/user)
	if((user.job != "Priest") && (user.job != "Priestess"))
		to_chat(user, "<font color='yellow'>UNWORTHY HANDS TOUCH THE VISAGE, CEASE OR BE PUNISHED</font>")
		spawn(30)
			if(loc == user)
				user.adjust_divine_fire_stacks(5)
				user.IgniteMob()
		return
	else
		. = ..()

