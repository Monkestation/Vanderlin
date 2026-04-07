
//................ Helmets ............... //

/obj/item/clothing/head/helmet/heavy/ancient
	misc_flags = CRAFTING_TEST_EXCLUDE
	name = "ancient barbute"
	desc = "A very old barbute."
	icon_state = "ancientbarbute"
	item_state = "ancientbarbute"

	armor = ARMOR_PLATE_GOOD
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
	armor = ARMOR_PLATE
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	body_parts_covered = HEAD_NECK
	block2add = FOV_BEHIND
	item_weight = 4.6 KILOGRAMS
	max_integrity = INTEGRITY_STRONG
	smeltresult = /obj/item/ingot/steel
	sellprice = VALUE_STEEL_HELMET

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

	armor = ARMOR_MAILLE_GOOD

/obj/item/clothing/neck/gorget/ancient
	name = "ancient gorget"
	desc = "A very old gorget."
	icon_state = "ancientgorget"
	misc_flags = CRAFTING_TEST_EXCLUDE

	armor = ARMOR_PLATE
	max_integrity = INTEGRITY_STRONG + 100

//................ Armor ............... //

/obj/item/clothing/armor/cuirass/ancient
	name = "ancient cuirass"
	desc = "An old cuirass, deceptively sturdy."
	icon_state = "ancientcuirass"
	misc_flags = CRAFTING_TEST_EXCLUDE

	armor = ARMOR_PLATE_GOOD
	item_weight = 8.5 KILOGRAMS

/obj/item/clothing/armor/plate/ancient
	name = "ancient half-plate"
	desc = "An ornate, ceremonial plate of considerable age."
	icon_state = "ancientplate"
	misc_flags = CRAFTING_TEST_EXCLUDE

	armor = ARMOR_PLATE_GOOD
	item_weight = 16 KILOGRAMS

//................ Underarmor ............... //

/obj/item/clothing/armor/chainmail/ancient
	name = "ancient haubergeon"
	desc = "A very old haubergeon."
	icon_state = "ancientchain"
	misc_flags = CRAFTING_TEST_EXCLUDE

	armor = ARMOR_MAILLE_GOOD
	item_weight = 10 KILOGRAMS

/obj/item/clothing/armor/chainmail/hauberk/ancient
	name = "ancient hauberk"
	desc = "A very old hauberk."
	icon_state = "ancienthauberk"
	misc_flags = CRAFTING_TEST_EXCLUDE

	armor = ARMOR_MAILLE_GOOD
	item_weight = 11 KILOGRAMS

//................ Wrists ............... //

/obj/item/clothing/wrists/bracers/ancient
	name = "ancient vambraces"
	desc = "Very old vambraces."
	icon_state = "ancientbracers"
	item_state = "ancientbracers"
	misc_flags = CRAFTING_TEST_EXCLUDE

	armor = ARMOR_PLATE_GOOD

//................ Gloves ............... //

/obj/item/clothing/gloves/chain/ancient
	name = "ancient chain gauntlets"
	desc = "Weathered gauntlets with an ancient design."
	icon_state = "acgloves"
	misc_flags = CRAFTING_TEST_EXCLUDE

	item_weight = 1.2 KILOGRAMS
	armor = ARMOR_MAILLE_GOOD

/obj/item/clothing/gloves/plate/ancient
	name = "ancient plate gauntlets"
	desc = "Weathered gauntlets with an ancient design."
	icon_state = "agauntlets"
	misc_flags = CRAFTING_TEST_EXCLUDE

	armor = ARMOR_PLATE_GOOD
	item_weight = 1.45 KILOGRAMS

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

	armor = ARMOR_MAILLE_GOOD
	item_weight = 5.4 KILOGRAMS

/obj/item/clothing/pants/platelegs/ancient
	name = "ancient chausses"
	desc = "Chausses made of an ancient steel."
	icon_state = "ancientpants"
	item_state = "ancientpants"
	misc_flags = CRAFTING_TEST_EXCLUDE

	sleeved = FALSE

	armor = ARMOR_PLATE_GOOD
	item_weight = 5.5 KILOGRAMS

//................ Shoes ............... //

/obj/item/clothing/shoes/boots/armor/ironmaille/ancient
	name = "ancient sandals"
	desc = "An uncomfortable looking pair of old metal sandals. Surprisingly protective."
	icon_state = "ancientsandals"
	item_state = "ancientsandals"
	misc_flags = CRAFTING_TEST_EXCLUDE

	max_integrity = INTEGRITY_STRONG
	armor = ARMOR_MAILLE_GOOD
	item_weight = 1.2 KILOGRAMS

/obj/item/clothing/shoes/boots/armor/ancient
	name = "ancient boots"
	desc = "Ancient boots with ceremonial ornaments from ages past."
	icon_state = "ancientboots"
	item_state = "ancientboots"
	misc_flags = CRAFTING_TEST_EXCLUDE

	armor = ARMOR_PLATE_GOOD
	item_weight = 2 KILOGRAMS

