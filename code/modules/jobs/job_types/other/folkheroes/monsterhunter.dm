/datum/job/advclass/combat/puritan
	title = "Monster Hunter"
	tutorial = "Monster Hunters dedicate their lives to the eradication of the varied evils infesting Psydonia. They know the vile sorcery of the necromancer, the insidious nature of the cultist and monstrousness of vampires and werevolfs. They also know how best to end them."
	allowed_races = RACES_PLAYER_NONEXOTIC
	outfit = /datum/outfit/folkhero/puritan
	total_positions = 2
	category_tags = list(CTAG_FOLKHEROES)
	cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'
	is_recognized = TRUE

	skills = list(
		/datum/skill/misc/sewing = 2,
		/datum/skill/misc/medicine = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/misc/reading = 3,
		/datum/skill/combat/swords = 4,
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/crossbows = 3,
		/datum/skill/combat/whipsflails = 4,
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/athletics = 3,
		/datum/skill/craft/cooking = 1,
	)

	jobstats = list(
		STATKEY_INT = 1,
		STATKEY_STR = 1,
		STATKEY_PER = 2,
		STATKEY_CON = 2,
	)

	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_STEELHEARTED,
	)

/datum/job/advclass/combat/puritan/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	add_verb(spawned, /mob/living/carbon/human/proc/torture_victim)


/datum/outfit/folkhero/puritan
	name = "Monster Hunter (Folkhero)"
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
	wrists = /obj/item/clothing/wrists/bracers/leather
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/mid = 1)

/datum/outfit/folkhero/puritan/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	if(H.patron)
		switch(H.patron.type)
			if(/datum/patron/psydon, /datum/patron/psydon/extremist)
				wrists = /obj/item/clothing/neck/psycross/silver
			if(/datum/patron/divine/astrata)
				wrists = /obj/item/clothing/neck/psycross/silver/astrata
			if(/datum/patron/divine/necra)
				wrists = /obj/item/clothing/neck/psycross/silver/necra
			if(/datum/patron/divine/pestra)
				wrists = /obj/item/clothing/neck/psycross/silver/pestra
			else
				wrists = /obj/item/clothing/neck/silveramulet
