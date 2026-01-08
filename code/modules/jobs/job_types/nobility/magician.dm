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
	skills = list(
	/datum/skill/misc/reading = 6,
	/datum/skill/misc/riding = 2 ,
	/datum/skill/magic/arcane = 5,
	/datum/skill/combat/wrestling = 2,
	/datum/skill/combat/unarmed = 2,
	/datum/skill/misc/athletics = 2, //old party member, he was an adventurer who saved the city, also buff wizard
	/datum/skill/combat/polearms = 3,
	/datum/skill/craft/alchemy = 3,
	/datum/skill/labor/mathematics = 4,
	)

	jobstats = list(
		STATKEY_STR =-2,
		STATKEY_INT = 5,
		STATKEY_CON =-2,
		STATKEY_SPD =-2,
	)

	traits = list(
	TRAIT_SEEPRICES,
	TRAIT_NOBLE,
	TRAIT_OLDPARTY,
	)

	spell_points = 17
	attunements_max = 6
	attunements_min = 4
	job_bitflag = BITFLAG_ROYALTY

	allowed_patrons = list(/datum/patron/divine/noc, /datum/patron/inhumen/zizo) //intentional. This means it's a gamble between Noc or Zizo if neither is your patron. Don't change this.

	exp_type = list(EXP_TYPE_ADVENTURER, EXP_TYPE_LIVING, EXP_TYPE_MAGICK)
	exp_types_granted = list(EXP_TYPE_NOBLE, EXP_TYPE_MAGICK, EXP_TYPE_ADVENTURER)
	exp_requirements = list(
		EXP_TYPE_LIVING = 1200,
		EXP_TYPE_ADVENTURER = 300,
		EXP_TYPE_MAGICK = 300
	)

	jobstats = list(
		STATKEY_STR = -2,
		STATKEY_INT = 5,
		STATKEY_CON = -2,
		STATKEY_SPD = -2
	)

	skills = list(
		/datum/skill/misc/reading = 6,
		/datum/skill/misc/riding = 2,
		/datum/skill/magic/arcane = 5,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/misc/athletics = 2,
		/datum/skill/combat/polearms = 3,
		/datum/skill/craft/alchemy = 3,
		/datum/skill/labor/mathematics = 4
	)

	traits = list(
		TRAIT_SEEPRICES,
		TRAIT_NOBLE,
		TRAIT_OLDPARTY
	)

/datum/job/magician/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.add_quirk(/datum/quirk/boon/folk_hero)
	if(prob(1))
		spawned.cmode_music = 'sound/music/cmode/antag/combat_evilwizard.ogg'

	if(istype(spawned.patron, /datum/patron/inhumen/zizo))
		spawned.grant_language(/datum/language/undead)

	spawned.adjust_skillrank(/datum/skill/magic/arcane, pick(0,1))

	if(spawned.age == AGE_OLD)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_SPD, -1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_INT, 1)

	spawned.virginity = TRUE

	if(spawned.gender == MALE && spawned.dna?.species  && spawned.dna.species.id != SPEC_ID_MEDICATOR)
		spawned.dna.species.soundpack_m = new /datum/voicepack/male/wizard()

/datum/outfit/magician
	name = "Court Magician"
	backr = /obj/item/storage/backpack/satchel
	cloak = /obj/item/clothing/cloak/black_cloak
	ring = /obj/item/clothing/ring/gold
	belt = /obj/item/storage/belt/leather/plaquegold
	beltr = /obj/item/storage/magebag/apprentice
	backl = /obj/item/weapon/polearm/woodstaff
	shoes = /obj/item/clothing/shoes/shortboots
	neck = /obj/item/clothing/neck/mana_star
	backpack_contents = list(
		/obj/item/scrying = 1,
		/obj/item/chalk = 1,
		/obj/item/reagent_containers/glass/bottle/killersice = 1,
		/obj/item/book/granter/spellbook/master = 1,
		/obj/item/weapon/knife/dagger/silver/arcyne = 1,
		/obj/item/storage/keyring/mage = 1
	)

/datum/outfit/magician/post_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	var/static/list/selectablehat = list(
		"Witch hat" = /obj/item/clothing/head/wizhat/witch,
		"Random Wizard hat" = /obj/item/clothing/head/wizhat/random,
		"Mage hood" = /obj/item/clothing/head/roguehood/colored/mage,
		"Generic Wizard hat" = /obj/item/clothing/head/wizhat/gen,
		"Black hood" = /obj/item/clothing/head/roguehood/colored/black,
	)
	equipped_human.select_equippable(equipped_human, selectablehat, message = "Choose your hat of choice", title = "WIZARD")

	var/static/list/selectablerobe = list(
		"Black robes" = /obj/item/clothing/shirt/robe/colored/black,
		"Mage robes" = /obj/item/clothing/shirt/robe/colored/mage,
		"Courtmage Robes" = /obj/item/clothing/shirt/robe/colored/courtmage,
		"Wizard robes" = /obj/item/clothing/shirt/robe/wizard,
	)
	equipped_human.select_equippable(equipped_human, selectablerobe, message = "Choose your robe of choice", title = "WIZARD")

