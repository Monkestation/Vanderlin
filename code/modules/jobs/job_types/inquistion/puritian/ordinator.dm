/datum/attribute_holder/sheet/job/ordinator
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
		STAT_PERCEPTION = 2,
		STAT_INTELLIGENCE = 1,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/combat/wrestling = 40,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/combat/firearms = 30,
	)

/datum/attribute_holder/sheet/job/ordinator/old
	raw_attribute_list = list(
		STAT_STRENGTH = 3,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
		STAT_PERCEPTION = 2,
		STAT_INTELLIGENCE = 1,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/combat/wrestling = 40,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/combat/firearms = 30,
	)

/datum/attribute_holder/sheet/job/creed
	clamped_adjustment = list(
		/datum/attribute/skill/combat/swords = list(40, 40),
		/datum/attribute/skill/combat/shields = list(40, 40),
	)

/datum/attribute_holder/sheet/job/consecratia
	clamped_adjustment = list(
		/datum/attribute/skill/combat/whipsflails = list(40, 40),
		/datum/attribute/skill/combat/shields = list(40, 40),
	)

/datum/attribute_holder/sheet/job/crusade
	clamped_adjustment = list(
		/datum/attribute/skill/combat/swords = list(40, 40),
		/datum/attribute/skill/combat/knives = list(40, 40),
	)

/datum/job/advclass/puritan/ordinator
	title = "Ordinator"
	tutorial = "The head of the Ordo Benetarus, your lessons are the most brutal of them all. Through adversity and challenge, your students will learn what it means to stand in Psydon’s name, unwavering and unblinking. Your body as hard as steel, your skills tempered through battles unending, every monster you’ve faced has fallen before you. Your students march to their doom, but with your lessons, they may yet emerge shaped in Psydon’s image, and your own."
	outfit = /datum/outfit/inquisitor/ordinator
	spells = list(/datum/action/cooldown/spell/undirected/list_target/convert_role/adept)
	category_tags = list(CTAG_PURITAN)

	attribute_sheet = /datum/attribute_holder/sheet/job/ordinator
	attribute_sheet_old = /datum/attribute_holder/sheet/job/ordinator/old

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
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/creed)
		if("Covenant and Consecratia (Flail + Shield)")
			spawned.put_in_hands(new /obj/item/weapon/flail/psydon/relic(get_turf(spawned)), TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/shield/tower/metal/psy, ITEM_SLOT_BACK_R, TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/consecratia)
		if("Crusade (Greatsword) and a Silver Dagger")
			spawned.put_in_hands(new /obj/item/weapon/sword/long/greatsword/psydon/relic(get_turf(spawned)), TRUE)
			spawned.put_in_hands(new /obj/item/weapon/knife/dagger/silver/psydon(get_turf(spawned)), TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/scabbard/knife, ITEM_SLOT_BACK_L, TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/crusade)

		if("Remembrance (Long Sword)")
			spawned.put_in_hands(new /obj/item/weapon/sword/long/psydon/relic(spawned), TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/retribution)

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
