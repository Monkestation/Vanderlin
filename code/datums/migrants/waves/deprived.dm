/datum/migrant_role/deprived
	name = "Deprived" // challenge run
	greet_text = "You were once a highwayman, a monster of the road - but you have since ditched your sinful ways, leaving society behind in wake of your regrets. Nothing erases the past, and you can find absolution only in the catharsis of death. Let the wildlife shepherd your soul to Necra."
	migrant_job = /datum/job/migrant/deprived

/datum/attribute_holder/sheet/job/migrant/deprived
	raw_attribute_list = list(
		STAT_SPEED = -2,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/craft/tanning = 20,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/labor/fishing = 20,
	)

/datum/job/migrant/deprived
	title = "Deprived"
	tutorial = "You were once a highwayman, a monster of the road - but you have since ditched your sinful ways, leaving society behind in wake of your regrets. Nothing erases the past, and you can find absolution only in the catharsis of death. Let the wildlife shepherd your soul to Necra."
	outfit = /datum/outfit/deprived

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/deprived

	traits = list(TRAIT_CRITICAL_RESISTANCE)
	cmode_music = 'sound/music/cmode/towner/CombatPrisoner.ogg'

/datum/outfit/deprived
	name = "Deprived (Migrant Wave)"
	head = /obj/item/clothing/head/menacing
	pants = /obj/item/clothing/pants/trou
	shoes = /obj/item/clothing/shoes/simpleshoes
	belt = /obj/item/storage/belt/leather/rope
	beltl = /obj/item/weapon/knife/villager

/datum/migrant_wave/deprived
	name = "The Deprived"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/deprived
	weight = 8
	roles = list(
		/datum/migrant_role/deprived = 1,
	)
	greet_text = "Absolve yourself of sin, cast yourself away from society, and leave the travelers to their toils. Death and isolation grants you absolution."
