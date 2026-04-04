/datum/attribute_holder/sheet/job/psydoniantemplar
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_CONSTITUTION = 2,
		STAT_ENDURANCE = 2,
		STAT_SPEED = -2,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/whipsflails = 30,
		/datum/attribute/skill/combat/crossbows = 20,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/misc/medicine = 10
	)

/datum/job/advclass/sacrestant/psydoniantemplar // A templar, but for the Inquisition
	title = "Psydonian Templar"
	tutorial = "You are among the strongest students of the Ordo Benetarus. Top of your classes in both physical skill and intellectual matters, you’re here to prove you’re worthy of becoming an inquisitor. One simple step, before your skill is recognized."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/psydoniantemplar
	category_tags = list(CTAG_INQUISITION)

	attribute_sheet = /datum/attribute_holder/sheet/job/psydoniantemplar

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
	spawned.select_equippable(player_client, armors, message = "Choose your ARMOR.", title = "TAKE UP PSYDON'S MANTLE.")

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
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/swords, 30, 30, TRUE)
		if("Psydonic War Axe", "Psydonic Mace", "Psydonic Poleaxe + Shortsword")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 30, 30, TRUE)
		if("Psydonic Whip", "Psydonic Flail")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/whipsflails, 30, 30, TRUE)
		if("Psydonic Spear + Handmace")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/polearms, 30, 30, TRUE)

/datum/outfit/psydoniantemplar
	name = "Psydonian Templar (Sacrestants)"
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
