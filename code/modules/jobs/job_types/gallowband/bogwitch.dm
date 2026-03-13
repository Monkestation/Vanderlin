/datum/job/bogwitch
	title = JOB_BOGWITCH
	tutorial = "Your ancestor came with the Gallowband as a healer. Eventually, they drifted apart to the fetid cauldron of life that is the Bog, drawn by the strange herbs and magics present in the mud. Even as you venerate the Great Hunt, you work in harmony with the land. Mender, potionmaker, miracle-worker, doomed to seclusion- but maybe your apprentice will carry on the old ways."
	department_flag = OUTSIDERS
	job_flags = (JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_BOGWITCH
	faction = FACTION_TOWN
	total_positions = 0
	spawn_positions = 0
	bypass_lastclass = TRUE
	allowed_races = RACES_PLAYER_ALL
	blacklisted_species = list(SPEC_ID_HALFLING)
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/bogwitch
	is_foreigner = TRUE
	is_recognized = TRUE
	cmode_music = 'sound/music/cmode/church/CombatDendor.ogg'
	banned_patrons = list()

	exp_type = list(EXP_TYPE_LIVING, EXP_TYPE_ADVENTURER, EXP_TYPE_CHURCH, EXP_TYPE_MEDICAL)
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_CHURCH, EXP_TYPE_MEDICAL)
	exp_requirements = list(
		EXP_TYPE_LIVING = 1200,
		EXP_TYPE_ADVENTURER = 300,
		EXP_TYPE_CHURCH = 300,
		EXP_TYPE_MEDICAL = 300
	)

	jobstats = list(
		STATKEY_STR = -1,
		STATKEY_INT = 3,
		STATKEY_CON = 1,
		STATKEY_END = 1
	)

	skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE
	)

	spells = list(/datum/action/cooldown/spell/diagnose)

	traits = list(
		TRAIT_DEADNOSE,
		TRAIT_FORAGER,
		TRAIT_LEGENDARY_ALCHEMIST,
		TRAIT_STEELHEARTED
	)
	selection_color = "#a33096"

/datum/job/bogwitch/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	spawned.apply_status_effect(/datum/status_effect/buff/bone_ward)

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_acolyte()
		devotion.grant_to(spawned)

	// This is hopefully temporary, as I couldn't make a tgui input list trigger, and this proc always triggers before proceeding.
	var/static/list/selectable = list(
		"Generalist" = /obj/item/weapon/knife/villager,
		"Path of Bone" = /obj/item/weapon/knife/villager,
		"Path of Nature" = /obj/item/weapon/knife/villager,
		"Path of The Hunt" = /obj/item/weapon/knife/villager,
	)
	var/chosen_path = spawned.select_equippable(player_client, selectable, time_limit = 1 MINUTES, message = "Choose a specialist path", title = "Specialist Path")

//	var/chosen_path = tgui_input_list(spawned, "Choose a specialist path", "Specialist Path", list("Generalist", "Path of Bone", "Path of Nature", "Path of The Hunt"))
	switch(chosen_path)
		if("Path of Bone")//Plus to Surgery
			spawned.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/craft/alchemy, -1, TRUE)
			spawned.adjust_skillrank(/datum/skill/magic/holy, -1, TRUE)
		if("Path of Nature")//Plus to Alchemy
			spawned.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/magic/holy, -1, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/medicine, -1, TRUE)
		if("Path of The Hunt")//Plus to Miracles
			spawned.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/craft/alchemy, -1, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/medicine, -1, TRUE)

/datum/job/bogwitch/adjust_patron(mob/living/carbon/human/spawned)
	var/datum/patron/old_patron = spawned.patron
	if(old_patron?.type == /datum/patron/alternate/great_hunt)
		return

	spawned.set_patron(/datum/patron/alternate/great_hunt, TRUE)

	var/datum/patron/new_patron = spawned.patron
	if(old_patron != new_patron) // If the patron we selected first does not match the patron we end up with, display the message.
		to_chat(spawned, span_warning("I've followed the word of [old_patron.display_name ? old_patron.display_name : old_patron] in my younger years, \
		but the path I tread todae has accustomed me to [new_patron.display_name ? new_patron.display_name : new_patron]."))


/datum/outfit/bogwitch
	name = JOB_BOGWITCH
	head = /obj/item/clothing/head/wizhat/bogwitch
	mask = /obj/item/clothing/face/spectacles
	shirt = /obj/item/clothing/shirt/robe/bogwitch
	backl = /obj/item/storage/backpack/satchel
	backr = /obj/item/storage/backpack/satchel/surgbag
	ring = /obj/item/clothing/ring/amber
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/storage/keyring/bogwitch
	r_hand = /obj/item/weapon/polearm/woodstaff/quarterstaff
	shoes = /obj/item/clothing/shoes/boots/leather
	pants = /obj/item/clothing/pants/trou/leather
	gloves = /obj/item/clothing/gloves/leather
	neck = /obj/item/clothing/neck/psycross/great_hunt
	backpack_contents = list(
		/obj/item/scrying = 1
	)
