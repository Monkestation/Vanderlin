/datum/job/men_at_arms
	title = JOB_MAN_AT_ARMS
	tutorial = "Chosen by the Captain and King, you're not like those shit stinking City Watchmen. \
	Like a hound on a leash, you stand vigilant for your masters. \
	You live better than the rest of the taffers in this kingdom-- \
	infact, you take shifts manning the gate with your brethren, assuming the gatemaster isn't there, \
	keeping the savages out, keeping the shit-covered knaves away from your foppish superiors. \
	It will be a cold day in hell when you and your compatriots are slain, and nobody in this town will care. \
	The nobility needs good men, and they only come in a pair of pairs."
	department_flag = GARRISON
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_MENATARMS
	factions = list(FACTION_TOWN, SUB_FACTION_KEEP)
	total_positions = 4
	spawn_positions = 4

	allowed_races = RACES_PLAYER_NO_KOBOLD
	blacklisted_species = list(SPEC_ID_HALFLING, SPEC_ID_HALF_SNOW_ELF, SPEC_ID_SNOW_ELF)

	outfit = /datum/outfit/watchman
	advclass_cat_rolls = list(CTAG_MENATARMS = 20)
	cmode_music = 'sound/music/cmode/garrison/CombatManAtArms.ogg'
	give_bank_account = 30
	knows_the_town = TRUE
	known_by_the_town = TRUE
	jobs_i_always_know = KNOW_COURT_LIST
	jobs_always_know_me = KNOW_COURT_AGENT_LIST
	starting_wage = 30

	job_bitflag = BITFLAG_GARRISON

	exp_type = list(EXP_TYPE_GARRISON)
	exp_types_granted = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)
	exp_requirements = list(
		EXP_TYPE_GARRISON = 600
	)
	verbs = list(
		/mob/proc/haltyell
	)

/datum/outfit/watchman
	name = "Men-at-arms Base"
	cloak = /obj/item/clothing/cloak/stabard/guard
	armor = /obj/item/clothing/armor/brigandine/light
	shirt = /obj/item/clothing/armor/gambeson
	neck = /obj/item/clothing/neck/gorget
	gloves = /obj/item/clothing/gloves/chain/iron
	wrists = /obj/item/clothing/wrists/bracers/leather/brigandine
	pants = /obj/item/clothing/pants/trou/leather/brigandine
	shoes = /obj/item/clothing/shoes/boots/leather/advanced/watch
	belt = /obj/item/storage/belt/leather
	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel/special = 1,
		/obj/item/storage/keyring/manorguard = 1
	)
/datum/job/men_at_arms/on_roundstart(mob/living/spawned, client/player_client)
	. = ..()

	var/static/list/selectablehelmets = list(
		"Royal Slitted Kettle Helmet" = /obj/item/clothing/head/helmet/kettle/slit/atarms,
		"Slitted Kettle Helmet" = /obj/item/clothing/head/helmet/kettle/slit,
		"Kettle Helmet"	= /obj/item/clothing/head/helmet/kettle,
		"Steel Sallet" = /obj/item/clothing/head/helmet/sallet,
		"Nasal Helmet" = /obj/item/clothing/head/helmet/nasal,
	)

	spawned.select_equippable(player_client, selectablehelmets, message = "Choose Your Helmet", title = JOB_MAN_AT_ARMS)

/datum/outfit/watchman/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	. = ..()
	if(H.cloak && !findtext(H.cloak.name, "([H.real_name])"))
		H.cloak.name = "[H.cloak.name] ([H.real_name])"

/datum/job/advclass/menatarms
	exp_type = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)
	exp_types_granted = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)
	factions = list(FACTION_TOWN, SUB_FACTION_KEEP)

/datum/attribute_holder/sheet/job/menatarms/footman
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 1,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/wrestling = 35,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 35,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/crafting = 10
	)

/datum/job/advclass/menatarms/watchman_footman
	title = "Footman Men-At-Arms"
	tutorial = "You once warded the town, beating the poor and killing the senseless. \
	Now you get to stare at them in the eyes, watching as they bleed, \
	exanguinated personally by one of the Monarch's best. \
	You are poor, and your belly is yet full."
	category_tags = list(CTAG_MENATARMS)
	attribute_sheet = /datum/attribute_holder/sheet/job/menatarms/footman
	traits = list(
		TRAIT_MEDIUMARMOR
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

/datum/job/advclass/menatarms/watchman_footman/on_roundstart(mob/living/spawned, client/player_client)
	. = ..()
	var/static/list/weapons = list(
		"Iron Warhammer & Shield" = list(/obj/item/weapon/mace/warhammer, /obj/item/weapon/shield/tower/metal),
		"Steel Shortsword & Shield" = list(/obj/item/weapon/sword/short, /obj/item/weapon/shield/tower/metal),
		"Billhook & Iron Shortsword" = list(/obj/item/weapon/polearm/spear/billhook, /obj/item/weapon/sword/short/iron),
		"Halberd" = /obj/item/weapon/polearm/halberd,
		"Greataxe" = /obj/item/weapon/greataxe,
		"Eagle's Beak" = /obj/item/weapon/polearm/eaglebeak,
	)

	var/weapon_choice = spawned.select_equippable(player_client, weapons, message = "CHOOSE YOUR WEAPON.", title = "TAKE UP ARMS.")

	switch(weapon_choice)
		if("Steel Shortsword & Shield", "Billhook & Iron Shortsword")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/swords, 33, 33)
		if("Iron Warhammer & Shield" || "Greataxe")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 33, 33)
		if("Billhook & Iron Shortsword" || "Halberd" || "Eagle's Beak")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/polearms, 33, 33)
		if("Iron Warhammer & Shield" || "Steel Shortsword & Shield")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/shields, 33, 33)

	var/armors = list("Brigandine Set", "Chainmail Set", "Cuirass Set")
	var/armor_choice = browser_input_list(spawned, "CHOOSE YOUR ARMOR.", "EQUIP YOURSELF.", armors)

	switch(armor_choice)
		//Brigandine Set doesn't need a case, it's the default armor anyway!
		if("Chainmail Set")
			spawned.equip_to_slot_or_del(new /obj/item/clothing/armor/medium/scale, ITEM_SLOT_ARMOR, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/armor/chainmail/iron, ITEM_SLOT_SHIRT, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/pants/chainlegs, ITEM_SLOT_PANTS, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/wrists/bracers/leather, ITEM_SLOT_WRISTS, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/gloves/chain, ITEM_SLOT_GLOVES, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/neck/chaincoif, ITEM_SLOT_NECK, TRUE)
		if("Cuirass Set")
			spawned.equip_to_slot_or_del(new /obj/item/clothing/armor/cuirass, ITEM_SLOT_ARMOR, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/armor/gambeson/arming, ITEM_SLOT_SHIRT, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/pants/chainlegs/iron, ITEM_SLOT_PANTS, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/wrists/bracers, ITEM_SLOT_WRISTS, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/gloves/chain, ITEM_SLOT_GLOVES, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/neck/bevor, ITEM_SLOT_NECK, TRUE)

/datum/attribute_holder/sheet/job/menatarms/ranger
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_PERCEPTION = 2,
		STAT_ENDURANCE = 1,
		STAT_SPEED = 1,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/bows = 33,
		/datum/attribute/skill/combat/crossbows = 33,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/crafting = 10
	)

/datum/job/advclass/menatarms/watchman_ranger
	title = "Archer Men-At-Arms"
	tutorial = "You once warded the town, beating the poor and killing the senseless. \
	Now you stare at them from above, raining hell down upon the knaves and the curs that see you a traitor. \
	You are poor, and your belly is yet full."
	outfit = /datum/outfit/watchman/ranger
	category_tags = list(CTAG_MENATARMS)
	attribute_sheet = /datum/attribute_holder/sheet/job/menatarms/ranger
	traits = list(
		TRAIT_DODGEEXPERT
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

/datum/outfit/watchman/ranger
	name = "Archer Men-At-Arms"
	backl = /obj/item/storage/backpack/satchel

/datum/job/advclass/menatarms/watchman_ranger/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/static/list/weapons = list("Bow", "Crossbow")
	var/weapon_choice = browser_input_list(spawned, "CHOOSE YOUR WEAPON.", "AIM TRUE.", weapons)
	switch(weapon_choice)
		if("Bow")
			spawned.equip_to_slot_or_del(new /obj/item/gun/ballistic/bow/long, ITEM_SLOT_BACK_L, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/ammo_holder/quiver/arrows, ITEM_SLOT_BELT_R, TRUE)
		if("Crossbow")
			spawned.equip_to_slot_or_del(new /obj/item/gun/ballistic/bow/cross, ITEM_SLOT_BACK_L, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/ammo_holder/quiver/bolts, ITEM_SLOT_BELT_R, TRUE)

	var/static/list/sidearms = list("Stiletto", "Iron Shortsword", "Cudgel")
	var/sidearm_choice = browser_input_list(spawned, "CHOOSE YOUR SIDEARM.", "BE VIGILANT.", sidearms)
	switch(sidearm_choice)
		if("Stiletto")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/knife/dagger/steel/stiletto, ITEM_SLOT_BELT_L, TRUE)
		if("Iron Shortsword")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/sword/short/iron, ITEM_SLOT_BELT_L, TRUE)
		if("Cudgel")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/mace/cudgel, ITEM_SLOT_BELT_L, TRUE)

/datum/attribute_holder/sheet/job/menatarms/hospitaller
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 1,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/wrestling = 35,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 35,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/craft/crafting = 10
	)

/datum/job/advclass/menatarms/watchman_hospitaller
	title = "Hospitaller Men-At-Arms"
	outfit = /datum/outfit/watchman/hospitaller
	category_tags = list(CTAG_MENATARMS)
	total_positions = 1
	attribute_sheet = /datum/attribute_holder/sheet/job/menatarms/hospitaller
	traits = list(
		TRAIT_MEDIUMARMOR
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

/datum/outfit/watchman/hospitaller
	name = "Hospitaller Men-At-Arms"
	backr = /obj/item/storage/backpack/backpack
	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel/special = 1,
		/obj/item/storage/keyring/manorguard = 1,
		/obj/item/natural/bundle/cloth/bandage/full = 2,
		/obj/item/tourniquet = 1,
		/obj/item/splint = 1
	)

/datum/job/advclass/menatarms/watchman_hospitaller/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/static/list/sidearms = list("Stiletto", "Iron Shortsword", "Cudgel")
	var/sidearm_choice = browser_input_list(spawned, "CHOOSE YOUR SIDEARM.", "BE VIGILANT.", sidearms)
	switch(sidearm_choice)
		if("Stiletto")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/knife/dagger/steel/stiletto, ITEM_SLOT_BELT_L, TRUE)
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/knives, 30, 30)
		if("Iron Shortsword")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/sword/short/iron, ITEM_SLOT_BELT_L, TRUE)
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/swords, 30, 30)
		if("Cudgel")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/mace/cudgel, ITEM_SLOT_BELT_L, TRUE)
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 30, 30)

/datum/attribute_holder/sheet/job/menatarms/cavalry
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 1,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/wrestling = 35,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 35,
		/datum/attribute/skill/misc/riding = 40,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/crafting = 10
	)

/datum/job/advclass/menatarms/watchman_cavalry
	title = "Cavalry Men-At-Arms"
	category_tags = list(CTAG_MENATARMS)
	total_positions = 2
	attribute_sheet = /datum/attribute_holder/sheet/job/menatarms/cavalry
	traits = list(
		TRAIT_MEDIUMARMOR
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

/datum/job/advclass/menatarms/watchman_cavalry/on_roundstart(mob/living/spawned, client/player_client)
	. = ..()
	var/static/list/weapons = list(
		"Steel Sabre & Crossbow" = list(/obj/item/weapon/sword/sabre, /obj/item/gun/ballistic/bow/cross),
		"Steel Shortsword & Shortbow" = list(/obj/item/weapon/sword/short, /obj/item/gun/ballistic/bow/short),
		"Steel Spear" = /obj/item/weapon/polearm/spear/steel,
		"Lucerne" = /obj/item/weapon/polearm/eaglebeak/lucerne,
	)

	var/weapon_choice = spawned.select_equippable(player_client, weapons, message = "CHOOSE YOUR WEAPON.", title = "TAKE UP ARMS.")

	switch(weapon_choice)
		if("Steel Sabre & Crossbow" || "Steel Shortsword & Shortbow")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/swords, 33, 33)
		if("Steel Spear" || "Lucerne")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/polearms, 33, 33)
		if("Steel Shortsword & Shortbow")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/bows, 33, 33)
			spawned.equip_to_slot_or_del(new /obj/item/ammo_holder/quiver/arrows, ITEM_SLOT_BELT_R, TRUE)
		if("Steel Sabre & Crossbow")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/crossbows, 33, 33)
			spawned.equip_to_slot_or_del(new /obj/item/ammo_holder/quiver/bolts, ITEM_SLOT_BELT_R, TRUE)

	var/armors = list("Brigandine Set", "Chainmail Set")
	var/armor_choice = browser_input_list(spawned, "CHOOSE YOUR ARMOR.", "EQUIP YOURSELF.", armors)

	switch(armor_choice)
		//Brigandine Set doesn't need a case, it's the default armor anyway!
		if("Chainmail Set")
			spawned.equip_to_slot_or_del(new /obj/item/clothing/armor/medium/scale, ITEM_SLOT_ARMOR, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/armor/chainmail/iron, ITEM_SLOT_SHIRT, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/pants/chainlegs, ITEM_SLOT_PANTS, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/wrists/bracers/leather, ITEM_SLOT_WRISTS, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/gloves/chain, ITEM_SLOT_GLOVES, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/neck/chaincoif, ITEM_SLOT_NECK, TRUE)

	var/bardings = list("None", "Padded", "Chainmail")
	var/barding_choice = browser_input_list(spawned, "CHOOSE YOUR BARDING.", "EQUIP YOUR STEED.", bardings)

	switch(barding_choice)
		if("Padded")
			new /obj/item/clothing/barding(get_turf(spawned))
		if("Chainmail")
			new /obj/item/clothing/barding/chain(get_turf(spawned))

/datum/job/advclass/menatarms/watchman_cavalry/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	new /mob/living/simple_animal/hostile/retaliate/saigabuck/tame/saddled(get_turf(spawned))

/datum/attribute_holder/sheet/job/menatarms/sergeant
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 1,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/wrestling = 35,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 35,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/crafting = 10
	)

/datum/job/advclass/menatarms/watchman_sergeant
	title = "Sergeant Men-At-Arms"
	outfit = /datum/outfit/watchman/sergeant
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD)
	total_positions = 1
	category_tags = list(CTAG_MENATARMS)
	attribute_sheet = /datum/attribute_holder/sheet/job/menatarms/sergeant
	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_HEAVYARMOR
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

/datum/outfit/watchman/sergeant
	name = "Sergeant Men-At-Arms"
	head = /obj/item/clothing/head/helmet/visored/sallet
	shirt = /obj/item/clothing/armor/gambeson/arming
	pants = /obj/item/clothing/pants/chainlegs/iron
	wrists = /obj/item/clothing/wrists/bracers
	gloves = /obj/item/clothing/gloves/chain
	neck = /obj/item/clothing/neck/bevor

/datum/job/advclass/menatarms/watchman_sergeant/on_roundstart(mob/living/spawned, client/player_client)
	. = ..()
	var/static/list/weapons = list(
		"Iron Warhammer & Shield" = list(/obj/item/weapon/mace/warhammer, /obj/item/weapon/shield/tower/metal),
		"Steel Shortsword & Shield" = list(/obj/item/weapon/sword/short, /obj/item/weapon/shield/tower/metal),
		"Billhook & Iron Shortsword" = list(/obj/item/weapon/polearm/spear/billhook, /obj/item/weapon/sword/short/iron),
		"Halberd" = /obj/item/weapon/polearm/halberd,
		"Greataxe" = /obj/item/weapon/greataxe,
		"Eagle's Beak" = /obj/item/weapon/polearm/eaglebeak,
	)

	var/weapon_choice = spawned.select_equippable(player_client, weapons, message = "CHOOSE YOUR WEAPON.", title = "TAKE UP ARMS.")

	switch(weapon_choice)
		if("Steel Shortsword & Shield" || "Billhook & Iron Shortsword")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/swords, 35, 35)
		if("Iron Warhammer & Shield" || "Greataxe")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 35, 35)
		if("Billhook & Iron Shortsword", "Halberd", "Eagle's Beak")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/polearms, 35, 35)
		if("Iron Warhammer & Shield" || "Steel Shortsword & Shield")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/shields, 35, 35)
