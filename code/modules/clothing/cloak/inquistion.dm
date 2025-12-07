
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
	name = "open grenzelhoftian tabard"
	desc = "Used by more radical followers of the Inquisition"
	body_parts_covered = null
	icon_state = "psydontabardalt"
	item_state = "psydontabardalt"
	open_wear = TRUE

/obj/item/clothing/cloak/psydontabard/attack_hand_secondary(mob/user)
	switch(open_wear)
		if(FALSE)
			name = "inquisitorial tabard"
			desc = "A long vest bearing Psydonian symbology"
			body_parts_covered = null
			icon_state = "psydontabardalt"
			item_state = "psydontabardalt"
			open_wear = TRUE
			to_chat(usr, span_warning("Now wearing ENDURINGLY!"))
		if(TRUE)
			name = "inquisitorial tabard"
			desc = "A long vest bearing Psydonian symbology"
			body_parts_covered = CHEST|GROIN
			icon_state = "psydontabard"
			item_state = "psydontabard"
			flags_inv =HIDEBOOB
			open_wear = FALSE
			to_chat(usr, span_warning("Now wearing normally!"))
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

/obj/item/clothing/cloak/ordinatorcape/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/storage/concrete/grid/cloak)

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

/obj/item/clothing/cloak/absolutionistrobe/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/storage/concrete/grid/cloak)
