/datum/job/advclass/mercenary/ironmaiden
	title = "Iron Maiden"
	tutorial = "You're a battlefield medic and have forsaken the blade for the scalpel. \
	Your vile apperance has been hidden under layers of steel, allowing you to ply your trade to all those who have the coin."
	allowed_races = list(SPEC_ID_MEDICATOR)
	outfit = /datum/outfit/mercenary/ironmaiden
	category_tags = list(CTAG_MERCENARY)
	total_positions = 5

	cmode_music = 'sound/music/cmode/nobility/combat_physician.ogg'
	exp_types_granted  = list(EXP_TYPE_MERCENARY, EXP_TYPE_COMBAT, EXP_TYPE_MEDICAL)

/datum/outfit/mercenary/ironmaiden
	head = /obj/item/clothing/head/helmet/sallet
	mask = /obj/item/clothing/face/facemask/steel
	neck = /obj/item/clothing/neck/gorget
	wrists = /obj/item/clothing/wrists/bracers
	armor = /obj/item/clothing/armor/plate/full
	shirt = /obj/item/clothing/armor/chainmail
	gloves = /obj/item/clothing/gloves/plate
	belt = /obj/item/storage/belt/leather/mercenary
	backl = /obj/item/storage/backpack/satchel
	backr = /obj/item/storage/backpack/satchel/surgbag
	beltr = /obj/item/weapon/knife/dagger/steel
	beltl = /obj/item/weapon/knife/cleaver
	pants = /obj/item/clothing/pants/platelegs
	shoes = /obj/item/clothing/shoes/boots/armor
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor
	)

/datum/outfit/mercenary/ironmaiden/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)

	H.merctype = 9

	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_END, 2)
	H.change_stat(STATKEY_INT, 2)

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DEADNOSE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
