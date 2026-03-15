/datum/attribute_holder/sheet/job/roguemage
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_INTELLIGENCE = 3,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = -1,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/bows = 10,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/swords = 10,
		/datum/attribute/skill/combat/knives = 10,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/riding = 10,
		/datum/attribute/skill/misc/reading = 40,
		/datum/attribute/skill/craft/alchemy = 30,
		/datum/attribute/skill/magic/arcane = 30,

	)

/datum/attribute_holder/sheet/job/roguemage/old
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_SPEED = -1,
		STAT_INTELLIGENCE = 4,
		STAT_CONSTITUTION = 1,
		STAT_PERCEPTION = 1,
		STAT_ENDURANCE = -1,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/bows = 10,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/swords = 10,
		/datum/attribute/skill/combat/knives = 10,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/riding = 10,
		/datum/attribute/skill/misc/reading = 40,
		/datum/attribute/skill/craft/alchemy = 30,
		/datum/attribute/skill/magic/arcane = 40,

	)

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

	attribute_sheet = /datum/attribute_holder/sheet/job/roguemage
	attribute_sheet_old = /datum/attribute_holder/sheet/job/roguemage/old

	spells = list(
		/datum/action/cooldown/spell/undirected/touch/prestidigitation
	)


/datum/job/advclass/bandit/roguemage/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_OLD)
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
