/datum/job/advclass/wretch/disgraced
	title = "Disgraced Knight"
	tutorial = "You were once a venerated and revered knight - now, a traitor who abandoned your liege. You live the life of an outlaw, shunned and looked down upon by society."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	outfit = /datum/outfit/wretch/disgraced
	total_positions = 1

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 2,
		STATKEY_END = 2,
		STATKEY_CON = 2,
		STATKEY_INT = 1,
		STATKEY_SPD = -1
	)

	skills = list(
		/datum/skill/combat/polearms = 3,
		/datum/skill/combat/axesmaces = 3,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/knives = 3,
		/datum/skill/combat/shields = 4,
		/datum/skill/combat/whipsflails = 3,
		/datum/skill/combat/wrestling = 4,
		/datum/skill/misc/swimming = 4,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/misc/athletics = 4,
		/datum/skill/misc/climbing = 4,
		/datum/skill/misc/riding = 4,
		/datum/skill/misc/reading = 3
	)

	traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_NOBLE,
		TRAIT_HEAVYARMOR,
		TRAIT_RECOGNIZED,
		TRAIT_INHUMENCAMP,
	)

	spells = list(
		/datum/action/cooldown/spell/undirected/list_target/convert_role/brotherhood
	)

/datum/job/advclass/wretch/disgraced/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/prev_real_name = spawned.real_name
	var/prev_name = spawned.name
	var/honorary = "Sir"
	if(spawned.pronouns == SHE_HER)
		honorary = "Dame"
	spawned.real_name = "[honorary] [prev_real_name]"
	spawned.name = "[honorary] [prev_name]"

	if(alert("Do you wish to be recognized as a non-foreigner?", "", "Yes", "No") == "Yes")
		REMOVE_TRAIT(spawned, TRAIT_FOREIGNER, TRAIT_GENERIC)

	if(spawned.dna?.species?.id == SPEC_ID_HUMEN && spawned.gender == MALE)
		spawned.dna.species.soundpack_m = new /datum/voicepack/male/knight()

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

	var/weaponchoice = spawned.select_equippable(spawned, selectableweapon, message = "Choose Your Specialisation", title = "DISGRACED KNIGHT")
	if(!weaponchoice)
		return

	var/grant_shield = TRUE

	switch(weaponchoice)
		if("Halberd")
			grant_shield = FALSE
			spawned.adjust_skillrank(/datum/skill/combat/polearms, 1)
		if("Longsword")
			grant_shield = FALSE
			spawned.adjust_skillrank(/datum/skill/combat/swords, 1)
		if("Unarmed")
			grant_shield = FALSE
			spawned.adjust_skillrank(/datum/skill/combat/unarmed, 1)
		if("Great Axe")
			grant_shield = FALSE
			spawned.adjust_skillrank(/datum/skill/combat/axesmaces, 1)
		if("Mace")
			grant_shield = FALSE
			spawned.adjust_skillrank(/datum/skill/combat/axesmaces, 1)
		if("Sabre")
			spawned.adjust_skillrank(/datum/skill/combat/swords, 1)
		if("Flail")
			spawned.adjust_skillrank(/datum/skill/combat/whipsflails, 1)

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

	var/helmetchoice = spawned.select_equippable(spawned, selectablehelmets, message = "Choose Your Helmet", title = "DISGRACED KNIGHT")
	if(!helmetchoice)
		return

	switch(helmetchoice)
		if("None")
			ADD_TRAIT(spawned, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
			spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_CON, 1)

	wretch_select_bounty(spawned)

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