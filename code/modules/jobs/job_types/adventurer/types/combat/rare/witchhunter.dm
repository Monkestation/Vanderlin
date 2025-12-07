
/datum/job/advclass/combat/puritan
	title = "Witch Hunter"
	tutorial = "Witch Hunters dedicate their lives to the eradication of the varied evils infesting Psydonia. They know the vile sorcery of the necromancer, the insidious nature of the cultist and monstrousness of vampires and werevolfs. They also know how best to end them."
	allowed_races = RACES_PLAYER_NONEXOTIC
	outfit = /datum/outfit/adventurer/puritan
	total_positions = 1
	roll_chance = 15
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'
	is_recognized = TRUE

/datum/outfit/adventurer/puritan/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/shirt/undershirt/puritan
	belt = /obj/item/storage/belt/leather
	shoes = /obj/item/clothing/shoes/boots
	pants = /obj/item/clothing/pants/tights/colored/black
	armor = /obj/item/clothing/armor/leather/splint
	cloak = /obj/item/clothing/cloak/cape/puritan
	head = /obj/item/clothing/head/helmet/leather/inquisitor
	gloves = /obj/item/clothing/gloves/angle
	beltl = /obj/item/weapon/sword/rapier/silver
	beltr = /obj/item/weapon/whip/silver
	neck = /obj/item/clothing/neck/chaincoif
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/mid)

	if(H.mind)
		H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
		H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_STR, 1)
		H.change_stat(STATKEY_PER, 2)
		H.change_stat(STATKEY_CON, 2)
		switch(H.patron?.type)
			if (/datum/patron/psydon)
				wrists = /obj/item/clothing/neck/psycross/silver
			if(/datum/patron/divine/astrata)
				wrists = /obj/item/clothing/neck/psycross/silver/astrata
			if(/datum/patron/divine/necra)
				wrists = /obj/item/clothing/neck/psycross/silver/necra
			if(/datum/patron/divine/pestra)
				wrists = /obj/item/clothing/neck/psycross/silver/pestra
			else
				wrists = /obj/item/clothing/wrists/bracers/leather
	H.verbs |= /mob/living/carbon/human/proc/torture_victim
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)		//Witch Hunter is more of a duelist in combat and should be dodging and parrying, and not tanking hits
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)		//If they have torture variables, they shouldn't be effected by stuff.
