/datum/job/advclass/pilgrim/rare/farmermaster
	title = "Master Farmer"
	tutorial = "A veteran among the serfs that tend to cattle and fields of produce, \
	able to handle almost every single task there is to do on a fief."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/pilgrim/farmermaster
	total_positions = 1
	roll_chance = 0
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	apprentice_name = "Handyman"
	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'
	is_recognized = TRUE

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_END = 2,
		STATKEY_INT = -1
	)

	skills = list(
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/knives = 1,
		/datum/skill/combat/polearms = 2,
		/datum/skill/combat/whipsflails = 1,
		/datum/skill/craft/crafting = 3,
		/datum/skill/misc/sewing = 2,
		/datum/skill/misc/climbing = 2,
		/datum/skill/labor/farming = 6,
		/datum/skill/craft/cooking = 2,
		/datum/skill/misc/medicine = 1,
		/datum/skill/labor/butchering = 2,
		/datum/skill/craft/tanning = 1,
		/datum/skill/misc/athletics = 4,
		/datum/skill/labor/taming = 2
	)

	traits = list(
		TRAIT_DEADNOSE,
		TRAIT_SEEDKNOW
	)

/datum/job/advclass/pilgrim/rare/farmermaster/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/misc/swimming, pick(0, 1, 1), TRUE)

/datum/outfit/pilgrim/farmermaster
	name = "Master Farmer (Pilgrim)"
	belt = /obj/item/storage/belt/leather
	shirt = /obj/item/clothing/shirt/undershirt/colored/random
	pants = /obj/item/clothing/pants/trou
	shoes = /obj/item/clothing/shoes/boots/leather
	backr = /obj/item/weapon/hoe
	wrists = /obj/item/clothing/wrists/bracers/leather
	backl = /obj/item/storage/backpack/backpack
	neck = /obj/item/clothing/neck/coif/cloth
	armor = /obj/item/clothing/armor/gambeson
	mouth = /obj/item/clothing/face/cigarette/pipe/westman
	beltl = /obj/item/weapon/sickle
	beltr = /obj/item/weapon/knife/hunting
	l_hand = /obj/item/weapon/pitchfork
	backpack_contents = list(
		/obj/item/neuFarm/seed/wheat = 1,
		/obj/item/neuFarm/seed/apple = 1,
		/obj/item/neuFarm/seed/cabbage = 1,
		/obj/item/neuFarm/seed/potato = 1,
		/obj/item/neuFarm/seed/onion = 1,
		/obj/item/fertilizer/ash = 2,
		/obj/item/flint = 1,
		/obj/item/storage/belt/pouch/coins/mid = 1
	)