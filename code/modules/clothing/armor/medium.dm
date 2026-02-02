/obj/item/clothing/armor/medium	// Template, not for use
	name = "Medium armor template"
	equip_delay_self = 4 SECONDS
	unequip_delay_self = 3 SECONDS
	anvilrepair = /datum/skill/craft/armorsmithing
	melt_amount = 75
	melting_material = /datum/material/steel
	armor_class = AC_MEDIUM
	armor = ARMOR_SCALE
	max_integrity = INTEGRITY_STANDARD
	clothing_flags = CANT_SLEEP_IN
	prevent_crits = ALL_EXCEPT_STAB
	abstract_type = /obj/item/clothing/armor/medium

/obj/item/clothing/armor/medium/scale // important is how this item covers legs too compared to halfplate
	name = "scalemail"
	desc = "Overlapping steel plates almost makes the wearer look like he has silvery fish scales."
	icon_state = "scale"
	sellprice = VALUE_STEEL_ARMOR_FINE

	body_parts_covered = COVERAGE_ALL_BUT_ARMS
	prevent_crits = ALL_CRITICAL_HITS
	max_integrity = INTEGRITY_STRONG
	item_weight = 7

/obj/item/clothing/armor/medium/scale/steppe
	name = "steel heavy lamellar"
	desc = "A chestpiece composed of easily-replaced small rectangular plates of layered steel laced together in rows with wire. Malleable and protective, perfect for cavalrymen."
	icon_state = "hudesutu"
	body_parts_covered = COVERAGE_FULL

//................ Armored Surcoat ............... //	- splint mail looking armor thats colored
/obj/item/clothing/armor/medium/surcoat
	name = "armored surcoat"
	desc = "Metal plates partly hidden by cloth, fitted for a man."
	icon_state = "surcoat"
	item_state = "surcoat"
	detail_tag = "_metal"		// metal bits are the details so keep them uncolorer = white
	detail_color = COLOR_WHITE
	item_weight = 7.4

/obj/item/clothing/armor/medium/surcoat/Initialize()
	. = ..()
	update_appearance(UPDATE_ICON)

/obj/item/clothing/armor/medium/surcoat/update_overlays()
	. = ..()
	if(!get_detail_tag())
		return
	var/mutable_appearance/pic = mutable_appearance(icon, "[icon_state][detail_tag]")
	pic.appearance_flags = RESET_COLOR
	if(get_detail_color())
		pic.color = get_detail_color()
	. += pic

//................ Armored surcoat (Heartfelt) ............... //
/obj/item/clothing/armor/medium/surcoat/heartfelt
	desc = "A lordly protection in Heartfelt colors. Masterfully crafted coat of plates, for important nobility."
	color = CLOTHING_BLOOD_RED
	sellprice = VALUE_SNOWFLAKE_STEEL+BONUS_VALUE_SMALL

	body_parts_covered = COVERAGE_FULL

/obj/item/clothing/armor/medium/scale/inqcoat
	slot_flags = ITEM_SLOT_ARMOR
	name = "inquisitorial duster"
	desc = "Metal plates reinforce this heavy coat. Its striking silhouette is of ill omen to any mainland community - whether pious, or profane."
	body_parts_covered = CHEST|VITALS|GROIN|LEGS|ARMS
	allowed_sex = list(MALE, FEMALE)
	icon = 'icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/armor.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_armor_inqui.dmi'
	icon_state = "inqcoat"
	item_state = "inqcoat"
	sleevetype = "shirt"
	max_integrity = INTEGRITY_STRONG
	anvilrepair = /datum/skill/craft/armorsmithing
	melt_amount = 75
	melting_material = /datum/material/steel
	equip_delay_self = 4 SECONDS
	blocksound = SOFTHIT

/obj/item/clothing/armor/medium/scale/inqcoat/Initialize()
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, custom_sounds = SFX_INQUIS_BOOT_STEP)

/obj/item/clothing/armor/medium/scale/inqcoat/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/clothing/armor/plate/fluted/ornate))
		user.visible_message(span_warning("[user] starts to fit [W] inside the [src]."))
		if(do_after(user, 12 SECONDS))
			var/obj/item/clothing/armor/medium/scale/inqcoat/armored/P = new /obj/item/clothing/armor/medium/scale/inqcoat/armored(get_turf(src.loc))
			if(user.is_holding(src))
				user.dropItemToGround(src)
			user.put_in_hands(P)
			P.update_integrity(atom_integrity)
			qdel(src)
			qdel(W)
		else
			user.visible_message(span_warning("[user] stops fitting [W] inside the [src]."))
		return

/obj/item/clothing/armor/medium/scale/inqcoat/armored
	slot_flags = ITEM_SLOT_ARMOR
	name = "armored inquisitorial duster"
	desc = "Metal plates reinforce this heavy coat, worn over the top of the finest Psydonian plate."
	smeltresult = /obj/item/ingot/steel
	icon_state = "inqcoata"
	item_state = "inqcoata"
	equip_delay_self = 4 SECONDS
	max_integrity = 300
	armor_class = AC_MEDIUM
	armor = list("blunt" = 40, "slash" = 100, "stab" = 80, "piercing" = 40, "fire" = 0, "acid" = 0)
	melt_amount = 150
	melting_material =  /datum/material/steel
	blocksound = PLATEHIT

