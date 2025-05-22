/datum/job/guardsman
	title = "City Watchmen"
	tutorial = "You are a member of the City Watch. \
	You've proven yourself worthy to the Captain and now you've got yourself a salary... \
	as long as you keep the peace that is."
	flag = GUARDSMAN
	department_flag = GARRISON
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_CITYWATCHMEN
	faction = FACTION_STATION
	total_positions = 8
	spawn_positions = 8
	min_pq = 4
	bypass_lastclass = TRUE

	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_IMMORTAL)
	allowed_races = RACES_PLAYER_GUARD

	outfit = /datum/outfit/job/guardsman	//Default outfit.
	advclass_cat_rolls = list(CTAG_GARRISON = 20)	//Handles class selection.
	give_bank_account = 30
	cmode_music = 'sound/music/cmode/garrison/CombatGarrison.ogg'

/datum/job/guardsman/after_spawn(mob/living/spawned, client/player_client)
	..()
	var/mob/living/carbon/human/H = spawned
	if(istype(H.cloak, /obj/item/clothing/cloak/half/guard))
		var/obj/item/clothing/S = H.cloak
		var/index = findtext(H.real_name, " ")
		if(index)
			index = copytext(H.real_name, 1, index)
		if(!index)
			index = H.real_name
		S.name = "guard's half cloak ([index])"

//................. City Watchmen Base .............. //
/datum/outfit/job/guardsman/pre_equip(mob/living/carbon/human/H)
	. = ..()
	cloak = pick(/obj/item/clothing/cloak/half/guard, /obj/item/clothing/cloak/half/guardsecond)
	head = /obj/item/clothing/head/helmet/townwatch
	pants = /obj/item/clothing/pants/trou/leather/guard
	wrists = /obj/item/clothing/wrists/bracers/leather
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather
	gloves = /obj/item/clothing/gloves/leather

// EVERY TOWN GUARD SHOULD HAVE AT LEAST THREE CLUB SKILL

//................. Axes, Maces, Swords, Shields .............. //
/datum/advclass/garrison/footman
	name = "City Watch Footman"
	tutorial = "You are a member of the City Watch. \
	You are well versed in holding the line with a shield while wielding a trusty sword, axe, or mace in the other hand."
	outfit = /datum/outfit/job/guardsman/footman
	category_tags = list(CTAG_GARRISON)

/datum/outfit/job/guardsman/footman/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/gorget
	armor = /obj/item/clothing/armor/chainmail/iron
	shirt = /obj/item/clothing/armor/gambeson
	backr = /obj/item/weapon/shield/heater
	backl = /obj/item/storage/backpack/satchel
	beltr = /obj/item/weapon/sword/iron
	beltl = /obj/item/weapon/mace/cudgel
	backpack_contents = list(/obj/item/storage/keyring/guard, /obj/item/weapon/knife/dagger/steel/special)


	H.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE) // Main weapon
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE) // Main off-hand weapon
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE) // Backup
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE) // Guards should be going for less than lethal in reality. Unarmed would be a primary thing.
	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_END, 2)
	H.change_stat(STATKEY_CON, 1)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE) // Wrestling is cardio intensive, and guards wrestle with the populace a lot.
	H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	ADD_TRAIT(H, TRAIT_KNOWBANDITS, TRAIT_GENERIC)
	H.verbs |= /mob/proc/haltyell

//................. Archer .............. //
/datum/advclass/garrison/archer
	name = "City Watch Archer"
	tutorial = "You are a member of the City Watch. Your training with bows makes you a formidable threat when perched atop the walls or rooftops, raining arrows down upon foes with impunity."
	outfit = /datum/outfit/job/guardsman/archer
	category_tags = list(CTAG_GARRISON)

/datum/outfit/job/guardsman/archer/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/gorget
	armor = /obj/item/clothing/armor/gambeson/heavy
	shirt = pick(/obj/item/clothing/shirt/undershirt/guard, /obj/item/clothing/shirt/undershirt/guardsecond)
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	backl = /obj/item/storage/backpack/satchel
	beltr = /obj/item/ammo_holder/quiver/arrows
	beltl = /obj/item/weapon/mace/cudgel
	backpack_contents = list(/obj/item/storage/keyring/guard, /obj/item/weapon/knife/dagger/steel/special)
	if(H.mind)
		H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE) // Main Weapon
		H.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE) // You don't even have access to crossbows
		H.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE) // Backup
		H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.change_stat(STATKEY_PER, 2)
		H.change_stat(STATKEY_END, 1)
		H.change_stat(STATKEY_SPD, 2)
		ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
		H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE) // Getting up onto vantage points is common for archers.
		H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		ADD_TRAIT(H, TRAIT_KNOWBANDITS, TRAIT_GENERIC)
		H.verbs |= /mob/proc/haltyell

/mob/proc/haltyell()
	set name = "HALT!"
	set category = "Noises"
	emote("haltyell")

/datum/advclass/garrison/pikeman
	name = "City Watch Pikeman"
	tutorial = "You are a pikeman in the City Watch. You are less fleet of foot compared to the rest, but you are burly and well practiced with spears, pikes, billhooks - all the various polearms for striking enemies from a distance."
	outfit = /datum/outfit/job/guardsman/pikeman

	category_tags = list(CTAG_GARRISON)

/datum/outfit/job/guardsman/pikeman/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/armor/chainmail/iron
	shirt = /obj/item/clothing/armor/gambeson
	neck = /obj/item/clothing/neck/gorget
	backl = /obj/item/storage/backpack/satchel
	backr = /obj/item/weapon/polearm/spear
	beltr = /obj/item/weapon/mace/cudgel
	backpack_contents = list(/obj/item/storage/keyring/guard, /obj/item/weapon/knife/dagger/steel/special)

	//Stats for class
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE) // Polearms use a lot of stamina. They'd be enduring.
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_END, 1)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_SPD, -1) // Stronk and gets training in hard hitting polearms, but slower
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KNOWBANDITS, TRAIT_GENERIC)
	H.verbs |= /mob/proc/haltyell
