/datum/job/apothecary
	title = "Apothecary"
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

	trainable_skills = list(/datum/skill/craft/alchemy = 0.1)
	max_apprentices = 2
	apprentice_name = "Apothecary-in-training"
	can_have_apprentices = TRUE

	jobstats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = 1,
		STATKEY_PER = -1
	)

	skills = list(
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/craft/crafting = 2,//they need this to craft bottles
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/reading = 4,
		/datum/skill/misc/sneaking = 3,
		/datum/skill/misc/climbing = 2,
		/datum/skill/craft/alchemy = 5,
		/datum/skill/misc/medicine = 3,
		/datum/skill/labor/farming = 3,
	)

	traits = list(
		TRAIT_FORAGER,
		TRAIT_LEGENDARY_ALCHEMIST,
	)

	allowed_races = RACES_PLAYER_NONEXOTIC

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
	spawned.adjust_skillrank(/datum/skill/combat/wrestling, pick(0,0,1), TRUE)
	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
		ADD_TRAIT(spawned, TRAIT_POISON_RESILIENCE, TRAIT_GENERIC)

/datum/outfit/apothecary
	name = "Apothecary"
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
