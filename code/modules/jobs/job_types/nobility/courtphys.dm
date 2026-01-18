/datum/job/courtphys
	title = "Court Physician"
	tutorial = "One fateful evening at a royal banquet, your steady hand and sharp eye saved the royal bloodline. \
	Now, you serve as the trusted healer of the crown, a living symbol of Pestra's favor. \
	Your duty is clear: keep the monarch alive, no matter the cost."
	department_flag = NOBLEMEN
	display_order = JDO_PHYSICIAN
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	allowed_races = RACES_PLAYER_NONHERETICAL
	outfit = /datum/outfit/courtphys
	give_bank_account = 100
	cmode_music = 'sound/music/cmode/nobility/combat_physician.ogg'
	spells = list(/datum/action/cooldown/spell/diagnose)
	job_bitflag = BITFLAG_ROYALTY
	exp_type = list(EXP_TYPE_MEDICAL)
	exp_types_granted = list(EXP_TYPE_NOBLE, EXP_TYPE_MEDICAL)
	exp_requirements = list(EXP_TYPE_MEDICAL = 900)

	jobstats = list(
		STATKEY_STR = -1,
		STATKEY_INT = 4,
		STATKEY_CON = -1
	)

	skills = list(
		/datum/skill/misc/reading = 5,
		/datum/skill/craft/crafting = 2,
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/sewing = 3,
		/datum/skill/misc/medicine = 5,
		/datum/skill/craft/alchemy = 3,
		/datum/skill/labor/mathematics = 3
	)

	traits = list(
		TRAIT_EMPATH,
		TRAIT_STEELHEARTED,
		TRAIT_DEADNOSE,
		TRAIT_LEGENDARY_ALCHEMIST
	)

/datum/job/courtphys/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.virginity = TRUE

	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)

	if(spawned.dna?.species?.id in RACES_PLAYER_NONDISCRIMINATED)
		ADD_TRAIT(spawned, TRAIT_NOBLE, TRAIT_GENERIC)

/datum/outfit/courtphys
	name = "Court Physician"
	shoes = /obj/item/clothing/shoes/shortboots
	shirt = /obj/item/clothing/shirt/undershirt/fancy
	backr = /obj/item/storage/backpack/satchel
	backl = /obj/item/storage/backpack/satchel/surgbag
	gloves = /obj/item/clothing/gloves/leather/feld
	head = /obj/item/clothing/head/courtphysician
	mask = /obj/item/clothing/face/courtphysician
	neck = /obj/item/clothing/neck/courtphysician
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/storage/keyring/physician
	beltr = /obj/item/weapon/mace/cane/courtphysician
	armor = /obj/item/clothing/shirt/robe/courtphysician
	ring = /obj/item/clothing/ring/feldsher_ring

/datum/outfit/courtphys/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == FEMALE)
		pants = /obj/item/clothing/pants/skirt/colored/random
	else
		pants = /obj/item/clothing/pants/tights/colored/random
