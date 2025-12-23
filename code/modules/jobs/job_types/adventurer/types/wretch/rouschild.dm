/datum/job/advclass/wretch/rouschild
	title = "Rouschild"
	tutorial = "A child of the sewers, abandoned at birth, you were taken in by a colony of rous and raised as one of their own."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/wretch/rouschild
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'
	total_positions = 2
	faction = FACTION_RATS

	jobstats = list(
		STATKEY_STR = 3,
		STATKEY_END = 2,
		STATKEY_CON = 2,
		STATKEY_INT = -3
	)

	skills = list(
		/datum/skill/combat/wrestling = 4,
		/datum/skill/combat/knives = 4,
		/datum/skill/combat/unarmed = 5,
		/datum/skill/craft/crafting = 2,
		/datum/skill/labor/farming = 2,
		/datum/skill/labor/fishing = 2,
		/datum/skill/labor/mathematics = 1,
		/datum/skill/misc/swimming = 3,
		/datum/skill/misc/reading = 1,
		/datum/skill/labor/taming = 4
	)

	traits = list(
		TRAIT_DARKVISION,
		TRAIT_DEADNOSE,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_NOPAINSTUN,
		TRAIT_STEELHEARTED,
		TRAIT_STRONGBITE,
		TRAIT_NASTY_EATER
	)

	spells = list(
		/datum/action/cooldown/spell/conjure/rous
	)


/datum/job/advclass/wretch/rouschild/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	wretch_select_bounty(spawned)

/datum/outfit/wretch/rouschild
	name = "Rouschild (Wretch)"
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/brown
	mask = /obj/item/clothing/face/shepherd
	armor = /obj/item/clothing/armor/leather/advanced
	pants = /obj/item/clothing/pants/trou/leather/advanced
	belt = /obj/item/storage/belt/leather/rope
	beltr = /obj/item/weapon/knife/hunting
	shoes = /obj/item/clothing/shoes/boots/leather/advanced
	wrists = /obj/item/rope/chain