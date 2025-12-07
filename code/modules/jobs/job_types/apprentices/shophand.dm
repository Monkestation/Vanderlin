/datum/job/shophand
	title = "Shophand"
	tutorial = "You work under the greedy eyes of the Merchant who has shackled you to the drudgery of employment. \
	Tasked with handling customers, organizing shelves, and taking inventory, your work is mind-numbing and repetitive. \
	Despite its mundanity however, it keeps a roof over your head and teaches you the art of mercantilism. \
	With enough time, you will become more than a glorified clerk and open a business that rivals all others."
	department_flag = COMPANY
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = RACES_PLAYER_ALL
	allowed_ages = list(AGE_CHILD, AGE_ADULT)

	outfit = /datum/outfit/shophand
	display_order = JDO_SHOPHAND
	give_bank_account = 10
	min_pq = -10
	bypass_lastclass = TRUE
	can_have_apprentices = FALSE

	exp_types_granted  = list(EXP_TYPE_MERCHANT_COMPANY)

/datum/outfit/shophand/pre_equip(mob/living/carbon/human/H)
	..()
	ADD_TRAIT(H, TRAIT_SEEPRICES, type)
	if(H.gender == FEMALE)
		head = /obj/item/clothing/head/chaperon
		pants = /obj/item/clothing/pants/tights
		shirt = /obj/item/clothing/shirt/dress/gen/colored/blue
		shoes = /obj/item/clothing/shoes/simpleshoes
		belt = /obj/item/storage/belt/leather
		beltr = /obj/item/storage/belt/pouch/coins/poor
		beltl = /obj/item/storage/keyring/stevedore
		backr = /obj/item/storage/backpack/satchel
		gloves = /obj/item/clothing/gloves/fingerless
	else
		head = /obj/item/clothing/head/chaperon
		pants = /obj/item/clothing/pants/tights
		shirt = /obj/item/clothing/shirt/undershirt/colored/blue
		shoes = /obj/item/clothing/shoes/simpleshoes
		belt = /obj/item/storage/belt/leather
		beltr = /obj/item/storage/belt/pouch/coins/poor
		beltl = /obj/item/storage/keyring/stevedore
		backr = /obj/item/storage/backpack/satchel
		gloves = /obj/item/clothing/gloves/fingerless
	//worse skills than a normal peasant, generally, with random bad combat skill
	H.adjust_skillrank(/datum/skill/misc/stealing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 3, TRUE)
	H.change_stat(STATKEY_SPD, 1)
	H.change_stat(STATKEY_INT, 1)
	H.change_stat(STATKEY_LCK, 1)
	if(prob(33))
		H.adjust_skillrank(/datum/skill/combat/crossbows, 1, TRUE)
	else if(prob(33))
		H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
	else //the legendary shopARM
		H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)
		H.change_stat(STATKEY_STR, 1)
