
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

/obj/item/clothing/armor/plate/full/grandmaster
	name = "holy silver plate"
	desc = "Silver-clad plate for the guardians and the warriors, for the spears and shields of the Ten."
	icon = 'icons/roguetown/clothing/special/martyr.dmi'
	icon_state = "silverarmor"
	item_state = "silverarmor"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	sleevetype = "silverarmor"
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/martyr.dmi'
	armor_type = /datum/armor/plate
	sellprice = 1000
	melting_material = /datum/material/silver
	melt_amount = 350

/obj/item/clothing/pants/platelegs/grandmaster
	name = "holy silver chausses"
	desc = "Plate leggings of silver forged for the grandmaster. A sea of silver to descend upon evil."
	icon = 'icons/roguetown/clothing/special/martyr.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/martyr.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_pants.dmi'
	sleevetype = "silverlegs"
	icon_state = "silverlegs"
	item_state = "silverlegs"
	armor_type = /datum/armor/pants/plate
	sellprice = 1000
	melting_material = /datum/material/silver
	melt_amount = 250

/obj/item/clothing/head/helmet/heavy/grandmaster
	name = "holy silver bascinet"
	desc = "Branded by the faithful of the Ten, these helms are worn by its chosen warriors. A bastion of hope in the dark nite."
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


/obj/item/clothing/cloak/grandmaster
	name = "holy silver vestments"
	desc = "A set of vestments worn by the grandmaster, silver embroidery and seals of light ordain it as a bastion against evil."
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
	has_storage = TRUE

/obj/item/clothing/cloak/grandmaster/MiddleClick(mob/user)
	overarmor = !overarmor
	to_chat(user, span_info("I [overarmor ? "wear the tabard over my armor" : "wear the tabard under my armor"]."))
	if(overarmor)
		alternate_worn_layer = TABARD_LAYER
	else
		alternate_worn_layer = UNDER_ARMOR_LAYER
	user.update_inv_cloak()
	user.update_inv_armor()

/obj/item/clothing/face/lordmask/preceptor
	name = "preceptor's mask"
	item_state = "naledimask"
	icon_state = "naledimask"
	desc = "Runes and wards, meant for daemons; the gold has somehow rusted in unnatural, impossible agony. The most prominent of these etchings is in the shape of the psycross. Armored to protect the wearer's face."
	max_integrity = 100
	armor_type = /datum/armor/mask/metal
	flags_inv = HIDEFACE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	sellprice = 0

/obj/item/clothing/face/lordmask/preceptor/gold
	name = "preceptor's mask"
	item_state = "naledimask"
	icon_state = "naledimask"
	desc = "A golden mask, hiding the face of those who prefer their fists and agility to speak for them."
	max_integrity = 150
	armor_type = /datum/armor/mask/metal
	flags_inv = HIDEFACE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	sellprice = 0

/obj/item/clothing/face/exoticsilkmask
	name = "exotic silk mask"
	icon_state = "exoticsilkmask"
	flags_inv = HIDEFACE|HIDEFACIALHAIR
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	sewrepair = /datum/attribute/skill/misc/sewing/mending
	salvage_amount = 1
	salvage_result = /obj/item/natural/silk
	dyeable = TRUE
	adjustable = CAN_CADJUST
	toggle_icon_state = FALSE
