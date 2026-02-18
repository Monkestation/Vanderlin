
/datum/job/advclass/puritan/inspector
	title = "Inquisitor"
	tutorial = "The head of the Ordo Venatari, your lessons are of a subtle touch and a light step. A silver dagger in the right place at the right time is all that is needed. Preparation is key, and this is something you impart on your students. Be always ready, be always waiting, and always be vigilant."
	outfit = /datum/outfit/inquisitor/inspector
	spells = list(/datum/action/cooldown/spell/undirected/list_target/convert_role/adept)
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
		TRAIT_FOREIGNER,
		TRAIT_RECOGNIZED,
	)

	jobstats = list(
		STATKEY_PER = 4,
		STATKEY_SPD = 4,
		STATKEY_INT = 2,
	) //10 Statline

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

/datum/job/advclass/puritan/inspector/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	GLOB.inquisition.add_member_to_position(spawned, GLOB.inquisition.venatari, 100)

	var/static/list/gear = list(
		"Retribution (Rapier)",
		"Daybreak (Whip)",
		"Sanctum (Halberd)",
		"Remembrance (Long Sword)",
	)
	var/weapon_choice = browser_input_list(spawned, "CHOOSE YOUR RELIQUARY PIECE.", "WIELD THEM IN HIS NAME.", gear)
	switch(weapon_choice)
		if("Retribution (Rapier)")
			spawned.put_in_hands(new /obj/item/weapon/sword/rapier/psy/relic(spawned), TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/scabbard/sword, ITEM_SLOT_BELT_L, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/combat/swords, 4, 4, TRUE)
			if(spawned.age == AGE_OLD)
				spawned.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if("Daybreak (Whip)")
			spawned.put_in_hands(new /obj/item/weapon/whip/psydon/relic(spawned), TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/combat/whipsflails, 4, 4)
			if(spawned.age == AGE_OLD)
				spawned.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
		if("Sanctum (Halberd)")
			spawned.put_in_hands(new /obj/item/weapon/polearm/halberd/psydon/relic(spawned), TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/combat/polearms, 4, 4, TRUE)
			if(spawned.age == AGE_OLD)
				spawned.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
				spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_STR, 1) //So they don't have a 33% chance if being unable to wield their weapon.
		if("Remembrance (Long Sword)")
			spawned.put_in_hands(new /obj/item/weapon/sword/long/psydon/relic(spawned), TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/combat/swords, 4, 4, TRUE)
			if(spawned.age == AGE_OLD)
				spawned.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)


/datum/outfit/inquisitor/inspector
	name = "Inspector (Herr Prafekt)"
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
