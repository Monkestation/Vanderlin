/datum/migrant_role/dark_itinerant_knight
	name = "Drow Knight"
	greet_text = "You are an evil itinerant Knight, you have embarked alongside your squire on a voyage to engulf chaos within these lands."
	migrant_job = /datum/job/migrant/dark_itinerant_knight

/datum/attribute_holder/sheet/job/migrant/dark_itinerant_knight
	raw_attribute_list = list(
		STAT_STRENGTH = 3,
		STAT_PERCEPTION = 1,
		STAT_INTELLIGENCE = 3,
		STAT_CONSTITUTION = 2,
		STAT_ENDURANCE = 2,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/whipsflails = 40,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/misc/riding = 40,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/labor/mathematics = 30,
		/datum/attribute/skill/misc/climbing = 10,
	)

/datum/job/migrant/dark_itinerant_knight
	title = "Drow Knight"
	tutorial = "You are an evil itinerant Knight, you have embarked alongside your squire on a voyage to engulf chaos within these lands."
	outfit = /datum/outfit/dark_itinerant_knight
	antag_role = /datum/antagonist/zizocultist/zizo_knight
	allowed_sexes = list(FEMALE)
	allowed_races = list(SPEC_ID_DROW)

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/dark_itinerant_knight

	traits = list(TRAIT_NOBLE_BLOOD, TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED)
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

/datum/attribute_holder/sheet/job/migrant/dark_itinerant_squire
	raw_attribute_list = list(
		STAT_PERCEPTION = 2,
		STAT_CONSTITUTION = 2,
		STAT_INTELLIGENCE = -1,
		STAT_SPEED = 2,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/combat/crossbows = 20,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/riding = 10,
		/datum/attribute/skill/craft/weaponsmithing = 20,
		/datum/attribute/skill/craft/armorsmithing = 20,
	)

/datum/job/migrant/dark_itinerant_squire
	title = "Underling Squire"
	tutorial = "You are the squire of an evil knight, they have taken you under their custody as you were the only one who didn't object to their dubious ethics."
	outfit = /datum/outfit/dark_itinerant_squire
	antag_role = /datum/antagonist/zizocultist/zizo_knight
	allowed_sexes = list(FEMALE)
	allowed_races = list(SPEC_ID_DROW, SPEC_ID_HALF_DROW)

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/dark_itinerant_squire

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
