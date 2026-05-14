/datum/attribute_holder/sheet/job/sweeper
	attribute_variance = list(
		STAT_FORTUNE = list(-9, 9),
		/datum/attribute/skill/misc/sneaking = list(10, 40),
		/datum/attribute/skill/misc/climbing = list(10, 30),
		/datum/attribute/skill/combat/wrestling = list(-10, 10),
		/datum/attribute/skill/combat/unarmed = list(10, 20),
	)
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 2,
		STAT_SPEED = 1,
		STAT_INTELLIGENCE = -2,
	)

/datum/job/sweeper
	title = JOB_SWEEPER
	tutorial = "You are the street cleaner of Vanderlin, the one who takes care of the rot and refuse."

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
	can_random = FALSE
	can_have_apprentices = FALSE
	can_be_apprentice = TRUE

	cmode_music = 'sound/music/cmode/towner/CombatBeggar.ogg'

	traits = list(
		TRAIT_DEADNOSE,
	)

	attribute_sheet = /datum/attribute_holder/sheet/job/sweeper

/datum/job/sweeper/New()
	. = ..()
	peopleknowme = list()

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
