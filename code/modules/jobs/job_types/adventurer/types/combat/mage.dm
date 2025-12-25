/datum/job/advclass/combat/mage
	title = "Mage"
	tutorial = "A wandering graduate of the many colleges of magick across Psydonia, you search for a job to put your degree to use. And they say school was hard..."
	outfit = /datum/outfit/adventurer/mage
	category_tags = list(CTAG_ADVENTURER)
	total_positions = 4
	cmode_music = 'sound/music/cmode/adventurer/CombatSorcerer.ogg'
	allowed_patrons = list(/datum/patron/divine/noc, /datum/patron/inhumen/zizo)
	blacklisted_species = list(SPEC_ID_HALFLING)
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT, EXP_TYPE_MAGICK)
	magic_user = TRUE
	spell_points = 5

	spells = list(
		/datum/action/cooldown/spell/undirected/touch/prestidigitation
	)

	skills = list(
		/datum/skill/misc/reading = 4,
		/datum/skill/magic/arcane = 3,
		/datum/skill/craft/cooking = 1,
		/datum/skill/misc/medicine = 1,
		/datum/skill/craft/alchemy = 2,
	)

	jobstats = list(
		STATKEY_STR = -2,
		STATKEY_INT = 3,
		STATKEY_CON = -2,
		STATKEY_END = -1,
		STATKEY_SPD = -2,
	)


/datum/job/advclass/combat/mage/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.patron?.type == /datum/patron/inhumen/zizo)
		if(!spawned.has_language(/datum/language/undead))
			spawned.grant_language(/datum/language/undead)

	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_INT, 1)


/datum/outfit/adventurer/mage
	name = "Mage (Adventurer)"
	shoes = /obj/item/clothing/shoes/simpleshoes
	belt = /obj/item/storage/belt/leather/rope
	backr = /obj/item/storage/backpack/satchel
	beltr = /obj/item/storage/magebag/poor
	beltl = /obj/item/reagent_containers/glass/bottle/manapot
	r_hand = /obj/item/weapon/polearm/woodstaff


	backpack_contents = list(
		/obj/item/book/granter/spellbook/apprentice = 1,
		/obj/item/chalk = 1,
	)

/datum/outfit/adventurer/mage/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	if(H.age == AGE_OLD)
		backl = /obj/item/storage/backpack/backpack

/datum/outfit/adventurer/mage/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	. = ..()
	if(visuals_only)
		return

	var/static/list/selectablehat = list(
		"Witch hat" = /obj/item/clothing/head/wizhat/witch,
		"Random Wizard hat" = /obj/item/clothing/head/wizhat/random,
		"Mage hood" = /obj/item/clothing/head/roguehood/colored/mage,
		"Generic Wizard hat" = /obj/item/clothing/head/wizhat/gen,
		"Black hood" = /obj/item/clothing/head/roguehood/colored/black,
	)

	H.select_equippable(H, selectablehat, message = "Choose your hat of choice", title = "WIZARD")

	// Robe selection
	var/static/list/selectablerobe = list(
		"Black robes" = /obj/item/clothing/shirt/robe/colored/black,
		"Mage robes" = /obj/item/clothing/shirt/robe/colored/mage,
	)

	H.select_equippable(H, selectablerobe, message = "Choose your robe of choice", title = "WIZARD")
