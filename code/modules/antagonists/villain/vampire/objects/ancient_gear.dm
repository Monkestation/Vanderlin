
//................ Helmets ............... //

/obj/item/clothing/head/helmet/heavy/ancient
	misc_flags = CRAFTING_TEST_EXCLUDE
	name = "ancient barbute"
	desc = "A very old barbute."
	icon_state = "ancientbarbute"
	item_state = "ancientbarbute"

	armor_type = /datum/armor/head/plate/good
	flags_inv = HIDEEARS|HIDEHAIR

	detail_tag = "_detail"
	detail_color = CLOTHING_BLOOD_RED

	body_parts_covered = COVERAGE_HEAD_NOSE
	block2add = FOV_BEHIND
	item_weight = 2.10 KILOGRAMS

/obj/item/clothing/head/helmet/ancient
	name = "ancient savoyard"
	desc = "A terrifying old savoyard."
	icon_state = "ancientsavoyard"
	item_state = "ancientsavoyard"

	misc_flags = CRAFTING_TEST_EXCLUDE

	armor_class = AC_MEDIUM
	armor_type = /datum/armor/head/plate
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	body_parts_covered = HEAD_NECK
	block2add = FOV_BEHIND
	item_weight = 4.6 KILOGRAMS
	max_integrity = INTEGRITY_OLD_STRONG
	smeltresult = /obj/item/ingot/steel_slag
	sellprice = VALUE_STEEL_HELMET

/obj/item/clothing/head/helmet/ancient/vampire
	name = "ancient ceremonial savoyard"
	desc = "A grand savoyard of enchanted gilbranze. Inflicting terror in style."
	icon_state = "vhelmet"
	armor_type = /datum/armor/head/plate/good
	smeltresult = /obj/item/ingot/vampire

	armor_class = AC_MEDIUM
	prevent_crits = ALL_CRITICAL_HITS_VAMP
	max_integrity = INTEGRITY_OLD_BLACKSTEEL

//................ Face ............... //

/obj/item/clothing/face/facemask/steel/ancient
	name = "ancient mask"
	icon_state = "ancientmask"
	desc = "An ancient mask that hides an ancient evil."
	misc_flags = CRAFTING_TEST_EXCLUDE

//................ Neck ............... //

/obj/item/clothing/neck/chaincoif/ancient
	name = "ancient chain coif"
	desc = "A very old coif."
	icon_state = "achaincoif"
	item_state = "achaincoif"
	misc_flags = CRAFTING_TEST_EXCLUDE

	armor_type = /datum/armor/neck/maille/good

/obj/item/clothing/neck/gorget/ancient
	name = "ancient gorget"
	desc = "A very old gorget."
	icon_state = "ancientgorget"
	misc_flags = CRAFTING_TEST_EXCLUDE

	armor_type = /datum/armor/neck/plate
	max_integrity = INTEGRITY_OLD_STRONG + 100

/obj/item/clothing/neck/gorget/ancient/vampire
	name = "ancient ceremonial gorget"
	desc = "A neckguard of enchanted gilbranze. Though a vampyre needn't air to lyve, they most certainly need a spine."
	icon_state = "vgorget"

	smeltresult = /obj/item/ingot/vampire
	armor_class = AC_MEDIUM
	prevent_crits = ALL_CRITICAL_HITS_VAMP
	max_integrity = INTEGRITY_OLD_BLACKSTEEL

//................ Armor ............... //

/obj/item/clothing/armor/cuirass/ancient
	name = "ancient cuirass"
	desc = "An old cuirass, deceptively sturdy."
	icon_state = "ancientcuirass"
	misc_flags = CRAFTING_TEST_EXCLUDE

	armor_type = /datum/armor/plate/good
	item_weight = 8.5 KILOGRAMS

/obj/item/clothing/armor/plate/ancient
	name = "ancient half-plate"
	desc = "An ornate, ceremonial plate of considerable age."
	icon_state = "ancientplate"
	misc_flags = CRAFTING_TEST_EXCLUDE

	armor_type = /datum/armor/plate/good
	item_weight = 16 KILOGRAMS

/obj/item/clothing/armor/plate/ancient/vampire
	name = "ancient ceremonial plate"
	desc = "A ornate, ceremonial enchanted gilbranze plate suit of considerable age."
	icon_state = "vplate"

	smeltresult = /obj/item/ingot/vampire
	armor_class = AC_MEDIUM
	prevent_crits = ALL_CRITICAL_HITS_VAMP
	item_weight = 10 KILOGRAMS
	max_integrity = INTEGRITY_OLD_BLACKSTEEL

//................ Underarmor ............... //

/obj/item/clothing/armor/chainmail/ancient
	name = "ancient haubergeon"
	desc = "A very old haubergeon."
	icon_state = "ancientchain"
	misc_flags = CRAFTING_TEST_EXCLUDE

	armor_type = /datum/armor/maille/good
	item_weight = 10 KILOGRAMS

/obj/item/clothing/armor/chainmail/hauberk/ancient
	name = "ancient hauberk"
	desc = "A very old hauberk."
	icon_state = "ancienthauberk"
	misc_flags = CRAFTING_TEST_EXCLUDE

	armor_type = /datum/armor/maille/good
	item_weight = 11 KILOGRAMS

/obj/item/clothing/armor/chainmail/hauberk/ancient/vampire
	name = "ancient ceremonial vestments"
	desc = "An ornate aketon, woven from crimson silk and worn beneath a layer of enchanted gilbranze maille."
	icon_state = "vhauberk"

	smeltresult = /obj/item/ingot/vampire
	armor_class = AC_MEDIUM
	prevent_crits = ALL_CRITICAL_HITS_VAMP
	item_weight = 9.5 KILOGRAMS
	max_integrity = INTEGRITY_OLD_BLACKSTEEL

//................ Wrists ............... //

/obj/item/clothing/wrists/bracers/ancient
	name = "ancient vambraces"
	desc = "Very old vambraces."
	icon_state = "ancientbracers"
	item_state = "ancientbracers"
	misc_flags = CRAFTING_TEST_EXCLUDE

	armor_type = /datum/armor/wrist/plate/good

/obj/item/clothing/wrists/bracers/ancient/vampire
	name = "ancient ceremonial bracers"
	desc = "Enchanted gilbranze cuffings, clasped around the wrists."
	icon_state = "vbracers"
	armor_class = AC_MEDIUM
	prevent_crits = ALL_CRITICAL_HITS_VAMP
	max_integrity = INTEGRITY_OLD_BLACKSTEEL
	smeltresult = /obj/item/ingot/vampire

//................ Gloves ............... //

/obj/item/clothing/gloves/chain/ancient
	name = "ancient chain gauntlets"
	desc = "Weathered gauntlets with an ancient design."
	icon_state = "acgloves"
	misc_flags = CRAFTING_TEST_EXCLUDE

	item_weight = 1.2 KILOGRAMS
	armor_type = /datum/armor/gloves/maille/good

/obj/item/clothing/gloves/plate/ancient
	name = "ancient plate gauntlets"
	desc = "Weathered gauntlets with an ancient design."
	icon_state = "agauntlets"
	misc_flags = CRAFTING_TEST_EXCLUDE

	armor_type = /datum/armor/gloves/plate/good
	item_weight = 1.45 KILOGRAMS

/obj/item/clothing/gloves/plate/ancient/vampire
	name = "ancient ceremonial gauntlets"
	icon_state = "Enchanted gilbranze fingerettes, meticulously forged to leave no motion unimpeded."
	icon_state = "vgloves"
	armor_class = AC_MEDIUM
	prevent_crits = ALL_CRITICAL_HITS_VAMP
	item_weight = 1.65 KILOGRAMS
	max_integrity = INTEGRITY_OLD_BLACKSTEEL
	smeltresult = /obj/item/ingot/vampire

//................ Legs ............... //

/obj/item/clothing/pants/chainlegs/kilt/ancient
	name = "ancient chain kilt"
	desc = "A very old chain kilt."
	icon_state = "achainkilt"
	item_state = "achainkilt"
	icon = 'icons/roguetown/clothing/pants.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/pants.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_pants.dmi'
	misc_flags = CRAFTING_TEST_EXCLUDE

	armor_type = /datum/armor/pants/maille/good
	item_weight = 5.4 KILOGRAMS

/obj/item/clothing/pants/platelegs/ancient
	name = "ancient chausses"
	desc = "Chausses made of an ancient steel."
	icon_state = "ancientpants"
	item_state = "ancientpants"
	misc_flags = CRAFTING_TEST_EXCLUDE

	sleeved = FALSE

	armor_type = /datum/armor/pants/plate/good
	item_weight = 5.5 KILOGRAMS

/obj/item/clothing/pants/platelegs/ancient/vampire
	name = "ancient ceremonial plate greaves"
	desc = "Enchanted gilbranze tassets, meticulously shingled over silk-lined chausses."
	icon_state = "vpants"
	item_weight = 4.5 KILOGRAMS
	armor_class = AC_MEDIUM
	prevent_crits = ALL_CRITICAL_HITS_VAMP
	max_integrity = INTEGRITY_OLD_BLACKSTEEL
	smeltresult = /obj/item/ingot/vampire

//................ Shoes ............... //

/obj/item/clothing/shoes/boots/armor/ironmaille/ancient
	name = "ancient sandals"
	desc = "An uncomfortable looking pair of old metal sandals. Surprisingly protective."
	icon_state = "ancientsandals"
	item_state = "ancientsandals"
	misc_flags = CRAFTING_TEST_EXCLUDE

	max_integrity = INTEGRITY_OLD_STRONG
	armor_type = /datum/armor/boots/maille/good
	item_weight = 1.2 KILOGRAMS

/obj/item/clothing/shoes/boots/armor/ancient
	name = "ancient boots"
	desc = "Ancient boots with ceremonial ornaments from ages past."
	icon_state = "ancientboots"
	item_state = "ancientboots"
	misc_flags = CRAFTING_TEST_EXCLUDE

	armor_type = /datum/armor/boots/plate/good
	item_weight = 2 KILOGRAMS

/obj/item/clothing/shoes/boots/armor/ancient/vampire
	name = "ancient ceremonial sabatons"
	desc = "A set of enchanted gilbranze boots, tightly fastened with strips of dark leather."
	icon_state = "vboots"
	armor_class = AC_MEDIUM
	prevent_crits = ALL_CRITICAL_HITS_VAMP
	item_weight = 1.8 KILOGRAMS
	sellprice = VALUE_SILVER_ITEM * 2
	max_integrity = INTEGRITY_OLD_BLACKSTEEL
	smeltresult = /obj/item/ingot/vampire
