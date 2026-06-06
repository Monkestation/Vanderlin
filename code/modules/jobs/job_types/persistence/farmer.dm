/datum/attribute_holder/sheet/job/persistant/farmer
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
		/datum/attribute/skill/labor/farming = 40,
		/datum/attribute/skill/labor/butchering = 20,
		/datum/attribute/skill/labor/fishing = 20,
		/datum/attribute/skill/labor/taming = 20,
		/datum/attribute/skill/combat/polearms = 20
	)

/datum/job/persistence/farmer
	title = "Farmer"
	tutorial = "You're a farmer, ensure the settlers don't starve."
	department_flag = PEASANTS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	outfit = /datum/outfit/farmer_p
	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/persistant/farmer

	traits = list(
		TRAIT_SEEDKNOW
	)

/datum/job/persistence/farmer/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(prob(50))
		spawned.cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'


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
