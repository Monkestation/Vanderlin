/datum/attribute_holder/sheet/job/persistant/woodsman
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
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/athletics = 10,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/labor/lumberjacking = 40,
		/datum/attribute/skill/craft/carpentry = 20
	)

/datum/job/persistence/woodsman
	title = JOB_LUMBERJACK
	tutorial = "You're a lumberjack, ensure the settlement has wood."
	department_flag = PEASANTS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	allowed_races = RACES_PLAYER_ALL
	allowed_ages = ALL_AGES_LIST
	outfit = /datum/outfit/woodsman_p
	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/persistant/woodsman

/datum/job/persistence/woodsman/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(prob(50))
		spawned.cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'

/datum/outfit/woodsman_p
	name = "Woodsman"
	shirt = /obj/item/clothing/shirt/undershirt/colored/random
	shoes = /obj/item/clothing/shoes/boots/leather
	beltl = /obj/item/weapon/axe/iron
	backl = /obj/item/storage/backpack/satchel

	backpack_contents = list(
		/obj/item/flint = 1,
		/obj/item/weapon/knife/villager = 1
	)

/datum/outfit/woodsman_p/pre_equip(mob/living/carbon/human/equipped_human)
	. = ..()
	head = pick(/obj/item/clothing/head/hatfur,/obj/item/clothing/head/hatblu,/obj/item/clothing/head/brimmed)
	armor = pick(/obj/item/clothing/armor/leather/vest,/obj/item/clothing/armor/gambeson/light/striped)
	pants = pick(/obj/item/clothing/pants/trou, /obj/item/clothing/pants/tights/colored/random)
	belt = pick(/obj/item/storage/belt/leather, /obj/item/storage/belt/leather/rope)


