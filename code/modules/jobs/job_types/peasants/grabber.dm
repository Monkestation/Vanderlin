/datum/job/grabber
	title = "Stevedore"
	tutorial = "A stevedore is the lowest yet essential position in the Merchant's employment, reserved for the strong and loyal. \
	You are responsible for hauling materials and goods to-and-fro the docks and warehouses, protecting their transportation from conniving thieves. \
	Keep your eye out for the security of the Merchant, and they will surely treat you like family."
	department_flag = COMPANY
	display_order = JDO_GRABBER
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 4
	spawn_positions = 4
	min_pq = -50
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/grabber
	give_bank_account = TRUE
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'
	exp_types_granted  = list(EXP_TYPE_MERCHANT_COMPANY)

/datum/outfit/grabber/pre_equip(mob/living/carbon/human/H)
	..()

	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE) // You get a cudgel for nonlethal self defense and that's it.
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)//they can use the merchant machine and that's it
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/firearms, 1, TRUE) // TALLY HO
	H.adjust_skillrank(/datum/skill/combat/crossbows, 1, TRUE)

	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_END, 1)
	H.change_stat(STATKEY_CON, 1)
	H.change_stat(STATKEY_SPD, -1)
	backr = /obj/item/storage/backpack/satchel
	wrists = /obj/item/clothing/wrists/bracers/leather
	gloves = /obj/item/clothing/gloves/fingerless
	neck = /obj/item/storage/belt/pouch/coins/poor
	armor = /obj/item/clothing/armor/leather/jacket/sea
	shirt = /obj/item/clothing/armor/gambeson/light
	pants = /obj/item/clothing/pants/tights/sailor
	belt = /obj/item/storage/belt/leather/rope
	beltr = /obj/item/weapon/mace/cudgel
	beltl = /obj/item/weapon/sword/sabre/cutlass
	scabbards = list(/obj/item/weapon/scabbard/sword)
	backpack_contents = list(/obj/item/storage/keyring/stevedore)
	if(H.gender == MALE)
		shoes = /obj/item/clothing/shoes/boots/leather
		head = /obj/item/clothing/head/headband/colored/red
		H.change_stat(STATKEY_CON, 1)
		H.change_stat(STATKEY_STR, 1)//thug bodytype
	else
		shoes = /obj/item/clothing/shoes/gladiator
		head = /obj/item/clothing/head/headband
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_SPD, 1)
	ADD_TRAIT(H, TRAIT_CRATEMOVER, type)
