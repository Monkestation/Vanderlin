/datum/migrant_role/escprisoner
	name = "Escaped Prisoner"
	greet_text = "You've been rotting for years in your rotted garbs, your atrophied body wasted on the cold, moist floors of \
	an oubliette. The years of abuse made you forget who you were, or what you did to deserve this punishment - but you were of \
	blue-blood, this is for certain. When your use faded, and when they brought you to the hangman to usher you to your final \
	destination, your last bit of strengh surged, and the man met his end with a cracked skull on your mask. The restraints, \
	too rusted to stay together, broke as you jumped into the river. The tiny voice you forgot you had echoed in the back of \
	your mind. 'I'm not going back.'"
	migrant_job = /datum/job/migrant/escprisoner

/datum/job/migrant/escprisoner
	title = "Escaped Prisoner"
	tutorial = "You've been rotting for years in your rotted garbs, your atrophied body wasted on the cold, moist floors of \
	an oubliette. The years of abuse made you forget who you were, or what you did to deserve this punishment - but you were of \
	blue-blood, this is for certain. When your use faded, and when they brought you to the hangman to usher you to your final \
	destination, your last bit of strengh surged, and the man met his end with a cracked skull on your mask. The restraints, \
	too rusted to stay together, broke as you jumped into the river. The tiny voice you forgot you had echoed in the back of \
	your mind. 'I'm not going back.'"
	outfit = /datum/outfit/escprisoner
	blacklisted_species = list(SPEC_ID_HALFLING)

	jobstats = list(
		STATKEY_CON = -2,
		STATKEY_END = -1,
		STATKEY_PER = 2,
		STATKEY_STR = 2,
	)

	skills = list(
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/bows = 3,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/reading = 2,
		/datum/skill/misc/climbing = 4,
		/datum/skill/misc/sneaking = 3,
		/datum/skill/craft/cooking = 1,
		/datum/skill/labor/butchering = 2,
		/datum/skill/labor/taming = 3,
		/datum/skill/craft/crafting = 2,
		/datum/skill/craft/tanning = 3,
	)

	traits = list(
		TRAIT_NOBLE,
		TRAIT_CRITICAL_RESISTANCE,
	)

	cmode_music = 'sound/music/cmode/towner/CombatPrisoner.ogg'

/datum/job/migrant/escprisoner/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	GLOB.outlawed_players |= spawned.real_name

/datum/outfit/escprisoner
	name = "Escaped Prisoner"
	pants = /obj/item/clothing/pants/loincloth/colored/brown
	mask = /obj/item/clothing/face/facemask/prisoner
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/brown
	belt = /obj/item/storage/belt/leather/rope
	beltl = /obj/item/weapon/knife/villager

/datum/migrant_wave/escprisoner
	name = "Escaped Prisoner"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/escprisoner
	weight = 8
	roles = list(
		/datum/migrant_role/escprisoner = 1,
	)
	greet_text = "A cloaked man sits in the farthest seat, smelling of blood. He looks terrified, he looks tired."
