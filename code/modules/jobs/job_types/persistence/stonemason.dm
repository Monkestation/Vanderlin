/datum/attribute_holder/sheet/job/persistant/stonemason
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
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/craft/masonry = 40,
		/datum/attribute/skill/labor/mining = 20
	)

/datum/job/persistence/stonemason
	title = "Stonemason"
	tutorial = "You're a stonemason, ensure the settlement isn't a bunch of tents."
	department_flag = SERFS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	outfit = /datum/outfit/stonemason_p
	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/persistant/stonemason


/datum/job/persistence/stonemason/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(prob(50))
		spawned.cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'

/datum/outfit/stonemason_p
	name = "Stonemason"
	shirt = /obj/item/clothing/shirt/undershirt/colored/random
	shoes = /obj/item/clothing/shoes/boots/leather

	beltl = /obj/item/weapon/hammer/iron
	beltr = /obj/item/weapon/pick

	backl = /obj/item/storage/backpack/satchel

	backpack_contents = list(
		/obj/item/recipe_book/masonry = 1,
		/obj/item/weapon/knife/villager = 1,
		/obj/item/weapon/chisel/iron = 1
	)

/datum/outfit/stonemason_p/pre_equip(mob/living/carbon/human/equipped_human)
	. = ..()
	head = pick(/obj/item/clothing/head/hatfur, /obj/item/clothing/head/hatblu, /obj/item/clothing/head/brimmed)
	armor = pick(/obj/item/clothing/armor/leather/vest, /obj/item/clothing/armor/gambeson/light/striped)
	pants = pick(/obj/item/clothing/pants/trou, /obj/item/clothing/pants/tights/colored/random)
	belt = pick(/obj/item/storage/belt/leather, /obj/item/storage/belt/leather/rope)
