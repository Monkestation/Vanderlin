/datum/attribute_holder/sheet/job/apothecary
	attribute_variance = list(
		/datum/attribute/skill/combat/wrestling = list(-10, 10)
	)
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 3,
		STAT_SPEED = 1,
		STAT_PERCEPTION = -1,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/craft/crafting = 20,//they need this to craft bottles
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 40,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/craft/alchemy = 50,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/labor/farming = 30,

	)

/datum/attribute_holder/sheet/job/apothecary/old
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 3,
		STAT_SPEED = 1,
		STAT_PERCEPTION = -1,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/craft/crafting = 20,//they need this to craft bottles
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 40,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/craft/alchemy = 60,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/labor/farming = 30,

	)
/datum/job/apothecary
	title = JOB_APOTHECARY
	tutorial = "You know every plant growing on these grounds and in the woods like the back of your hand. \
	You are tasked with mixing tinctures and supplying the town and Feldsher with medicine. \
	Some seek you out for your expertise in poisons or hedonistic pleasure. \
	Others may look down upon you for your work, but your clients never complain. \
	You have combined ownership of the Apothecarian Workshop and the Clinic with the Feldsher. Best to work together."
	department_flag = SERFS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_APOTHECARY
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE

	trainable_skills = list(/datum/attribute/skill/craft/alchemy = 0.1)
	max_apprentices = 2
	apprentice_name = "Apothecary-in-training"
	can_have_apprentices = TRUE

	traits = list(
		TRAIT_FORAGER,
		TRAIT_LEGENDARY_ALCHEMIST,
	)

	allowed_races = RACES_PLAYER_ALL

	attribute_sheet_old = /datum/attribute_holder/sheet/job/apothecary/old
	attribute_sheet = /datum/attribute_holder/sheet/job/apothecary

	outfit = /datum/outfit/apothecary
	give_bank_account = 100
	cmode_music = 'sound/music/cmode/nobility/combat_physician.ogg'

	job_bitflag = BITFLAG_CONSTRUCTOR

	exp_type = list(EXP_TYPE_LIVING)
	exp_requirements = list(
		EXP_TYPE_LIVING = 600
	)


/datum/job/apothecary/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_OLD)
		ADD_TRAIT(spawned, TRAIT_POISON_RESILIENCE, TRAIT_GENERIC)

/datum/outfit/apothecary
	name = JOB_APOTHECARY
	armor = /obj/item/clothing/armor/gambeson/apothecary
	shoes = /obj/item/clothing/shoes/apothboots
	shirt = /obj/item/clothing/shirt/apothshirt
	pants = /obj/item/clothing/pants/trou/apothecary
	gloves = /obj/item/clothing/gloves/leather/apothecary
	backl = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/storage/keyring/clinic
	beltr = /obj/item/storage/belt/pouch/coins/poor
	ring = /obj/item/clothing/ring/apothecary_ring
