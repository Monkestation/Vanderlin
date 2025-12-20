/datum/job/butler
	title = "Butler"
	f_title = "Head Housekeeper"
	tutorial = "You are elevated to near nobility, as you hold the distinguished position of master of the royal household staff. \
	Your blade is a charcuterie of artisanal cheeses and meat, your armor wit and classical training. \
	By your word the meals are served, the chambers kept, and the floors polished clean. \
	You wear the royal colors and hold their semblance of dignity, \
	for without you and the servants under your command, the court would have all starved to death."
	department_flag = SERFS
	display_order = JDO_BUTLER
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE

	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	allowed_races = RACES_BUTLER

	outfit = /datum/outfit/butler
	give_bank_account = 30 // Along with the pouch, enough to purchase some ingredients from the farm and give hard working servants a silver here and there. Still need the assistance of the crown's coffers to do anything significant
	cmode_music = 'sound/music/cmode/towner/CombatInn.ogg'
	exp_type = list(EXP_TYPE_LIVING)
	exp_requirements = list(
		EXP_TYPE_LIVING = 600
	)

/datum/job/butler/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(length(GLOB.keep_doors) > 0)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(know_keep_door_password), spawned), 5 SECONDS)

/datum/outfit/butler/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == MALE)
		armor = /obj/item/clothing/armor/leather/jacket/tailcoat/lord
		shirt = /obj/item/clothing/shirt/undershirt/formal
		belt = /obj/item/storage/belt/leather/suspenders // aware that these render over shit like coats. it's a problem for another day, in my time.
		pants = /obj/item/clothing/pants/trou/formal
	else
		armor = /obj/item/clothing/shirt/dress/maid/lord
		cloak = /obj/item/clothing/cloak/apron/maid
		belt = /obj/item/storage/belt/leather/cloth_belt
		pants = /obj/item/clothing/pants/tights/colored/white
	shoes = /obj/item/clothing/shoes/nobleboot
	beltr = /obj/item/storage/keyring/butler
	beltl = /obj/item/storage/belt/pouch/coins/mid
	backr = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/weapon/knife/villager = 1,
		/obj/item/servant_bell/lord = 1)

	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/butchering, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/farming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 3, TRUE) // Someone who's been in charge of servants for a while should probably understand money well.
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/music, pick(1,1,2,3), TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE) // A well educated head of servants should at least have skilled literacy level
	H.adjust_skillrank(/datum/skill/misc/riding, 1, TRUE) // Privilege of living a life raising nobility. Knows the very basics about riding a mount
	H.adjust_skillrank(/datum/skill/misc/sewing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
	H.change_stat(STATKEY_STR, -1)
	H.change_stat(STATKEY_INT, 2)
	H.change_stat(STATKEY_PER, 1)
	H.change_stat(STATKEY_END, 1)
	ADD_TRAIT(H, TRAIT_KNOWKEEPPLANS, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_ROYALSERVANT, TRAIT_GENERIC)
