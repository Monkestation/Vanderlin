/datum/job/advclass/combat/hollowranger
	title = "Hollow Ranger"
	tutorial = "While Rangers are seen often amongst Humen and Elves, Amber Hollow's Rangers are hardly seen at all. \
	Acting mostly as scouts for groups of 'supply liberation' militia around their home, \
	stealth is a virtue for a Hollow Ranger."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(\
		SPEC_ID_HOLLOWKIN,\
		SPEC_ID_HUMEN,\
		SPEC_ID_HARPY,\
	)
	outfit = /datum/outfit/adventurer/hollowranger
	min_pq = 0
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatIntense.ogg'

	exp_types_granted  = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT, EXP_TYPE_RANGER)


/datum/outfit/adventurer/hollowranger/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguehood/colored/red
	mask = /obj/item/clothing/face/shepherd/rag
	pants = /obj/item/clothing/pants/tights/colored/black
	shirt = /obj/item/clothing/shirt/tunic/colored/black
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
	backl = /obj/item/storage/backpack/satchel
	beltl = /obj/item/ammo_holder/quiver/arrows
	beltr = /obj/item/weapon/knife/cleaver/combat
	armor = /obj/item/clothing/armor/leather/jacket
	wrists = /obj/item/clothing/neck/psycross/silver/dendor
	gloves = /obj/item/clothing/gloves/fingerless
	backpack_contents = list(/obj/item/weapon/knife/hunting)
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/black

	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE) // Knives are gonna be a rough backup, but should be one anyway
	H.adjust_skillrank(/datum/skill/misc/sneaking, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE) // Same climbing as Thieves, but without lockpicking
	H.adjust_skillrank(/datum/skill/misc/stealing, 4, TRUE) // Worse than a Thief, but still very possible to pickpocket
	H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, 2, TRUE) // Dendor asks us to use every part of the beast
	H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE) // Can upgrade to Longbow if they desire to
	H.adjust_skillrank(/datum/skill/craft/traps, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)

	H.change_stat(STATKEY_PER, 1)
	H.change_stat(STATKEY_SPD, 2) // Speedy out of necessity! Get the hell outta there

	ADD_TRAIT(H, TRAIT_BESTIALSENSE, TRAIT_GENERIC) // Dendor influence in nature blesses them with the Eyes of the Zad
	H.update_sight()
