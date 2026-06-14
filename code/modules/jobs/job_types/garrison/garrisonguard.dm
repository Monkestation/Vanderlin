/datum/job/guardsman
	title = JOB_CITY_WATCH
	tutorial = "You are a member of the City Watch. \
	You've proven yourself worthy to the Captain and now you've got yourself a salary... \
	as long as you keep the peace that is."
	department_flag = GARRISON
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_CITYWATCHMEN
	faction = FACTION_TOWN
	total_positions = 8
	spawn_positions = 8
	bypass_lastclass = TRUE

	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_IMMORTAL)
	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/guardsman
	advclass_cat_rolls = list(CTAG_GARRISON = 20)
	give_bank_account = 30
	cmode_music = 'sound/music/cmode/garrison/CombatGarrison.ogg'

	exp_type = list(EXP_TYPE_LIVING)
	exp_types_granted = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)
	exp_requirements = list(
		EXP_TYPE_LIVING = 300
	)
	verbs = list(
		/mob/proc/haltyell
	)

/datum/outfit/guardsman
	name = "City Watchmen Base"
	shirt = /obj/item/clothing/shirt/guard
	pants = /obj/item/clothing/pants/guard
	wrists = /obj/item/clothing/wrists/bracers/iron/concealed
	shoes = /obj/item/clothing/shoes/boots/armor/ironmaille
	belt = /obj/item/storage/belt/leather/townguard
	gloves = /obj/item/clothing/gloves/leather
	backl = /obj/item/storage/backpack/satchel
	beltl = /obj/item/weapon/mace/cudgel
	backpack_contents = list(
		/obj/item/rope/chain = 1
	)

/datum/outfit/guardsman/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.dna && !(equipped_human.dna.species.id in RACES_PLAYER_NONDISCRIMINATED))
		mask = /obj/item/clothing/face/shepherd

/datum/outfit/guardsman/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	. = ..()
	if(H.wear_shirt && !findtext(H.wear_shirt.name, "([H.real_name])"))
		H.wear_shirt.name = "[H.wear_shirt.name] ([H.real_name])"


/datum/job/advclass/garrison
	exp_types_granted = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)

/mob/proc/haltyell()
	set name = "HALT!"
	set category = "Emotes.Noises"
	emote("haltyell")

/*
	# SUBTYPES 
*/

// Regular City Watch Footman
// Have a good variety of weapon combintations to choose, that mostly composed of iron/basic weapon versions.
// ALSO REFLECT ALL CHANGES TO PIKEMAN, BECAUSE THEY SHOULD BE EXACLY THE SAME, JUST WITH DIFFERENT WEAPONS!
/datum/job/advclass/garrison/footman
	title = "City Watch Footman"
	tutorial = "You are a member of the City Watch. \
	You are well versed in holding the line with a shield while wielding a trusty sword, axe, or mace in the other hand."
	outfit = /datum/outfit/guardsman/footman
	category_tags = list(CTAG_GARRISON)

	attribute_sheet = /datum/attribute_holder/sheet/job/garrison/footman

	traits = list(
		TRAIT_MEDIUMARMOR,
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

/datum/job/advclass/garrison/footman/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/selectable = list( \
		"Sword & Cudgel" = /obj/item/weapon/sword/iron, \
		"Axe & Cudgel" = /obj/item/weapon/axe/iron, \
		"Mace & Shortsword" = /obj/item/weapon/mace, \
	)
	var/choice = spawned.select_equippable(player_client, selectable, message = "CHOOSE YOUR MAIN AND SIDE WEAPON", title = "FOOTMAN")
	if(!choice)
		choice = "Sword & Cudgel"
		return
	switch(choice)
		if("Sword & Cudgel")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/sword/iron(), ITEM_SLOT_BELT_L, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/mace/cudgel(), ITEM_SLOT_BELT_R, TRUE)
			spawned.adjust_skill_level(/datum/attribute/skill/combat/swords, 10)
		if("Axe & Cudgel")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/axe/iron(), ITEM_SLOT_BELT_L, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/mace/cudgel(), ITEM_SLOT_BELT_R, TRUE)
			spawned.adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 10)
		if("Mace & Shortsword")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/mace(), ITEM_SLOT_BELT_L, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/sword/short(), ITEM_SLOT_BELT_R, TRUE)
			spawned.adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 10)

/datum/attribute_holder/sheet/job/garrison/footman
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 1,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/polearms = 10,
		/datum/attribute/skill/combat/knives = 10,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/sneaking = 10,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/reading = 10
	)

/datum/outfit/guardsman/footman
	name = "City Watch Footman"
	head = /obj/item/clothing/head/helmet/watchmen
	neck = /obj/item/clothing/neck/gorget
	armor = /obj/item/clothing/armor/cuirass/fluted/iron
	backr = /obj/item/weapon/shield/heater
	backl = /obj/item/storage/backpack/satchel
	
	backpack_contents = list(
		/obj/item/rope/chain = 1
	)

// City Watch Pikeman
// Specialized in using spears and other polearms.
// Basically same as Footman, just with slight skill and gear difference.
/datum/job/advclass/garrison/pikeman
	title = "City Watch Pikeman"
	tutorial = "You are City Watch's member. \
	You used to stay lean more into polearms, prefering having greater reach over having a shield."
	outfit = /datum/outfit/guardsman/pikeman
	category_tags = list(CTAG_GARRISON)

	attribute_sheet = /datum/attribute_holder/sheet/job/garrison/pikeman

	traits = list(
		TRAIT_MEDIUMARMOR,
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

/datum/job/advclass/garrison/pikeman/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/selectable = list( \
		"Short Sword" = /obj/item/weapon/sword/short/iron, \
		"Cudgel" = /obj/item/weapon/mace/cudgel, \
	)
	spawned.select_equippable(player_client, selectable, message = "CHOOSE YOUR SIDE WEAPON", title = "PIKEMAN")

/datum/attribute_holder/sheet/job/garrison/pikeman
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 1,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/shields = 10,
		/datum/attribute/skill/combat/knives = 10,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/sneaking = 10,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/reading = 10
	)

/datum/outfit/guardsman/pikeman
	name = "City Watch Pikeman"
	head = /obj/item/clothing/head/helmet/watchmen
	neck = /obj/item/clothing/neck/gorget
	armor = /obj/item/clothing/armor/cuirass/fluted/iron
	backr = /obj/item/weapon/polearm/spear
	backl = /obj/item/storage/backpack/satchel
	
	backpack_contents = list(
		/obj/item/rope/chain = 1
	)

// City Watch Archer
// Mostly support watchmen role.
/datum/job/advclass/garrison/archer
	title = "City Watch Archer"
	tutorial = "You are a member of the City Watch. Your training with bows makes you a great support in battles or formidable threat when perched atop the walls or rooftops, raining arrows down upon foes with impunity."
	outfit = /datum/outfit/guardsman/archer
	category_tags = list(CTAG_GARRISON)

	attribute_sheet = /datum/attribute_holder/sheet/job/garrison/archer

	traits = list(
		TRAIT_DODGEEXPERT,
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

/datum/attribute_holder/sheet/job/garrison/archer
	raw_attribute_list = list(
		STAT_PERCEPTION = 2,
		STAT_ENDURANCE = 1,
		STAT_SPEED = 2,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/combat/crossbows = 30, // Because why not? If they somehow will get a crossbow, let them use it to the fullest.
		/datum/attribute/skill/combat/knives = 30, 
		/datum/attribute/skill/combat/wrestling = 20, 
		/datum/attribute/skill/combat/axesmaces = 20, // Just to be able to non-lethaly detain someone using a cugel
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/swords = 10,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/reading = 10
	)

/datum/outfit/guardsman/archer
	name = "City Watch Archer"
	head = /obj/item/clothing/head/helmet/watchmen
	neck = /obj/item/clothing/neck/highcollier/iron
	armor = /obj/item/clothing/armor/leather/splint
	backr = /obj/item/gun/ballistic/bow
	beltr = /obj/item/ammo_holder/quiver/arrows

/datum/outfit/guardsman/archer/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	shirt = pick(/obj/item/clothing/shirt/undershirt/colored/guard, /obj/item/clothing/shirt/undershirt/colored/guardsecond)
