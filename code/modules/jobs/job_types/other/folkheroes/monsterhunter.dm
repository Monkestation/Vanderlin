/datum/attribute_holder/sheet/job/puritan
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 1,
		STAT_STRENGTH = 1,
		STAT_PERCEPTION = 2,
		STAT_CONSTITUTION = 2,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/combat/whipsflails = 40,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/craft/cooking = 10,
	)

/datum/job/advclass/combat/puritan
	title = "Monster Hunter"
	tutorial = "Monster Hunters dedicate their lives to the eradication of the varied evils infesting Psydonia. They know the vile sorcery of the necromancer, the insidious nature of the cultist and monstrousness of vampires and werevolfs. They also know how best to end them."
	allowed_races = RACES_PLAYER_NONEXOTIC
	outfit = /datum/outfit/folkhero/puritan
	total_positions = 2
	category_tags = list(CTAG_FOLKHEROES)
	cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'
	is_recognized = TRUE

	attribute_sheet = /datum/attribute_holder/sheet/job/puritan

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
				wrists = /obj/item/clothing/neck/psycross/silver/divine/astrata
			if(/datum/patron/divine/necra)
				wrists = /obj/item/clothing/neck/psycross/silver/divine/necra
			if(/datum/patron/divine/pestra)
				wrists = /obj/item/clothing/neck/psycross/silver/divine/pestra
			else
				wrists = /obj/item/clothing/neck/silveramulet
