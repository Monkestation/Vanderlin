
/datum/job/advclass/puritan/ordinator
	title = "Ordinator"
	tutorial = "The head of the Ordo Benetarus, your lessons are the most brutal of them all. Through adversity and challenge, your students will learn what it means to stand in Psydon’s name, unwavering and unblinking. Your body as hard as steel, your skills tempered through battles unending, every monster you’ve faced has fallen before you. Your students march to their doom, but with your lessons, they may yet emerge shaped in Psydon’s image, and your own."
	outfit = /datum/outfit/inquisitor/ordinator
	spells = list(/datum/action/cooldown/spell/undirected/list_target/convert_role/adept)
	category_tags = list(CTAG_PURITAN)

	skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/firearms = SKILL_LEVEL_JOURNEYMAN,
	)

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_END = 1,
		STATKEY_PER = 2,
		STATKEY_INT = 1,
	) //7 Statline due to them having armors.

	traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_HEAVYARMOR,
		TRAIT_INQUISITION,
		TRAIT_PSYDONIAN_GRIT,
		TRAIT_PSYDONITE,
		TRAIT_FOREIGNER,
		TRAIT_RECOGNIZED,
	)

/datum/job/advclass/puritan/ordinator/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	GLOB.inquisition.add_member_to_position(spawned, GLOB.inquisition.benetarus, 100)
	if(spawned.age == AGE_OLD)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_STR, 1)

	var/static/list/gear = list(
		"Covenant And Creed (Broadsword + Shield)",
		"Covenant and Consecratia (Flail + Shield)",
		"Crusade (Greatsword) and a Silver Dagger",
		"Remembrance (Long Sword)",
	)
	var/gear_choice = browser_input_list(spawned, "CHOOSE YOUR RELIQUARY PIECE.", "WIELD THEM IN HIS NAME.", gear)
	switch(gear_choice)
		if("Covenant And Creed (Broadsword + Shield)")
			spawned.put_in_hands(new /obj/item/weapon/sword/long/broadsword/psy/relic(get_turf(spawned)), TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/shield/tower/metal/psy, ITEM_SLOT_BACK_R, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/combat/swords, 4, 4, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/combat/shields, 4, 4, TRUE)
			if(spawned.age == AGE_OLD)
				spawned.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
				spawned.adjust_skillrank(/datum/skill/combat/shields, 1, TRUE)
		if("Covenant and Consecratia (Flail + Shield)")
			spawned.put_in_hands(new /obj/item/weapon/flail/psydon/relic(get_turf(spawned)), TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/shield/tower/metal/psy, ITEM_SLOT_BACK_R, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/combat/whipsflails, 4, 4, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/combat/shields, 4, 4, TRUE)
			if(spawned.age == AGE_OLD)
				spawned.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
				spawned.adjust_skillrank(/datum/skill/combat/shields, 1, TRUE)
		if("Crusade (Greatsword) and a Silver Dagger")
			spawned.put_in_hands(new /obj/item/weapon/sword/long/greatsword/psydon/relic(get_turf(spawned)), TRUE)
			spawned.put_in_hands(new /obj/item/weapon/knife/dagger/silver/psydon(get_turf(spawned)), TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/scabbard/knife, ITEM_SLOT_BACK_L, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/combat/swords, 4, 4, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/combat/knives, 4, 4, TRUE)
			if(spawned.age == AGE_OLD)
				spawned.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
				spawned.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		if("Remembrance (Long Sword)")
			spawned.put_in_hands(new /obj/item/weapon/sword/long/psydon/relic(spawned), TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/combat/swords, 4, 4, TRUE)
			if(spawned.age == AGE_OLD)
				spawned.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)

/datum/outfit/inquisitor/ordinator
	name = "Ordinator (Herr Prafekt)"
	shirt = /obj/item/clothing/armor/gambeson/heavy/inq
	armor = /obj/item/clothing/armor/plate/fluted/ornate/ordinator
	belt = /obj/item/storage/belt/leather/steel
	neck = /obj/item/clothing/neck/gorget
	shoes = /obj/item/clothing/shoes/otavan/inqboots
	backl = /obj/item/storage/backpack/satchel/otavan
	wrists = /obj/item/clothing/neck/psycross/silver
	ring = /obj/item/clothing/ring/signet/silver
	pants = /obj/item/clothing/pants/platelegs
	cloak = /obj/item/clothing/cloak/ordinatorcape
	beltr = /obj/item/storage/belt/pouch/coins/rich
	head = /obj/item/clothing/head/helmet/heavy/ordinatorhelm
	gloves = /obj/item/clothing/gloves/leather/otavan
	backpack_contents = list(
		/obj/item/storage/keyring/inquisitor = 1,
		/obj/item/paper/inqslip/arrival/inq = 1,
	)
