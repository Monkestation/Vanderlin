/datum/attribute_holder/sheet/job/redwood
	raw_attribute_list = list(
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/crafting = 10, // no stats since its based on archetypes
	)

/datum/attribute_holder/sheet/job/redwood/heavy
		raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 2,
		STAT_INTELLIGENCE = -2, // strong (for a elf) heavy armor user, stupid
	)

/datum/attribute_holder/sheet/job/redwood/medium
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 1,
		STAT_SPEED = 2, // speedy polearm fighters
	)

/datum/attribute_holder/sheet/job/redwood/light
	raw_attribute_list = list(
		STAT_PERCEPTION = 3,
		STAT_SPEED = 2,
		STAT_CONSTITUTION = -1, // speedy frail archers
	)

/datum/job/advclass/mercenary/redwood
	title = "Redwood Mercenary"
	tutorial = "A hired blade from the Redwood Warband, known for carrying the seed of a red-wooded tree from the Crimsonlands, their homeland. When one mercenary falls, their seed is carried home and planted in the plains. One dae there will be forests of the dead, outnumbering even the orcish horde."
	allowed_races = RACES_PLAYER_ELF
	outfit = /datum/outfit/mercenary/redwood
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander3.ogg'
	total_positions = 5

	attribute_sheet = /datum/attribute_holder/sheet/job/redwood

	traits = list(
		TRAIT_FORAGER, //survivalist mfs
	)

/datum/job/advclass/mercenary/redwood/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.merctype = 4

	exp_type = list(EXP_TYPE_LIVING)
	exp_requirements = list(EXP_TYPE_LIVING = 600)

/datum/outfit/mercenary/redwood
	name = "Redwood Mercenary (Mercenary)"
	shoes = /obj/item/clothing/shoes/boots/leather
	cloak = /obj/item/clothing/cloak/raincloak/colored/red
	gloves = /obj/item/clothing/gloves/angle
	belt = /obj/item/storage/belt/leather/mercenary/black
	backl = /obj/item/storage/backpack/satchel
	beltl = /obj/item/weapon/knife/dagger/steel/special
	scabbards = list(/obj/item/weapon/scabbard/knife)
	shirt = /obj/item/clothing/armor/gambeson/light/colored/black
	pants = /obj/item/clothing/pants/trou/leather
	neck = /obj/item/clothing/neck/chaincoif
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor
	)

/datum/job/advclass/mercenary/redwood/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/weapons = list(
		"Brute" = /obj/item/weapon/mace/elvenclub/steel,
		"Glaive Master" = /obj/item/weapon/polearm/halberd/elvenglaive,
		"Ranger" = /obj/item/gun/ballistic/bow/long
	)

	var/weapon_choice = spawned.select_equippable(player_client, weapons, message = "Choose your ARCHETYPE.", title = "FOR THE WARBAND.")
	switch(weapon_choice)
		if("Brute")
			spawned.adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 35)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/armor/brigandine, ITEM_SLOT_ARMOR, TRUE)
			ADD_TRAIT(spawned, TRAIT_HEAVYARMOR, JOB_TRAIT)
			ADD_TRAIT(spawned, TRAIT_MEDIUMARMOR, JOB_TRAIT)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/redwood/heavy)
		if("Glaive Master")
			spawned.adjust_skill_level(/datum/attribute/skill/combat/polearms, 35)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/armor/cuirass, ITEM_SLOT_ARMOR, TRUE)
			ADD_TRAIT(spawned, TRAIT_MEDIUMARMOR, JOB_TRAIT)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/redwood/medium)
		if("Ranger")
			spawned.adjust_skill_level(/datum/attribute/skill/combat/bows, 35)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/armor/leather/advanced, ITEM_SLOT_ARMOR, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/ammo_holder/quiver/arrows, ITEM_SLOT_BELT_R, TRUE)
			ADD_TRAIT(spawned, TRAIT_DODGEEXPERT, JOB_TRAIT)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/redwood/light)

	var/static/list/helmets = list(
		"Elven Barbute" = /obj/item/clothing/head/helmet/elfbarbute,
		"Winged Elven Barbute" = /obj/item/clothing/head/helmet/elfbarbute/winged,
		"Reinforced Hood" = /obj/item/clothing/head/roguehood/leather/advanced,
		"Kettle Helmet" = /obj/item/clothing/head/helmet/kettle/slit,
	)
	spawned.select_equippable(player_client, helmets, message = "Choose your HELMET.", title = "PROTECT YOUR HEAD.")
