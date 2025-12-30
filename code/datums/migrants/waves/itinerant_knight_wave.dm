/datum/migrant_role/itinerant_knight
	name = "Itinerant Knight"
	greet_text = "You are an itinerant Knight, you have embarked alongside your squire on a voyage to fulfill your knightly vows."
	migrant_job = /datum/job/migrant/itinerant_knight

/datum/job/migrant/itinerant_knight
	title = "Itinerant Knight"
	tutorial = "You are an itinerant Knight, you have embarked alongside your squire on a voyage to fulfill your knightly vows."
	outfit = /datum/outfit/itinerant_knight
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	exp_types_granted  = list(EXP_TYPE_COMBAT)
	jobstats = list(
		STATKEY_STR = 3,
		STATKEY_PER = 2,
		STATKEY_INT = 3,
		STATKEY_CON = 4,
		STATKEY_END = 3,
		STATKEY_SPD = -2,
	)

	skills = list(
		/datum/skill/combat/polearms = 4,
		/datum/skill/combat/swords = 4,
		/datum/skill/combat/whipsflails = 4,
		/datum/skill/combat/axesmaces = 4,
		/datum/skill/combat/wrestling = 4,
		/datum/skill/combat/unarmed = 4,
		/datum/skill/combat/crossbows = 3,
		/datum/skill/combat/bows = 3,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/climbing = 1,
		/datum/skill/misc/reading = 3,
		/datum/skill/misc/riding = 4,
		/datum/skill/labor/mathematics = 3,
	)

	traits = list(
		TRAIT_NOBLE,
		TRAIT_NOSEGRAB,
		TRAIT_HEAVYARMOR,
		TRAIT_STEELHEARTED,
	)
	cmode_music = 'sound/music/cmode/nobility/CombatKnight.ogg'
	voicepack_m = /datum/voicepack/male/knight

/datum/job/migrant/itinerant_knight/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/prev_real_name = spawned.real_name
	var/prev_name = spawned.name
	var/honorary = "Itinerant Knight"
	spawned.real_name = "[honorary] [prev_real_name]"
	spawned.name = "[honorary] [prev_name]"

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

/datum/job/migrant/itinerant_squire
	title = "Itinerant Squire"
	tutorial = "You are the squire of an itinerant knight, they have taken you under their custody as you have shown great talents, if you keep it on, you might become a knight yourself."
	outfit = /datum/outfit/itinerant_squire
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	allowed_ages = list(AGE_CHILD, AGE_ADULT)
	exp_types_granted  = list(EXP_TYPE_COMBAT)
	jobstats = list(
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_INT = 1,
		STATKEY_SPD = 2,
	)

	skills = list(
		/datum/skill/combat/bows = 2,
		/datum/skill/combat/crossbows = 2,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/combat/swords = 2,
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/riding = 1,
		/datum/skill/craft/weaponsmithing = 2,
		/datum/skill/craft/armorsmithing = 2,
	)

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
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
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
