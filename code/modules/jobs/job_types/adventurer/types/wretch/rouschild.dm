/datum/attribute_holder/sheet/job/rouschild
	raw_attribute_list = list(
		STAT_STRENGTH = 3,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 2,
		STAT_INTELLIGENCE = -3,
		/datum/attribute/skill/combat/wrestling = 40,
		/datum/attribute/skill/combat/knives = 40,
		/datum/attribute/skill/combat/unarmed = 50,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/labor/farming = 20,
		/datum/attribute/skill/labor/fishing = 20,
		/datum/attribute/skill/labor/mathematics = 10,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/labor/taming = 40,
	)

/datum/job/advclass/wretch/rouschild
	title = "Rouschild"
	tutorial = "A child of the sewers, abandoned at birth, you were taken in by a colony of rous and raised as one of their own."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/wretch/rouschild
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'
	total_positions = 2
	faction = FACTION_RATS

	attribute_sheet = /datum/attribute_holder/sheet/job/rouschild

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
