
/datum/spellcraft_contribution/natural_feather
	atom_path = /obj/item/natural/feather
	form_points = list(FORM_AIR = 1)
	form_cast_speed_multipliers = list(FORM_AIR = 1.05)

/datum/spellcraft_contribution/natural_feather_infernal
	atom_path = /obj/item/natural/feather/infernal
	form_points = list(FORM_FIRE = 2)
	form_magnitude_modifications = list(FORM_AIR = 0.1)
	technique_points = list(TECHNIQUE_DESTRUCTION = 1)

/datum/spellcraft_contribution/natural_hide
	atom_path = /obj/item/natural/hide
	form_points = list(FORM_LIFE = 1)
	form_magnitude_modifications = list(FORM_EARTH = 0.05)

/datum/spellcraft_contribution/natural_hide_cured
	atom_path = /obj/item/natural/hide/cured
	form_points = list(FORM_LIFE = 1)
	form_cost_multipliers = list(FORM_LIFE = 1.1)
	technique_points = list(TECHNIQUE_RESTORATION = 1)

/datum/spellcraft_contribution/natural_cured
	atom_path = /obj/item/natural/cured
	form_points = list(FORM_LIFE = 1)
	technique_points = list(TECHNIQUE_RESTORATION = 1)

/datum/spellcraft_contribution/natural_cured_essence
	atom_path = /obj/item/natural/cured/essence
	form_points = list(FORM_LIFE = 2)
	form_magnitude_modifications = list(FORM_ARCANE = 0.1)
	technique_points = list(TECHNIQUE_RESTORATION = 2)

/datum/spellcraft_contribution/natural_fur
	atom_path = /obj/item/natural/fur
	form_points = list(FORM_LIFE = 1)

/datum/spellcraft_contribution/natural_fur_gote
	atom_path = /obj/item/natural/fur/gote
	form_points = list(FORM_LIFE = 1)
	form_magnitude_modifications = list(FORM_EARTH = 0.05)

/datum/spellcraft_contribution/natural_fur_volf
	atom_path = /obj/item/natural/fur/volf
	form_points = list(FORM_LIFE = 1)
	form_cast_speed_multipliers = list(FORM_AIR = 1.05)

/datum/spellcraft_contribution/natural_fur_mole
	atom_path = /obj/item/natural/fur/mole
	form_points = list(FORM_LIFE = 1)
	form_magnitude_modifications = list(FORM_EARTH = 0.1)

/datum/spellcraft_contribution/natural_fur_rous
	atom_path = /obj/item/natural/fur/rous
	form_points = list(FORM_LIFE = 2)
	form_cost_multipliers = list(FORM_LIFE = 1.1)

/datum/spellcraft_contribution/natural_fur_cabbit
	atom_path = /obj/item/natural/fur/cabbit
	form_points = list(FORM_LIFE = 1)
	technique_points = list(TECHNIQUE_ILLUSION = 1)

/datum/spellcraft_contribution/natural_fur_direbear
	atom_path = /obj/item/natural/fur/direbear
	form_points = list(FORM_LIFE = 2)
	form_magnitude_modifications = list(FORM_EARTH = 0.1)

/datum/spellcraft_contribution/natural_fur_fox
	atom_path = /obj/item/natural/fur/fox
	form_points = list(FORM_LIFE = 1)
	technique_points = list(TECHNIQUE_ILLUSION = 1)

/datum/spellcraft_contribution/natural_fur_raccoon
	atom_path = /obj/item/natural/fur/raccoon
	form_points = list(FORM_LIFE = 1)
	technique_points = list(TECHNIQUE_ALTERATION = 1)

/datum/spellcraft_contribution/natural_fur_bobcat
	atom_path = /obj/item/natural/fur/bobcat
	form_points = list(FORM_LIFE = 1)
	form_cast_speed_multipliers = list(FORM_AIR = 1.05)

/datum/spellcraft_contribution/natural_brick
	atom_path = /obj/item/natural/brick
	form_points = list(FORM_EARTH = 1)
	form_cost_multipliers = list(FORM_EARTH = 0.95)

/datum/spellcraft_contribution/natural_glass
	atom_path = /obj/item/natural/glass
	technique_cost_multipliers = list(TECHNIQUE_ILLUSION = 1.2)
	form_points = list(FORM_EARTH = 1)
	form_magnitude_modifications = list(FORM_FIRE = 0.05)
	technique_points = list(TECHNIQUE_ILLUSION = 1)

/datum/spellcraft_contribution/natural_poo
	atom_path = /obj/item/natural/poo
	include_subtypes = TRUE
	form_points = list(FORM_LIFE = 1)
	form_magnitude_modifications = list(FORM_EARTH = 0.05)

/datum/spellcraft_contribution/natural_worms
	atom_path = /obj/item/natural/worms
	form_points = list(FORM_LIFE = 1)
	form_magnitude_modifications = list(FORM_DEATH = 0.05)

/datum/spellcraft_contribution/natural_worms_leech
	atom_path = /obj/item/natural/worms/leech
	form_points = list(FORM_DEATH = 1)
	form_magnitude_modifications = list(FORM_LIFE = 0.05)

/datum/spellcraft_contribution/natural_worms_leech_parasite
	atom_path = /obj/item/natural/worms/leech/parasite
	form_points = list(FORM_DEATH = 2)
	technique_points = list(TECHNIQUE_DESTRUCTION = 1)

/datum/spellcraft_contribution/natural_worms_leech_abyssoid
	atom_path = /obj/item/natural/worms/leech/abyssoid
	form_points = list(FORM_DEATH = 2)
	form_magnitude_modifications = list(FORM_ARCANE = 0.15)
	technique_points = list(TECHNIQUE_SUMMONING = 1, TECHNIQUE_DESTRUCTION = 1)

/datum/spellcraft_contribution/natural_worms_grub_silk
	atom_path = /obj/item/natural/worms/grub_silk
	form_cast_speed_multipliers = list(FORM_LIFE = 0.9)
	form_points = list(FORM_LIFE = 1)
	form_cast_speed_multipliers = list(FORM_AIR = 1.05)

/datum/spellcraft_contribution/natural_teeth
	atom_path = /obj/item/natural/teeth
	form_cast_speed_multipliers = list(FORM_DEATH = 0.9)
	form_points = list(FORM_DEATH = 1)

/datum/spellcraft_contribution/natural_teeth_gold
	atom_path = /obj/item/natural/teeth/gold
	form_points = list(FORM_DEATH = 1)
	form_cost_multipliers = list(FORM_ARCANE = 1.1)
	form_magnitude_modifications = list(FORM_EARTH = 0.05)

/datum/spellcraft_contribution/natural_teeth_fang
	atom_path = /obj/item/natural/teeth/fang
	form_cost_multipliers = list(FORM_DEATH = 1.4)
	form_points = list(FORM_DEATH = 2)
