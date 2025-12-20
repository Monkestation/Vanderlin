/datum/migrant_role/bodyguard
	name = "Bodyguard"
	greet_text = "Many adventurers decide to strike it rich by raiding tombs, others band together to form mercenary companies. \
	You, however, have had the misfortune of slipping through many cracks. Instead of tainting your eternal soul by means of \
	murder, you've elected to taint it in self-defense. Find an employer, and make a use for yourself. Cut the middleman, \
	avoid working with any guilds."
	migrant_job = /datum/job/migrant/bodyguard

/datum/job/migrant/bodyguard
	title = "Bodyguard"
	tutorial = "Many adventurers decide to strike it rich by raiding tombs, others band together to form mercenary companies. \
	You, however, have had the misfortune of slipping through many cracks. Instead of tainting your eternal soul by means of \
	murder, you've elected to taint it in self-defense. Find an employer, and make a use for yourself. Cut the middleman, \
	avoid working with any guilds."
	outfit = /datum/outfit/bodyguard
	blacklisted_species = list(SPEC_ID_HALFLING)

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_CON = 3,
		STATKEY_SPD = -1,
	)

	skills = list(
		/datum/skill/combat/knives = 3,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 4,
		/datum/skill/misc/athletics = 4,
		/datum/skill/misc/climbing = 4,
		/datum/skill/misc/reading = 3,
		/datum/skill/misc/sewing = 2,
		/datum/skill/misc/medicine = 2,
	)

	traits = list(TRAIT_CRITICAL_RESISTANCE, TRAIT_NOPAINSTUN)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg'

/datum/outfit/bodyguard
	name = "Bodyguard"
	wrists = /obj/item/clothing/wrists/bracers/leather
	neck = /obj/item/clothing/neck/coif
	gloves = /obj/item/clothing/gloves/angle
	pants = /obj/item/clothing/pants/trou/leathertights
	shirt = /obj/item/clothing/shirt/tunic/colored/black
	armor = /obj/item/clothing/armor/leather/jacket/leathercoat/black
	shoes = /obj/item/clothing/shoes/nobleboot
	beltl = /obj/item/flashlight/flare/torch/lantern
	mask = /obj/item/clothing/face/spectacles/inqglasses
	beltr = /obj/item/weapon/knife/cleaver/combat
	belt = /obj/item/storage/belt/leather/steel
	backr = /obj/item/storage/backpack/satchel
	ring = /obj/item/clothing/ring/silver
	head = /obj/item/clothing/neck/keffiyeh/colored/black

/datum/migrant_wave/bodyguard
	name = "Bodyguard"
	max_spawns = 2
	shared_wave_type = /datum/migrant_wave/bodyguard
	weight = 10
	roles = list(
		/datum/migrant_role/bodyguard = 1,
	)
	greet_text = "A hired hand takes an empty seat, sliding an invoice across the table - a heavy knife embeds it into the wood."
