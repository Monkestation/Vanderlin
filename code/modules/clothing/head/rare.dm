/obj/item/clothing/head/rare
	name = "rare helmet template"
	icon_state = "elfhead"
	icon = 'icons/roguetown/clothing/Racial_Armour.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/onmob_racial.dmi'
	bloody_icon = 'icons/effects/blood32x64.dmi'
	bloody_icon_state = "helmetblood_big"
	blocksound = PLATEHIT	//DELETE AFTER REPATH
	equip_delay_self = 3 SECONDS
	unequip_delay_self = 3 SECONDS
	resistance_flags = FIRE_PROOF // These are all metallic DELETE AFTER REPATH
	anvilrepair = /datum/skill/craft/armorsmithing	//DELETE AFTER REPATH
	melt_amount = 75
	melting_material = /datum/material/steel
	sellprice = VALUE_STEEL_HELMET+BONUS_VALUE_SMALL

	armor = ARMOR_PLATE_GOOD
	armor_class = AC_HEAVY
	prevent_crits = ALL_CRITICAL_HITS
	max_integrity = INTEGRITY_STRONG
	abstract_type =  /obj/item/clothing/head/rare

//............... Bladesinger Helmet ............... //
/obj/item/clothing/head/rare/elfplate // Unique Bladesinger kit
	name = "elvish plate helmet"
	desc = "A bizarrely lightweight helmet of alloyed dark elven steel, offering unparalleled protection for elite bladesingers."
	icon_state = "elfhead"
	allowed_race = RACES_PLAYER_ELF_ALL
	clothing_flags = CANT_SLEEP_IN
	armor_class = AC_MEDIUM
	body_parts_covered = HEAD|HAIR|NOSE

/obj/item/clothing/head/rare/elfplate/welfplate // Unique Bladesinger kit
	desc = "A bizarrely lightweight helmet of alloyed elven steel, offering unparalleled protection for elite bladesingers."
	icon_state = "welfhead"

	body_parts_covered = HEAD|HAIR|NOSE|EYES


//............... Langobard Helmet ............... //
/obj/item/clothing/head/rare/dwarfplate // Unique Longbeard kit
	name = "langobard pot helm"
	desc = "The Langobards are a cult of personality that are tasked by the Dwarven Kings to issue judgement, \
			justice and order around the realms for dwarvenkind. This helmet is a respected symbol of authority."
	icon_state = "dwarfhead"
	allowed_race = list(SPEC_ID_DWARF)
	flags_inv = HIDEEARS
	clothing_flags = CANT_SLEEP_IN
	body_parts_covered = HEAD_EXCEPT_MOUTH

//............... Swordmaster Helmet ............... //
/obj/item/clothing/head/rare/grenzelplate // Unique Swordmaster kit
	name = "chicklet sallet"
	desc = "A Grenzelhoftian chicklet sallet, decorated with a plume of valor. \
			It has been proven with severe battle-testing that a wearer's head would crack before the helmet chips."
	icon_state = "human_swordhead"
	allowed_sex = list(MALE)
	allowed_race = list(SPEC_ID_HUMEN, SPEC_ID_AASIMAR)
	flags_inv = HIDEEARS
	clothing_flags = CANT_SLEEP_IN
	body_parts_covered = HEAD|EARS|HAIR


//............... Kataphract/bastion/spear/zaladin Helmet ............... //
/obj/item/clothing/head/rare/zaladplate // Unique Freelancer kit
	name = "bastion helm"
	desc = "The Zaladin Kataphractoe are the ancestral guardians of the first Despot, \
			their helms designed in the fashion of the capital's majestic sky-piercing tower \
			where the old God-King resided."
	icon_state = "human_spearhead"
	item_state = "human_spearplate"
	allowed_sex = list(MALE)
	allowed_race = list(SPEC_ID_HUMEN)
	flags_inv = HIDEEARS|HIDEFACE
	clothing_flags = CANT_SLEEP_IN
	body_parts_covered = HEAD|EARS|HAIR|NOSE|MOUTH

//............... Hoplite Helmet ............... //
/obj/item/clothing/head/rare/hoplite // Unique Hoplite kit
	name = "ancient helmet"
	desc = "A weathered bronze helmet topped with a symbol of Astrata's sun."
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64x64.dmi'
	icon_state = "aasimarhead"
	worn_x_dimension = 64
	worn_y_dimension = 64
	allowed_race = list(SPEC_ID_AASIMAR)
	flags_inv = HIDEEARS
	clothing_flags = CANT_SLEEP_IN
	body_parts_covered = HEAD|EARS|HAIR
	smeltresult = /obj/item/ingot/bronze
