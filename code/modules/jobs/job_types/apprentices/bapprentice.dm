/datum/job/bapprentice
	title = "Smithy Apprentice"
	tutorial = "Long hours and back-breaking work wouldnt even describe a quarter of what you do in a day for your Master. \
	Its exhausting, filthy and you dont get much freetime: \
	but someday youll get your own smithy, and youll have TWICE as many apprentices as your master does."
	department_flag = APPRENTICES
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 2
	spawn_positions = 2
	display_order = JDO_BAPP
	give_bank_account = TRUE
	bypass_lastclass = TRUE
	can_have_apprentices = FALSE
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'
	job_bitflag = BITFLAG_CONSTRUCTOR

	allowed_races = RACES_PLAYER_ALL
	allowed_ages = list(AGE_CHILD, AGE_ADULT)

	outfit = /datum/outfit/bapprentice

	jobstats = list(
		STATKEY_END = 2,
		STATKEY_SPD = 1
	)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/misc/athletics = 2,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/craft/blacksmithing = 2,
		/datum/skill/craft/armorsmithing = 2,
		/datum/skill/craft/weaponsmithing = 2,
		/datum/skill/craft/smelting = 2,
		/datum/skill/craft/crafting = 2,
		/datum/skill/misc/reading = 2
	)

	traits = list(
		TRAIT_MALUMFIRE
	)

	skill_multipliers = list(/datum/skill/craft/blacksmithing = 1.25, /datum/skill/craft/armorsmithing = 1.25, /datum/skill/craft/weaponsmithing = 1.25)

/datum/outfit/bapprentice
	name = "Smithy Apprentice"
	belt = /obj/item/storage/belt/leather/rope
	beltr = /obj/item/key/blacksmith
	backr = /obj/item/storage/backpack/satchel

/datum/outfit/bapprentice/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == MALE)
		pants = /obj/item/clothing/pants/tights/colored/random
		shoes = /obj/item/clothing/shoes/simpleshoes
		armor = /obj/item/clothing/armor/leather/vest
		wrists = /obj/item/clothing/wrists/bracers/leather
	else
		armor = /obj/item/clothing/shirt/dress/gen/colored/random
		shoes = /obj/item/clothing/shoes/simpleshoes
		shirt = /obj/item/clothing/shirt/undershirt
		cloak = /obj/item/clothing/cloak/apron/brown
