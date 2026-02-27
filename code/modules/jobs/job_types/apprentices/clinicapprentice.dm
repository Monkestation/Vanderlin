/datum/job/clinicapprentice
	title = "Clinic Apprentice"
	tutorial = "You've been taken under as an apprentice by the Feldsher and Apothecary. \
	You're both an assistant and student, helping the two of them in the more menial tasks. \
	You hope to one dae open a Clinic of your own. \
	Perhaps you might even venture out to Kingsfield to further your studies in their fabled universities. \
	Though most likely you will end up as one of the many countless Physickers roaming Faience."
	department_flag = APPRENTICES
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	display_order = JDO_CLINICAPPRENTICE
	total_positions = 4
	spawn_positions = 4
	bypass_lastclass = TRUE
	can_have_apprentices = FALSE
	give_bank_account = 5

	//ALL races and ALL ages are intended
	//a contrast to Noc gatekeeping knowledge, anyone is allowed to learn about Pestra's medicine and alchemy
	//think of it how IRL age doesn't matter that much when it comes to attending university
	//you can have 20 year olds in the same group as 60 year olds
	allowed_ages = ALL_AGES_LIST_CHILD
	allowed_races = RACES_PLAYER_ALL
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'
	outfit = /datum/outfit/clinicapprentice
	job_bitflag = BITFLAG_CONSTRUCTOR

	exp_types_granted = list(EXP_TYPE_MEDICAL)

	jobstats = list(
		STATKEY_INT = 1
	)

	skills = list(
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/misc/athletics = 1,
		/datum/skill/craft/crafting = 2,
		/datum/skill/labor/farming = 2,
		/datum/skill/misc/reading = 3,
		/datum/skill/craft/alchemy = 2,
		/datum/skill/misc/medicine = 2
	)

	traits = list(
		TRAIT_FORAGER,
		TRAIT_EMPATH
	)

	outfit = /datum/outfit/clinicapprentice

	job_bitflag = BITFLAG_CONSTRUCTOR

	exp_types_granted  = list(EXP_TYPE_MEDICAL)

	skill_multipliers = list(/datum/skill/misc/medicine = 1.25, /datum/skill/craft/alchemy = 1.25)

/datum/job/clinicapprentice/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age != AGE_CHILD)
		spawned.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)

/datum/outfit/clinicapprentice
	name = "Clinic Apprentice"
	head = /obj/item/clothing/head/roguehood/colored/black
	backl = /obj/item/storage/backpack/satchel/surgbag/shit
	shoes = /obj/item/clothing/shoes/simpleshoes
	shirt = /obj/item/clothing/shirt/undershirt/colored/random
	pants = /obj/item/clothing/pants/tights/colored/random
	gloves = /obj/item/clothing/gloves/leather/phys
	armor = /obj/item/clothing/shirt/robe/phys
	neck = /obj/item/storage/belt/pouch/cloth
	wrists = /obj/item/storage/keyring/clinicapprentice
	belt = /obj/item/storage/belt/leather/rope
