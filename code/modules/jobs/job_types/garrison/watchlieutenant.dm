/datum/job/lieutenant
	/*
	From wikipedia:
	The word lieutenant derives from French; the lieu meaning "place" as in a position (cf. in lieu of);
	and tenant meaning "holding" as in "holding a position";
	thus a "lieutenant" is a placeholder for a superior, during their absence.
	*/
	title = "City Watch Lieutenant"
	tutorial = "You are a lieutenant of the City Watch. \
	You have been chosen by the Captain to lead the Watch in his absence; \
	Failure is not an option."
	department_flag = GARRISON
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_CITYWATCHMEN
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE

	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_IMMORTAL)
	allowed_races = RACES_PLAYER_GUARD
	blacklisted_species = list(SPEC_ID_HALFLING)

	outfit = /datum/outfit/lieutenant	//Default outfit.
	give_bank_account = 50
	cmode_music = 'sound/music/cmode/garrison/CombatGarrison.ogg'

	exp_type = list(EXP_TYPE_GARRISON)
	exp_types_granted  = list(EXP_TYPE_COMBAT, EXP_TYPE_GARRISON, EXP_TYPE_LEADERSHIP)
	exp_requirements = list(
		EXP_TYPE_GARRISON = 900
	)


//................. Base Gear .............. //
/datum/outfit/lieutenant/pre_equip(mob/living/carbon/human/H)
	. = ..()
	head = /obj/item/clothing/head/helmet/sargebarbute //veteran who won a nice helmet
	cloak = pick(/obj/item/clothing/cloak/half/guard, /obj/item/clothing/cloak/half/guardsecond)
	wrists = /obj/item/clothing/wrists/bracers/jackchain
	shoes = /obj/item/clothing/shoes/boots/leather
	belt = /obj/item/storage/belt/leather
	shirt = /obj/item/clothing/armor/chainmail/iron
	armor = /obj/item/clothing/armor/cuirass/iron
	pants = /obj/item/clothing/pants/chainlegs/iron
	gloves = /obj/item/clothing/gloves/chain/iron
	neck = /obj/item/clothing/neck/chaincoif/iron
	beltl = /obj/item/weapon/mace/bludgeon
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/storage/keyring/lieutenant, /obj/item/weapon/knife/dagger/steel, /obj/item/rope/chain)
	if(H.dna && !(H.dna.species.id in RACES_PLAYER_NONDISCRIMINATED)) // to prevent examine stress
		mask = /obj/item/clothing/face/shepherd/clothmask

	//combat
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE) // Cudgel
	H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE) //weak in swords, polearms, bows and whipsandflails
	H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE) //basically the gear the watchmen can use
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE) //no bow specialization tho, so they get average instead
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)

	//movement and stamina
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)

	//misc skills
	H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)

	//stats
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_END, 2)
	H.change_stat(STATKEY_CON, 1)
	H.change_stat(STATKEY_SPD, 1)

	//traits
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KNOWBANDITS, TRAIT_GENERIC)

	//verbs
	H.verbs |= /mob/proc/haltyell

/datum/outfit/lieutenant/post_equip(mob/living/carbon/human/H)
	. = ..()
	if(H.cloak)
		if(!findtext(H.cloak.name,"([H.real_name])"))
			H.cloak.name = "[H.cloak.name]"+" "+"([H.real_name])"

	var/static/list/selectable = list( \
		"Flail" = /obj/item/weapon/flail, \
		"Spear" = /obj/item/weapon/polearm/spear, \
		"Sword" = /obj/item/weapon/sword/iron, \
		)
	var/choice = H.select_equippable(H, selectable, time_limit = 1 MINUTES, message = "Choose your secondary weapon", title = "LIEUTENANT")
	if(!choice)
		return
	//yeah this is copied from how royal knights do it
	var/shield_type = null
	switch(choice)
		if("Flail")
			H.clamped_adjust_skillrank(/datum/skill/combat/whipsflails, 2, 3, TRUE)
			shield_type = new /obj/item/weapon/shield/wood()
		if("Spear")
			H.clamped_adjust_skillrank(/datum/skill/combat/polearms, 2, 3, TRUE)
			shield_type = new /obj/item/weapon/shield/tower/buckleriron()
		if("Sword")
			H.clamped_adjust_skillrank(/datum/skill/combat/swords, 2, 3, TRUE)
			shield_type = new /obj/item/weapon/shield/heater()
			var/scabbard = new /obj/item/weapon/scabbard/sword()
			if(!H.equip_to_appropriate_slot(scabbard))
				qdel(scabbard)
	if(shield_type)//just incase
		H.clamped_adjust_skillrank(/datum/skill/combat/shields, 3, 3, TRUE)
		if(!H.equip_to_appropriate_slot(shield_type))
			qdel(shield_type)
