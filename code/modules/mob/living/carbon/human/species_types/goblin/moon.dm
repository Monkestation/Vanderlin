/datum/attribute_holder/sheet/job/goblin/moon
	attribute_variance = list(
		STAT_STRENGTH = list(-4, 0),
		STAT_PERCEPTION = list(-5, 0),
		STAT_INTELLIGENCE = list(-5, -2),
		STAT_CONSTITUTION = list(-6, -2),
		STAT_ENDURANCE = list(-2, 2),
		STAT_SPEED = list(2, 8),
	)
	raw_attribute_list = list(
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/polearms = 10,
		/datum/attribute/skill/combat/knives = 10,
		/datum/attribute/skill/combat/axesmaces = 10,
		/datum/attribute/skill/combat/swords = 10,
	)

/datum/species/goblin/moon
	id = "goblin_moon"
	raceicon = "goblin_moon"
	statsheet_male = /datum/attribute_holder/sheet/job/goblin/moon

/datum/species/goblin/moon/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	C.add_spell(/datum/action/cooldown/spell/undirected/conjure_item/brick)

/datum/species/goblin/moon/spec_death(gibbed, mob/living/carbon/human/H)
	new /obj/item/reagent_containers/powder/moondust_purest(get_turf(H))
	H.visible_message("<span class='blue'>Moondust falls from [H]!</span>")
