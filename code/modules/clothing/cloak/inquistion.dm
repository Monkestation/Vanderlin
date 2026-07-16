
/obj/item/clothing/cloak/psydontabard
	name = "inquisitorial tabard"
	desc = "A long vest bearing Psydonian symbology"
	color = null
	icon_state = "psydontabard"
	item_state = "psydontabard"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDEBOOB
	var/open_wear = FALSE

/obj/item/clothing/cloak/psydontabard/alt
	name = "inquisitorial tabard"
	examine_name = "monk tabard"
	desc = "Used by more radical followers of the Inquisition"
	body_parts_covered = null
	icon_state = "psydontabardalt"
	item_state = "psydontabardalt"
	open_wear = TRUE

/obj/item/clothing/cloak/psydontabard/attack_hand_secondary(mob/user)
	switch(open_wear)
		if(FALSE)
			name = "inquisitorial tabard"
			examine_name = "monk tabard"
			desc = "A long vest bearing Psydonian symbology"
			body_parts_covered = null
			icon_state = "psydontabardalt"
			item_state = "psydontabardalt"
			open_wear = TRUE
			to_chat(usr, span_warning("Now wearing ENDURINGLY!"))
		if(TRUE)
			name = "inquisitorial tabard"
			examine_name = "inquisitorial tabard"
			desc = "A long vest bearing Psydonian symbology"
			body_parts_covered = CHEST|GROIN
			icon_state = "psydontabard"
			item_state = "psydontabard"
			flags_inv =HIDEBOOB
			open_wear = FALSE
			to_chat(usr, span_warning("Now wearing normally!"))

	if(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_cloak()
			H.update_inv_armor()

/obj/item/clothing/cloak/psydontabard/black
	name = "blessed tabard"
	desc = "A tabard worn by the worshippers of Psydon. A funeral shroud for the paradise that could've been, and a solemn vow to continue the struggle towards salvation."
	icon_state = "blackpsydontabard"
	item_state = "blackpsydontabard"

/obj/item/clothing/cloak/psydontabard/black/alt
	name = "opened blessed tabard"
	desc = "A tabard worn by the worshippers of Psydon, peeled back to reveal its mourning innards."
	body_parts_covered = GROIN

/obj/item/clothing/cloak/psydontabard/black/MiddleClick(mob/user)
	..()
	user.update_inv_shirt()

/obj/item/clothing/cloak/psydontabard/black/attack_hand_secondary(mob/user)
	switch(open_wear)
		if(FALSE)
			name = "opened blessed tabard"
			desc = "A tabard worn by the worshippers of Psydon, peeled back to reveal its mourning innards."
			body_parts_covered = GROIN
			icon_state = "blackpsydontabardalt"
			item_state = "blackpsydontabardalt"
			open_wear = TRUE
			flags_inv = NONE
			to_chat(usr, span_warning("You pull back the threaded burlap, baring your heart to Psydonia's eyes."))
		if(TRUE)
			name = "blessed tabard"
			desc = "A tabard worn by the worshippers of Psydon. A funeral shroud for the paradise that could've been, and a solemn vow to continue the struggle towards salvation."
			body_parts_covered = CHEST|GROIN
			icon_state = "blackpsydontabard"
			item_state = "blackpsydontabard"
			flags_inv = HIDEBOOB
			open_wear = FALSE
			to_chat(usr, span_warning("You cloak yourself in the threaded burlap, veiling your heart from Psydonia's eyes."))
	update_icon()
	if(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_cloak()
			H.update_inv_armor()

/obj/item/clothing/cloak/tabard/toga
	name = "toga"
	desc = "The ancestral predecessor to Psydonia's many tabards, worn by the heroes and villains of antiquity."
	icon_state = "whitepsydontabard"
	item_state = "whitepsydontabard"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	detail_tag = null
	var/open_wear = FALSE

/obj/item/clothing/cloak/tabard/toga/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Right-clicking this cloak allows for it to be dynamically worn as a traditional tabard, or as a sleeveless robe that partially exposes the chest.")

/obj/item/clothing/cloak/tabard/toga/alt
	name = "opened toga"
	desc = "The ancestral predecessor to Psydonia's many tabards, parted to reveal what lies beneath its cloth."
	body_parts_covered = GROIN
	icon_state = "whitepsydontabardalt"
	item_state = "whitepsydontabardalt"
	open_wear = TRUE

/obj/item/clothing/cloak/tabard/toga/MiddleClick(mob/user)
	..()
	user.update_inv_shirt()

/obj/item/clothing/cloak/tabard/toga/attack_hand_secondary(mob/user)
	switch(open_wear)
		if(FALSE)
			name = "opened toga"
			desc = "The ancestral predecessor to Psydonia's many tabards, parted to reveal what lies beneath its cloth."
			body_parts_covered = GROIN
			icon_state = "whitepsydontabardalt"
			item_state = "whitepsydontabardalt"
			open_wear = TRUE
			flags_inv = NONE
			to_chat(usr, span_warning("You pull back the threaded cloth, baring your heart to Psydonia's eyes."))
		if(TRUE)
			name = "toga"
			desc = "The ancestral predecessor to Psydonia's many tabards, worn by the heroes and villains of antiquity."
			body_parts_covered = CHEST|GROIN
			icon_state = "whitepsydontabard"
			item_state = "whitekpsydontabard"
			flags_inv = HIDEBOOB
			open_wear = FALSE
			to_chat(usr, span_warning("You cloak yourself in the threaded cloth, veiling your heart from Psydonia's eyes."))
	update_icon()
	if(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_cloak()
			H.update_inv_armor()

/obj/item/clothing/cloak/ordinatorcape
	name = "ordinator cape"
	desc = "A flowing red cape complete with an ornately patterned steel shoulderguard. Made to last. Made to ENDURE. Made to LIVE."
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	icon_state = "ordinatorcape"
	item_state = "ordinatorcape"
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	has_storage = TRUE

/obj/item/clothing/cloak/ordinatorcape/lirvas
	name = "warrior silks"
	desc = "Fine silks. Only the best for me, of course. You need to look good while beating someone to death."
	icon_state = "lirvastabard"
	item_state = "lirvastabard"
	sellprice = 25

/obj/item/clothing/cloak/cape/inquisitorgold
	name = "golden order cloak"
	desc = "A time honored cloak inlined with golden threading, the stitchwork tethers it to the Golden Orders."
	icon_state = "inquisitor_cloak"
	icon = 'icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	color = null

/obj/item/clothing/cloak/cape/inquisitorsilver
	name = "silver order cloak"
	desc = "A time honored cloak inlined with silver threading, the stitchwork tethers it to the Silver Orders"
	icon_state = "sinquisitor_cloak"
	icon = 'icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	color = null

/obj/item/clothing/cloak/absolutionistrobe
	name = "absolver's robe"
	desc = "Absolve them of their pain. Absolve them of their longing. Live, as PSYDON lives."
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	icon_state = "absolutionistrobe"
	item_state = "absolutionistrobe"
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	has_storage = TRUE

/obj/item/clothing/cloak/absolutionistrobe/black
	name = "blessed robe"
	desc = "Weep for what was lost. Pray for those who may yet be saved. Endure, in His name."
	icon_state = "blackabsolutionistrobe"
	item_state = "blackabsolutionistrobe"
