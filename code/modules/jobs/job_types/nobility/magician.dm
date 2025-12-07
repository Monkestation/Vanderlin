/datum/job/magician
	title = "Court Magician"
	tutorial = "A seer of dreams, a reader of stars, and a master of the arcyne. Along a band of unlikely heroes, you shaped the fate of these lands.\
	Now the days of adventure are gone, replaced by dusty tomes and whispered prophecies. The ruler's coin funds your studies,\
	but debts both magical and mortal are never so easily repaid. With age comes wisdom, but also the creeping dread that your greatest spell work\
	may already be behind you."
	department_flag = NOBLEMEN
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_MAGICIAN
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	allowed_sexes = list(MALE, FEMALE)


	outfit = /datum/outfit/magician
	give_bank_account = 120
	cmode_music = 'sound/music/cmode/nobility/CombatCourtMagician.ogg'
	magic_user = TRUE

	spells = list(
		/datum/action/cooldown/spell/aoe/knock,
		/datum/action/cooldown/spell/undirected/jaunt/ethereal_jaunt,
		/datum/action/cooldown/spell/undirected/touch/prestidigitation,
	)
	spell_points = 17
	attunements_max = 6
	attunements_min = 4

	job_bitflag = BITFLAG_ROYALTY

	allowed_patrons = list(/datum/patron/divine/noc, /datum/patron/inhumen/zizo) //intentional. This means it's a gamble between Noc or Zizo if your not one already. Don't fucking change this.

	exp_type = list(EXP_TYPE_ADVENTURER, EXP_TYPE_LIVING, EXP_TYPE_MAGICK)
	exp_types_granted  = list(EXP_TYPE_NOBLE, EXP_TYPE_MAGICK, EXP_TYPE_ADVENTURER)
	exp_requirements = list(
		EXP_TYPE_LIVING = 1200,
		EXP_TYPE_ADVENTURER = 300,
		EXP_TYPE_MAGICK = 300
	)

/datum/job/magician/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(prob(1))
		spawned.cmode_music = 'sound/music/cmode/antag/combat_evilwizard.ogg'

/datum/outfit/magician/pre_equip(mob/living/carbon/human/H)
	..()
	H.mana_pool?.set_intrinsic_recharge(MANA_ALL_LEYLINES)
	backr = /obj/item/storage/backpack/satchel
	cloak = /obj/item/clothing/cloak/black_cloak
	ring = /obj/item/clothing/ring/gold
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltr = /obj/item/storage/magebag/apprentice
	backl = /obj/item/weapon/polearm/woodstaff
	shoes = /obj/item/clothing/shoes/shortboots
	neck = /obj/item/clothing/neck/mana_star
	belt = /obj/item/storage/belt/leather/plaquegold
	backpack_contents = list(/obj/item/scrying = 1, /obj/item/chalk = 1,/obj/item/reagent_containers/glass/bottle/killersice = 1, /obj/item/book/granter/spellbook/master = 1, /obj/item/weapon/knife/dagger/silver/arcyne = 1, /obj/item/storage/keyring/mage = 1,)

	if(istype(H.patron, /datum/patron/inhumen/zizo))
		H.grant_language(/datum/language/undead)
	H.adjust_skillrank(/datum/skill/misc/reading, 6, TRUE)
	H.adjust_skillrank(/datum/skill/magic/arcane, pick(6,5), TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)//old party member, he was an adventurer who saved the city, also buff wizard
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 3, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 4, TRUE)
	if(H.age == AGE_OLD)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_INT, 1)
	if(H.gender == MALE)
		H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
	ADD_TRAIT(H, TRAIT_SEEPRICES, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_OLDPARTY, TRAIT_GENERIC)
	H.virginity = TRUE
	H.change_stat(STATKEY_STR, -2)
	H.change_stat(STATKEY_INT, 5)
	H.change_stat(STATKEY_CON, -2)
	H.change_stat(STATKEY_SPD, -2)

/datum/outfit/magician/post_equip(mob/living/carbon/human/H)
	. = ..()
	var/static/list/selectablehat = list(
		"Witch hat" = /obj/item/clothing/head/wizhat/witch,
		"Random Wizard hat" = /obj/item/clothing/head/wizhat/random,
		"Mage hood" = /obj/item/clothing/head/roguehood/colored/mage,
		"Generic Wizard hat" = /obj/item/clothing/head/wizhat/gen,
		"Mage hood" = /obj/item/clothing/head/roguehood/colored/mage,
		"Black hood" = /obj/item/clothing/head/roguehood/colored/black,
	)
	H.select_equippable(H, selectablehat, message = "Choose your hat of choice", title = "WIZARD")
	var/static/list/selectablerobe = list(
		"Black robes" = /obj/item/clothing/shirt/robe/colored/black,
		"Mage robes" = /obj/item/clothing/shirt/robe/colored/mage,
		"Courtmage Robes" = /obj/item/clothing/shirt/robe/colored/courtmage,
		"Wizard robes" = /obj/item/clothing/shirt/robe/wizard,
	)
	H.select_equippable(H, selectablerobe, message = "Choose your robe of choice", title = "WIZARD")
