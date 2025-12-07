//master smith

/datum/job/advclass/pilgrim/rare/masterblacksmith
	title = "Master Blacksmith"
	tutorial = "Dwarves, and humen who trained extensively under them in the art of smithing, \
	become the most legendary smiths at their craft, gaining reputation beyond compare."
	allowed_races = list(\
		SPEC_ID_HUMEN,\
		SPEC_ID_DWARF,\
	)
	outfit = /datum/outfit/adventurer/masterblacksmith
	total_positions = 1
	roll_chance = 0
	category_tags = list(CTAG_PILGRIM)
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'
	is_recognized = TRUE

/datum/outfit/adventurer/masterblacksmith/pre_equip(mob/living/carbon/human/H)
	..()
	beltr = /obj/item/weapon/hammer/iron
	backl = /obj/item/storage/backpack/backpack
	backr =	/obj/item/weapon/hammer/sledgehammer
	pants = /obj/item/clothing/pants/trou
	shoes = /obj/item/clothing/shoes/boots/leather
	shirt = /obj/item/clothing/shirt/shortshirt
	neck = /obj/item/storage/belt/pouch/coins/mid
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/weapon/knife/hunting
	cloak = /obj/item/clothing/cloak/apron/brown
	gloves = /obj/item/clothing/gloves/leather
	backpack_contents = list(/obj/item/flint = 1, /obj/item/weapon/tongs=1, /obj/item/ore/coal=1, /obj/item/ore/iron=1, /obj/item/mould/ingot = 1, /obj/item/storage/crucible/random = 1)

	if(H.mind)
		H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, pick(0,1,1), TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, pick(1,1,2), TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, pick(2,2,3), TRUE)
		H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/carpentry, pick(1,2,2), TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, pick(1,1,2), TRUE)
		H.adjust_skillrank(/datum/skill/craft/engineering, 4, TRUE)
		H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/traps, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/cooking, pick(0,1,1), TRUE)
		H.adjust_skillrank(/datum/skill/craft/carpentry, pick(0,1,1), TRUE) // 66% over 50% of normal smith
		H.adjust_skillrank(/datum/skill/craft/blacksmithing, 6, TRUE)
		H.adjust_skillrank(/datum/skill/craft/armorsmithing, 6, TRUE)
		H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 6, TRUE)
		H.adjust_skillrank(/datum/skill/craft/smelting, 6, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, pick(1,2,2), TRUE)
		H.adjust_skillrank(/datum/skill/labor/mathematics, 2, TRUE)
		ADD_TRAIT(H, TRAIT_MALUMFIRE, TRAIT_GENERIC)
		if(H.age == AGE_OLD) // Wise still on every field, but gimped stats from age.
			H.change_stat(STATKEY_END, -1)
			H.change_stat(STATKEY_CON, -1)
			H.change_stat(STATKEY_SPD, -1)
			H.adjust_skillrank(/datum/skill/craft/engineering, 1, TRUE)
		else // The actual stats
			H.change_stat(STATKEY_STR, 1)
			H.change_stat(STATKEY_END, 1)
			H.change_stat(STATKEY_CON, 1)
			H.change_stat(STATKEY_SPD, -1)

	if(H.gender == MALE)
		shoes = /obj/item/clothing/shoes/boots/leather
		shirt = /obj/item/clothing/shirt/shortshirt
	else
		shoes = /obj/item/clothing/shoes/shortboots
		armor = /obj/item/clothing/shirt/dress/gen/colored/random
		shirt = /obj/item/clothing/shirt/undershirt
