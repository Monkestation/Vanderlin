/datum/job/advclass/sacrestant/confessor
	title = "Confessor"
	tutorial = "Psydonite hunters, unmatched in the fields of subterfuge and investigation. There is no suspect too powerful to investigate, no room too guarded to infiltrate, and no weakness too hidden to exploit. The Ordo Venatari trained you, and this, your final hunt as a student, will prove the wisdom of their teachings."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/confessor
	category_tags = list(CTAG_INQUISITION)

	jobstats = list(
		STATKEY_SPD = 3,
		STATKEY_END = 1,
		STATKEY_PER = 2,
		STATKEY_STR = -2
	) //4 Statline
	skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN, //Should rely on the seizing garrote to properly subdue foes.
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN, //Ensures that captured individuals are less likely to die, if subdued with harsher force.
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
	)

	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_STEELHEARTED,
		TRAIT_INQUISITION,
		TRAIT_BLACKBAGGER,
		TRAIT_SILVER_BLESSED,
		TRAIT_PSYDONIAN_GRIT,
		TRAIT_PSYDONITE,
		TRAIT_FOREIGNER,
	)
/datum/job/advclass/sacrestant/confessor/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	GLOB.inquisition.add_member_to_school(spawned, "Order of the Venatari", 0, "Confessor")

/datum/outfit/confessor/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/weapons = list("Blessed Psydonic Dagger", "Psydonic Handmace", "Psydonic Shortsword")
		var/weapon_choice = input(H,"Choose your WEAPON.", "TAKE UP PSYDON'S ARMS.") as anything in weapons
		switch(weapon_choice)
			if("Blessed Psydonic Dagger")
				l_hand = /obj/item/weapon/knife/dagger/silver/psydon
				r_hand = /obj/item/weapon/scabbard/knife
				H.clamped_adjust_skillrank(/datum/skill/combat/knives, 4, 4, TRUE)
			if("Psydonic Handmace")
				l_hand = /obj/item/weapon/mace/cudgel/psy
				H.clamped_adjust_skillrank(/datum/skill/combat/axesmaces, 4, 4, TRUE)
			if("Psydonic Shortsword")
				l_hand = /obj/item/weapon/sword/short/psy
				r_hand = /obj/item/weapon/scabbard/sword
				H.clamped_adjust_skillrank(/datum/skill/combat/swords, 4, 4, TRUE)
		var/armors = list("Confessor - Slurbow, Leather Maillecoat", "Arbalist - Crossbow, Lightweight Brigandine")
		var/armor_choice = input(H, "Choose your ARCHETYPE.", "TAKE UP PSYDON'S DUTY.") as anything in armors
		switch(armor_choice)
			if("Confessor - Slurbow, Leather Maillecoat")
				head = /obj/item/clothing/head/roguehood/psydon/confessor
				armor = /obj/item/clothing/armor/leather/jacket/leathercoat/confessor
				shirt = /obj/item/clothing/armor/gambeson/heavy/inq
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
			if("Arbalist - Crossbow, Lightweight Brigandine")
				head = /obj/item/clothing/head/headband
				armor = /obj/item/clothing/armor/brigandine/light
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				REMOVE_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				H.change_stat(STATKEY_CON, 1)
				H.change_stat(STATKEY_STR, 2)
				H.change_stat(STATKEY_PER, 1) //Applies a base statblock of 11/11/11/13 to CON, STR, SPD and PER - compared to the standard 10/9/13/12 + DODGE EXPERT. Physically adept and capable of higher ranged damage..
				H.change_stat(STATKEY_SPD, -2) //..but with a massive loss to mobility and damage evasion, alongside the naturally low defense of their sidearms.
		var/quivers = list("Bolts - Steel-Tipped", "Sunderbolts - Silver-Tipped, Halved Damage")
		var/boltchoice = input(H,"Choose your MUNITIONS.", "TAKE UP PSYDON'S MISSILES.") as anything in quivers
		switch(boltchoice)
			if("Bolts - Steel-Tipped")
				beltl = /obj/item/ammo_holder/quiver/bolts
			if("Sunderbolts - Silver-Tipped, Halved Damage")
				beltl = /obj/item/ammo_holder/quiver/bolt/holy


	H.grant_language(/datum/language/otavan)
	cloak = /obj/item/storage/backpack/satchel
	wrists = /obj/item/clothing/neck/psycross/silver
	gloves = /obj/item/clothing/gloves/leather/otavan
	neck = /obj/item/clothing/neck/gorget
	backr = /obj/item/storage/backpack/satchel/otavan
	belt = /obj/item/storage/belt/leather/knifebelt/black/psydon
	beltr = /obj/item/storage/belt/pouch/coins/mid
	pants = /obj/item/clothing/pants/tights/colored/black
	shoes = /obj/item/clothing/shoes/psydonboots
	mask = /obj/item/clothing/face/facemask/steel/confessor
	ring = /obj/item/clothing/ring/signet/silver
	backpack_contents = list(
		/obj/item/key/inquisition = 1,
		/obj/item/rope/inqarticles/inquirycord = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/clothing/head/inqarticles/blackbag = 1,
		/obj/item/inqarticles/garrote = 1,
		/obj/item/grapplinghook = 1,
		/obj/item/paper/inqslip/arrival/ortho = 1,
		/obj/item/collar_detonator = 1,
		)
