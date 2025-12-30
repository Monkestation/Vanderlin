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
	display_order = JDO_SHOPHAND
	give_bank_account = 10
	bypass_lastclass = TRUE
	can_have_apprentices = FALSE

	allowed_races = RACES_PLAYER_ALL
	allowed_ages = list(AGE_CHILD, AGE_ADULT)

	outfit = /datum/outfit/shophand
	display_order = JDO_SHOPHAND
	give_bank_account = 10
	bypass_lastclass = TRUE
	can_have_apprentices = FALSE
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'
	exp_types_granted = list(EXP_TYPE_MERCHANT_COMPANY)

	exp_types_granted = list(EXP_TYPE_MERCHANT_COMPANY)

	jobstats = list(
		STATKEY_SPD = 1,
		STATKEY_INT = 1,
		STATKEY_LCK = 1
	)

	skills = list(
		/datum/skill/misc/stealing = 4,
		/datum/skill/misc/sneaking = 2,
		/datum/skill/misc/reading = 3,
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/athletics = 1,
		/datum/skill/misc/lockpicking = 2,
		/datum/skill/labor/mathematics = 3
	)

	traits = list(
		TRAIT_SEEPRICES
	)

/datum/job/shophand/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/random_roll = rand(1, 3)
	switch(random_roll)
		if(1)
			spawned.adjust_skillrank(/datum/skill/combat/crossbows, 1)
		if(2)
			spawned.adjust_skillrank(/datum/skill/combat/bows, 1)
		if(3)
			spawned.adjust_skillrank(/datum/skill/combat/swords, 1)
			spawned.adjust_skillrank(/datum/skill/combat/axesmaces, 1)
			spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_STR, 1)

/datum/outfit/shophand
	name = "Shophand Base"
	head = /obj/item/clothing/head/chaperon
	pants = /obj/item/clothing/pants/tights
	shoes = /obj/item/clothing/shoes/simpleshoes
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/storage/belt/pouch/coins/poor
	beltl = /obj/item/storage/keyring/stevedore
	backr = /obj/item/storage/backpack/satchel
	gloves = /obj/item/clothing/gloves/fingerless

/datum/outfit/shophand/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == FEMALE)
		shirt = /obj/item/clothing/shirt/dress/gen/colored/blue
	else
		shirt = /obj/item/clothing/shirt/undershirt/colored/blue
