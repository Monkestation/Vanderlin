/datum/job/archivist
	title = "Archivist"
	tutorial = "A well-traveled and well-learned seeker of wisdom, the Archivist bears the mark of Noc's influence.\
	Tasked with recording the court's events and educating the ungrateful whelps the monarch calls heirs.\
	Your work may go unappreciated now, but one dae historians will sing of your dedication and insight."
	department_flag = NOBLEMEN
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = 19 //lol?
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	cmode_music = 'sound/music/cmode/nobility/CombatCourtMagician.ogg'
	outfit = /datum/outfit/archivist
	spells = list(
		/datum/action/cooldown/spell/undirected/learn,
		/datum/action/cooldown/spell/undirected/touch/prestidigitation,
		/datum/action/cooldown/spell/undirected/conjure_item/summon_parchment,
		/datum/action/cooldown/spell/undirected/conjure_item/summon_parchment/scroll,
	)
	give_bank_account = 100

	job_bitflag = BITFLAG_ROYALTY
	allowed_patrons = list(/datum/patron/divine/noc, /datum/patron/inhumen/zizo)
	magic_user = TRUE

	exp_type = list(EXP_TYPE_LIVING)
	exp_types_granted = list(EXP_TYPE_MAGICK, EXP_TYPE_NOBLE)
	exp_requirements = list(
		EXP_TYPE_LIVING = 300
	)

	jobstats = list(
		STATKEY_STR = -1,
		STATKEY_INT = 8,
		STATKEY_CON = -1,
		STATKEY_END = -1,
		STATKEY_SPD = -1
	)

	skills = list(
		/datum/skill/misc/reading = 6,
		/datum/skill/misc/riding = 2,
		/datum/skill/craft/alchemy = 3,
		/datum/skill/magic/arcane = 3,
		/datum/skill/labor/mathematics = 6
	)

	languages = list(
		/datum/language/elvish,
		/datum/language/dwarvish,
		/datum/language/zalad,
		/datum/language/celestial,
		/datum/language/hellspeak,
		/datum/language/oldpsydonic,
		/datum/language/orcish,
		/datum/language/deepspeak
	)

	mind_traits = list(
		TRAIT_KNOW_KEEP_DOORS
	)
	traits = list(
		TRAIT_NOBLE
	)

/datum/job/archivist/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	spawned.virginity = TRUE

	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/magic/arcane, 2, TRUE)

	if(istype(spawned.patron, /datum/patron/inhumen/zizo))
		spawned.grant_language(/datum/language/undead)

/datum/outfit/archivist
	name = "Archivist"
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltl = /obj/item/storage/keyring/archivist
	beltr = /obj/item/book/granter/spellbook/apprentice
	backl = /obj/item/storage/backpack/satchel
	neck = /obj/item/clothing/neck/psycross/silver/noc
	backpack_contents = list(
		/obj/item/textbook = 1,
		/obj/item/natural/feather = 1
	)

/datum/outfit/archivist/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.dna?.species?.id == SPEC_ID_DWARF)
		shirt = /obj/item/clothing/shirt/undershirt/puritan
		armor = /obj/item/clothing/armor/leather/jacket/apothecary
		pants = /obj/item/clothing/pants/tights/colored/black
	else
		if(equipped_human.gender == FEMALE)
			armor = /obj/item/clothing/shirt/robe/archivist
			pants = /obj/item/clothing/pants/tights/colored/black
		else
			shirt = /obj/item/clothing/shirt/undershirt/puritan
			armor = /obj/item/clothing/shirt/robe/archivist
			pants = /obj/item/clothing/pants/tights/colored/black
