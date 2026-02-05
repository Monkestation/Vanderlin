/datum/job/mageapprentice
	title = "Magician Apprentice"
	tutorial = "Your family managed to send you to college to learn the Arcyne Arts.\
	It's been stressful, but you'll earn your degree and become a fully fleged Magician one dae.\
	As long as you can keep your grades up, that is..."
	department_flag = APPRENTICES
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 2
	spawn_positions = 2

	allowed_races = RACES_PLAYER_ALL
	allowed_ages = list(AGE_CHILD, AGE_ADULT)
	allowed_sexes = list(MALE, FEMALE)
	cmode_music = "sound/music/cmode/adventurer/CombatSorcerer.ogg"
	outfit = /datum/outfit/mageapprentice
	display_order = JDO_WAPP
	give_bank_account = TRUE
	bypass_lastclass = TRUE
	banned_leprosy = FALSE
	can_have_apprentices = FALSE
	magic_user = TRUE

	allowed_races = RACES_PLAYER_ALL
	allowed_ages = list(AGE_CHILD, AGE_ADULT)
	allowed_sexes = list(MALE, FEMALE)
	allowed_patrons = list(/datum/patron/divine/noc, /datum/patron/inhumen/zizo)

	outfit = /datum/outfit/mageapprentice

	spells = list(
		/datum/action/cooldown/spell/undirected/touch/prestidigitation,
	)

	exp_type = list(EXP_TYPE_LIVING, EXP_TYPE_MAGICK)
	exp_types_granted = list(EXP_TYPE_MAGICK)

	jobstats = list(
		STATKEY_INT = 1,
		STATKEY_SPD = -1
	)

	skills = list(
		/datum/skill/magic/arcane = 1,
		/datum/skill/misc/reading = 3,
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/athletics = 1,
		/datum/skill/combat/polearms = 2
	)

	skill_multipliers = list(/datum/skill/magic/arcane = 1.25)

/datum/job/mageapprentice/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_ADULT)
		spawned.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
		spawned.adjust_spell_points(4)


/datum/outfit/mageapprentice
	name = "Magician Apprentice"
	belt = /obj/item/storage/belt/leather/rope
	beltl = /obj/item/storage/keyring/mageapprentice
	beltr = /obj/item/storage/magebag/apprentice
	armor = /obj/item/clothing/shirt/robe/newmage/adept
	backr = /obj/item/storage/backpack/satchel
	shoes = /obj/item/clothing/shoes/sandals
	shirt = /obj/item/clothing/shirt/dress/silkdress/colored/random
	head = /obj/item/clothing/head/wizhat/witch
	backpack_contents = list(
		/obj/item/book/granter/spellbook/apprentice = 1,
		/obj/item/chalk = 1
	)

/datum/outfit/mageapprentice/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == MALE)
		pants = /obj/item/clothing/pants/tights/colored/random
		shoes = /obj/item/clothing/shoes/simpleshoes
		shirt = /obj/item/clothing/shirt/shortshirt
		head = /obj/item/clothing/head/wizhat/gen
