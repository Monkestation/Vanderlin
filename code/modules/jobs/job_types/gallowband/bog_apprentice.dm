/datum/job/bog_apprentice
	title = JOB_BOGWITCH_APP
	tutorial = "Wild at heart and certainly wild in appearance. A healer and worker of miracles, in a manner of speaking anyway."
	department_flag = OUTSIDERS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_BOGWITCH
	faction = FACTION_TOWN
	total_positions = 0
	spawn_positions = 0
	bypass_lastclass = TRUE
	allowed_races = RACES_PLAYER_ALL
	blacklisted_species = list(SPEC_ID_HALFLING)
	allowed_ages = list(AGE_CHILD, AGE_ADULT)
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/bog_apprentice
	is_foreigner = TRUE
	is_recognized = TRUE
	cmode_music = 'sound/music/cmode/church/CombatDendor.ogg'
	banned_patrons = list()

	exp_type = list(EXP_TYPE_LIVING, EXP_TYPE_ADVENTURER, EXP_TYPE_MEDICAL)
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_MEDICAL)
	exp_requirements = list(
		EXP_TYPE_LIVING = 1200,
		EXP_TYPE_ADVENTURER = 300,
		EXP_TYPE_MEDICAL = 300
	)

	jobstats = list(
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_END = 1
	)

	skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE
	)

	traits = list(
		TRAIT_FORAGER,
		TRAIT_STEELHEARTED
	)
	selection_color = "#a33096"

/datum/job/bog_apprentice/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_ADULT)
		spawned.adjust_skillrank(/datum/skill/misc/athletics, 1)
		spawned.adjust_skillrank(/datum/skill/combat/unarmed, 1)
		spawned.adjust_skillrank(/datum/skill/combat/wrestling, 1)

/datum/job/bog_apprentice/adjust_patron(mob/living/carbon/human/spawned)
	var/datum/patron/old_patron = spawned.patron
	if(old_patron?.type == /datum/patron/alternate/great_hunt)
		return

	spawned.set_patron(/datum/patron/alternate/great_hunt, TRUE)

	var/datum/patron/new_patron = spawned.patron
	if(old_patron != new_patron) // If the patron we selected first does not match the patron we end up with, display the message.
		to_chat(spawned, span_warning("I've followed the word of [old_patron.display_name ? old_patron.display_name : old_patron] in my younger years, \
		but the path I tread todae has accustomed me to [new_patron.display_name ? new_patron.display_name : new_patron]."))


/datum/outfit/bog_apprentice
	name = JOB_BOGWITCH_APP
	shirt = /obj/item/clothing/shirt/robe/colored/black
	backl = /obj/item/storage/backpack/satchel
	backr = /obj/item/storage/backpack/satchel/surgbag/shit
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/storage/keyring/bogwitch
	beltl = /obj/item/weapon/knife/villager
	shoes = /obj/item/clothing/shoes/boots/leather
	pants = /obj/item/clothing/pants/trou/leather
	gloves = /obj/item/clothing/gloves/leather
	neck = /obj/item/clothing/neck/psycross/great_hunt
