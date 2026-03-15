/datum/attribute_holder/sheet/job/feldsher
	attribute_variance = list(
		/datum/attribute/skill/combat/wrestling = list(-10, 10)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_INTELLIGENCE = 4,
		STAT_PERCEPTION = 1,
		STAT_CONSTITUTION = -1,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/reading = 50,
		/datum/attribute/skill/labor/mathematics = 30,
		/datum/attribute/skill/misc/sewing = 30,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/medicine = 50,
		/datum/attribute/skill/craft/alchemy = 30,
		/datum/attribute/skill/labor/farming = 30,
	)

/datum/attribute_holder/sheet/job/feldsher/old
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_INTELLIGENCE = 4,
		STAT_PERCEPTION = 1,
		STAT_CONSTITUTION = -1,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/reading = 50,
		/datum/attribute/skill/labor/mathematics = 30,
		/datum/attribute/skill/misc/sewing = 30,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/medicine = 60,
		/datum/attribute/skill/craft/alchemy = 30,
		/datum/attribute/skill/labor/farming = 30,
	)

/datum/job/feldsher
	title = "Feldsher"
	tutorial = "You have seen countless wounds over your time. \
	Stitched the sores of blades, sealed honey over the bubous of plague. \
	A thousand deaths stolen from the Carriagemen, yet these people will still call you a charlatan. \
	At least the Apothecary understands you. \
	You have combined ownership of the Apothecarian Workshop and the Clinic with the Apothecary. Best to work together."
	department_flag = SERFS
	display_order = JDO_FELDSHER
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE

	trainable_skills = list(/datum/attribute/skill/misc/medicine = 0.1)
	max_apprentices = 2
	apprentice_name = "Feldsher-in-training"
	can_have_apprentices = TRUE

	allowed_races = RACES_PLAYER_NONHERETICAL

	attribute_sheet = /datum/attribute_holder/sheet/job/feldsher
	attribute_sheet_old = /datum/attribute_holder/sheet/job/feldsher/old

	traits = list(
		TRAIT_EMPATH,
		TRAIT_STEELHEARTED,
		TRAIT_DEADNOSE,
	)

	outfit = /datum/outfit/feldsher
	give_bank_account = 100
	cmode_music = 'sound/music/cmode/nobility/combat_physician.ogg'

	spells = list(
		/datum/action/cooldown/spell/diagnose,
	)

	job_bitflag = BITFLAG_CONSTRUCTOR

	exp_type = list(EXP_TYPE_LIVING, EXP_TYPE_MEDICAL)
	exp_types_granted = list(EXP_TYPE_MEDICAL)
	exp_requirements = list(
		EXP_TYPE_LIVING = 600,
		EXP_TYPE_MEDICAL = 300

	)

/datum/outfit/feldsher
	shoes = /obj/item/clothing/shoes/shortboots
	shirt = /obj/item/clothing/shirt/undershirt/colored/red
	backr = /obj/item/storage/backpack/satchel
	backl = /obj/item/storage/backpack/satchel/surgbag
	pants = /obj/item/clothing/pants/tights/colored/random
	gloves = /obj/item/clothing/gloves/leather/feld
	armor = /obj/item/clothing/shirt/robe/feld
	head = /obj/item/clothing/head/roguehood/feld
	mask = /obj/item/clothing/face/feld
	neck = /obj/item/clothing/neck/feld
	belt = /obj/item/storage/belt/leather
	wrists = /obj/item/storage/keyring/clinic
	beltl = /obj/item/storage/fancy/ifak
	beltr = /obj/item/storage/belt/pouch
	ring = /obj/item/clothing/ring/feldsher_ring
