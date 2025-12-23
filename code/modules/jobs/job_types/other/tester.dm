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

	jobstats = list(
		STATKEY_STR = 1
	)


/datum/job/tester/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/misc/swimming, rand(1,5), TRUE)
	spawned.adjust_skillrank(/datum/skill/misc/climbing, rand(1,5), TRUE)
	spawned.adjust_skillrank(/datum/skill/misc/sneaking, rand(1,5), TRUE)
	spawned.adjust_skillrank(/datum/skill/combat/axesmaces, rand(1,5), TRUE)
	spawned.adjust_skillrank(/datum/skill/combat/bows, rand(1,5), TRUE)
	spawned.adjust_skillrank(/datum/skill/combat/crossbows, rand(1,5), TRUE)
	spawned.adjust_skillrank(/datum/skill/combat/wrestling, rand(1,5), TRUE)
	spawned.adjust_skillrank(/datum/skill/combat/unarmed, rand(1,5), TRUE)
	spawned.adjust_skillrank(/datum/skill/combat/swords, rand(1,5), TRUE)
	spawned.adjust_skillrank(/datum/skill/combat/polearms, rand(1,5), TRUE)
	spawned.adjust_skillrank(/datum/skill/combat/whipsflails, rand(1,5), TRUE)
	spawned.adjust_skillrank(/datum/skill/combat/knives, rand(1,5), TRUE)
	spawned.adjust_skillrank(/datum/skill/misc/reading, rand(1,5), TRUE)

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