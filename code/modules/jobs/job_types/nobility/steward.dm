/datum/job/steward
	title = "Steward"
	tutorial = "Coin, Coin, Coin! Oh beautiful coin: \
	You're addicted to it, and you hold the position as the King's personal treasurer of both coin and information. \
	You know the power silver and gold has on a man's mortal soul, \
	and you know just what lengths they'll go to in order to get even more. Keep your festering economy and your rats alive, theyre the only two things you can weigh any trust into anymore."
	flag = STEWARD
	department_flag = NOBLEMEN
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_STEWARD
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	min_pq = 2
	bypass_lastclass = TRUE

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_NONDISCRIMINATED

	outfit = /datum/outfit/job/steward
	give_bank_account = 100
	noble_income = 16
	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg'

/datum/outfit/job/steward
	job_bitflag = BITFLAG_ROYALTY

/datum/outfit/job/steward/pre_equip(mob/living/carbon/human/H)
	..()
	H.virginity = TRUE
	if(H.gender == FEMALE)
		shirt = /obj/item/clothing/shirt/dress/stewarddress
	else
		shirt = /obj/item/clothing/shirt/undershirt/fancy
		pants = /obj/item/clothing/pants/trou/leathertights

	ADD_TRAIT(H, TRAIT_SEEPRICES, type)
	shoes = /obj/item/clothing/shoes/simpleshoes/buckle
	head = /obj/item/clothing/head/stewardtophat
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	armor = /obj/item/clothing/armor/gambeson/steward
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltr = /obj/item/storage/keyring/steward
	beltl = /obj/item/weapon/knife/dagger
	backr = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/rich = 1, /obj/item/lockpickring/mundane = 1)

	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 6, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 6, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 5, TRUE)
	H.change_stat(STATKEY_STR, -2)
	H.change_stat(STATKEY_INT, 5)
	H.change_stat(STATKEY_CON, -2)
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
