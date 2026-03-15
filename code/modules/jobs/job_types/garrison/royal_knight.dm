/datum/attribute_holder/sheet/job/royalknight
	raw_attribute_list = list(
		STAT_STRENGTH = 3,
		STAT_PERCEPTION = 2,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 2,
		STAT_INTELLIGENCE = 1,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/wrestling = 40,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/whipsflails = 30,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/combat/crossbows = 40,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/misc/riding = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/labor/mathematics = 30
	)

/datum/job/royalknight
	title = "Royal Knight"
	tutorial = "You are a knight of the royal family, elevated by your skill and steadfast devotion. \
	Sworn to protect the royal family, you stand as their shield, upholding their rule with steel and sacrifice. \
	Yet service is not without its trials, and your loyalty will be tested in ways both seen and unseen. \
	In the end, duty is a path you must walk carefully."
	department_flag = GARRISON
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_ROYALKNIGHT
	faction = FACTION_TOWN
	total_positions = 2
	spawn_positions = 2
	bypass_lastclass = TRUE
	selection_color = "#920909"

	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_IMMORTAL)
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)

	advclass_cat_rolls = list(CTAG_ROYALKNIGHT = 20)
	give_bank_account = 60
	cmode_music = 'sound/music/cmode/nobility/CombatKnight.ogg'
	job_bitflag = BITFLAG_GARRISON

	exp_type = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)
	exp_types_granted = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)
	exp_requirements = list(
		EXP_TYPE_GARRISON = 900,
		EXP_TYPE_COMBAT = 1200
	)

	attribute_sheet = /datum/attribute_holder/sheet/job/royalknight
	honorary = "Sir"
	honorary_f = "Dame"

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_NOBLE_POWER
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

/datum/job/royalknight/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	add_verb(spawned, /mob/proc/haltyell)

	if(spawned.dna?.species?.id == SPEC_ID_HUMEN && spawned.gender == MALE)
		spawned.dna.species.soundpack_m = new /datum/voicepack/male/knight()

/datum/attribute_holder/sheet/job/royalknight/flail
	raw_attribute_list = list(
		/datum/attribute/skill/combat/shields = 10
	)
	clamped_adjustment = list(
		/datum/attribute/skill/combat/whipsflails = list(20, 40)
	)

/datum/attribute_holder/sheet/job/royalknight/sabre
	raw_attribute_list = list(
		/datum/attribute/skill/combat/shields = 10
	)
	clamped_adjustment = list(
		/datum/attribute/skill/combat/swords = list(20, 40)
	)

/datum/attribute_holder/sheet/job/royalknight/polearms
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/polearms = list(20, 40)
	)

/datum/attribute_holder/sheet/job/royalknight/longsword
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/swords = list(20, 40)
	)

/datum/job/advclass/royalknight
	inherit_parent_title = TRUE
	should_reset_stats = FALSE
	exp_types_granted = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)

/datum/job/advclass/royalknight/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/static/list/selectable = list(
		"Flail" = /obj/item/weapon/flail/sflail,
		"Halberd" = /obj/item/weapon/polearm/halberd,
		"Longsword" = /obj/item/weapon/sword/long,
		"Sabre" = /obj/item/weapon/sword/sabre/dec,
	)

	var/choice = spawned.select_equippable(player_client, selectable, message = "Choose Your Specialisation", title = "KNIGHT")
	if(!choice)
		return

	var/grant_shield = TRUE

	switch(choice)
		if("Flail")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/royalknight/flail)
		if("Halberd")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/royalknight/polearms)
			grant_shield = FALSE
		if("Longsword")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/royalknight/longsword)
			grant_shield = FALSE
		if("Sabre")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/royalknight/sabre)

	if(grant_shield)
		var/obj/item/weapon/shield/tower/metal/shield = new /obj/item/weapon/shield/tower/metal()
		if(!spawned.equip_to_appropriate_slot(shield))
			qdel(shield)

/datum/outfit/royalknight
	name = "Royal Knight Base"
	neck = /obj/item/clothing/neck/chaincoif
	pants = /obj/item/clothing/pants/platelegs
	cloak = /obj/item/clothing/cloak/tabard/knight/guard
	shirt = /obj/item/clothing/armor/gambeson/arming
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/weapon/sword/arming
	backl = /obj/item/storage/backpack/satchel
	scabbards = list(/obj/item/weapon/scabbard/sword/noble)
	backpack_contents = list(/obj/item/storage/keyring/manorguard = 1)

/datum/outfit/royalknight/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	. = ..()
	if(H.cloak && !findtext(H.cloak.name, "([H.real_name])"))
		H.cloak.name = "[H.cloak.name] ([H.real_name])"

/datum/job/advclass/royalknight/knight
	title = "Royal Knight"
	tutorial = "The classic Knight in shining armor. Slightly more skilled then their Steam counterpart but has worse armor."
	outfit = /datum/outfit/royalknight/knight
	category_tags = list(CTAG_ROYALKNIGHT)

/datum/outfit/royalknight/knight
	name = "Royal Knight"
	armor = /obj/item/clothing/armor/plate/full
	gloves = /obj/item/clothing/gloves/plate
	shoes = /obj/item/clothing/shoes/boots/armor

// Helmet Selection (Royal Knight Exclusive)
/datum/job/advclass/royalknight/knight/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/static/list/selectablehelmets = list(
		"Hounskull" = /obj/item/clothing/head/helmet/visored/hounskull,
		"Royal Knight Helmet" = /obj/item/clothing/head/helmet/visored/royalknight,
		"Knight Helmet" = /obj/item/clothing/head/helmet/visored/knight,
		"Decorated Knight Helmet" = /obj/item/clothing/head/helmet/heavy/decorated/knight,
		"Visored Sallet" = /obj/item/clothing/head/helmet/visored/sallet,
		"Decorated Golden Helmet" = /obj/item/clothing/head/helmet/heavy/decorated/golden,
	)

	var/helmetchoice = spawned.select_equippable(player_client, selectablehelmets, message = "Choose Your Helmet", title = "ROYAL KNIGHT")
	if(!helmetchoice)
		return

/datum/attribute_holder/sheet/job/royalknight/steam
	raw_attribute_list = list(
		/datum/attribute/skill/combat/swords = -10,
		/datum/attribute/skill/combat/unarmed = -10,
		/datum/attribute/skill/combat/shields = -10,
		/datum/attribute/skill/combat/wrestling = -10,
		/datum/attribute/skill/combat/polearms = -10,
		/datum/attribute/skill/combat/whipsflails = -10,
		/datum/attribute/skill/combat/axesmaces = -10,
		/datum/attribute/skill/combat/bows = -10,
		/datum/attribute/skill/combat/crossbows = -10,
		/datum/attribute/skill/craft/engineering = 30
	)

/datum/job/advclass/royalknight/steam
	title = "Steam Knight"
	tutorial = "The pinnacle of Vanderlin's steam technology. \
	Start with a set of Steam Armor that requires steam to function. \
	The suit is powerful when powered but will slow you down when not \
	learning how to use it has cost you precious time \
	you could have spent learning to use other weapons."
	outfit = /datum/outfit/royalknight/steam
	attribute_sheet = /datum/attribute_holder/sheet/job/royalknight/steam
	category_tags = list(CTAG_ROYALKNIGHT)

/datum/outfit/royalknight/steam
	name = "Steam Knight"
	armor = /obj/item/clothing/armor/steam
	head = /obj/item/clothing/head/helmet/heavy/steam
	gloves = /obj/item/clothing/gloves/plate/steam
	shoes = /obj/item/clothing/shoes/boots/armor/steam
	backr = /obj/item/clothing/cloak/boiler

/datum/outfit/royalknight/steam/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	. = ..()
	if(H.backr && istype(H.backr, /obj/item/clothing/cloak/boiler))
		var/obj/item/clothing/cloak/boiler/B = H.backr
		SEND_SIGNAL(B, COMSIG_ATOM_STEAM_INCREASE, 1000)

