/datum/migrant_role/dark_itinerant_knight
	name = "Drow Knight"
	greet_text = "You are an evil itinerant Knight, you have embarked alongside your squire on a voyage to engulf chaos within these lands."
	migrant_job = /datum/job/migrant/dark_itinerant_knight

/datum/job/migrant/dark_itinerant_knight
	title = "Drow Knight"
	tutorial = "You are an evil itinerant Knight, you have embarked alongside your squire on a voyage to engulf chaos within these lands."
	outfit = /datum/outfit/dark_itinerant_knight
	antag_role = /datum/antagonist/zizocultist/zizo_knight
	allowed_sexes = list(FEMALE)
	allowed_races = list(SPEC_ID_DROW)

	jobstats = list(
		STATKEY_STR = 3,
		STATKEY_PER = 1,
		STATKEY_INT = 3,
		STATKEY_CON = 2,
		STATKEY_END = 2,
		STATKEY_SPD = -1,
	)

	skills = list(
		/datum/skill/combat/polearms = 3,
		/datum/skill/combat/swords = 4,
		/datum/skill/combat/whipsflails = 4,
		/datum/skill/combat/axesmaces = 3,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/crossbows = 3,
		/datum/skill/combat/bows = 3,
		/datum/skill/misc/riding = 4,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 3,
		/datum/skill/labor/mathematics = 3,
		/datum/skill/misc/climbing = 1,
	)

	traits = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED)
	languages = list(/datum/language/undead)
	cmode_music = 'sound/music/cmode/antag/CombatThrall.ogg'

/datum/outfit/dark_itinerant_knight
	name = "Drow Knight"
	head = /obj/item/clothing/head/helmet/heavy/zizo
	gloves = /obj/item/clothing/gloves/plate/zizo
	pants = /obj/item/clothing/pants/platelegs/zizo
	shirt = /obj/item/clothing/shirt/shadowshirt
	armor = /obj/item/clothing/armor/plate/full/zizo
	shoes = /obj/item/clothing/shoes/boots/armor/zizo
	neck = /obj/item/clothing/neck/chaincoif
	beltl = /obj/item/flashlight/flare/torch/lantern
	belt = /obj/item/storage/belt/leather/steel
	backr = /obj/item/storage/backpack/satchel
	backl = /obj/item/weapon/sword/long/greatsword/zizo
	wrists = /obj/item/clothing/neck/psycross/zizo

/datum/migrant_role/dark_itinerant_squire
	name = "Underling Squire"
	greet_text = "You are the squire of an evil knight, they have taken you under their custody as you were the only one who didn't object to their dubious ethics."
	migrant_job = /datum/job/migrant/dark_itinerant_squire

/datum/job/migrant/dark_itinerant_squire
	title = "Underling Squire"
	tutorial = "You are the squire of an evil knight, they have taken you under their custody as you were the only one who didn't object to their dubious ethics."
	outfit = /datum/outfit/dark_itinerant_squire
	antag_role = /datum/antagonist/zizocultist/zizo_knight
	allowed_sexes = list(FEMALE)
	allowed_races = list(SPEC_ID_DROW, SPEC_ID_HALF_DROW)

	jobstats = list(
		STATKEY_PER = 2,
		STATKEY_CON = 2,
		STATKEY_INT = -1,
		STATKEY_SPD = 2,
	)

	skills = list(
		/datum/skill/combat/swords = 2,
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/bows = 2,
		/datum/skill/combat/crossbows = 2,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/riding = 1,
		/datum/skill/craft/weaponsmithing = 2,
		/datum/skill/craft/armorsmithing = 2,
	)

	traits = list(TRAIT_DODGEEXPERT)
	languages = list(/datum/language/undead)
	cmode_music = 'sound/music/cmode/antag/CombatThrall.ogg'

/datum/outfit/dark_itinerant_squire
	name = "Underling Squire"
	shirt = /obj/item/clothing/shirt/dress/gen/colored/black
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/ammo_holder/quiver/bolts
	armor = /obj/item/clothing/armor/leather/splint
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	gloves = /obj/item/clothing/gloves/leather
	wrists = /obj/item/clothing/wrists/bracers/leather
	backr = /obj/item/storage/backpack/satchel
	neck = /obj/item/clothing/neck/psycross/zizo

	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/clothing/neck/chaincoif = 1,
		/obj/item/weapon/hammer/iron = 1,
	)

/datum/migrant_wave/evil_knight
	name = "The Unknightly journey"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/evil_knight
	downgrade_wave = /datum/migrant_wave/evil_knight_down
	weight = 8
	roles = list(
		/datum/migrant_role/dark_itinerant_knight = 1,
		/datum/migrant_role/dark_itinerant_squire = 1,
	)
	greet_text = "These lands have insulted once more Zizo, you are here to remind them of her prowess."

/datum/migrant_wave/evil_knight_down
	name = "The Unknightly journey"
	shared_wave_type = /datum/migrant_wave/evil_knight
	can_roll = FALSE
	weight = 35
	roles = list(
		/datum/migrant_role/dark_itinerant_knight = 1,
	)
	greet_text = "These lands have insulted once more Zizo, you are here to remind them of her prowess."
