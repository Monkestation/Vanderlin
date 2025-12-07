
/obj/item/clothing/cloak/martyr
	name = "martyr cloak"
	desc = "An elegant cloak in the colors of Astrata. Looks like it can only fit Humen-sized people."
	color = null
	icon_state = "martyrcloak"
	item_state = "martyrcloak"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	body_parts_covered = CHEST|GROIN
	boobed = FALSE
	sellprice = 100
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDEBOOB

/obj/item/clothing/armor/plate/full/holysee
	name = "holy silver plate"
	desc = "Silver-clad plate for the guardians and the warriors, for the spears and shields of the Ten."
	icon = 'icons/roguetown/clothing/special/martyr.dmi'
	icon_state = "silverarmor"
	item_state = "silverarmor"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	sleevetype = "silverarmor"
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/martyr.dmi'
	armor = ARMOR_PLATE
	sellprice = 1000
	melting_material = /datum/material/silver
	melt_amount = 350

/obj/item/clothing/pants/platelegs/holysee
	name = "holy silver chausses"
	desc = "Plate leggings of silver forged for the Holy See's forces. A sea of silver to descend upon evil."
	icon = 'icons/roguetown/clothing/special/martyr.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/martyr.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_pants.dmi'
	sleevetype = "silverlegs"
	icon_state = "silverlegs"
	item_state = "silverlegs"
	armor = ARMOR_PLATE
	sellprice = 1000
	melting_material = /datum/material/silver
	melt_amount = 250

/obj/item/clothing/head/helmet/heavy/holysee
	name = "holy silver bascinet"
	desc = "Branded by the Holy See, these helms are worn by its chosen warriors. A bastion of hope in the dark nite."
	icon = 'icons/roguetown/clothing/special/martyr.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/martyrbascinet.dmi'
	bloody_icon = 'icons/effects/blood64x64.dmi'
	adjustable = CAN_CADJUST
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	worn_x_dimension = 64
	worn_y_dimension = 64
	icon_state = "silverbascinet"
	item_state = "silverbascinet"
	sellprice = 1000
	melting_material = /datum/material/silver
	melt_amount = 250


/obj/item/clothing/cloak/holysee
	name = "holy silver vestments"
	desc = "A set of vestments worn by the Holy See's forces, silver embroidery and seals of light ordain it as a bastion against evil."
	icon = 'icons/roguetown/clothing/special/martyr.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/martyr.dmi'
	icon_state = "silvertabard"
	item_state = "silvertabard"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_cloaks.dmi'
	sleevetype = "silvertabard"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDEBOOB
	var/overarmor = TRUE
	sellprice = 300


/obj/item/clothing/cloak/holysee/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/storage/concrete/grid/cloak)

/obj/item/clothing/cloak/holysee/dropped(mob/living/carbon/human/user)
	..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		var/list/things = STR.contents()
		for(var/obj/item/I in things)
			STR.remove_from_storage(I, get_turf(src))

/obj/item/clothing/cloak/holysee/MiddleClick(mob/user)
	overarmor = !overarmor
	to_chat(user, span_info("I [overarmor ? "wear the tabard over my armor" : "wear the tabard under my armor"]."))
	if(overarmor)
		alternate_worn_layer = TABARD_LAYER
	else
		alternate_worn_layer = UNDER_ARMOR_LAYER
	user.update_inv_cloak()
	user.update_inv_armor()

/datum/stress_event/naledimasklost
	stress_change = 3
	desc = span_boldred("The mask! Anyone here could be unholy. I'm exposed.")
	timer = 999 MINUTES

/datum/status_effect/debuff/lost_naledi_mask
	id = "naledimask"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/naledimask
	effectedstats = list(STATKEY_END = -3, STATKEY_LCK = -3)

/atom/movable/screen/alert/status_effect/debuff/naledimask
	name = "Lost Mask"
	desc = "The unholy and daemons may claim me at any moment without the mask. It is not safe."
	icon_state = "muscles"

/obj/item/clothing/face/lordmask/naledi
	name = "war scholar's mask"
	item_state = "naledimask"
	icon_state = "naledimask"
	desc = "Runes and wards, meant for daemons; the gold has somehow rusted in unnatural, impossible agony. The most prominent of these etchings is in the shape of the psycross. Armored to protect the wearer's face."
	max_integrity = 100
	armor = ARMOR_MASK_METAL
	flags_inv = HIDEFACE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	sellprice = 0

/obj/item/clothing/face/lordmask/naledi/equipped(mob/user, slot)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.merctype == 14)	//Naledi
			H.remove_status_effect(/datum/status_effect/debuff/lost_naledi_mask)
			H.remove_stress(/datum/stress_event/naledimasklost)

/obj/item/clothing/face/lordmask/naledi/dropped(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.merctype == 14)	//Naledi
			if(!istiefling(user)) //Funny exception
				H.apply_status_effect(/datum/status_effect/debuff/lost_naledi_mask)
				H.add_stress(/datum/stress_event/naledimasklost)

/obj/item/clothing/face/lordmask/naledi/sojourner
	name = "sojourner's mask"
	item_state = "naledimask"
	icon_state = "naledimask"
	desc = "A golden mask, hiding the face of those who prefer their fists and agility to speak for them."
	max_integrity = 150
	armor = ARMOR_MASK_METAL
	flags_inv = HIDEFACE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	sellprice = 0

/obj/item/clothing/face/exoticsilkmask
	name = "exotic silk mask"
	icon_state = "exoticsilkmask"
	flags_inv = HIDEFACE|HIDEFACIALHAIR
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	sewrepair = TRUE
	adjustable = CAN_CADJUST
	toggle_icon_state = FALSE
