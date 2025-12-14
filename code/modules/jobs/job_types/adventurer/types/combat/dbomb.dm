/datum/job/advclass/combat/dbomb
	title = "Dwarven Bombardier"
	tutorial = "Tinkering Dwarves that like to blow things up."
	allowed_races = list(SPEC_ID_DWARF)
	outfit = /datum/outfit/adventurer/dbomb
	category_tags = list(CTAG_ADVENTURER)

/datum/outfit/adventurer/dbomb/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/helmet/horned
	pants = /obj/item/clothing/pants/trou
	belt = /obj/item/storage/belt/leather
	armor = /obj/item/clothing/armor/chainmail/iron
	wrists = /obj/item/clothing/wrists/bracers/leather
	backl = /obj/item/storage/backpack/backpack
	beltl = /obj/item/weapon/pick
	beltr = /obj/item/weapon/hammer/iron
	backpack_contents = list(/obj/item/explosive/bottle = 1, /obj/item/flint = 1)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mining, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/engineering, 5, TRUE)
	H.adjust_skillrank(/datum/skill/craft/bombs, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/smelting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_END, 1)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	switch(pick(1,2))
		if (1)
			shoes = /obj/item/clothing/shoes/boots/leather
		if (2)
			shoes = /obj/item/clothing/shoes/simpleshoes
