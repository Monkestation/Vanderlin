/datum/attribute_holder/sheet/job/persistant/caravanguard
	attribute_variance = list(
		STAT_STRENGTH = list(0, 1),
		STAT_CONSTITUTION = list(0, 1),
		STAT_ENDURANCE = list(0, 1),
	)
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
		/datum/attribute/skill/combat/knives = 10,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/athletics = 20
	)

/datum/job/persistence/caravanguard
	title = "Caravan Guard"
	tutorial = "You're a caravan guard, ensure the settlers aren't killed and maimed by whatever lurks in here."
	department_flag = GARRISON
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	outfit = /datum/outfit/caravanguard
	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/persistant/caravanguard

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
