/datum/attribute_holder/sheet/job/alchemist
	attribute_variance = list(
		/datum/attribute/skill/craft/alchemy = list(0, 20)
	)
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 3,
		STAT_SPEED = -1,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/misc/reading = 20,
	)

/datum/attribute_holder/sheet/job/alchemist/old
	attribute_variance = list(
		/datum/attribute/skill/craft/alchemy = list(40, 60)
	)

/datum/job/alchemist
	title = JOB_ALCHEMIST
	tutorial = "You came to Vanderlin either to seek knowledge or riches."
	department_flag = SERFS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = 6
	faction = FACTION_TOWN
	total_positions = 0
	spawn_positions = 0
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/alchemist
	give_bank_account = 12

	attribute_sheet = /datum/attribute_holder/sheet/job/alchemist
	attribute_sheet_old = /datum/attribute_holder/sheet/job/alchemist/old


/datum/outfit/alchemist
	name = JOB_ALCHEMIST
	pants = /obj/item/clothing/pants/trou
	shoes = /obj/item/clothing/shoes/boots/leather
	shirt = /obj/item/clothing/shirt/shortshirt
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/storage/belt/pouch/coins/poor
	cloak = /obj/item/clothing/cloak/apron/brown

