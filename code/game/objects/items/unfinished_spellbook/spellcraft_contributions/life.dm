/datum/spellcraft_contribution/bait
	atom_path = /obj/item/bait
	form_points = list(FORM_LIFE = 1)
	form_magnitude_modifications = list(FORM_LIFE = 0.05)

/datum/spellcraft_contribution/bait_sweet
	atom_path = /obj/item/bait/sweet
	form_points = list(FORM_LIFE = 1)
	form_cost_multipliers = list(FORM_LIFE = 0.9)
	form_cast_speed_multipliers = list(FORM_LIFE = 1.05)

/datum/spellcraft_contribution/bait_bloody
	atom_path = /obj/item/bait/bloody
	form_points = list(FORM_LIFE = 1)
	form_magnitude_modifications = list(FORM_DEATH = 0.1)
	technique_points = list(TECHNIQUE_SUMMONING = 1)

/datum/spellcraft_contribution/bait_greasy
	atom_path = /obj/item/bait/greasy
	form_points = list(FORM_LIFE = 1)
	form_cast_speed_multipliers = list(FORM_LIFE = 1.1)
	form_cost_multipliers = list(FORM_FIRE = 0.9)

/datum/spellcraft_contribution/bait_forestdelight
	atom_path = /obj/item/bait/forestdelight
	form_points = list(FORM_LIFE = 2)
	form_cost_multipliers = list(FORM_LIFE = 1.1)
	technique_points = list(TECHNIQUE_SUMMONING = 1)
