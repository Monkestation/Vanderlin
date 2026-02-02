/datum/job/advclass/bandit/roguemage //mage class - like the adventurer mage, but more evil.
	title = "Rogue Mage"
	tutorial = "Those fools at the academy laughed at you and cast you from the ivory tower of higher learning and magickal practice. \
	No matter - you will ascend to great power one day, but first you need wealth - vast amounts of it. \
	Show those fools in the town what REAL magic looks like."
	outfit = /datum/outfit/bandit/roguemage
	category_tags = list(CTAG_BANDIT)
	cmode_music = 'sound/music/cmode/antag/CombatRogueMage.ogg'
	exp_types_granted = list(EXP_TYPE_COMBAT, EXP_TYPE_MAGICK)
	magic_user = TRUE
	allowed_patrons = list(/datum/patron/inhumen/zizo)
	languages = list(/datum/language/undead)
	spell_points = 1

	jobstats = list(
		STATKEY_STR = -1,
		STATKEY_INT = 3,
		STATKEY_CON = 1,
		STATKEY_END = -1,
	)

	skills = list(
		/datum/skill/combat/polearms = 2,
		/datum/skill/combat/bows = 1,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/athletics = 3,
		/datum/skill/combat/swords = 1,
		/datum/skill/combat/knives = 1,
		/datum/skill/craft/crafting = 1,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/riding = 1,
		/datum/skill/misc/reading = 4,
		/datum/skill/craft/alchemy = 3,
		/datum/skill/magic/arcane = 3,
	)

	spells = list(
		/datum/action/cooldown/spell/undirected/touch/prestidigitation
	)


/datum/job/advclass/bandit/roguemage/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_SPD, -1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_INT, 1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_PER, 1)
		spawned.adjust_spell_points(1)

	if(prob(1))
		spawned.cmode_music = 'sound/music/cmode/antag/combat_evilwizard.ogg'

/datum/outfit/bandit/roguemage
	name = "Rogue Mage (Bandit)"
	shoes = /obj/item/clothing/shoes/simpleshoes
	pants = /obj/item/clothing/pants/trou/leather
	shirt = /obj/item/clothing/shirt/shortshirt
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/reagent_containers/glass/bottle/manapot
	backr = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/needle/thorn = 1, /obj/item/natural/cloth = 1, /obj/item/clothing/face/spectacles/sglasses, /obj/item/chalk = 1, /obj/item/book/granter/spellbook/apprentice = 1)
	mask = /obj/item/clothing/face/facemask/steel
	neck = /obj/item/clothing/neck/coif
	r_hand = /obj/item/weapon/polearm/woodstaff/quarterstaff/iron


/datum/outfit/bandit/roguemage/post_equip(mob/living/carbon/human/H)
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
	)
	H.select_equippable(H, selectablerobe, message = "Choose your robe of choice", title = "WIZARD")
