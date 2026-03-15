/datum/attribute_holder/sheet/job/bogapprentice
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 1,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
		/datum/attribute/skill/misc/athletics = 10,
		/datum/attribute/skill/craft/alchemy = 20,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/labor/farming = 20,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/combat/wrestling = 10
	)


/datum/job/bog_apprentice
	title = JOB_BOGWITCH_APP
	tutorial = "You were dragged out of the mud by the Bog Witch on one of their expeditions- shivering, hungry, and alone. They taught you the ways of the Great Hunt, and in the eclectic methods of the their practice. You work yourself to the bone to tend the crops, stir the cauldrons, and run messages between the Witch and the Gallowband. When the Witch dies, you alone will carry the tradition forward."
	department_flag = OUTSIDERS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_BOGWITCH_APP
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

	attribute_sheet = /datum/attribute_holder/sheet/job/bogapprentice

	traits = list(
		TRAIT_FORAGER,
		TRAIT_STEELHEARTED
	)
	selection_color = "#a33096"

/datum/job/bog_apprentice/get_latejoin_spawn_point()
	if(length(GLOB.jobspawn_overrides[title]))
		return pick(GLOB.jobspawn_overrides[title])
	if(length(SSjob.latejoin_trackers))
		return pick(SSjob.latejoin_trackers)
	return SSjob.get_last_resort_spawn_points()


/datum/job/bog_apprentice/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_ADULT)
		spawned.adjust_skillrank(/datum/attribute/skill/misc/athletics, 1)
		spawned.adjust_skillrank(/datum/attribute/skill/combat/unarmed, 1)
		spawned.adjust_skillrank(/datum/attribute/skill/combat/wrestling, 1)

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
