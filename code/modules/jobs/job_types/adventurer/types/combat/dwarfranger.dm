/datum/advclass/combat/dranger
	name = "Ranger"
	tutorial = "Dwarfish rangers, much like their humen counterparts, \
	live outside of society and explore the far corners of the creation. They \
	protect dwarfish settlements from wild beasts and sell their notes to the cartographers."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list("Dwarf")
	outfit = /datum/outfit/job/adventurer/dranger
	min_pq = 0
	category_tags = list(CTAG_ADVENTURER)

/datum/outfit/job/adventurer/dranger/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguehood/uncolored
	pants = /obj/item/clothing/pants/trou/leather
	shirt = /obj/item/clothing/shirt/undershirt/random
	shoes = /obj/item/clothing/shoes/simpleshoes
	belt = /obj/item/storage/belt/leather
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	backl = /obj/item/storage/backpack/satchel
	beltl = /obj/item/ammo_holder/quiver/bolts
	beltr = /obj/item/flashlight/flare/torch/lantern
	armor = /obj/item/clothing/armor/chainmail/iron // Starts with better armor than a typical ranger (iron chainmail) but has no dodge expert or sneaking skill
	wrists = /obj/item/clothing/wrists/bracers/leather
	r_hand = /obj/item/weapon/sword/iron
	backpack_contents = list(/obj/item/bait = 1)
	if(prob(23))
		shoes = /obj/item/clothing/shoes/boots
	if(prob(23))
		shoes = /obj/item/clothing/shoes/boots/leather
	cloak = /obj/item/clothing/cloak/raincloak/brown
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE) // In line with basic combat classes
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
	H.change_stat(STATKEY_PER, 3)
	H.change_stat(STATKEY_SPD, 1) // Fast... for a dwarf
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC) // Dwarf rangers are no good at dodging, but can wear heavier armor than typical rangers
