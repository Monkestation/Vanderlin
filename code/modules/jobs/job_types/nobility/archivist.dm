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

	exp_type = list(EXP_TYPE_LIVING)
	exp_types_granted  = list(EXP_TYPE_MAGICK, EXP_TYPE_NOBLE)
	exp_requirements = list(
		EXP_TYPE_LIVING = 300
	)


/datum/job/archivist/after_spawn(mob/living/carbon/spawned, client/player_client)
	. = ..()
	var/mob/living/carbon/human/H = spawned
	if(GLOB.keep_doors.len > 0)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(know_keep_door_password), H), 5 SECONDS)
	ADD_TRAIT(H, TRAIT_KNOWKEEPPLANS, TRAIT_GENERIC)

/datum/outfit/archivist/pre_equip(mob/living/carbon/human/H)
	..()
	H.mana_pool?.set_intrinsic_recharge(MANA_ALL_LEYLINES)
	if(H.dna.species.id == SPEC_ID_DWARF)
		shirt = /obj/item/clothing/shirt/undershirt/puritan
		armor = /obj/item/clothing/armor/leather/jacket/apothecary
		pants = /obj/item/clothing/pants/tights/colored/black
	else
		if(H.gender == FEMALE)
			armor = /obj/item/clothing/shirt/robe/archivist
			pants = /obj/item/clothing/pants/tights/colored/black
		else
			shirt = /obj/item/clothing/shirt/undershirt/puritan
			armor = /obj/item/clothing/shirt/robe/archivist
			pants = /obj/item/clothing/pants/tights/colored/black
	H.virginity = TRUE
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltl = /obj/item/storage/keyring/archivist
	beltr = /obj/item/book/granter/spellbook/apprentice
	backl = /obj/item/storage/backpack/satchel
	neck = /obj/item/clothing/neck/psycross/silver/noc
	backpack_contents = list(/obj/item/textbook = 1, /obj/item/natural/feather)

	H.grant_language(/datum/language/elvish)
	H.grant_language(/datum/language/dwarvish)
	H.grant_language(/datum/language/zalad)
	H.grant_language(/datum/language/celestial)
	H.grant_language(/datum/language/hellspeak)
	H.grant_language(/datum/language/oldpsydonic)
	H.grant_language(/datum/language/orcish)
	H.grant_language(/datum/language/deepspeak)
	if(istype(H.patron, /datum/patron/inhumen/zizo))
		H.grant_language(/datum/language/undead)
	H.adjust_skillrank(/datum/skill/misc/reading, 6, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 3, TRUE)
	H.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 6, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/magic/arcane, 2, TRUE)
	H.change_stat(STATKEY_STR, -1)
	H.change_stat(STATKEY_INT, 8)
	H.change_stat(STATKEY_CON, -1)
	H.change_stat(STATKEY_END, -1)
	H.change_stat(STATKEY_SPD, -1)
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
