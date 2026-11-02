/datum/attribute_holder/sheet/job/goblin/cave
	attribute_variance = list(
		STAT_STRENGTH = list(-4, 0),
		STAT_PERCEPTION = list(1, 6),
		STAT_INTELLIGENCE = list(-9, -6),
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

/datum/species/goblin/cave
	id = "goblin_cave"
	raceicon = "goblin_cave"
	statsheet_male = /datum/attribute_holder/sheet/job/goblin/cave

/datum/species/goblin/cave/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	C.add_spell(/datum/action/cooldown/spell/burrow)

/datum/species/goblin/cave/on_species_loss(mob/living/carbon/C)
	. = ..()
	C.remove_spell(/datum/action/cooldown/spell/burrow)
