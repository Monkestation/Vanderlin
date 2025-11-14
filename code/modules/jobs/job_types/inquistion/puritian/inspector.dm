
/datum/job/advclass/puritan/inspector
	title = "Inquisitor"
	tutorial = "The head of the Ordo Venatari, your lessons are of a subtle touch and a light step. A silver dagger in the right place at the right time is all that is needed. Preparation is key, and this is something you impart on your students. Be always ready, be always waiting, and always be vigilant."
	outfit = /datum/outfit/job/inquisitor/inspector

	category_tags = list(CTAG_PURITAN)

	traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_DODGEEXPERT,
		TRAIT_BLACKBAGGER,
		TRAIT_MEDIUMARMOR,
		TRAIT_INQUISITION,
		TRAIT_SILVER_BLESSED,
		TRAIT_PURITAN,
		TRAIT_PSYDONIAN_GRIT,
		TRAIT_PSYDONITE,
	)

	jobstats = list(
		STATKEY_END = 1,
		STATKEY_CON = 1,
		STATKEY_PER = 3,
		STATKEY_SPD = 2,
		STATKEY_INT = 2,
	)

	skills = list(
		/datum/skill/misc/lockpicking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/firearms = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/inquisitor/inspector/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/armor/gambeson/heavy/inq
	belt = /obj/item/storage/belt/leather/knifebelt/black/psydon
	neck = /obj/item/clothing/neck/gorget
	shoes = /obj/item/clothing/shoes/otavan/inqboots
	pants = /obj/item/clothing/pants/tights/colored/black
	backr =  /obj/item/storage/backpack/satchel/otavan
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	beltr = /obj/item/ammo_holder/quiver/bolts
	head = /obj/item/clothing/head/leather/inqhat
	mask = /obj/item/clothing/face/spectacles/inq/spawnpair
	gloves = /obj/item/clothing/gloves/leather/otavan
	wrists = /obj/item/clothing/neck/psycross/silver
	ring = /obj/item/clothing/ring/signet/silver
	armor = /obj/item/clothing/armor/medium/scale/inqcoat/armored
	backpack_contents = list(
		/obj/item/storage/keyring/inquisitor = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/weapon/knife/dagger/silver/psydon,
		/obj/item/clothing/head/inqarticles/blackbag = 1,
		/obj/item/inqarticles/garrote = 1,
		/obj/item/rope/inqarticles/inquirycord = 1,
		/obj/item/grapplinghook = 1,
		/obj/item/paper/inqslip/arrival/inq = 1,
		)

	var/weapons = list("Retribution (Rapier)", "Daybreak (Whip)", "Sanctum (Halberd)", "The Forgotten Blade")
	var/weapon_choice = input(H,"CHOOSE YOUR RELIQUARY PIECE.", "WIELD THEM IN HIS NAME.") as anything in weapons
	switch(weapon_choice)
		if("Retribution (Rapier)")
			H.put_in_hands(new /obj/item/weapon/sword/rapier/psy/relic(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/weapon/scabbard/sword, ITEM_SLOT_BELT_L, TRUE)
			H.clamped_adjust_skillrank(/datum/skill/combat/swords, 4, 4, TRUE)
		if("Daybreak (Whip)")
			H.put_in_hands(new /obj/item/weapon/whip/psydon/relic(H), TRUE)
			H.clamped_adjust_skillrank(/datum/skill/combat/whipsflails, 4, 4)
		if("Sanctum (Halberd)")
			H.put_in_hands(new /obj/item/weapon/polearm/halberd/psydon/relic(H), TRUE)
			H.clamped_adjust_skillrank(/datum/skill/combat/polearms, 4, 4, TRUE)
		if("The Forgotten Blade")
			H.put_in_hands(new /obj/item/weapon/sword/long/forgotten(H), TRUE)
			H.clamped_adjust_skillrank(/datum/skill/combat/swords, 4, 4, TRUE)

/datum/outfit/job/inquisitor/inspector/post_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	GLOB.inquisition.add_member_to_position(H, GLOB.inquisition.venatari, 100)
