/datum/attribute_holder/sheet/job/bogwitch
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_INTELLIGENCE = 3,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
		/datum/attribute/skill/misc/athletics = 10,
		/datum/attribute/skill/craft/alchemy = 30,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/labor/farming = 30,
		/datum/attribute/skill/magic/holy = 30,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/misc/sewing = 20
	)


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
	allowed_ages = ALL_AGES_LIST
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/bogwitch
	is_foreigner = TRUE
	is_recognized = TRUE
	cmode_music = 'sound/music/cmode/church/CombatDendor.ogg'
	banned_patrons = list()

	exp_type = list(EXP_TYPE_LIVING, EXP_TYPE_ADVENTURER, EXP_TYPE_CLERIC, EXP_TYPE_MEDICAL)
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_CLERIC, EXP_TYPE_MEDICAL)
	exp_requirements = list(
		EXP_TYPE_LIVING = 1200,
		EXP_TYPE_ADVENTURER = 300,
		EXP_TYPE_CLERIC = 300,
		EXP_TYPE_MEDICAL = 300
	)

	attribute_sheet = /datum/attribute_holder/sheet/job/bogwitch

	spells = list(/datum/action/cooldown/spell/diagnose)

	traits = list(
		TRAIT_DEADNOSE,
		TRAIT_FORAGER,
		TRAIT_LEGENDARY_ALCHEMIST,
		TRAIT_STEELHEARTED
	)
	selection_color = "#a33096"

/datum/job/bogwitch/get_latejoin_spawn_point()
	if(length(GLOB.jobspawn_overrides[title]))
		return pick(GLOB.jobspawn_overrides[title])
	if(length(SSjob.latejoin_trackers))
		return pick(SSjob.latejoin_trackers)
	return SSjob.get_last_resort_spawn_points()


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
			spawned.adjust_skillrank(/datum/attribute/skill/misc/medicine, 1, TRUE)
			spawned.adjust_skillrank(/datum/attribute/skill/craft/alchemy, -1, TRUE)
			spawned.adjust_skillrank(/datum/attribute/skill/magic/holy, -1, TRUE)
		if("Path of Nature")//Plus to Alchemy
			spawned.adjust_skillrank(/datum/attribute/skill/craft/alchemy, 1, TRUE)
			spawned.adjust_skillrank(/datum/attribute/skill/magic/holy, -1, TRUE)
			spawned.adjust_skillrank(/datum/attribute/skill/misc/medicine, -1, TRUE)
		if("Path of The Hunt")//Plus to Miracles
			spawned.adjust_skillrank(/datum/attribute/skill/magic/holy, 1, TRUE)
			spawned.adjust_skillrank(/datum/attribute/skill/craft/alchemy, -1, TRUE)
			spawned.adjust_skillrank(/datum/attribute/skill/misc/medicine, -1, TRUE)

/datum/job/bogwitch/adjust_patron(mob/living/carbon/human/spawned)
	var/datum/patron/old_patron = spawned.patron
	if(old_patron?.type == /datum/patron/alternate/great_hunt/proven)
		return

	spawned.set_patron(/datum/patron/alternate/great_hunt/proven, TRUE)

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
