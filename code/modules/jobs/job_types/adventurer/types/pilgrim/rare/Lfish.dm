//human, master fisher

/datum/job/advclass/pilgrim/rare/fishermaster
	title = "Master Fisher"
	tutorial = "Seafarers who have mastered the tides, and are able to catch any fish with ease \
	no matter the body of water. They have learned to thrive off the gifts of Abyssor, not simply survive."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/adventurer/fishermaster

	total_positions = 1
	roll_chance = 0
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	apprentice_name = "Fisher Apprentice"
	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'
	is_recognized = TRUE

/datum/outfit/adventurer/fishermaster/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == MALE)
		pants = /obj/item/clothing/pants/trou
		shirt = /obj/item/clothing/shirt/shortshirt/colored/random
		shoes = /obj/item/clothing/shoes/boots/leather
		neck = /obj/item/storage/belt/pouch/coins/mid
		head = /obj/item/clothing/head/fisherhat
		backr = /obj/item/storage/backpack/satchel
		armor = /obj/item/clothing/armor/leather/jacket/sea
		belt = /obj/item/storage/belt/leather
		backl = /obj/item/fishingrod/fisher
		beltr = /obj/item/cooking/pan
		beltl = /obj/item/weapon/knife/hunting
		backpack_contents = list(/obj/item/natural/worms = 2,/obj/item/weapon/shovel/small=1)
		if(H.mind)
			H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
			H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
			H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/swimming, 5, TRUE)
			H.adjust_skillrank(/datum/skill/craft/cooking, 3, TRUE)
			H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
			H.adjust_skillrank(/datum/skill/labor/fishing, 5, TRUE)
			H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
			H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
			if(H.age == AGE_OLD)
				H.adjust_skillrank(/datum/skill/labor/fishing, 1, TRUE)
				H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
			H.change_stat(STATKEY_CON, 2)
			H.change_stat(STATKEY_PER, 2)
	else
		pants = /obj/item/clothing/pants/trou
		shoes = /obj/item/clothing/shoes/boots/leather
		shirt = /obj/item/clothing/shirt/shortshirt/colored/random
		neck = /obj/item/storage/belt/pouch/coins/mid
		head = /obj/item/clothing/head/fisherhat
		backr = /obj/item/storage/backpack/satchel
		armor = /obj/item/clothing/armor/leather/jacket/sea
		belt = /obj/item/storage/belt/leather
		beltr = /obj/item/fishingrod/fisher
		beltl = /obj/item/weapon/knife/hunting
		backpack_contents = list(/obj/item/natural/worms = 2,/obj/item/weapon/shovel/small=1)
		if(H.mind)
			H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
			H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
			H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/swimming, 5, TRUE)
			H.adjust_skillrank(/datum/skill/craft/cooking, 3, TRUE)
			H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
			H.adjust_skillrank(/datum/skill/labor/fishing, 5, TRUE)
			H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
			if(H.age == AGE_OLD)
				H.adjust_skillrank(/datum/skill/labor/fishing, 1, TRUE)
				H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
			H.change_stat(STATKEY_CON, 2)
			H.change_stat(STATKEY_PER, 2)
