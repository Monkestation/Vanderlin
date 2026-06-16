/datum/attribute_holder/sheet/job/sweeper
	raw_attribute_list = list(
		STAT_ENDURANCE = 2,
		STAT_SPEED = 1,
		STAT_INTELLIGENCE = -2,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/craft/crafting = 20,
	)

/datum/job/sweeper
	title = JOB_SWEEPER
	tutorial = "You are the local sweeper and cleaner, the one who takes care of the rot and refuse."

	department_flag = PEASANTS
	display_order = JDO_SWEEPER
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE | JOB_SHOW_IN_CREDITS)
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE
	banned_leprosy = FALSE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/sweeper
	give_bank_account = 10
	can_random = FALSE
	can_have_apprentices = FALSE
	can_be_apprentice = TRUE

	cmode_music = 'sound/music/cmode/towner/CombatBeggar.ogg'

	traits = list(
		TRAIT_DEADNOSE,
	)

	attribute_sheet = /datum/attribute_holder/sheet/job/sweeper

/datum/job/sweeper/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	// Hygiene roll
	if(prob(25))
		spawned.set_hygiene(HYGIENE_LEVEL_DISGUSTING)
	else
		spawned.set_hygiene(HYGIENE_LEVEL_DIRTY)


/datum/outfit/sweeper
	name = JOB_SWEEPER
	pants = /obj/item/clothing/pants/tights/colored/black
	gloves =/obj/item/clothing/gloves/leather/black
	shirt = /obj/item/clothing/shirt/shortshirt/colored/grey
	backl = /obj/item/storage/backpack/satchel/cloth
	head = /obj/item/clothing/head/strawhat
	shoes = /obj/item/clothing/shoes/boots
	ring = /obj/item/key/sweeper
	belt = /obj/item/storage/belt/leather/black
	neck = /obj/item/storage/belt/pouch
