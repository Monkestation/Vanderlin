/datum/spellcraft_contribution/ore_gold
	atom_path = /obj/item/ore/gold
	form_points = list(FORM_EARTH = 1)
	form_cost_multipliers = list(FORM_ARCANE = 1.1)

/datum/spellcraft_contribution/ore_silver
	atom_path = /obj/item/ore/silver
	form_points = list(FORM_EARTH = 1)
	form_cast_speed_multipliers = list(FORM_ICE = 1.05)

/datum/spellcraft_contribution/ore_iron
	atom_path = /obj/item/ore/iron
	form_points = list(FORM_EARTH = 2)

/datum/spellcraft_contribution/ore_copper
	atom_path = /obj/item/ore/copper
	form_points = list(FORM_EARTH = 1)
	form_cast_speed_multipliers = list(FORM_LIGHTNING = 1.05)

/datum/spellcraft_contribution/ore_tin
	atom_path = /obj/item/ore/tin
	form_points = list(FORM_EARTH = 1)
	form_cast_speed_multipliers = list(FORM_AIR = 1.05)

/datum/spellcraft_contribution/ore_coal
	atom_path = /obj/item/ore/coal
	form_points = list(FORM_EARTH = 1)
	form_magnitude_modifications = list(FORM_FIRE = 0.1)

/datum/spellcraft_contribution/ore_coal_charcoal
	atom_path = /obj/item/ore/coal/charcoal
	form_points = list(FORM_FIRE = 2)
	form_cost_multipliers = list(FORM_FIRE = 1.1)

/datum/spellcraft_contribution/ore_cinnabar
	atom_path = /obj/item/ore/cinnabar
	form_points = list(FORM_FIRE = 1)
	form_magnitude_modifications = list(FORM_ARCANE = 0.1)

/datum/spellcraft_contribution/ore_bloodstone
	atom_path = /obj/item/ore/bloodstone
	form_points = list(FORM_BLOOD = 1)
	form_magnitude_modifications = list(FORM_BLOOD = 0.1)

/datum/spellcraft_contribution/ore_dust_gold
	atom_path = /obj/item/ore/dust/gold
	form_cost_multipliers = list(FORM_ARCANE = 0.95)
	form_magnitude_modifications = list(FORM_EARTH = 0.05)

/datum/spellcraft_contribution/ore_dust_silver
	atom_path = /obj/item/ore/dust/silver
	form_cost_multipliers = list(FORM_ICE = 0.95)
	form_magnitude_modifications = list(FORM_EARTH = 0.05)

/datum/spellcraft_contribution/ore_dust_iron
	atom_path = /obj/item/ore/dust/iron
	form_cost_multipliers = list(FORM_EARTH = 0.95)
	form_cast_speed_multipliers = list(FORM_EARTH = 1.05)

/datum/spellcraft_contribution/ore_dust_copper
	atom_path = /obj/item/ore/dust/copper
	form_cost_multipliers = list(FORM_LIGHTNING = 0.95)
	form_cast_speed_multipliers = list(FORM_LIGHTNING = 1.05)

/datum/spellcraft_contribution/ore_dust_tin
	atom_path = /obj/item/ore/dust/tin
	form_cost_multipliers = list(FORM_AIR = 0.95)
	form_cast_speed_multipliers = list(FORM_AIR = 1.05)

/datum/spellcraft_contribution/ore_dust_bloodstone
	atom_path = /obj/item/ore/dust/bloodstone
	form_cost_multipliers = list(FORM_BLOOD = 0.95)
	form_cast_speed_multipliers = list(FORM_BLOOD = 1.05)

/datum/spellcraft_contribution/ingot_gold
	atom_path = /obj/item/ingot/gold
	form_points = list(FORM_EARTH = 1)
	form_cost_multipliers = list(FORM_ARCANE = 1.1)

/datum/spellcraft_contribution/ingot_iron
	atom_path = /obj/item/ingot/iron
	form_points = list(FORM_EARTH = 2)
	form_cost_multipliers = list(FORM_EARTH = 1.1)

/datum/spellcraft_contribution/ingot_thaumic
	atom_path = /obj/item/ingot/thaumic
	form_points = list(FORM_ARCANE = 3)
	form_cost_multipliers = list(FORM_ARCANE = 1.3)
	technique_points = list(TECHNIQUE_ALTERATION = 1)

/datum/spellcraft_contribution/ingot_copper
	atom_path = /obj/item/ingot/copper
	form_points = list(FORM_EARTH = 1)
	form_cast_speed_multipliers = list(FORM_LIGHTNING = 1.1)

/datum/spellcraft_contribution/ingot_tin
	atom_path = /obj/item/ingot/tin
	form_points = list(FORM_EARTH = 1)
	form_cast_speed_multipliers = list(FORM_AIR = 1.05)

/datum/spellcraft_contribution/ingot_bronze
	atom_path = /obj/item/ingot/bronze
	form_points = list(FORM_EARTH = 2)
	form_magnitude_modifications = list(FORM_FIRE = 0.1)

/datum/spellcraft_contribution/ingot_silver
	atom_path = /obj/item/ingot/silver
	form_points = list(FORM_EARTH = 1)
	form_cast_speed_multipliers = list(FORM_ICE = 1.05)
	technique_points = list(TECHNIQUE_RESTORATION = 1)

/datum/spellcraft_contribution/ingot_steel
	atom_path = /obj/item/ingot/steel
	form_points = list(FORM_EARTH = 2)
	form_cost_multipliers = list(FORM_EARTH = 1.15)

/datum/spellcraft_contribution/ingot_steelholy
	atom_path = /obj/item/ingot/steelholy
	form_points = list(FORM_EARTH = 2)
	form_magnitude_modifications = list(FORM_LIFE = 0.1)
	technique_points = list(TECHNIQUE_RESTORATION = 2)

/datum/spellcraft_contribution/ingot_silverblessed
	atom_path = /obj/item/ingot/silverblessed
	form_points = list(FORM_LIFE = 2)
	form_cast_speed_multipliers = list(FORM_ICE = 1.05)
	technique_points = list(TECHNIQUE_RESTORATION = 2)

/datum/spellcraft_contribution/ingot_blacksteel
	atom_path = /obj/item/ingot/blacksteel
	form_points = list(FORM_EARTH = 2)
	form_magnitude_modifications = list(FORM_DEATH = 0.15)
	technique_points = list(TECHNIQUE_DESTRUCTION = 2)

/datum/spellcraft_contribution/ingot_steel_slag
	atom_path = /obj/item/ingot/steel_slag
	form_points = list(FORM_EARTH = 1)
	form_magnitude_modifications = list(FORM_FIRE = 0.05)

/datum/spellcraft_contribution/ingot_aalloy
	atom_path = /obj/item/ingot/aalloy
	form_points = list(FORM_EARTH = 2)
	form_magnitude_modifications = list(FORM_ARCANE = 0.1)

/datum/spellcraft_contribution/ingot_purifiedaalloy
	atom_path = /obj/item/ingot/purifiedaalloy
	form_points = list(FORM_ARCANE = 3)
	form_cost_multipliers = list(FORM_ARCANE = 1.3)
	technique_points = list(TECHNIQUE_ALTERATION = 2)

/datum/spellcraft_contribution/ingot_aaslag
	atom_path = /obj/item/ingot/aaslag
	form_points = list(FORM_EARTH = 1)
	form_magnitude_modifications = list(FORM_ARCANE = 0.05)

/datum/spellcraft_contribution/ingot_weeping
	atom_path = /obj/item/ingot/weeping
	form_points = list(FORM_WATER = 2)
	form_magnitude_modifications = list(FORM_DEATH = 0.1)
	technique_points = list(TECHNIQUE_RESTORATION = 1)

/datum/spellcraft_contribution/ingot_draconic
	atom_path = /obj/item/ingot/draconic
	form_points = list(FORM_FIRE = 3)
	form_magnitude_modifications = list(FORM_ARCANE = 0.15)
	technique_points = list(TECHNIQUE_DESTRUCTION = 2, TECHNIQUE_IMBUE = 1)

/datum/spellcraft_contribution/ingot_avantyne
	atom_path = /obj/item/ingot/avantyne
	form_points = list(FORM_AIR = 2)
	form_magnitude_modifications = list(FORM_ARCANE = 0.1)

/datum/spellcraft_contribution/ingot_ketryl
	atom_path = /obj/item/ingot/ketryl
	form_points = list(FORM_LIGHTNING = 2)
	form_magnitude_modifications = list(FORM_ARCANE = 0.1)

/datum/spellcraft_contribution/ingot_lithmyc
	atom_path = /obj/item/ingot/lithmyc
	form_points = list(FORM_ICE = 2)
	form_magnitude_modifications = list(FORM_ARCANE = 0.1)

/datum/spellcraft_contribution/ingot_component_glutcrystal
	atom_path = /obj/item/ingot/component/glutcrystal
	form_points = list(FORM_ARCANE = 2)
	technique_points = list(TECHNIQUE_CREATION = 1)

/datum/spellcraft_contribution/ingot_component_threadavantyne
	atom_path = /obj/item/ingot/component/threadavantyne
	form_points = list(FORM_AIR = 1)
	technique_points = list(TECHNIQUE_CREATION = 1)

/datum/spellcraft_contribution/ingot_component_threadketryl
	atom_path = /obj/item/ingot/component/threadketryl
	form_points = list(FORM_LIGHTNING = 1)
	technique_points = list(TECHNIQUE_CREATION = 1)

/datum/spellcraft_contribution/ingot_component_zizo
	atom_path = /obj/item/ingot/component/zizo
	form_points = list(FORM_ARCANE = 2)
	technique_points = list(TECHNIQUE_SUMMONING = 1)

/datum/spellcraft_contribution/ingot_component_graggar
	atom_path = /obj/item/ingot/component/graggar
	form_points = list(FORM_EARTH = 2)
	technique_points = list(TECHNIQUE_CREATION = 1)

/datum/spellcraft_contribution/ingot_component_matthios
	atom_path = /obj/item/ingot/component/matthios
	form_points = list(FORM_LIFE = 2)
	technique_points = list(TECHNIQUE_RESTORATION = 1)

/datum/spellcraft_contribution/ingot_component_baotha
	atom_path = /obj/item/ingot/component/baotha
	form_points = list(FORM_WATER = 2)
	technique_points = list(TECHNIQUE_CREATION = 1)

/datum/spellcraft_contribution/quicksilver
	atom_path = /obj/item/quicksilver
	form_points = list(FORM_ARCANE = 2)
	form_magnitude_modifications = list(FORM_WATER = 0.1)
	technique_points = list(TECHNIQUE_ILLUSION = 1)

/datum/spellcraft_contribution/ingot_bloodsteel
	atom_path = /obj/item/ingot/bloodsteel
	form_points = list(FORM_BLOOD = 2)
	form_magnitude_modifications = list(FORM_BLOOD = 0.1)
