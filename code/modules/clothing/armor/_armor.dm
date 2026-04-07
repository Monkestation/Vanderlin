/obj/item/clothing/armor
	name = "suit"

	icon = 'icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/armor.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	sleevetype = "shirt"
	bloody_icon_state = "bodyblood"
	boobed = TRUE
	nodismemsleeves = TRUE

	equip_delay_self = 3 SECONDS
	unequip_delay_self = 2 SECONDS

	resistance_flags = FIRE_PROOF
	blocksound = PLATEHIT
	blade_dulling = DULLING_BASHCHOP

	equip_sound = 'sound/foley/equip/equip_armor.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	pickup_sound =  'sound/blank.ogg'
	break_sound = 'sound/foley/breaksound.ogg'

	slot_flags = ITEM_SLOT_ARMOR
	armor = ARMOR_MINIMAL
	experimental_onhip = TRUE // does this do anything on armor I wonder?
	body_parts_covered = CHEST

	sellprice = VALUE_COMMON_GOODS

	min_cold_protection_temperature = 0 ///this is kinda just a balance thing
	max_heat_protection_temperature = 0 ///this is kinda just a balance thing

	grid_width = 64
	grid_height = 96
	item_weight = 7 KILOGRAMS

	var/fire_resist = T0C+100
	var/blood_overlay_type = "suit"
	var/togglename = null
	abstract_type = /obj/item/clothing/armor

	material_category = ARMOR_MAT_PLATE

/obj/item/clothing/armor/worn_overlays(mutable_appearance/standing, isinhands = FALSE, icon_file, dummy_block = FALSE)
	. = ..()
	if(!isinhands)
		var/mob/living/carbon/human/M = loc
		if(ishuman(M) && M.wear_pants)
			var/obj/item/clothing/pants/U = M.wear_pants
			if(istype(U) && U.attached_accessory)
				var/obj/item/clothing/accessory/A = U.attached_accessory
				if(A.above_suit)
					. += U.accessory_overlay

/obj/item/clothing/armor/update_clothes_damaged_state(damaging = TRUE)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_shirt()
		M.update_inv_armor()
