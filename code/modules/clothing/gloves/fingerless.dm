
/obj/item/clothing/gloves/fingerless
	name = "fingerless gloves"
	desc = "Gloves made out of sturdy leather with the fingers cut off for extra dexterity. They offer almost no protection whatsoever."
	icon_state = "fingerless_gloves"
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	resistance_flags = FLAMMABLE // Made of leather

	armor = ARMOR_MINIMAL
	max_integrity = INTEGRITY_POOR
	clothing_traits = list(TRAIT_FINGERPRINT_PASSTHROUGH)

/obj/item/clothing/gloves/fingerless/shadowgloves
	name = "silk gloves"
	desc = "Silk gloves to absorb palm sweat while leaving the fingers free for fine manipulation."
	mob_overlay_icon = 'icons/roguetown/clothing/newclothes/onmob/onmobgloves.dmi'
	sleeved = 'icons/roguetown/clothing/newclothes/onmob/onmobgloves.dmi'
	icon_state = "shadowgloves"
	salvage_result = /obj/item/natural/silk
