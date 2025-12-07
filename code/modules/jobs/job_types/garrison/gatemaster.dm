/datum/job/gatemaster
	title = "Gatemaster"
	tutorial = "Tales speak of the Gatemaster's legendary ability to stand still at a gate and ask people questions. \
	Some may mock you as lazy sitting on your comfy chair all day, \
	but the lord themself entrusted you with who is and isn't allowed behind those gates. \
	You could almost say you're the lord's most trusted person. At least you yourself like to say that."
	department_flag = GARRISON
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_GATEMASTER
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_NONDISCRIMINATED

	outfit = /datum/outfit/gatemaster	//Default outfit.
	advclass_cat_rolls = list(CTAG_GATEMASTER = 20)	//Handles class selection.
	give_bank_account = 30
	cmode_music = 'sound/music/cmode/garrison/CombatGatekeeper.ogg'
	give_bank_account = 15

	job_bitflag = BITFLAG_GARRISON

	exp_type = list(EXP_TYPE_GARRISON, EXP_TYPE_LIVING)
	exp_types_granted  = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)
	exp_requirements = list(
		EXP_TYPE_LIVING = 300,
		EXP_TYPE_GARRISON = 300
	)

/datum/outfit/gatemaster/pre_equip(mob/living/carbon/human/H)
	. = ..()
	head = /obj/item/clothing/head/helmet/townwatch/gatemaster
	shirt = /obj/item/clothing/armor/chainmail
	belt = /obj/item/storage/belt/leather/black
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots

/datum/outfit/gatemaster/post_equip(mob/living/carbon/human/H)
	. = ..()
	if(H.wear_armor)
		if(!findtext(H.wear_armor.name,"([H.real_name])"))
			H.wear_armor.name = "[H.wear_armor.name]"+" "+"([H.real_name])"

/datum/job/advclass/gatemaster
	inherit_parent_title = TRUE
	exp_type = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)
	exp_types_granted  = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)

/datum/job/advclass/gatemaster/gatemaster_whip
	title = "Chainguard Gatemaster"
	tutorial = "Metal chimes in your hands, their skin rough from those heavy chains you pull. \
	Day by day, chains pass through your palms. \
	Day by day, the chains' coldness feels more familar. \
	Day by day, trespassers hear your chain whip rattling."
	outfit = /datum/outfit/gatemaster/whip

	category_tags = list(CTAG_GATEMASTER)

/datum/outfit/gatemaster/whip/pre_equip(mob/living/carbon/human/H)
	..()
	gloves = /obj/item/clothing/gloves/chain
	neck = /obj/item/clothing/neck/gorget
	armor = /obj/item/clothing/armor/leather/jacket/gatemaster_jacket/armored
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

/datum/job/advclass/gatemaster/gatemaster_mace
	title = "Bruiser Gatemaster"
	tutorial = "Years of work let your body grow acustome to the job. Growing large, fitting to your chair. \
	Even if you may be slower, but you dont need to be fast. \
	They are the ones that need to get past you after all. \
	Let them try to break through your armor, and let them learn how easy skulls break under cold hard steel."
	outfit = /datum/outfit/gatemaster/mace
	category_tags = list(CTAG_GATEMASTER)

/datum/outfit/gatemaster/mace/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/gorget
	gloves = /obj/item/clothing/gloves/chain
	armor = /obj/item/clothing/armor/leather/jacket/gatemaster_jacket/armored
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

/datum/job/advclass/gatemaster/gatemaster_bow
	title = "Archer Gatemaster"
	tutorial = "Many may try to sneak past your post, thinking you wont see them. \
	But the years made your senses grow sharp, and your arrows sharper. \
	There is yet to be an arrow fired from you, that did not put the fear of the ten into their eyes."
	outfit = /datum/outfit/gatemaster/bow

	category_tags = list(CTAG_GATEMASTER)

/datum/outfit/gatemaster/bow/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/coif
	armor = /obj/item/clothing/armor/leather/jacket/gatemaster_jacket
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
