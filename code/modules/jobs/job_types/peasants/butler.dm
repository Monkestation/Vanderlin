/datum/attribute_holder/sheet/job/butler
	attribute_variance = list(
		/datum/attribute/skill/misc/music = list(0, 30)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_INTELLIGENCE = 2,
		STAT_PERCEPTION = 1,
		STAT_ENDURANCE = 1,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/craft/cooking = 40,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/labor/butchering = 20,
		/datum/attribute/skill/labor/farming = 20,
		/datum/attribute/skill/labor/mathematics = 30,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/misc/music = 10,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/misc/riding = 10,
		/datum/attribute/skill/misc/sewing = 30,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/misc/stealing = 30
	)

/datum/job/butler
	title = JOB_BUTLER
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

	attribute_sheet = /datum/attribute_holder/sheet/job/butler

	mind_traits = list(
		TRAIT_KNOW_KEEP_DOORS,
		TRAIT_ROYALSERVANT
	)

/datum/outfit/butler
	name = JOB_BUTLER
	shoes = /obj/item/clothing/shoes/nobleboot
	beltr = /obj/item/storage/keyring/butler
	beltl = /obj/item/storage/belt/pouch/coins/mid
	backr = /obj/item/storage/backpack/satchel

	backpack_contents = list(
		/obj/item/weapon/knife/villager = 1,
		/obj/item/servant_bell/lord = 1
	)

/datum/outfit/butler/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == MALE)
		armor = /obj/item/clothing/armor/leather/jacket/tailcoat/lord
		shirt = /obj/item/clothing/shirt/undershirt/formal
		belt = /obj/item/storage/belt/leather/suspenders
		pants = /obj/item/clothing/pants/trou/formal
	else
		armor = /obj/item/clothing/shirt/dress/maid/lord
		cloak = /obj/item/clothing/cloak/apron/maid
		belt = /obj/item/storage/belt/leather/cloth_belt
		pants = /obj/item/clothing/pants/tights/colored/white

