/datum/attribute_holder/sheet/job/disgraced
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_PERCEPTION = 2,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 2,
		STAT_INTELLIGENCE = 1,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/shields = 40,
		/datum/attribute/skill/combat/whipsflails = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/misc/swimming = 40,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/riding = 40,
		/datum/attribute/skill/misc/reading = 30,
	)

/datum/job/advclass/wretch/disgraced
	title = "Disgraced Knight"
	tutorial = "You were once a venerated and revered knight - now, a traitor who abandoned your liege. You live the life of an outlaw, shunned and looked down upon by society."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	outfit = /datum/outfit/wretch/disgraced
	total_positions = 1

	attribute_sheet = /datum/attribute_holder/sheet/job/disgraced

	traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_NOBLE_BLOOD,
		TRAIT_HEAVYARMOR,
		TRAIT_RECOGNIZED,
	)

	spells = list(
		/datum/action/cooldown/spell/undirected/list_target/convert_role/brotherhood
	)

/datum/job/advclass/wretch/disgraced/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	if(spawned.dna?.species?.id == SPEC_ID_HUMEN && spawned.gender == MALE)
		spawned.dna.species.soundpack_m = new /datum/voicepack/male/knight()

/datum/job/advclass/wretch/disgraced/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	if(tgui_alert(spawned, "Do you wish to be recognized as a non-foreigner?", "Foreigner", list("Yes", "No")) == "Yes")
		REMOVE_TRAIT(spawned, TRAIT_FOREIGNER, TRAIT_GENERIC)

	// Weapon selection
	var/static/list/selectableweapon = list(
		"Flail" = /obj/item/weapon/flail/sflail,
		"Halberd" = /obj/item/weapon/polearm/halberd,
		"Longsword" = /obj/item/weapon/sword/long,
		"Sabre" = /obj/item/weapon/sword/sabre/dec,
		"Unarmed" = /obj/item/weapon/knife/dagger/steel,
		"Great Axe" = /obj/item/weapon/greataxe/steel,
		"Mace" = /obj/item/weapon/mace/goden/steel,
	)

	var/weaponchoice = spawned.select_equippable(player_client, selectableweapon, message = "Choose Your Specialisation", title = "DISGRACED KNIGHT")
	if(!weaponchoice)
		return

	var/grant_shield = TRUE

	switch(weaponchoice)
		if("Halberd")
			grant_shield = FALSE
			spawned.adjust_skill_level(/datum/attribute/skill/combat/polearms, 10)
		if("Longsword")
			grant_shield = FALSE
			spawned.adjust_skill_level(/datum/attribute/skill/combat/swords, 10)
		if("Unarmed")
			grant_shield = FALSE
			spawned.adjust_skill_level(/datum/attribute/skill/combat/unarmed, 10)
		if("Great Axe")
			grant_shield = FALSE
			spawned.adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 10)
		if("Mace")
			grant_shield = FALSE
			spawned.adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 10)
		if("Sabre")
			spawned.adjust_skill_level(/datum/attribute/skill/combat/swords, 10)
		if("Flail")
			spawned.adjust_skill_level(/datum/attribute/skill/combat/whipsflails, 10)

	if(grant_shield)
		var/obj/item/weapon/shield/tower/metal/shield = new /obj/item/weapon/shield/tower/metal()
		if(!spawned.equip_to_appropriate_slot(shield))
			qdel(shield)

	var/static/list/selectablehelmets = list(
		"hounskull" = /obj/item/clothing/head/helmet/visored/hounskull,
		"Bastion Helmet" = /obj/item/clothing/head/helmet/heavy/necked,
		"Royal Knight Helmet" = /obj/item/clothing/head/helmet/visored/royalknight,
		"Knight Helmet" = /obj/item/clothing/head/helmet/visored/knight,
		"Decorated Knight Helmet" = /obj/item/clothing/head/helmet/heavy/decorated/knight,
		"Visored Sallet" = /obj/item/clothing/head/helmet/visored/sallet,
		"Decored Golden Helmet" = /obj/item/clothing/head/helmet/heavy/decorated/golden,
		"None" = /obj/item/clothing/head/roguehood/colored/uncolored,
	)

	var/helmetchoice = spawned.select_equippable(player_client, selectablehelmets, message = "Choose Your Helmet", title = "DISGRACED KNIGHT")
	if(!helmetchoice)
		return

	switch(helmetchoice)
		if("None")
			ADD_TRAIT(spawned, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)

/datum/outfit/wretch/disgraced
	name = "Disgraced Knight (Wretch)"
	neck = /obj/item/clothing/neck/chaincoif
	pants = /obj/item/clothing/pants/platelegs
	cloak = /obj/item/clothing/cloak/tabard/knight
	shirt = /obj/item/clothing/armor/gambeson/arming
	belt = /obj/item/storage/belt/leather
	armor = /obj/item/clothing/armor/plate
	gloves = /obj/item/clothing/gloves/plate
	shoes = /obj/item/clothing/shoes/boots/armor
	backl = /obj/item/storage/backpack/satchel
	beltr = /obj/item/weapon/sword/arming
	scabbards = list(/obj/item/weapon/scabbard/sword/noble)
	backpack_contents = list(
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/rope/chain = 1,
		/obj/item/reagent_containers/glass/bottle/stronghealthpot = 1
	)
