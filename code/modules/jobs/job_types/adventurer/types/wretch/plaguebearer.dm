/datum/job/advclass/wretch/plaguebearer
	title = "Plaguebearer"
	tutorial = "A disgraced physician forced into exile and years of hardship, you have turned to a private practice surrounding the only things you've ever known - poisons and plague. Revel in the spreading of blight, and unleash craven pestilence."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/wretch/plaguebearer
	total_positions = 2

/datum/outfit/wretch/plaguebearer/pre_equip(mob/living/carbon/human/H)
	..()
	mask = /obj/item/clothing/face/phys/plaguebearer
	head = /obj/item/clothing/head/roguehood/phys
	shoes = /obj/item/clothing/shoes/boots/leather
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	backl =	/obj/item/storage/backpack/satchel/surgbag
	backr = /obj/item/storage/backpack/satchel
	pants = /obj/item/clothing/pants/tights/colored/random
	gloves = /obj/item/clothing/gloves/leather/phys
	armor = /obj/item/clothing/shirt/robe/phys
	neck = /obj/item/clothing/neck/phys
	belt = /obj/item/storage/belt/leather/black
	beltl = /obj/item/gun/ballistic/revolver/grenadelauncher/blowgun
	beltr = /obj/item/ammo_holder/dartpouch/poisondarts
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/poison = 1,
		/obj/item/reagent_containers/glass/bottle/strongstampoison = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/rope/chain = 1,
		/obj/item/flint = 1,
		/obj/item/reagent_containers/glass/bottle/stronghealthpot = 1,
	)
	H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 5, TRUE)
	H.adjust_skillrank(/datum/skill/labor/farming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/bombs, 3, TRUE) //to craft smoke bombs.
	ADD_TRAIT(H, TRAIT_LEGENDARY_ALCHEMIST, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_FORAGER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DEADNOSE, TRAIT_GENERIC)
	H.change_stat(STATKEY_INT, 3)
	H.change_stat(STATKEY_PER, 3)
	H.change_stat(STATKEY_CON, 3)
	H.add_spell(/datum/action/cooldown/spell/diagnose)
	H.add_spell(/datum/action/cooldown/spell/undirected/conjure_item/poison_bomb)
	wretch_select_bounty(H)

