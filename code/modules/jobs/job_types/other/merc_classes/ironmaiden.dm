/datum/job/advclass/mercenary/ironmaiden
	title = "Iron Maiden"
	tutorial = "You're a battlefield medic and have forsaken the blade for the scalpel. \
	Your vile apperance has been hidden under layers of steel, allowing you to ply your trade to all those who have the coin."
	allowed_races = list(SPEC_ID_MEDICATOR)
	outfit = /datum/outfit/mercenary/ironmaiden
	category_tags = list(CTAG_MERCENARY)
	total_positions = 5

	cmode_music = 'sound/music/cmode/adventurer/CombatDream.ogg' // Medicators are from the isle of Enigma, they're loosely related to Heartfelt
	exp_types_granted = list(EXP_TYPE_MERCENARY, EXP_TYPE_COMBAT, EXP_TYPE_MEDICAL)

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_END = 2,
		STATKEY_INT = 2
	)

	skills = list(
		/datum/skill/combat/knives = 1,
		/datum/skill/misc/medicine = 4,
		/datum/skill/misc/sewing = 3,
		/datum/skill/misc/reading = 3, // Using the higher value (3) since there were two entries with different values
		/datum/skill/combat/wrestling = 3,
		/datum/skill/craft/crafting = 2,
		/datum/skill/craft/alchemy = 2,
		/datum/skill/labor/mathematics = 3
	)

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_HEAVYARMOR,
		TRAIT_DEADNOSE,
		TRAIT_STEELHEARTED
	)

/datum/job/advclass/mercenary/ironmaiden/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.merctype = 9

/datum/outfit/mercenary/ironmaiden
	name = "Iron Maiden (Mercenary)"
	head = /obj/item/clothing/head/helmet/sallet
	mask = /obj/item/clothing/face/facemask/steel
	neck = /obj/item/clothing/neck/gorget
	wrists = /obj/item/clothing/wrists/bracers
	armor = /obj/item/clothing/armor/plate/full
	shirt = /obj/item/clothing/armor/chainmail
	gloves = /obj/item/clothing/gloves/plate
	belt = /obj/item/storage/belt/leather/mercenary
	backl = /obj/item/storage/backpack/satchel
	backr = /obj/item/storage/backpack/satchel/surgbag
	beltr = /obj/item/weapon/knife/dagger/steel
	beltl = /obj/item/weapon/knife/cleaver
	pants = /obj/item/clothing/pants/platelegs
	shoes = /obj/item/clothing/shoes/boots/armor
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1
	)
