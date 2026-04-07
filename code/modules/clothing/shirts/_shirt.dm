/obj/item/clothing/shirt
	name = "shirt"

	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	bloody_icon_state = "bodyblood"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	sleevetype = "shirt"
	boobed = TRUE

	slot_flags = ITEM_SLOT_SHIRT
	body_parts_covered = CHEST|VITALS
	prevent_crits = list(BCLASS_LASHING)
	armor = list("blunt" = 0, "slash" = 0, "stab" = 0,  "piercing" = 0, "fire" = 0, "acid" = 0)

	edelay_type = 1
	equip_delay_self = 25

	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'

	sewrepair = /datum/attribute/skill/misc/sewing/mending
	dyeable = TRUE
	anvilrepair = null
	smeltresult = /obj/item/fertilizer/ash

	grid_width = 64
	grid_height = 64
	item_weight = 150 GRAMS

	var/fire_resist = T0C+100
	var/blood_overlay_type = "suit"
	var/togglename = null
	abstract_type = /obj/item/clothing/shirt

/obj/item/clothing/shirt/worn_overlays(mutable_appearance/standing, isinhands = FALSE, icon_file, dummy_block = FALSE)
	. = ..()
	if(!isinhands)
		var/mob/living/carbon/human/M = loc
		if(ishuman(M) && M.wear_pants)
			var/obj/item/clothing/pants/U = M.wear_pants
			if(istype(U) && U.attached_accessory)
				var/obj/item/clothing/accessory/A = U.attached_accessory
				if(A.above_suit)
					. += U.accessory_overlay

/obj/item/clothing/shirt/update_clothes_damaged_state(damaging = TRUE)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_shirt()
		M.update_inv_armor()
