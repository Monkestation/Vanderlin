/datum/spellcraft_contribution/elementalmote
	atom_path = /obj/item/natural/elementalmote
	form_cost_multipliers = list(
		FORM_LIGHTNING = 0.9,
		FORM_WATER = 0.9,
		FORM_ICE = 0.9,
		FORM_AIR = 0.9,
		FORM_EARTH = 1.2,
	)

/datum/spellcraft_contribution/elementalshard
	atom_path = /obj/item/natural/elementalshard
	form_cast_speed_multipliers = list(
		FORM_LIGHTNING = 1.1,
		FORM_WATER = 1.1,
		FORM_ICE = 1.1,
		FORM_AIR = 1.1,
		FORM_EARTH = 0.8,
	)

/datum/spellcraft_contribution/elementalfragment
	atom_path = /obj/item/natural/elementalfragment
	form_magnitude_modifications = list(
		FORM_LIGHTNING = 0.1,
		FORM_WATER = 0.1,
		FORM_ICE = 0.1,
		FORM_AIR = 0.1,
		FORM_EARTH = -0.2,
	)

/datum/spellcraft_contribution/elementalrelic
	atom_path = /obj/item/natural/elementalrelic
	form_cost_multipliers = list(
		FORM_EARTH = 1.1,
		FORM_LIGHTNING = 1.1,
		FORM_WATER = 1.1,
		FORM_AIR = 1.1,
		FORM_ICE = 1.1,
	)
	technique_points = list(
		TECHNIQUE_ALTERATION = 2,
	)

/datum/spellcraft_contribution/airdust
	atom_path = /obj/item/alch/airdust
	form_points = list(
		FORM_AIR = 2,
	)

/datum/spellcraft_contribution/waterdust
	atom_path = /obj/item/alch/waterdust
	form_points = list(
		FORM_WATER = 2,
	)

/datum/spellcraft_contribution/seeddust
	atom_path = /obj/item/alch/seeddust
	form_points = list(
		FORM_LIFE = 2,
	)

/datum/spellcraft_contribution/feaudust
	atom_path = /obj/item/alch/feaudust
	form_points = list(
		FORM_DEATH = 2,
	)

/datum/spellcraft_contribution/magicdust
	atom_path = /obj/item/alch/magicdust
	form_points = list(
		FORM_ARCANE = 2,
	)

/datum/spellcraft_contribution/runedust
	atom_path = /obj/item/alch/runedust
	form_points = list(
		FORM_LIGHTNING = 2,
	)

/datum/spellcraft_contribution/swampdust
	atom_path = /obj/item/alch/swampdust
	form_points = list(
		FORM_ICE = 2,
	)
