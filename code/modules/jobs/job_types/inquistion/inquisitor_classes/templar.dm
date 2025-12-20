/datum/job/advclass/sacrestant/psydoniantemplar // A templar, but for the Inquisition
	title = "Psydonian Templar"
	tutorial = "You are among the strongest students of the Ordo Benetarus. Top of your classes in both physical skill and intellectual matters, you’re here to prove you’re worthy of becoming an inquisitor. One simple step, before your skill is recognized."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/psydoniantemplar
	category_tags = list(CTAG_INQUISITION)

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_END = 2,
		STATKEY_SPD = -2,
	) //4 Statline

	skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axesmaces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE
	)

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_STEELHEARTED,
		TRAIT_INQUISITION,
		TRAIT_SILVER_BLESSED,
		TRAIT_PSYDONIAN_GRIT,
		TRAIT_PSYDONITE,
		TRAIT_FOREIGNER,
	)

	voicepack_m = /datum/voicepack/male/knight

/datum/job/advclass/sacrestant/psydoniantemplar/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	GLOB.inquisition.add_member_to_school(spawned, "Benetarus", 0, "Templar")

	var/static/list/helmets = list(
		"Barbute" = /obj/item/clothing/head/helmet/heavy/psydonbarbute,
		"Sallet" = /obj/item/clothing/head/helmet/heavy/psysallet,
		"Armet" = /obj/item/clothing/head/helmet/heavy/psydonhelm,
		"Bucket Helm" = /obj/item/clothing/head/helmet/heavy/psybucket,
	)
	spawned.select_equippable(player_client, helmets, message = "Choose your HELMET.", title = "TAKE UP PSYDON'S HELMS.")

	var/static/list/armors = list(
		"Hauberk" = /obj/item/clothing/armor/chainmail/hauberk/fluted,
		"Cuirass" = /obj/item/clothing/armor/cuirass/fluted,
	)
	var/armor_choice = spawned.select_equippable(player_client, armors, message = "Choose your ARMOR.", title = "TAKE UP PSYDON'S MANTLE.")
	if(armor_choice == "Cuirass")
		spawned.change_stat(STATKEY_SPD, 1) //Less durability and coverage, but still upgradable. Balances out the innate -1 SPD debuff.

	var/static/list/weapons = list(
		"Psydonic Longsword" = list(/obj/item/weapon/scabbard/sword, /obj/item/weapon/sword/long/psydon),
		"Psydonic War Axe" = /obj/item/weapon/axe/psydon,
		"Psydonic Whip" = /obj/item/weapon/whip/psydon,
		"Psydonic Flail" = /obj/item/weapon/flail/psydon,
		"Psydonic Mace" = /obj/item/weapon/mace/goden/psydon,
		"Psydonic Spear + Handmace" = list(/obj/item/weapon/polearm/spear/psydon, /obj/item/weapon/mace/cudgel/psy),
		"Psydonic Poleaxe + Shortsword" = list(/obj/item/weapon/greataxe/psy, /obj/item/weapon/sword/short/psy),
	)
	var/weapon_choice = spawned.select_equippable(player_client, weapons, message = "Choose your WEAPON.", title = "TAKE UP PSYDON'S ARMS.")
	switch(weapon_choice)
		if("Psydonic Longsword")
			spawned.clamped_adjust_skillrank(/datum/skill/combat/swords, 4, 4, TRUE)
		if("Psydonic War Axe", "Psydonic Mace", "Psydonic Poleaxe + Shortsword")
			spawned.clamped_adjust_skillrank(/datum/skill/combat/axesmaces, 4, 4, TRUE)
		if("Psydonic Whip", "Psydonic Flail")
			spawned.clamped_adjust_skillrank(/datum/skill/combat/whipsflails, 4, 4, TRUE)
		if("Psydonic Spear + Handmace")
			spawned.clamped_adjust_skillrank(/datum/skill/combat/polearms, 4, 4, TRUE)

/datum/outfit/psydoniantemplar
	name = "Psydonian Templar"
	wrists = /obj/item/clothing/neck/psycross/silver
	cloak = /obj/item/clothing/cloak/psydontabard
	backr = /obj/item/weapon/shield/tower/metal
	gloves = /obj/item/clothing/gloves/chain/psydon
	neck = /obj/item/clothing/neck/chaincoif
	pants = /obj/item/clothing/pants/chainlegs
	backl = /obj/item/storage/backpack/satchel/otavan
	shirt = /obj/item/clothing/armor/gambeson/heavy/inq
	shoes = /obj/item/clothing/shoes/psydonboots
	belt = /obj/item/storage/belt/leather/black
	beltl = /obj/item/storage/belt/pouch/coins/mid
	ring = /obj/item/clothing/ring/signet/silver
	backpack_contents = list(
		/obj/item/storage/keyring/inquisitor = 1,
		/obj/item/paper/inqslip/arrival/ortho = 1,
		/obj/item/collar_detonator = 1,
	)
