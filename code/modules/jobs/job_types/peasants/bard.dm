/datum/job/bard
	title = "Bard"
	tutorial = "Bards make up one of the largest populations of registered adventurers in Vanderlin, \
	mostly because they are the last ones in a party to die. \
	Their wish is to experience the greatest adventures of the age and write amazing songs \
	about them. This is not your story, for you are the storyteller."
	department_flag = PEASANTS
	display_order = JDO_BARD
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 4
	spawn_positions = 4

	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/bard
	cmode_music = 'sound/music/cmode/adventurer/CombatIntense.ogg'
	exp_types_granted = list(EXP_TYPE_BARD)

	spells = list(
		/datum/action/cooldown/spell/vicious_mockery,
		// /datum/action/cooldown/spell/bardic_inspiration
	)

	jobstats = list(
		STATKEY_PER = 1,
		STATKEY_SPD = 2,
		STATKEY_STR = -1
	)

	skills = list(
		/datum/skill/combat/knives = 1,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/craft/crafting = 1,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/riding = 3,
		/datum/skill/misc/sewing = 1,
		/datum/skill/misc/reading = 3,
		/datum/skill/craft/cooking = 1,
		/datum/skill/misc/sneaking = 3,
		/datum/skill/misc/stealing = 1,
		/datum/skill/misc/lockpicking = 1,
		/datum/skill/misc/music = 4.1,
		/datum/skill/misc/athletics = 2
	)

	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_BARDIC_TRAINING
	)

/datum/job/bard/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.select_equippable(player_client, list(
		"Harp" = /obj/item/instrument/harp,
		"Lute" = /obj/item/instrument/lute,
		"Accordion" = /obj/item/instrument/accord,
		"Guitar" = /obj/item/instrument/guitar,
		"Flute" = /obj/item/instrument/flute,
		"Drum" = /obj/item/instrument/drum,
		"Hurdy-Gurdy" = /obj/item/instrument/hurdygurdy,
		"Viola" = /obj/item/instrument/viola
		),
		message = "Choose your instrument.",
		title = "XYLIX"
	)
	spawned.inspiration = new /datum/inspiration(spawned)
	spawned.clamped_adjust_skillrank(/datum/skill/misc/music, 4, 4, TRUE) //Due to Harpy's innate music skill giving them legendary

	if(spawned.dna?.species?.id == SPEC_ID_DWARF)
		spawned.cmode_music = 'sound/music/cmode/combat_dwarf.ogg'

/datum/outfit/bard
	name = "Bard"
	head = /obj/item/clothing/head/bardhat
	shoes = /obj/item/clothing/shoes/boots
	pants = /obj/item/clothing/pants/tights/colored/random
	shirt = /obj/item/clothing/shirt/tunic/noblecoat
	belt = /obj/item/storage/belt/leather
	armor = /obj/item/clothing/armor/leather/vest
	cloak = /obj/item/clothing/cloak/raincloak/colored/blue
	backl = /obj/item/storage/backpack/satchel
	beltr = /obj/item/weapon/knife/dagger/steel/special
	beltl = /obj/item/storage/belt/pouch/coins/poor
	backpack_contents = list(/obj/item/flint)
	scabbards = list(/obj/item/weapon/scabbard/knife)

/datum/outfit/bard/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(prob(30))
		gloves = /obj/item/clothing/gloves/fingerless
	if(prob(50))
		cloak = /obj/item/clothing/cloak/raincloak/colored/red



