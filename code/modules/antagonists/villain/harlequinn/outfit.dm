
/datum/outfit/harlequin/pre_equip(mob/living/carbon/human/H)
	. = ..()
	shoes = /obj/item/clothing/shoes/boots/leather
	neck = /obj/item/clothing/neck/gorget
	mask = /obj/item/clothing/face/facemask/steel/harlequin
	gloves = /obj/item/clothing/gloves/fingerless
	belt = /obj/item/storage/belt/leather/black
	pants = /obj/item/clothing/pants/trou/leather
	armor = /obj/item/clothing/armor/leather/jacket
	beltl = /obj/item/weapon/knife/dagger/steel
	backr = /obj/item/storage/backpack/satchel
	backl = /obj/item/storage/belt/pouch/coins/poor
	cloak = /obj/item/clothing/cloak/half/shadowcloak
	head = /obj/item/clothing/head/roguehood/colored/black

	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/music, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
	H.add_spell(/datum/action/cooldown/spell/undirected/shadow_step, TRUE)
	H.add_spell(/datum/action/cooldown/spell/enhanced_mimicry, TRUE)
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_END, 2)
	H.change_stat(STATKEY_PER, 1)
	H.change_stat(STATKEY_SPD, 2)

	backpack_contents = list(
		/obj/item/harlequinn_disguise_kit,
		/obj/item/reagent_containers/glass/bottle/poison,
		/obj/item/lockpick,
		/obj/item/rope,
		/obj/item/smokebomb,
		/obj/item/smokebomb,
	)

	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
