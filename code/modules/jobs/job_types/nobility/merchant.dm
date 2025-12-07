/datum/job/merchant
	title = "Merchant"
	tutorial = "Born a wastrel in the dirt, you clawed your way up. Either by luck or, gods forbid, effort to earn a place in the Merchant's Guild. \
	Now, you are either a ruthless economist or a disgraced steward from distant lands. Where you came from no longer matters. \
	What matters now is you make sure the fools around you keep buying what you sell. Everything has a price, and you shall be the beating heart of this economy."
	department_flag = COMPANY
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE )
	display_order = JDO_MERCHANT
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE
	selection_color = "#192bc2"
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/merchant
	give_bank_account = 200

	exp_type = list(EXP_TYPE_LIVING, EXP_TYPE_MERCHANT_COMPANY)
	exp_types_granted  = list(EXP_TYPE_MERCHANT_COMPANY)
	exp_requirements = list(
		EXP_TYPE_LIVING = 600,
		EXP_TYPE_MERCHANT_COMPANY = 300,
	)

/datum/outfit/merchant/pre_equip(mob/living/carbon/human/H)
	..()

	neck = /obj/item/clothing/neck/mercator
	backr = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/veryrich = 1, /obj/item/merctoken = 1)
	beltr = /obj/item/weapon/sword/rapier
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltl = /obj/item/storage/keyring/merchant
	armor = /obj/item/clothing/shirt/robe/merchant
	head = /obj/item/clothing/head/chaperon/colored/greyscale/silk/random
	ring = /obj/item/clothing/ring/gold/guild_mercator
	scabbards = list(/obj/item/weapon/scabbard/sword)

	if(H.gender == MALE)
		shirt = /obj/item/clothing/shirt/undershirt/sailor
		pants = /obj/item/clothing/pants/tights/sailor
		shoes = /obj/item/clothing/shoes/boots/leather
	else
		shirt = /obj/item/clothing/shirt/tunic/colored/blue
		shoes = /obj/item/clothing/shoes/gladiator

	ADD_TRAIT(H, TRAIT_SEEPRICES, type)

	H.change_stat(STATKEY_INT, 2)
	H.change_stat(STATKEY_PER, 1)
	H.change_stat(STATKEY_STR, -1)

	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, 6, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 5, TRUE)
