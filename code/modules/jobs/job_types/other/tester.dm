/datum/attribute_holder/sheet/job/tester
	attribute_variance = list(
		/datum/attribute/skill/misc/swimming = list(-50, 50),
		/datum/attribute/skill/misc/climbing = list(-50, 50),
		/datum/attribute/skill/misc/sneaking = list(-50, 50),
		/datum/attribute/skill/combat/axesmaces = list(-50, 50),
		/datum/attribute/skill/combat/bows = list(-50, 50),
		/datum/attribute/skill/combat/wrestling = list(-50, 50),
		/datum/attribute/skill/combat/crossbows = list(-50, 50),
		/datum/attribute/skill/combat/unarmed = list(-50, 50),
		/datum/attribute/skill/combat/swords = list(-50, 50),
		/datum/attribute/skill/combat/polearms = list(-50, 50),
		/datum/attribute/skill/combat/whipsflails = list(-50, 50),
		/datum/attribute/skill/combat/knives = list(-50, 50),
		/datum/attribute/skill/misc/reading = list(-50, 50)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
	)

/datum/job/tester
	title = "Tester"
	tutorial = "Try not to get obliterated by the Gods while they toy with you."
	department_flag = PEASANTS
	job_flags = (JOB_EQUIP_RANK)
	faction = FACTION_TOWN
	display_order = JDO_MERCENARY
	#ifdef TESTSERVER
	total_positions = 99
	spawn_positions = 99
	#endif

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/tester

	attribute_sheet = /datum/attribute_holder/sheet/job/tester

/datum/outfit/tester
	name = "Tester"

	shoes = /obj/item/clothing/shoes/boots/leather
	wrists = /obj/item/clothing/wrists/bracers
	belt = /obj/item/storage/belt/leather
	armor = /obj/item/clothing/armor/gambeson/arming
	neck = /obj/item/clothing/neck/gorget
	beltl = /obj/item/storage/belt/pouch/coins/poor
	beltr = /obj/item/weapon/sword/sabre
	shirt = /obj/item/clothing/shirt/shortshirt/colored/merc
	pants = /obj/item/clothing/pants/trou/leather

/datum/outfit/tester/pre_equip(mob/living/carbon/human/equipped_human)
	. = ..()
	if(equipped_human.gender == FEMALE)
		pants = /obj/item/clothing/pants/tights/colored/black
		beltr = /obj/item/weapon/sword/sabre
	if(prob(50))
		armor = /obj/item/clothing/armor/gambeson
	if(prob(50))
		beltr = /obj/item/weapon/sword/arming
