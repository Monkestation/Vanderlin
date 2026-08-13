/datum/physiology_modifier/species
	id = "species"
	variable = TRUE
	priority = 0

/datum/physiology_modifier/species/applies_to(datum/physiology/holder)
	return TRUE

/datum/physiology_modifier/species/halfling
	hunger_mod = 2

/datum/physiology_modifier/species/horc
	hunger_mod = 2
	hygiene_mod = 1.5

/datum/physiology_modifier/species/medicator
	hygiene_mod = 1.25

/datum/physiology_modifier/species/werewolf
	bleed_mod = 0.6
	pain_mod = 0.2

/datum/physiology_modifier/species/automaton
	bleed_mod = 0.7

/datum/physiology_modifier/species/aasimar
	bleed_mod = 0.8
	pain_mod = 0.9
