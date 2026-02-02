/datum/essence_combo/spell/flame_jet
	name = "Flame Jet"
	required_essences = list(/datum/thaumaturgical_essence/fire, /datum/thaumaturgical_essence/air)
	granted_spells = list(/datum/action/cooldown/spell/essence/flame_jet)

/datum/essence_combo/spell/mud_shaping
	name = "Mud Shaping"
	required_essences = list(/datum/thaumaturgical_essence/water, /datum/thaumaturgical_essence/earth)
	granted_spells = list(/datum/action/cooldown/spell/essence/mud_shape, /datum/action/cooldown/spell/essence/fertile_soil)

/datum/essence_combo/spell/ice_mastery
	name = "Ice Mastery"
	required_essences = list(/datum/thaumaturgical_essence/frost, /datum/thaumaturgical_essence/water)
	granted_spells = list(/datum/action/cooldown/spell/essence/ice_bridge, /datum/action/cooldown/spell/essence/frozen_storage)

/datum/essence_combo/spell/healing_spring
	name = "Healing Spring"
	required_essences = list(/datum/thaumaturgical_essence/life, /datum/thaumaturgical_essence/water)
	granted_spells = list(/datum/action/cooldown/spell/essence/healing_spring, /datum/action/cooldown/spell/essence/purify_water)

/datum/essence_combo/spell/crystal_mastery
	name = "Crystal Mastery"
	required_essences = list(/datum/thaumaturgical_essence/earth, /datum/thaumaturgical_essence/crystal)
	granted_spells = list(/datum/action/cooldown/spell/essence/gem_growth)

/datum/essence_combo/spell/wind_step
	name = "Wind Step"
	required_essences = list(/datum/thaumaturgical_essence/motion, /datum/thaumaturgical_essence/air)
	granted_spells = list(/datum/action/cooldown/spell/essence/wind_step, /datum/action/cooldown/spell/essence/aerial_dash)

/datum/essence_combo/spell/divine_order
	name = "Divine Order"
	required_essences = list(/datum/thaumaturgical_essence/order, /datum/thaumaturgical_essence/light)
	granted_spells = list(/datum/action/cooldown/spell/essence/divine_order)

/datum/essence_combo/spell/reality_shift
	name = "Reality Shift"
	required_essences = list(/datum/thaumaturgical_essence/chaos, /datum/thaumaturgical_essence/void)
	granted_spells = list(/datum/action/cooldown/spell/essence/reality_shift, /datum/action/cooldown/spell/essence/probability_warp)

/datum/essence_combo/spell/toxic_cleanse
	name = "Toxic Cleanse"
	required_essences = list(/datum/thaumaturgical_essence/poison, /datum/thaumaturgical_essence/water)
	granted_spells = list(/datum/action/cooldown/spell/essence/toxic_cleanse)

/datum/essence_combo/spell/arcane_focus
	name = "Arcane Focus"
	required_essences = list(/datum/thaumaturgical_essence/magic, /datum/thaumaturgical_essence/crystal)
	granted_spells = list(/datum/action/cooldown/spell/essence/spell_crystal, /datum/action/cooldown/spell/essence/arcane_focus)

/datum/essence_combo/spell/kinetic_burst
	name = "Kinetic Burst"
	required_essences = list(/datum/thaumaturgical_essence/energia, /datum/thaumaturgical_essence/motion)
	granted_spells = list(/datum/action/cooldown/spell/essence/kinetic_burst, /datum/action/cooldown/spell/essence/momentum_transfer)

/datum/essence_combo/spell/regeneration_cycle
	name = "Regeneration Cycle"
	required_essences = list(/datum/thaumaturgical_essence/cycle, /datum/thaumaturgical_essence/life)
	granted_spells = list(/datum/action/cooldown/spell/essence/regeneration_cycle, /datum/action/cooldown/spell/essence/growth_acceleration)

// Racial Spell Combos
/datum/essence_combo/spell/dwarven_brewing
	name = "Dwarven Brewing"
	required_essences = list(/datum/thaumaturgical_essence/earth, /datum/thaumaturgical_essence/water)
	granted_spells = list(/datum/action/cooldown/spell/essence/create_beer)
	required_race = "dwarf"

/datum/essence_combo/spell/master_forge
	name = "Master Forge"
	required_essences = list(/datum/thaumaturgical_essence/fire, /datum/thaumaturgical_essence/earth)
	granted_spells = list(/datum/action/cooldown/spell/essence/master_forge, /datum/action/cooldown/spell/essence/ancestral_smithing)
	required_race = "dwarf"

/datum/essence_combo/spell/elven_grace
	name = "Elven Grace"
	required_essences = list(/datum/thaumaturgical_essence/life, /datum/thaumaturgical_essence/light)
	granted_spells = list(/datum/action/cooldown/spell/essence/elven_grace)
	required_race = "elf"

/datum/essence_combo/spell/balanced_mind
	name = "Balanced Mind"
	required_essences = list(/datum/thaumaturgical_essence/order, /datum/thaumaturgical_essence/chaos)
	granted_spells = list(/datum/action/cooldown/spell/essence/balanced_mind)
	required_race = "human"
