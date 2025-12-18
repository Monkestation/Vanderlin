/datum/job/alchemist
	title = "Alchemist"
	tutorial = "You came to Vanderlin either to seek knowledge or riches."
	department_flag = SERFS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = 6
	faction = FACTION_TOWN
	total_positions = 0
	spawn_positions = 0
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_NONDISCRIMINATED

	outfit = /datum/outfit/alchemist
	give_bank_account = 12

	jobstats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = -1
	)

	skills = list(
		/datum/skill/craft/crafting = 3,
		/datum/skill/craft/alchemy = 2,
		/datum/skill/misc/reading = 2
	)


/datum/job/alchemist/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/craft/alchemy, rand(0,3), TRUE)
	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/craft/alchemy, rand(4,6), TRUE)

/datum/outfit/alchemist
	name = "Alchemist"
	pants = /obj/item/clothing/pants/trou
	shoes = /obj/item/clothing/shoes/boots/leather
	shirt = /obj/item/clothing/shirt/shortshirt
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/storage/belt/pouch/coins/poor
	cloak = /obj/item/clothing/cloak/apron/brown

