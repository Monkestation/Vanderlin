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
	faction = FACTION_TOWN
	total_positions = 4
	spawn_positions = 4
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_NO_KOBOLD
	blacklisted_species = list(SPEC_ID_HALFLING)

	outfit = /datum/outfit/watchman
	advclass_cat_rolls = list(CTAG_MENATARMS = 20)
	cmode_music = 'sound/music/cmode/garrison/CombatManAtArms.ogg'
	give_bank_account = 30

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
	wrists = /obj/item/clothing/wrists/bracers/leather
	pants = /obj/item/clothing/pants/trou/leather/guard
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/storage/keyring/manorguard

/datum/outfit/watchman/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	. = ..()
	if(H.cloak && !findtext(H.cloak.name, "([H.real_name])"))
		H.cloak.name = "[H.cloak.name] ([H.real_name])"

/datum/job/advclass/menatarms
	exp_type = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)
	exp_types_granted = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)

/datum/attribute_holder/sheet/job/menatarms/pikeman
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_PERCEPTION = -1,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = 1,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/crafting = 10
	)

/datum/job/advclass/menatarms/watchman_pikeman
	title = "Pikeman Men-At-Arms"
	tutorial = "You once warded the town, beating the poor and killing the senseless. \
	Now you get to stare at them in the eyes, watching as they bleed, \
	exanguinated personally by one of the Monarch's best. \
	You are poor, and your belly is yet full."
	outfit = /datum/outfit/watchman/pikeman
	category_tags = list(CTAG_MENATARMS)

	attribute_sheet = /datum/attribute_holder/sheet/job/menatarms/pikeman

	traits = list(
		TRAIT_MEDIUMARMOR
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

/datum/outfit/watchman/pikeman
	name = "Pikeman Men-At-Arms"
	head = /obj/item/clothing/head/helmet/kettle/slit/atarms
	armor = /obj/item/clothing/armor/chainmail/hauberk
	shirt = /obj/item/clothing/armor/gambeson/arming
	neck = /obj/item/clothing/neck/bevor
	gloves = /obj/item/clothing/gloves/leather
	beltr = /obj/item/weapon/sword/arming
	backr = /obj/item/weapon/polearm/spear/billhook
	backl = /obj/item/storage/backpack/satchel
	scabbards = list(/obj/item/weapon/scabbard/sword)
	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel/special = 1
	)

/datum/attribute_holder/sheet/job/menatarms/axeman
	raw_attribute_list = list(
		STAT_ENDURANCE = 2,
		STAT_STRENGTH = 2,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/labor/lumberjacking = 10
	)

/datum/job/advclass/menatarms/watchman_axeman
	title = "Axeman Men-At-Arms"
	tutorial = "You once warded the town, beating the poor and killing the senseless. \
	Now you charge straight ahead, those infront cannot stop the weight of your axe- \
	exanguinated personally by one of the Monarch's best. \
	You are poor, and your belly is yet full."
	outfit = /datum/outfit/watchman/axeman
	category_tags = list(CTAG_MENATARMS)

	attribute_sheet = /datum/attribute_holder/sheet/job/menatarms/axeman

	traits = list(
		TRAIT_HEAVYARMOR,
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

/datum/outfit/watchman/axeman
	name = "Axeman Men-At-Arms"
	head = /obj/item/clothing/head/helmet/kettle/slit/atarms
	armor = /obj/item/clothing/armor/brigandine
	shirt = /obj/item/clothing/armor/gambeson/heavy
	neck = /obj/item/clothing/neck/bevor
	gloves = /obj/item/clothing/gloves/chain
	backl = /obj/item/storage/backpack/satchel
	backr = /obj/item/weapon/greataxe/steel
	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel/special = 1
	)

/datum/attribute_holder/sheet/job/menatarms/ranger
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_PERCEPTION = 2,
		STAT_SPEED = 1,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/combat/crossbows = 30,
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
	head = /obj/item/clothing/head/helmet/kettle/slit/atarms
	armor = /obj/item/clothing/armor/leather/splint
	shirt = /obj/item/clothing/armor/gambeson/arming
	beltr = /obj/item/weapon/mace/cudgel
	neck = /obj/item/clothing/neck/bevor
	gloves = /obj/item/clothing/gloves/leather
	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel/special = 1
	)

/datum/outfit/watchman/ranger/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	var/weapontypec = pickweight(list("Bow" = 6, "Crossbow" = 4))
	switch(weapontypec)
		if("Bow")
			backl = /obj/item/gun/ballistic/bow/long
			backr = /obj/item/ammo_holder/quiver/arrows
		if("Crossbow")
			backl = /obj/item/gun/ballistic/bow/cross
			backr = /obj/item/ammo_holder/quiver/bolts

/datum/attribute_holder/sheet/job/menatarms/swordsman
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 1,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/crafting = 10
	)

/datum/job/advclass/menatarms/watchman_swordsman
	title = "Swordsman Men-At-Arms"
	tutorial = "You once warded the town, beating the poor and killing the senseless. \
	Now you get to stare at them in the eyes, watching as they bleed, \
	exanguinated personally by one of the Monarch's best. \
	You are poor, and your belly is yet full."
	outfit = /datum/outfit/watchman/swordsman
	category_tags = list(CTAG_MENATARMS)

	attribute_sheet = /datum/attribute_holder/sheet/job/menatarms/swordsman

	traits = list(
		TRAIT_MEDIUMARMOR
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

/datum/outfit/watchman/swordsman
	name = "Swordsman Men-At-Arms"
	head = /obj/item/clothing/head/helmet/kettle/slit/atarms
	armor = /obj/item/clothing/armor/chainmail/hauberk
	shirt = /obj/item/clothing/armor/gambeson/arming
	neck = /obj/item/clothing/neck/bevor
	gloves = /obj/item/clothing/gloves/leather
	beltr = /obj/item/weapon/sword/arming
	backr = /obj/item/weapon/shield/heater
	backl = /obj/item/storage/backpack/satchel
	scabbards = list(/obj/item/weapon/scabbard/sword)
	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel/special = 1
	)
