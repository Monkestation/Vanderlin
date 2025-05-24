/datum/advclass/pilgrim/fisher
	name = "Fisher"
	tutorial = "Simple folk with an affinity for catching fish out of any body of water, \
				they are decent cooks and swimmers, living off the gifts of Abyssor."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/adventurer/fisher
	category_tags = list(CTAG_PILGRIM)
	apprentice_name = "Fisher Apprentice"
	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'

/datum/outfit/job/adventurer/fisher/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
		H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, pick(1,2), TRUE)
		H.adjust_skillrank(/datum/skill/labor/fishing, 4, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, pick(2,2,3), TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		if(H.age == AGE_OLD)
			H.adjust_skillrank(/datum/skill/labor/fishing, 1, TRUE)
			H.change_stat(STATKEY_CON, 1)
			H.change_stat(STATKEY_PER, 1)
		else
			H.change_stat(STATKEY_CON, 2)
	if(H.gender == MALE)
		pants = /obj/item/clothing/pants/tights/random
		shirt = /obj/item/clothing/shirt/shortshirt/random
		shoes = /obj/item/clothing/shoes/boots/leather
		neck = /obj/item/storage/belt/pouch/coins/poor
		head = /obj/item/clothing/head/fisherhat
		armor = /obj/item/clothing/armor/gambeson/light/striped
		backl = /obj/item/storage/backpack/satchel
		belt = /obj/item/storage/belt/leather
		backr = /obj/item/fishingrod/fisher
		beltr = /obj/item/cooking/pan
		beltl = /obj/item/flint
		backpack_contents = list(/obj/item/weapon/knife/villager = 1, /obj/item/natural/worms = 1, /obj/item/weapon/shovel/small = 1)

	else
		shirt = /obj/item/clothing/shirt/dress/gen/random
		armor = /obj/item/clothing/armor/gambeson/light/striped
		shoes = /obj/item/clothing/shoes/boots/leather
		neck = /obj/item/storage/belt/pouch/coins/poor
		head = /obj/item/clothing/head/fisherhat
		backl = /obj/item/storage/backpack/satchel
		backr = /obj/item/fishingrod/fisher
		belt = /obj/item/storage/belt/leather
		beltr = /obj/item/cooking/pan
		beltl = /obj/item/flint
		backpack_contents = list(/obj/item/weapon/knife/hunting = 1, /obj/item/natural/worms = 1, /obj/item/weapon/shovel/small = 1)
