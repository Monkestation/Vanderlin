/datum/spellcraft_contribution/voidstone
	atom_path = /obj/item/natural/voidstone

	technique_points = list(
		TECHNIQUE_DESTRUCTION = 2,
		TECHNIQUE_CREATION = 2,
		TECHNIQUE_ALTERATION = 2,
		TECHNIQUE_SUMMONING = 2,
		TECHNIQUE_RESTORATION = 2,
	)

/datum/spellcraft_contribution/bone
	atom_path = /obj/item/alch/bone

	form_cost_multipliers = list(
		FORM_DEATH = 0.9,
		FORM_LIFE = 1.2,
	)

/datum/spellcraft_contribution/riddleofsteel
	atom_path = /obj/item/riddleofsteel
	form_points = list(FORM_EARTH = 2)
	technique_points = list(TECHNIQUE_CREATION = 3, TECHNIQUE_DESTRUCTION = 2)

/datum/spellcraft_contribution/mimictrinket
	atom_path = /obj/item/mimictrinket
	form_points = list(FORM_ARCANE = 3)
	technique_points = list(TECHNIQUE_ILLUSION = 3, TECHNIQUE_SUMMONING = 1)

/datum/spellcraft_contribution/natural_leyline
	atom_path = /obj/item/natural/leyline
	form_points = list(FORM_ARCANE = 4)
	form_cost_multipliers = list(FORM_ARCANE = 1.4)
	technique_points = list(TECHNIQUE_CREATION = 2, TECHNIQUE_RESTORATION = 2)

/datum/spellcraft_contribution/natural_artifact
	atom_path = /obj/item/natural/artifact
	form_points = list(FORM_ARCANE = 3)
	form_cost_multipliers = list(FORM_ARCANE = 1.4)
	technique_points = list(TECHNIQUE_ALTERATION = 2, TECHNIQUE_IMBUE = 2)

/datum/spellcraft_contribution/corruptedheart
	atom_path = /obj/item/corruptedheart
	form_points = list(FORM_DEATH = 3)
	form_magnitude_modifications = list(FORM_ARCANE = 0.15)
	technique_points = list(TECHNIQUE_DESTRUCTION = 2, TECHNIQUE_IMBUE = 1)

/datum/spellcraft_contribution/deepone_artifact
	atom_path = /obj/item/deepone_artifact
	form_points = list(FORM_WATER = 3)
	form_magnitude_modifications = list(FORM_ARCANE = 0.15)
	technique_points = list(TECHNIQUE_SUMMONING = 2, TECHNIQUE_ILLUSION = 1)
