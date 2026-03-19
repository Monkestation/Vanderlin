/datum/migrant_role/itinerant_knight
	name = "Itinerant Knight"
	greet_text = "You are an itinerant Knight, you have embarked alongside your squire on a voyage to fulfill your knightly vows."
	migrant_job = /datum/job/migrant/itinerant_knight

/datum/attribute_holder/sheet/job/migrant/itinerant_knight
	raw_attribute_list = list(
		STAT_STRENGTH = 3,
		STAT_PERCEPTION = 2,
		STAT_INTELLIGENCE = 1,
		STAT_CONSTITUTION = 2,
		STAT_ENDURANCE = 3,
		STAT_SPEED = -2,
		/datum/attribute/skill/combat/polearms = 40,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/whipsflails = 40,
		/datum/attribute/skill/combat/axesmaces = 40,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 40,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/misc/riding = 40,
		/datum/attribute/skill/labor/mathematics = 30,
	)

/datum/job/migrant/itinerant_knight
	title = "Itinerant Knight"
	tutorial = "You are an itinerant Knight, you have embarked alongside your squire on a voyage to fulfill your knightly vows."
	outfit = /datum/outfit/itinerant_knight
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	exp_types_granted  = list(EXP_TYPE_COMBAT)

	honorary = "Sir"
	honorary_f = "Dame"

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/itinerant_knight

	traits = list(
		TRAIT_NOBLE_BLOOD,
		TRAIT_NOBLE_POWER,
		TRAIT_NOSEGRAB,
		TRAIT_HEAVYARMOR,
		TRAIT_STEELHEARTED,
	)
	cmode_music = 'sound/music/cmode/nobility/CombatKnight.ogg'
	voicepack_m = /datum/voicepack/male/knight

/datum/outfit/itinerant_knight
	name = "Itinerant Knight (Migrant Wave)"
	head = /obj/item/clothing/head/helmet/visored/sallet
	wrists = /obj/item/clothing/wrists/bracers
	gloves = /obj/item/clothing/gloves/plate
	pants = /obj/item/clothing/pants/platelegs
	neck = /obj/item/clothing/neck/chaincoif
	shirt = /obj/item/clothing/armor/chainmail
	armor = /obj/item/clothing/armor/plate/full
	shoes = /obj/item/clothing/shoes/boots/armor
	beltl = /obj/item/flashlight/flare/torch/lantern
	belt = /obj/item/storage/belt/leather/steel
	backr = /obj/item/storage/backpack/satchel
	backl = /obj/item/weapon/sword/long/greatsword
	backpack_contents = list(
		/obj/item/clothing/neck/psycross/silver = 1,
		/obj/item/weapon/knife/dagger/steel = 1,
		/obj/item/storage/belt/pouch/coins/mid = 1,
	)

/datum/migrant_role/itinerant_squire
	name = "Itinerant Squire"
	greet_text = "You are the squire of an itinerant knight, they have taken you under their custody as you have shown great talents, if you keep it on, you might become a knight yourself."
	migrant_job = /datum/job/migrant/itinerant_squire

/datum/attribute_holder/sheet/job/migrant/itinerant_squire
	raw_attribute_list = list(
		STAT_PERCEPTION = 1,
		STAT_CONSTITUTION = 1,
		STAT_INTELLIGENCE = 1,
		STAT_SPEED = 2,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/combat/crossbows = 20,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/riding = 10,
		/datum/attribute/skill/craft/weaponsmithing = 20,
		/datum/attribute/skill/craft/armorsmithing = 20,
	)

/datum/job/migrant/itinerant_squire
	title = "Itinerant Squire"
	tutorial = "You are the squire of an itinerant knight, they have taken you under their custody as you have shown great talents, if you keep it on, you might become a knight yourself."
	outfit = /datum/outfit/itinerant_squire
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	allowed_ages = list(AGE_CHILD, AGE_ADULT)
	exp_types_granted  = list(EXP_TYPE_COMBAT)

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/itinerant_squire

	traits = list(TRAIT_DODGEEXPERT)
	cmode_music = 'sound/music/cmode/garrison/CombatGarrison.ogg'
	voicepack_m = /datum/voicepack/male/squire

/datum/outfit/itinerant_squire
	name = "Itinerant Squire (Migrant Wave)"
	shirt = /obj/item/clothing/shirt/dress/gen/colored/black
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/ammo_holder/quiver/arrows
	armor = /obj/item/clothing/armor/leather/splint
	backl = /obj/item/gun/ballistic/bow/short
	gloves = /obj/item/clothing/gloves/leather
	wrists = /obj/item/clothing/wrists/bracers/leather
	backr = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/clothing/neck/chaincoif = 1,
		/obj/item/weapon/hammer/iron = 1,
	)

/datum/migrant_wave/knight
	name = "The Knightly Journey"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/knight
	downgrade_wave = /datum/migrant_wave/knight_down
	weight = 10
	roles = list(
		/datum/migrant_role/itinerant_knight = 1,
		/datum/migrant_role/itinerant_squire = 1,
	)
	greet_text = "The weight of Psydon's cross is heavy, the vows you have undertaken heavier, a Knight and their squire have taken to the road to fulfill them."

/datum/migrant_wave/knight_down
	name = "The Knightly Journey"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/knight
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/itinerant_knight = 1,
	)
	greet_text = "The weight of Psydon's cross is heavy, the vows you have undertaken heavier, a Knight has taken to the road to fulfill them."
