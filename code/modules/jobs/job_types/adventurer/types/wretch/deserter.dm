/datum/job/advclass/wretch/disgraced //Deserted, just without the MAA and the orders.
	title = "Disgraced Knight"
	tutorial = "You were once a venerated and revered knight - now, a traitor who abandoned your liege. You live the life of an outlaw, shunned and looked down upon by society."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_NONDISCRIMINATED //Royal Knight
	outfit = /datum/outfit/wretch/disgraced
	total_positions = 1

/datum/outfit/wretch/disgraced/pre_equip(mob/living/carbon/human/H)
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
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
	H.add_spell(/datum/action/cooldown/spell/undirected/list_target/convert_role/brotherhood)
	if(H.dna?.species?.id == SPEC_ID_HUMEN)
		H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_END, 2)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_INT, 1)
	H.change_stat(STATKEY_SPD, -1)
	backpack_contents = list(
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/rope/chain = 1,
		/obj/item/reagent_containers/glass/bottle/stronghealthpot = 1,	//Small health vial
	)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_RECOGNIZED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_INHUMENCAMP, TRAIT_GENERIC)

/datum/outfit/wretch/disgraced/post_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	var/prev_real_name = H.real_name
	var/prev_name = H.name
	var/honorary = "Sir"
	if(H.pronouns == SHE_HER)
		honorary = "Dame"
	H.real_name = "[honorary] [prev_real_name]"
	H.name = "[honorary] [prev_name]"
	if(alert("Do you wish to be recognized as a non-foreigner?", "", "Yes", "No") == "Yes")
		REMOVE_TRAIT(H, TRAIT_FOREIGNER, TRAIT_GENERIC)
	var/static/list/selectableweapon = list( \
		"Flail" = /obj/item/weapon/flail/sflail, \
		"Halberd" = /obj/item/weapon/polearm/halberd, \
		"Longsword" = /obj/item/weapon/sword/long, \
		"Sabre" = /obj/item/weapon/sword/sabre/dec, \
		"Unarmed" = /obj/item/weapon/knife/dagger/steel, \
		"Great Axe" = /obj/item/weapon/greataxe/steel, \
		"Mace" = /obj/item/weapon/mace/goden/steel, \
		)
	var/weaponchoice = H.select_equippable(H, selectableweapon, message = "Choose Your Specialisation", title = "DISGRACED KNIGHT")
	if(!weaponchoice)
		return
	var/grant_shield = TRUE
	switch(weaponchoice)
		if("Halberd")
			grant_shield = FALSE
			H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
		if("Longsword")
			grant_shield = FALSE
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if("Unarmed")
			grant_shield = FALSE
			H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
		if("Great Axe")
			grant_shield = FALSE
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)
		if("Mace")
			grant_shield = FALSE
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)
		if("Sabre")
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if("Flail")
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
	if(grant_shield)
		var/shield = new /obj/item/weapon/shield/tower/metal()
		if(!H.equip_to_appropriate_slot(shield))
			qdel(shield)
	var/static/list/selectablehelmets = list(
		"hounskull"	= /obj/item/clothing/head/helmet/visored/hounskull,
		"Bastion Helmet" = /obj/item/clothing/head/helmet/heavy/necked,
		"Royal Knight Helmet" = /obj/item/clothing/head/helmet/visored/royalknight,
		"Knight Helmet"	= /obj/item/clothing/head/helmet/visored/knight,
		"Decorated Knight Helmet" = /obj/item/clothing/head/helmet/heavy/decorated/knight,
		"Visored Sallet" = /obj/item/clothing/head/helmet/visored/sallet,
		"Decored Golden Helmet" = /obj/item/clothing/head/helmet/heavy/decorated/golden,
		"None" = /obj/item/clothing/head/roguehood/colored/uncolored,
	)
	var/helmetchoice = H.select_equippable(H, selectablehelmets, message = "Choose Your Helmet", title = "DISGRACED KNIGHT")
	if(!helmetchoice)
		return
	switch(helmetchoice)
		if("None")
			ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
			H.change_stat(STATKEY_CON, 1) //I respect the idea of not wearing one.
	wretch_select_bounty(H)
