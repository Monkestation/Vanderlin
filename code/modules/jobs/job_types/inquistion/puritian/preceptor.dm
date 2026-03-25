/datum/attribute_holder/sheet/job/preceptor
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_PERCEPTION = 2,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 2,
		STAT_SPEED = 2,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/combat/unarmed = 40,
		/datum/attribute/skill/combat/wrestling = 40,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/combat/firearms = 30,
	)

/datum/attribute_holder/sheet/job/preceptor/old
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_PERCEPTION = 2,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 2,
		STAT_SPEED = 2,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/combat/unarmed = 50,
		/datum/attribute/skill/combat/wrestling = 40,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/combat/firearms = 30,
	)

/datum/job/advclass/puritan/preceptor
	title = "Preceptor"
	tutorial = "The head of the Ordo Benetarus, you stand as a pillar of discipline. With unwavering resolve and a fist of steel, you temper the untested into Psydon's dauntless warriors."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/job/preceptor
	category_tags = list(CTAG_PURITAN)

	attribute_sheet = /datum/attribute_holder/sheet/job/preceptor
	attribute_sheet_old = /datum/attribute_holder/sheet/job/preceptor/old

	traits = list(
		TRAIT_INQUISITION,
		TRAIT_SILVER_BLESSED,
		TRAIT_STEELHEARTED,
		TRAIT_PSYDONIAN_GRIT,
		TRAIT_PSYDONITE,
		TRAIT_DODGEEXPERT,
		TRAIT_DUALWIELDER,
		TRAIT_FOREIGNER,
		TRAIT_RECOGNIZED,
	)
/datum/job/advclass/puritan/preceptor/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	GLOB.inquisition.add_member_to_position(spawned, GLOB.inquisition.benetarus, 100)

	var/static/list/gear = list(
		"Knuckleduster and Knuckleduster",
		"Katar and Katar",
	)
	var/gear_choice = browser_input_list(spawned, "CHOOSE YOUR RELIQUARY PIECE.", "WIELD THEM IN HIS NAME.", gear)
	switch(gear_choice)
		if("Knuckleduster and Knuckleduster")
			spawned.put_in_hands(new /obj/item/weapon/knuckles/psydon(get_turf(spawned)), TRUE)
			spawned.put_in_hands(new /obj/item/weapon/knuckles/psydon(get_turf(spawned)), TRUE)
		if("Katar and Katar")
			spawned.put_in_hands(new /obj/item/weapon/katar/psydon(get_turf(spawned)), TRUE)
			spawned.put_in_hands(new /obj/item/weapon/katar/psydon(get_turf(spawned)), TRUE)

/datum/outfit/job/preceptor/pre_equip(mob/living/carbon/human/H)
	..()
	name = "Preceptor (Herr Prafekt)"
	shoes = /obj/item/clothing/shoes/psydonboots
	armor = /obj/item/clothing/armor/regenerating/skin/disciple
	backl = /obj/item/storage/backpack/satchel/otavan
	backpack_contents = list(/obj/item/storage/keyring/inquisitor = 1,
	/obj/item/paper/inqslip/arrival/inq = 1)
	belt = /obj/item/storage/belt/leather/rope/dark
	pants = /obj/item/clothing/pants/tights/colored/black
	cloak = /obj/item/clothing/cloak/cape/inquisitor
	head = /obj/item/clothing/head/headband/naledi
	mask = /obj/item/clothing/face/lordmask/naledi/sojourner
	gloves = /obj/item/clothing/gloves/bandages/pugilist
	neck = /obj/item/clothing/neck/psycross/gold
	wrists = /obj/item/clothing/wrists/bracers/naledi
	ring = /obj/item/clothing/ring/signet

