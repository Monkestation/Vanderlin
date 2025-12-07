/datum/job/advclass/mercenary/desert_pirate
	title = "Desert Rider"
	tutorial = "A pirate of rakshari origin, hailing from the west dune-sea of Zaladin. Well-trained riders and experienced archers, these nomads live the life of marauders and raiders, taking what belongs to weaker settlements and caravans."
	allowed_races = list(SPEC_ID_RAKSHARI)
	outfit = /datum/outfit/mercenary/desert_pirate
	total_positions = 3
	min_pq = 0
	category_tags = list(CTAG_MERCENARY)

	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg'

/datum/outfit/mercenary/desert_pirate/pre_equip(mob/living/carbon/human/H)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
	H.adjust_skillrank(/datum/skill/labor/taming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE) // Little use for climbing, main targets were other caravans and shitty settlements.
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/traps, 1, TRUE)
	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_SPD, 1)
	H.change_stat(STATKEY_END, 1)


	pants = /obj/item/clothing/pants/trou/leather
	beltr = /obj/item/weapon/sword/sabre
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
	beltl= /obj/item/ammo_holder/quiver/arrows
	shoes = /obj/item/clothing/shoes/ridingboots
	gloves = /obj/item/clothing/gloves/angle
	wrists = /obj/item/rope/chain //Seems fitting for slavers
	belt = /obj/item/storage/belt/leather/mercenary/shalal
	shirt = /obj/item/clothing/shirt/undershirt/colored/uncolored
	armor = /obj/item/clothing/armor/leather/splint
	backr = /obj/item/storage/backpack/satchel
	head = /obj/item/clothing/neck/keffiyeh/colored/uncolored
	scabbards = list(/obj/item/weapon/scabbard/sword)
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor, /obj/item/weapon/knife/dagger)

	H.merctype = 1 //Desert Rider chain, 0 for Desert Rider Medal

	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
