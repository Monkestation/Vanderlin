/datum/attribute_holder/sheet/job/harlequin
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 2,
		STAT_PERCEPTION = 1,
		STAT_SPEED = 2,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/misc/stealing = 30,
		/datum/attribute/skill/misc/music = 30,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/combat/crossbows = 20,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/athletics = 10,
		/datum/attribute/skill/misc/lockpicking = 10,
	)

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

	H.add_spell(/datum/action/cooldown/spell/undirected/shadow_step, TRUE)
	H.add_spell(/datum/action/cooldown/spell/enhanced_mimicry, TRUE)
	H.attributes?.add_sheet(/datum/attribute_holder/sheet/job/harlequin)

	backpack_contents = list(
		/obj/item/harlequinn_disguise_kit,
		/obj/item/reagent_containers/glass/bottle/poison,
		/obj/item/lockpick,
		/obj/item/rope,
		/obj/item/smokebomb,
		/obj/item/smokebomb,
	)

	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
