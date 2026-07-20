/datum/migrant_role/escprisoner
	name = "Escaped Prisoner"
	greet_text = "You've been rotting for years in your rotted garbs, your atrophied body wasted on the cold, moist floors of \
	an oubliette. The years of abuse made you forget who you were, or what you did to deserve this punishment - but you were of \
	blue-blood, this is for certain. When your use faded, and when they brought you to the hangman to usher you to your final \
	destination, your last bit of strengh surged, and the man met his end with a cracked skull on your mask. The restraints, \
	too rusted to stay together, broke as you jumped into the river. The tiny voice you forgot you had echoed in the back of \
	your mind. 'I'm not going back.'"
	migrant_job = /datum/job/migrant/escprisoner

/datum/attribute_holder/sheet/job/migrant/escprisoner
	raw_attribute_list = list(
		STAT_CONSTITUTION = -2,
		STAT_ENDURANCE = -1,
		STAT_PERCEPTION = 2,
		STAT_STRENGTH = 2,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/labor/butchering = 20,
		/datum/attribute/skill/labor/taming = 30,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/craft/tanning = 30,
	)

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

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/escprisoner

	traits = list(
		TRAIT_NOBLE_BLOOD,
		TRAIT_CRITICAL_RESISTANCE,
	)

	cmode_music = 'sound/music/cmode/towner/CombatPrisoner.ogg'

/datum/job/migrant/escprisoner/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	GLOB.outlawed_players |= spawned.real_name

/datum/outfit/escprisoner
	name = "Escaped Prisoner (Migrant Wave)"
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
