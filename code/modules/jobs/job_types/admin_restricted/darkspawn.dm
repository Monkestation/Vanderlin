/datum/attribute_holder/sheet/job/darkspawn
	raw_attribute_list = list(
		STAT_STRENGTH = 9,
		STAT_INTELLIGENCE = 5,
		STAT_CONSTITUTION = 9,
		STAT_ENDURANCE = 9,
		STAT_PERCEPTION = 5,
		STAT_SPEED = 5,
		/datum/attribute/skill/combat/wrestling = 60,
		/datum/attribute/skill/combat/unarmed = 60,
		/datum/attribute/skill/combat/shields = 50,
		/datum/attribute/skill/combat/axesmaces = 50,
		/datum/attribute/skill/combat/knives = 50,
		/datum/attribute/skill/combat/crossbows = 50,
		/datum/attribute/skill/combat/bows = 50,
		/datum/attribute/skill/combat/swords = 60,
		/datum/attribute/skill/combat/polearms = 60,
		/datum/attribute/skill/combat/whipsflails = 60,
		/datum/attribute/skill/misc/climbing = 50,
		/datum/attribute/skill/misc/athletics = 50,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/magic/holy = 60,
		/datum/attribute/skill/magic/arcane = 60,
		/datum/attribute/skill/magic/blood = 60,
	)

/datum/job/admin/darkspawn
	title = JOB_ADMIN_DARKSPAWN
	tutorial = "The Lady has chosen you. \
	The Lady has invested in you. \
	You are her flesh. \
	You are her will."
	job_flags = (JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	factions = list(FACTION_CABAL, FACTION_UNDEAD)

	cmode_music = 'sound/music/cmode/antag/combat_cult.ogg'
	allowed_patrons = list(/datum/patron/inhumen/zizo)

	outfit = /datum/outfit/admin/darkspawn
	honorary = "Lord"
	honorary_f = "Lady"

	magic_user = TRUE
	knows_the_town = TRUE
	known_by_the_town = FALSE

	exp_type = list()
	exp_types_granted = list()
	exp_requirements = list()

	attribute_sheet = /datum/attribute_holder/sheet/job/darkspawn

	spells = list(
		/datum/action/cooldown/spell/aoe/knock,
		/datum/action/cooldown/spell/undirected/jaunt/ethereal_jaunt,
		/datum/action/cooldown/spell/undirected/touch/prestidigitation,
		/datum/action/cooldown/spell/projectile/repel,
		/datum/action/cooldown/spell/gravity,
		/datum/action/cooldown/spell/strengthen_undead,
	)

	traits = list(
		TRAIT_CLOSECOMBAT,
		TRAIT_NOSTAMINA,
		TRAIT_SLEEPIMMUNE,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_ZJUMP,
		TRAIT_HEAVYARMOR,
		TRAIT_MEDIUMARMOR,
		TRAIT_SHARPER_BLADES,
		TRAIT_BLINDFIGHTING,
		TRAIT_NOBLOOD,
		TRAIT_NOBREATH,
		TRAIT_NOHUNGER,
		TRAIT_NOHYGIENE,
		TRAIT_NOLIMBDISABLE,
		TRAIT_NOHARDCRIT,
		TRAIT_STUNIMMUNE,
		TRAIT_TOXIMMUNE,
		TRAIT_NODECAPITATE,
		TRAIT_LIMBATTACHMENT,
		TRAIT_DEADNOSE,
		TRAIT_STEELHEARTED,
		TRAIT_BLOOD_SORCERER,
		TRAIT_VITAE_USER,
		TRAIT_NOPAIN,
	)

	languages = list(
		/datum/language/elvish,
		/datum/language/dwarvish,
		/datum/language/zalad,
		/datum/language/hellspeak,
		/datum/language/newpsydonic,
		/datum/language/orcish,
		/datum/language/thievescant,
		/datum/language/undead
	)
	book_type = /obj/item/recipe_book/arcyne

/datum/job/admin/darkspawn/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_acolyte()
		devotion.grant_to(spawned)
		devotion.update_passive_devotion(5)

	spawned.adjust_technique_mastery_points(12)
	spawned.adjust_form_mastery_points(20)
	spawned.mana_pool.set_intrinsic_recharge(MANA_ALL_LEYLINES)

	if(spawned.dna?.species)
		spawned.dna.species.soundpack_m = new /datum/voicepack/male/darkspawn()
		spawned.dna.species.organs[ORGAN_SLOT_EYES] = /obj/item/organ/eyes/night_vision/nightmare

	spawned.grant_nightmare_eyes()

/datum/outfit/admin/darkspawn
	name = JOB_ADMIN_DARKSPAWN
	pants = /obj/item/clothing/pants/trou/formal/shorts
	shoes = /obj/item/clothing/shoes/courtphysician/female
	belt = /obj/item/storage/belt/leather/exoticsilkbelt
	beltl = /obj/item/weapon/sword/sabre/stalker
	armor = /obj/item/clothing/armor/basiceast/mentorsuit

