/datum/job/advclass/puritan/preceptor
	title = "Preceptor"
	tutorial = "The head of the Ordo Benetarus, you stand as a pillar of discipline. With unwavering resolve and a fist of steel, you temper the untested into Psydon's dauntless warriors."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/job/preceptor
	category_tags = list(CTAG_PURITAN)
	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_END = 2,
		STATKEY_CON = 2,
		STATKEY_SPD = 2,
	)
	skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/firearms = SKILL_LEVEL_JOURNEYMAN,
	)

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
	neck = /obj/item/clothing/neck/psycross/g
	wrists = /obj/item/clothing/wrists/bracers/naledi
	ring = /obj/item/clothing/ring/signet

