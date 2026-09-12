/datum/spellcraft_contribution/fairydust
	atom_path = /obj/item/natural/fairydust
	form_points = list(
		FORM_EARTH = 1,
	)
	form_cost_multipliers = list(
		FORM_EARTH = 0.9,
		FORM_LIGHTNING = 1.2,
	)

/datum/spellcraft_contribution/earthdust
	atom_path = /obj/item/alch/earthdust
	form_points = list(
		FORM_EARTH = 1,
	)
	form_cast_speed_multipliers = list(
		FORM_EARTH = 1.1,
		FORM_LIGHTNING = 0.8,
	)

/datum/spellcraft_contribution/iridescentscale
	atom_path = /obj/item/natural/iridescentscale
	form_points = list(
		FORM_EARTH = 1,
	)
	form_magnitude_modifications = list(
		FORM_EARTH = 0.1,
		FORM_LIGHTNING = -0.1,
	)

/datum/spellcraft_contribution/heartwoodcore
	atom_path = /obj/item/natural/heartwoodcore
	form_points = list(
		FORM_EARTH = 2,
	)
	form_cost_multipliers = list(
		FORM_EARTH = 1.2,
		FORM_LIGHTNING = 1.2,
	)
	technique_points = list(
		TECHNIQUE_CREATION = 2,
	)

/datum/spellcraft_contribution/sylvanessence
	atom_path = /obj/item/natural/sylvanessence
	form_points = list(
		FORM_EARTH = 4,
	)
	form_cost_multipliers = list(
		FORM_EARTH = 1.4,
		FORM_LIGHTNING = 2,
	)
	technique_points = list(
		TECHNIQUE_CREATION = 2,
		TECHNIQUE_IMBUE = 1,
	)


/datum/spellcraft_contribution/stone
	atom_path = /obj/item/natural/stone
	form_cost_multipliers = list(
		FORM_EARTH = 0.95,
	)
	form_cast_speed_multipliers = list(
		FORM_EARTH = 1.05,
	)
	form_magnitude_modifications = list(
		FORM_EARTH = 0.05,
	)
