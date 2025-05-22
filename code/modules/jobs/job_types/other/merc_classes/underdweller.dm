/datum/advclass/mercenary/underdweller
	name = "Underdweller"
	tutorial = "A member of the Underdwellers, you've taken many of the deadliest contracts known to man in literal underground circles. Drow or Dwarf, you've put your differences aside for coin and adventure."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		"Dwarf",
		"Dark Elf",
		"Kobold",
	)
	outfit = /datum/outfit/job/mercenary/underdweller
	category_tags = list(CTAG_MERCENARY)
	maximum_possible_slots = 5

/datum/outfit/job/mercenary/underdweller/pre_equip(mob/living/carbon/human/H)
	..()

	var/shirt_type = pickweight(list(
		/obj/item/clothing/armor/chainmail/iron = 1,//iron maille
		/obj/item/clothing/armor/gambeson = 4,//gambeson
		/obj/item/clothing/armor/gambeson/light = 4,//light gambeson
		/obj/item/clothing/shirt/undershirt/sailor/red= 1))//sailor shirt
	pants = /obj/item/clothing/pants/trou/leather
	armor = /obj/item/clothing/armor/cuirass/iron
	shirt = shirt_type
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather/mercenary
	beltr = /obj/item/weapon/knife/hunting
	neck = /obj/item/clothing/neck/chaincoif/iron
	backl = /obj/item/storage/backpack/backpack
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor=1)
	if(H.mind)
		H.adjust_skillrank(/datum/skill/labor/mining, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/engineering, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/lockpicking, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.change_stat(STATKEY_LCK, 1)
		H.change_stat(STATKEY_END, 2)
		H.change_stat(STATKEY_STR, 1)
		H.change_stat(STATKEY_INT, 1)

	if(H.dna.species.id == "dwarf")
		H.cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'
		H.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/bombs, 4, TRUE) // Dwarves get to make bombs.
		head = /obj/item/clothing/head/helmet/leather/minershelm
		beltl = /obj/item/weapon/pick/paxe // Dorfs get a pick as their primary weapon and axes/maces to use it
		backr = /obj/item/weapon/shield/wood
	else // No miner's helm for Delves or kobolds as they haven nitevision now.
		H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)

		beltl = /obj/item/weapon/sword/sabre // Dark elves get a sabre as their primary weapon and swords skill, who woulda thought
		head = /obj/item/clothing/head/helmet/leather//similar to the miner helm, except not as cool of course

	H.merctype = 3

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
