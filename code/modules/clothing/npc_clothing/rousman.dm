/obj/item/clothing/head/helmet/rousman
	name = "stomachgutter helmet"
	icon_state = "stomachgutter_helm_item"
	item_state = "stomachgutter_helm"
	smeltresult = /obj/item/ingot/iron
	icon = 'icons/roguetown/mob/monster/rousman.dmi'
	allowed_race = list(SPEC_ID_ROUSMAN)
	armor = list("blunt" = 80, "slash" = 80, "stab" = 80,  "piercing" = 0, "fire" = 0, "acid" = 0)
	body_parts_covered = HEAD|EARS|HAIR|EYES
	sellprice = 0

/obj/item/clothing/armor/cuirass/iron/rousman
	name = "stomachgutter plate armor"
	icon_state = "stomachgutter_armor_item"
	item_state = "stomachgutter_armor"
	icon = 'icons/roguetown/mob/monster/rousman.dmi'
	smeltresult = /obj/item/ingot/iron
	armor = list("blunt" = 80, "slash" = 80, "stab" = 80,  "piercing" = 0, "fire" = 0, "acid" = 0)
	allowed_race = list(SPEC_ID_ROUSMAN)
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
	anvilrepair = /datum/skill/craft/armorsmithing
	max_integrity = 60
	armor_class = AC_LIGHT
	sellprice = 0

/obj/item/clothing/armor/leather/hide/rousman
	name = "rousman loincloth"
	icon_state = "rousman_loincloth_item"
	item_state = "rousman_loincloth"
	icon = 'icons/roguetown/mob/monster/rousman.dmi'
	allowed_race = list(SPEC_ID_ROUSMAN)
	armor = list("blunt" = 30, "slash" = 30, "stab" = 30,  "piercing" = 0, "fire" = 0, "acid" = 0)
	body_parts_covered = CHEST|GROIN
	sellprice = 0
	smeltresult = /obj/item/fertilizer/ash

/obj/item/clothing/armor/leather/advanced/rousman
	name = "rous assassin armor"
	icon_state = "assassin_armour"
	item_state = "assassin_armour"
	icon = 'icons/roguetown/mob/monster/rousman.dmi'
	allowed_race = list(SPEC_ID_ROUSMAN)
	sellprice = 0
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/head/roguehood/rousman
	name = "rous assassin mask"
	icon_state = "assassin_mask"
	item_state = "assassin_mask"
	icon = 'icons/roguetown/mob/monster/rousman.dmi'
	allowed_race = list(SPEC_ID_ROUSMAN)
	adjustable = CAN_CADJUST
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	armor = list("blunt" = 70, "slash" = 60, "stab" = 30, "piercing" = 20, "fire" = 0, "acid" = 0)
	sellprice = 0
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/head/roguehood/rousman/AdjustClothes(mob/living/carbon/user)
	. = ..()
	item_state = icon_state
	if(ishuman(user))
		var/mob/living/carbon/H = user
		H.update_inv_head()

/obj/item/clothing/head/roguehood/rousman/ResetAdjust(mob/user)
	. = ..()
	item_state = icon_state
	if(ishuman(user))
		var/mob/living/carbon/H = user
		H.update_inv_head()

/obj/item/clothing/shirt/robe/rousseer
	name = "rousman seer armour"
	icon_state = "seer_armour"
	item_state = "seer_armour"
	icon = 'icons/roguetown/mob/monster/rousman.dmi'
	icon = 'icons/roguetown/mob/monster/rousman.dmi'
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	body_parts_covered = CHEST|GROIN|VITALS|LEGS
	armor = list("blunt" = 50, "slash" = 30, "stab" = 20, "piercing" = 10, "fire" = 0, "acid" = 0)
	allowed_race = list(SPEC_ID_ROUSMAN)
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/head/roguehood/rousman/rousseer
	name = "rousman seer hood"
	icon_state = "seer_hood"
	item_state = "seer_hood"
	mob_overlay_icon = 'icons/roguetown/mob/monster/rousman.dmi'
	armor = list("blunt" = 50, "slash" = 30, "stab" = 20, "piercing" = 10, "fire" = 0, "acid" = 0)
	misc_flags = CRAFTING_TEST_EXCLUDE
