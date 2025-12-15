/datum/job/advclass/mercenary/corsair
	title = "Corsair"
	tutorial = "Driven away from a typical life, you once found kin with privateers, working adjacent to a royal navy. After the Red Flag battered itself in the wind one last time, your purse was still not satisfied... And yet he complained that his belly was not full."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/adventurer/corsair
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg'
	total_positions = 5

/datum/outfit/adventurer/corsair
	head = /obj/item/clothing/head/helmet/leather/headscarf
	pants = /obj/item/clothing/pants/tights/sailor
	belt = /obj/item/storage/belt/leather/mercenary
	armor = /obj/item/clothing/armor/leather/jacket/sea
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/natural/worms/leech = 2, /obj/item/storage/belt/pouch/coins/mid)
	backr = /obj/item/fishingrod/fisher
	beltl = /obj/item/weapon/sword/sabre/cutlass
	beltr = /obj/item/weapon/knife/dagger
	scabbards = list(/obj/item/weapon/sword/sabre/cutlass::associated_scabbard_type, /obj/item/weapon/knife/dagger::associated_scabbard_type)
	shoes = /obj/item/clothing/shoes/boots

/datum/outfit/adventurer/corsair/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)

		H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE) // Swords / Nonlethal.
		H.adjust_skillrank(/datum/skill/labor/fishing, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 4, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE) // For jumping off roofs. Don't lower.
		H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE) // Most other classes have better Sneaking.
		H.adjust_skillrank(/datum/skill/misc/lockpicking, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE) // Very athletic from climbing masts and being on boats all the time.
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/cooking, 3, TRUE)

	shirt = pick(/obj/item/clothing/shirt/undershirt/sailor, /obj/item/clothing/shirt/undershirt/sailor/red)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	H.change_stat(STATKEY_END, 2)
	H.change_stat(STATKEY_SPD, 3) // Hit-And-Run.
