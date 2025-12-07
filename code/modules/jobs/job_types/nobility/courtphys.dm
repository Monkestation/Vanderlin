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

	spells = list(
		/datum/action/cooldown/spell/diagnose,
	)

	job_bitflag = BITFLAG_ROYALTY

	exp_type = list(EXP_TYPE_MEDICAL)
	exp_types_granted  = list(EXP_TYPE_NOBLE, EXP_TYPE_MEDICAL)
	exp_requirements = list(
		EXP_TYPE_MEDICAL = 900
	)

/datum/outfit/courtphys/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.virginity = TRUE
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
	beltr = /obj/item/weapon/mace/courtphysician
	armor = /obj/item/clothing/shirt/robe/courtphysician
	ring = /obj/item/clothing/ring/feldsher_ring
	if(H.gender == FEMALE)
		pants = /obj/item/clothing/pants/skirt/colored/random
	else
		pants = /obj/item/clothing/pants/tights/colored/random
	H.adjust_skillrank(/datum/skill/misc/reading, 5, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 5, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 3, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 3, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.change_stat(STATKEY_STR, -1)
	H.change_stat(STATKEY_INT, 4)
	H.change_stat(STATKEY_CON, -1)
	ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DEADNOSE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_LEGENDARY_ALCHEMIST, TRAIT_GENERIC)
	if(H.dna.species.id in RACES_PLAYER_NONDISCRIMINATED) // Astrata forbid a medicator gets nobility
		ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
