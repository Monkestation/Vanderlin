/datum/job/persistence/farmer
	title = "Farmer"
	tutorial = "You're a farmer, ensure the settlers don't starve."
	department_flag = PEASANTS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	outfit = /datum/outfit/farmer_p
	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_CON = 1,
		STATKEY_END = 1
	)

	skills = list(
		/datum/skill/combat/knives = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/misc/reading = 1,
		/datum/skill/craft/crafting = 1,
		/datum/skill/misc/climbing = 1,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/athletics = 1,
		/datum/skill/labor/farming = 4,
		/datum/skill/labor/butchering = 2,
		/datum/skill/labor/fishing = 2,
		/datum/skill/labor/taming = 2,
		/datum/skill/combat/polearms = 2
	)

	traits = list(
		TRAIT_SEEDKNOW
	)

/datum/job/persistence/farmer/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(prob(50))
		spawned.cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'

	spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_STR, pick(0,1))
	spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_CON, pick(0,1))
	spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_END, pick(0,1))



/datum/outfit/farmer_p
	name = "Farmer"
	shirt = /obj/item/clothing/shirt/undershirt/colored/random
	shoes = /obj/item/clothing/shoes/boots/leather

	beltl = /obj/item/weapon/sickle
	beltr = /obj/item/weapon/shovel/small
	backr = /obj/item/weapon/hoe
	backl = /obj/item/storage/backpack/satchel

	backpack_contents = list(
		/obj/item/weapon/knife/villager = 1,
		/obj/item/recipe_book/agriculture = 1
	)

	r_hand = /obj/item/weapon/thresher
	l_hand = /obj/item/weapon/pitchfork

/datum/outfit/farmer_p/pre_equip(mob/living/carbon/human/equipped_human)
	. = ..()
	head = pick(/obj/item/clothing/head/strawhat, /obj/item/clothing/head/armingcap, /obj/item/clothing/head/fisherhat)
	armor = pick(/obj/item/clothing/armor/leather/vest, /obj/item/clothing/armor/gambeson/light/striped)
	pants = pick(/obj/item/clothing/pants/trou, /obj/item/clothing/pants/tights/colored/random)
	belt = pick(/obj/item/storage/belt/leather, /obj/item/storage/belt/leather/rope)
