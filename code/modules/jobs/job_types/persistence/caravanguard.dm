/datum/job/persistence/caravanguard
	title = "Caravan Guard"
	tutorial = "You're a caravan guard, ensure the settlers aren't killed and maimed by whatever lurks in here."
	department_flag = GARRISON
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	outfit = /datum/outfit/caravanguard
	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_CON = 1,
		STATKEY_END = 1
	)

	skills = list(
		/datum/skill/combat/knives = 1,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/shields = 3,
		/datum/skill/combat/axesmaces = 3,
		/datum/skill/misc/reading = 1,
		/datum/skill/craft/crafting = 1,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/athletics = 2
	)

	traits = list(
		TRAIT_MEDIUMARMOR
	)


/datum/job/persistence/caravanguard/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(prob(50))
		spawned.cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'

/datum/outfit/caravanguard
	name = "Caravan Guard"
	head = /obj/item/clothing/head/helmet/ironpot
	armor = /obj/item/clothing/armor/cuirass/iron
	shirt = /obj/item/clothing/armor/gambeson
	shoes = /obj/item/clothing/shoes/boots/leather
	neck = /obj/item/clothing/neck/coif/cloth
	gloves = /obj/item/clothing/gloves/leather


	beltr = /obj/item/weapon/mace/cudgel
	beltl = /obj/item/weapon/sword/short/iron
	backr = /obj/item/weapon/shield/heater
	backl = /obj/item/weapon/shield/wood

	backpack_contents = list(
		/obj/item/flint = 1,
		/obj/item/weapon/knife/villager = 1
	)

/datum/outfit/caravanguard/pre_equip(mob/living/carbon/human/equipped_human)
	. = ..()
	pants = pick(/obj/item/clothing/pants/trou, /obj/item/clothing/pants/tights/colored/random)
	belt = pick(/obj/item/storage/belt/leather, /obj/item/storage/belt/leather/rope)