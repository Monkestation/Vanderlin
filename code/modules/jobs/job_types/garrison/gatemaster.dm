/datum/job/gatemaster
	title = "Gatemaster"
	tutorial = "Tales speak of the Gatemaster's legendary ability to stand still at a gate and ask people questions. \
	Some may mock you as lazy sitting on your comfy chair all day, \
	but the lord themself entrusted you with who is and isn't allowed behind those gates. \
	You could almost say you're the lord's most trusted person. At least you yourself like to say that."
	flag = GATEMASTER
	department_flag = GARRISON
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_GATEMASTER
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	min_pq = 10
	bypass_lastclass = TRUE

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		"Humen",
		"Elf",
		"Half-Elf",
		"Dwarf",
		"Aasimar"
	)

	outfit = /datum/outfit/job/gatemaster	//Default outfit.
	advclass_cat_rolls = list(CTAG_GATEMASTER = 20)	//Handles class selection.
	give_bank_account = 30
	cmode_music = 'sound/music/cmode/garrison/CombatGatekeeper.ogg'
	give_bank_account = 15

/datum/outfit/job/gatemaster
	job_bitflag = BITFLAG_GARRISON

/datum/outfit/job/gatemaster/pre_equip(mob/living/carbon/human/H)
	. = ..()
	head = /obj/item/clothing/head/helmet/townwatch/alt
	cloak = /obj/item/clothing/cloak/stabard/surcoat/guard
	wrists = /obj/item/clothing/wrists/bracers/leather/advanced
	belt = /obj/item/storage/belt/leather/black
	pants = /obj/item/clothing/pants/trou/leather/guard

/datum/job/gatemaster/after_spawn(mob/living/spawned, client/player_client)
	..()
	var/mob/living/carbon/human/H = spawned
	H.advsetup = TRUE
	H.invisibility = INVISIBILITY_MAXIMUM
	H.become_blind("advsetup")

	if(istype(H.cloak, /obj/item/clothing/cloak/stabard/surcoat/guard))
		var/obj/item/clothing/S = H.cloak
		var/index = findtext(H.real_name, " ")
		if(index)
			index = copytext(H.real_name, 1,index)
		if(!index)
			index = H.real_name
		S.name = "gatemaster jupon ([index])"

/datum/advclass/gatemaster/gatemaster_whip
	name = "Chainguard Gatemaster"
	tutorial = "Metal chimes in your hands, their skin rough from those heavy chains you pull. \
	Day by day, chains pass through your palms. \
	Day by day, the chains' coldness feels more familar. \
	Day by day, trespassers hear your chain whip rattling."
	outfit = /datum/outfit/job/gatemaster/whip

	category_tags = list(CTAG_GATEMASTER)

/datum/outfit/job/gatemaster/whip/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/chaincoif/iron
	armor = /obj/item/clothing/armor/leather/advanced
	shirt = /obj/item/clothing/armor/chainmail/iron
	gloves = /obj/item/clothing/gloves/chain
	shoes = /obj/item/clothing/shoes/boots
	beltr = /obj/item/weapon/mace/cudgel
	beltl = /obj/item/weapon/whip/chain
	backl = /obj/item/storage/backpack/satchel/black
	backpack_contents = list(/obj/item/storage/keyring/manorguard = 1, /obj/item/weapon/knife/dagger/steel/special = 1, /obj/item/rope/chain = 1)

	H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 1, TRUE)
	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_END, 2)
	H.change_stat(STATKEY_PER, -1)
	H.verbs |= /mob/proc/haltyell
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KNOWBANDITS, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)

/datum/advclass/gatemaster/gatemaster_mace
	name = "Bruiser Gatemaster"
	tutorial = "Years of work let your body grow acustome to the job. Growing large, fitting to your chair. \
	Even if you may be slower, but you dont need to be fast. \
	They are the ones that need to get past you after all. \
	Let them try to break through your armor, and let them learn how easy skulls break under cold hard steel."
	outfit = /datum/outfit/job/gatemaster/mace
	category_tags = list(CTAG_GATEMASTER)

/datum/outfit/job/gatemaster/mace/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/chaincoif/iron
	armor = /obj/item/clothing/armor/cuirass
	shirt = /obj/item/clothing/armor/chainmail
	gloves = /obj/item/clothing/gloves/chain
	wrists = /obj/item/clothing/wrists/bracers
	shoes = /obj/item/clothing/shoes/boots/armor/light
	beltr = /obj/item/weapon/mace/steel
	backr = /obj/item/weapon/shield/heater
	backl = /obj/item/storage/backpack/satchel/black
	backpack_contents = list(/obj/item/storage/keyring/manorguard = 1, /obj/item/weapon/knife/dagger/steel/special = 1, /obj/item/rope/chain = 1)
	if(H.mind)
		H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/axesmaces, 4, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.change_stat(STATKEY_STR, 1)
		H.change_stat(STATKEY_CON, 2)
		H.change_stat(STATKEY_SPD, -1)
		ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_KNOWBANDITS, TRAIT_GENERIC)
		H.verbs |= /mob/proc/haltyell

/datum/advclass/gatemaster/gatemaster_bow
	name = "Archer Gatemaster"
	tutorial = "Many may try to sneak past your post, thinking you wont see them. \
	But the years made your senses grow sharp, and your arrows sharper. \
	There is yet to be an arrow fired from you, that did not put the fear of the ten into their eyes."
	outfit = /datum/outfit/job/gatemaster/bow

	category_tags = list(CTAG_GATEMASTER)

/datum/outfit/job/gatemaster/bow/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/chaincoif/iron
	armor = /obj/item/clothing/armor/leather/hide
	shirt = /obj/item/clothing/armor/gambeson/heavy
	shoes = /obj/item/clothing/shoes/boots
	gloves = /obj/item/clothing/gloves/leather
	beltr = /obj/item/weapon/mace/cudgel
	backl = /obj/item/storage/backpack/satchel/black
	backpack_contents = list(/obj/item/storage/keyring/manorguard = 1, /obj/item/weapon/knife/dagger/steel/special = 1, /obj/item/rope/chain = 1)
	if(H.mind)
		H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/bows, 4, TRUE)
		H.adjust_skillrank(/datum/skill/combat/crossbows, 4, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.change_stat(STATKEY_STR, 1)
		H.change_stat(STATKEY_PER, 2)
		H.change_stat(STATKEY_END, -1)
		H.verbs |= /mob/proc/haltyell
		ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_KNOWBANDITS, TRAIT_GENERIC)
		var/weapontypec = pickweight(list("Bow" = 4, "Crossbow" = 6)) // Rolls for either a bow or a Crossbow
		switch(weapontypec)
			if("Bow")
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/long
				beltl = /obj/item/ammo_holder/quiver/arrows
			if("Crossbow")
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltl = /obj/item/ammo_holder/quiver/bolts
