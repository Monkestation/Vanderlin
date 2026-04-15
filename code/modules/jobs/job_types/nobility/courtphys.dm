/datum/attribute_holder/sheet/job/courtphys
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_INTELLIGENCE = 4,
		STAT_CONSTITUTION = -1,
		/datum/attribute/skill/misc/reading = 50,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/sewing = 30,
		/datum/attribute/skill/misc/medicine = 50,
		/datum/attribute/skill/craft/alchemy = 30,
		/datum/attribute/skill/labor/mathematics = 30
	)

/datum/attribute_holder/sheet/job/courtphys/old
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_INTELLIGENCE = 4,
		STAT_CONSTITUTION = -1,
		/datum/attribute/skill/misc/reading = 50,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/sewing = 30,
		/datum/attribute/skill/misc/medicine = 60,
		/datum/attribute/skill/craft/alchemy = 30,
		/datum/attribute/skill/labor/mathematics = 30
	)
/datum/job/courtphys
	title = JOB_COURT_PHYSICIAN
	tutorial = "One fateful evening at a royal banquet, your steady hand and sharp eye saved the royal bloodline. \
	Now, you serve as the trusted healer of the crown, a living symbol of Pestra's favor. \
	Your duty is clear: keep the monarch alive, no matter the cost."
	department_flag = NOBLEMEN
	display_order = JDO_PHYSICIAN
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE
	allowed_races = RACES_PLAYER_NONHERETICAL
	blacklisted_species = list(SPEC_ID_TRITON, SPEC_ID_HARPY)
	outfit = /datum/outfit/courtphys/male
	outfit_female = /datum/outfit/courtphys/female
	give_bank_account = 100
	cmode_music = 'sound/music/cmode/nobility/combat_physician.ogg'
	spells = list(/datum/action/cooldown/spell/diagnose)
	job_bitflag = BITFLAG_ROYALTY
	exp_type = list(EXP_TYPE_MEDICAL)
	exp_types_granted = list(EXP_TYPE_NOBLE, EXP_TYPE_MEDICAL)
	exp_requirements = list(EXP_TYPE_MEDICAL = 900)

	attribute_sheet = /datum/attribute_holder/sheet/job/courtphys
	attribute_sheet_old = /datum/attribute_holder/sheet/job/courtphys/old

	honorary = "Lord"
	honorary_f = "Lady"

	traits = list(
		TRAIT_EMPATH,
		TRAIT_STEELHEARTED,
		TRAIT_DEADNOSE,
		TRAIT_LEGENDARY_ALCHEMIST
	)

/datum/job/courtphys/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.virginity = TRUE

	if(spawned.dna?.species?.id != SPEC_ID_MEDICATOR)
		ADD_TRAIT(spawned, TRAIT_NOBLE_BLOOD, JOB_TRAIT)
		ADD_TRAIT(spawned, TRAIT_NOBLE_POWER, JOB_TRAIT)
	else
		spawned.honorary = null

/datum/outfit/courtphys
	name = "Court Physician Base"
	backr = /obj/item/storage/backpack/satchel
	backl = /obj/item/storage/backpack/satchel/surgbag
	mask = /obj/item/clothing/face/courtphysician
	belt = /obj/item/storage/belt/leather/black
	beltl = /obj/item/storage/keyring/physician
	beltr = /obj/item/weapon/sword/rapier/caneblade/courtphysician
	ring = /obj/item/clothing/ring/feldsher_ring
	scabbards = list(/obj/item/weapon/scabbard/cane/courtphysician)

/datum/outfit/courtphys/male
	name = "Male Court Physician"
	shoes = /obj/item/clothing/shoes/courtphysician
	shirt = /obj/item/clothing/shirt/undershirt/courtphysician
	pants = /obj/item/clothing/pants/trou/courtphysician
	gloves = /obj/item/clothing/gloves/leather/courtphysician
	head = /obj/item/clothing/head/courtphysician/male
	armor = /obj/item/clothing/armor/leather/jacket/courtphysician

/datum/outfit/courtphys/female
	name = "Female Court Physician"
	shoes = /obj/item/clothing/shoes/courtphysician/female
	shirt = /obj/item/clothing/shirt/undershirt/courtphysician/female
	pants = /obj/item/clothing/pants/skirt/courtphysician
	gloves = /obj/item/clothing/gloves/leather/courtphysician/female
	head = /obj/item/clothing/head/courtphysician/female
	armor = /obj/item/clothing/armor/leather/jacket/courtphysician/female
