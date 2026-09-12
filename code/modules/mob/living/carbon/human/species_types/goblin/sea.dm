/datum/attribute_holder/sheet/job/goblin/sea
	attribute_variance = list(
		STAT_STRENGTH = list(-4, 0),
		STAT_PERCEPTION = list(-5, 0),
		STAT_INTELLIGENCE = list(-3, 0),
		STAT_CONSTITUTION = list(-6, -2),
		STAT_ENDURANCE = list(0, 4),
		STAT_SPEED = list(-2, 4),
	)
	raw_attribute_list = list(
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/polearms = 10,
		/datum/attribute/skill/combat/knives = 10,
		/datum/attribute/skill/combat/axesmaces = 10,
		/datum/attribute/skill/combat/swords = 10,
	)

/datum/species/goblin/sea
	raceicon = "goblin_sea"
	id = "goblin_sea"
	statsheet_male = /datum/attribute_holder/sheet/job/goblin/sea
	species_traits = list(
		TRAIT_SWIMMER,
	)
