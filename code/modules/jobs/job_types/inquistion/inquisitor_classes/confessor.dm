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
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
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

	languages = list(/datum/language/oldpsydonic)

/datum/job/advclass/sacrestant/confessor/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	GLOB.inquisition.add_member_to_school(spawned, "Order of the Venatari", 0, "Confessor")

	var/weapons = list("Blessed Psydonic Dagger", "Psydonic Handmace", "Psydonic Shortsword")
	var/weapon_choice = browser_input_list(spawned, "CHOOSE YOUR WEAPON.", "TAKE UP PSYDON'S ARMS.", weapons)

	switch(weapon_choice)
		if("Blessed Psydonic Dagger")
			spawned.put_in_hands(new /obj/item/weapon/knife/dagger/silver/psydon(get_turf(spawned)), TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/scabbard/knife, ITEM_SLOT_BACK_R, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/combat/knives, 3, 3, TRUE)
		if("Psydonic Handmace")
			spawned.put_in_hands(new /obj/item/weapon/mace/cudgel/psy(get_turf(spawned)), TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/combat/axesmaces, 3, 3, TRUE)
		if("Psydonic Shortsword")
			spawned.put_in_hands(new /obj/item/weapon/sword/short/psy(get_turf(spawned)), TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/scabbard/sword, ITEM_SLOT_BACK_R, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/combat/swords, 3, 3, TRUE)

	// Armor/archetype selection
	var/armors = list("Confessor - Slurbow, Leather Maillecoat", "Arbalist - Crossbow, Lightweight Brigandine")
	var/armor_choice = browser_input_list(spawned, "CHOOSE YOUR ARCHETYPE.", "TAKE UP PSYDON'S DUTY.", armors)

	switch(armor_choice)
		if("Confessor - Slurbow, Leather Maillecoat")
			spawned.equip_to_slot_or_del(new /obj/item/clothing/head/roguehood/psydon/confessor, ITEM_SLOT_HEAD, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/armor/leather/jacket/leathercoat/confessor, ITEM_SLOT_ARMOR, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/armor/gambeson/heavy/inq, ITEM_SLOT_SHIRT, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow, ITEM_SLOT_BACK_L, TRUE)
		if("Arbalist - Crossbow, Lightweight Brigandine")
			spawned.equip_to_slot_or_del(new /obj/item/clothing/head/headband, ITEM_SLOT_HEAD, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/armor/brigandine/light, ITEM_SLOT_ARMOR, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow, ITEM_SLOT_BACK_L, TRUE)
			REMOVE_TRAIT(spawned, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_CON, 1)
			spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_STR, 2)
			spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_PER, 1)
			spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_SPD, -2)

	// Bolt selection
	var/quivers = list("Bolts - Steel-Tipped", "Sunderbolts - Silver-Tipped, Halved Damage")
	var/boltchoice = browser_input_list(spawned, "CHOOSE YOUR MUNITIONS.", "TAKE UP PSYDON'S MISSILES.", quivers)

	switch(boltchoice)
		if("Bolts - Steel-Tipped")
			spawned.equip_to_slot_if_possible(new /obj/item/ammo_holder/quiver/bolts(get_turf(spawned)), ITEM_SLOT_BELT_L)
		if("Sunderbolts - Silver-Tipped, Halved Damage")
			spawned.equip_to_slot_if_possible(new /obj/item/ammo_holder/quiver/bolt/holy(get_turf(spawned)), ITEM_SLOT_BELT_L)

/datum/outfit/confessor
	name = "Confessor (Sacrestants)"
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
