/datum/attribute_holder/sheet/job/hedgemage
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 4, // Base for non-old characters
		STAT_ENDURANCE = 1,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/reading = 50,
		/datum/attribute/skill/craft/alchemy = 40,
		/datum/attribute/skill/magic/arcane = 40 // Base value, adjusted for age in after_spawn
	)

/datum/attribute_holder/sheet/job/hedgemage/old
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 5, // Base for non-old characters
		STAT_ENDURANCE = 1,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/reading = 50,
		/datum/attribute/skill/craft/alchemy = 40,
		/datum/attribute/skill/magic/arcane = 50 // Base value, adjusted for age in after_spawn
	)

/datum/job/advclass/wretch/hedgemage
	title = "Hedge Mage"
	tutorial = "They reject your genius, they cast you out, they call you unethical. They do not understand the SACRIFICES you must make. But it does not matter anymore, your power eclipse any of those fools, save for the Court Magos themselves. Show them true magic."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/wretch/hedgemage
	cmode_music = 'sound/music/cmode/antag/CombatRogueMage.ogg'
	total_positions = 2

	allowed_patrons = list(/datum/patron/divine/noc, /datum/patron/inhumen/zizo)
	blacklisted_species = list(SPEC_ID_HALFLING)

	attribute_sheet = /datum/attribute_holder/sheet/job/hedgemage
	attribute_sheet_old = /datum/attribute_holder/sheet/job/hedgemage/old

	magic_user = TRUE
	spell_points = 12
	exp_types_granted = list(EXP_TYPE_COMBAT, EXP_TYPE_MAGICK)

	traits = list(
		TRAIT_STEELHEARTED,
	)

	spells = list(
		/datum/action/cooldown/spell/undirected/touch/prestidigitation
	)

/datum/job/advclass/wretch/hedgemage/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(prob(1))
		spawned.cmode_music = 'sound/music/cmode/antag/combat_evilwizard.ogg'

/datum/outfit/wretch/hedgemage
	name = "Hedge Mage (Wretch)"
	shoes = /obj/item/clothing/shoes/simpleshoes
	belt = /obj/item/storage/belt/leather/rope
	shirt = /obj/item/clothing/armor/gambeson/heavy
	neck = /obj/item/clothing/neck/mana_star
	backr = /obj/item/storage/backpack/satchel
	beltr = /obj/item/storage/magebag/apprentice
	beltl = /obj/item/reagent_containers/glass/bottle/manapot
	r_hand = /obj/item/weapon/polearm/woodstaff/quarterstaff/steel
	backpack_contents = list(
		/obj/item/book/granter/spellbook/adept = 1,
		/obj/item/chalk = 1,
		/obj/item/rope/chain = 1,
		/obj/item/reagent_containers/glass/bottle/stronghealthpot = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/weapon/knife/dagger/silver/arcyne = 1
	)

/datum/outfit/wretch/hedgemage/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.age == AGE_OLD)
		head = /obj/item/clothing/head/wizhat
		backl = /obj/item/storage/backpack/backpack

/datum/outfit/wretch/hedgemage/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	. = ..()
	var/static/list/selectablehat = list(
		"Witch hat" = /obj/item/clothing/head/wizhat/witch,
		"Random Wizard hat" = /obj/item/clothing/head/wizhat/random,
		"Mage hood" = /obj/item/clothing/head/roguehood/colored/mage,
		"Generic Wizard hat" = /obj/item/clothing/head/wizhat/gen,
		"Black hood" = /obj/item/clothing/head/roguehood/colored/black,
	)
	H.select_equippable(H, selectablehat, message = "Choose your hat of choice", title = "HEDGE MAGE")

	var/static/list/selectablerobe = list(
		"Black robes" = /obj/item/clothing/shirt/robe/colored/black,
		"Mage robes" = /obj/item/clothing/shirt/robe/colored/mage,
	)
	H.select_equippable(H, selectablerobe, message = "Choose your robe of choice", title = "HEDGE MAGE")
