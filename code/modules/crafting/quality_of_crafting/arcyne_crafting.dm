
/datum/arcyne_crafting_recipe
	abstract_type = /datum/arcyne_crafting_recipe
	var/name = "unnamed recipe"
	/// Unordered list of item typepaths required (one entry per item needed)
	var/list/ingredients = list()
	/// The typepath of the item produced
	var/atom/output
	/// Minimum arcane skill level required to invoke
	var/required_skill = SKILL_LEVEL_NONE
	///amount of mana this costs
	var/mana_cost = 0

/datum/arcyne_crafting_recipe/amethyst_transmutation
	name = "amethyst transmutation"
	ingredients = list(
		/obj/item/natural/stone,
	)
	output = /obj/item/gem/amethyst
	required_skill = SKILL_LEVEL_NONE
	mana_cost = 20

/datum/arcyne_crafting_recipe/infernal_feather
	name = "infernal feather"
	ingredients = list(
		/obj/item/natural/infernalash,
		/obj/item/natural/infernalash,
		/obj/item/natural/feather,
	)
	output = /obj/item/natural/feather/infernal
	required_skill =  SKILL_LEVEL_APPRENTICE

/datum/arcyne_crafting_recipe/sending_stones
	name = "sending stones"
	ingredients = list(
		/obj/item/gem/amethyst,
		/obj/item/gem/amethyst,
		/obj/item/natural/stone,
		/obj/item/natural/stone,
		/obj/item/natural/melded/t1,
	)
	output = /obj/item/sendingstonesummoner
	required_skill = SKILL_LEVEL_APPRENTICE

/datum/arcyne_crafting_recipe/void_lamptern
	name = "void lamptern"
	ingredients = list(
		/obj/item/natural/melded/t1,
		/obj/item/natural/obsidian,
		/obj/item/flashlight/flare/torch/lantern,
	)
	output = /obj/item/flashlight/flare/torch/lantern/voidlamptern
	required_skill =  SKILL_LEVEL_APPRENTICE

/datum/arcyne_crafting_recipe/mana_binding_gloves
	name = "mana binding gloves"
	ingredients = list(
		/obj/item/natural/melded/t3,
		/obj/item/clothing/gloves/leather,
		/obj/item/gem,
	)
	output = /obj/item/clothing/gloves/nomagic
	required_skill = SKILL_LEVEL_JOURNEYMAN

/datum/arcyne_crafting_recipe/temporal_hourglass
	name = "temporal hourglass"
	ingredients = list(
		/obj/item/natural/wood/plank,
		/obj/item/natural/wood/plank,
		/obj/item/natural/wood/plank,
		/obj/item/natural/wood/plank,
		/obj/item/natural/melded/t2,
		/obj/item/natural/glass,
		/obj/item/gem,
	)
	output = /obj/item/hourglass/temporal
	required_skill = SKILL_LEVEL_JOURNEYMAN

/datum/arcyne_crafting_recipe/shimmering_lens
	name = "shimmering lens"
	ingredients = list(
		/obj/item/natural/melded/t1,
		/obj/item/natural/leyline,
		/obj/item/natural/iridescentscale,
	)
	output = /obj/item/clothing/ring/shimmeringlens
	required_skill =  SKILL_LEVEL_APPRENTICE

/datum/arcyne_crafting_recipe/mimic_trinket
	name = "mimic trinket"
	ingredients = list(
		/obj/item/natural/melded/t2,
		/obj/item/natural/wood/plank,
		/obj/item/natural/wood/plank,
	)
	output = /obj/item/mimictrinket
	required_skill = SKILL_LEVEL_JOURNEYMAN

/datum/arcyne_crafting_recipe/binding_shackles
	name = "binding shackles"
	ingredients = list(
		/obj/item/natural/melded/t2,
		/obj/item/ingot/iron,
		/obj/item/ingot/iron,
	)
	output = /obj/item/rope/chain/bindingshackles
	required_skill =  SKILL_LEVEL_APPRENTICE

/datum/arcyne_crafting_recipe/primordial_focus
	name = "primordial quartz focus"
	ingredients = list(
		/obj/item/natural/melded/t2,
		/obj/item/ingot/gold,
		/obj/item/mana_battery/mana_crystal/small,
	)
	output = /obj/item/mana_battery/mana_crystal/small/focus
	required_skill =  SKILL_LEVEL_APPRENTICE

/datum/arcyne_crafting_recipe/arcyne_sigil
	name = "arcyne sigil"
	ingredients = list(
		/obj/item/natural/melded/t3,
		/obj/item/natural/leyline,
	)
	output = /obj/item/clothing/ring/arcanesigil
	required_skill =  SKILL_LEVEL_APPRENTICE

/datum/arcyne_crafting_recipe/mana_chalk
	name = "mana infused chalk"
	ingredients = list(
		/obj/item/ore/cinnabar,
	)
	output = /obj/item/chalk
	required_skill = SKILL_LEVEL_NONE

/datum/arcyne_crafting_recipe/t1_meld
	name = "arcanic meld"
	ingredients = list(
		/obj/item/natural/infernalash,
		/obj/item/natural/fairydust,
		/obj/item/natural/elementalmote,
	)
	output = /obj/item/natural/melded/t1
	required_skill =  SKILL_LEVEL_APPRENTICE

/datum/arcyne_crafting_recipe/t2_meld
	name = "dense arcanic meld"
	ingredients = list(
		/obj/item/natural/hellhoundfang,
		/obj/item/natural/iridescentscale,
		/obj/item/natural/elementalshard,
	)
	output = /obj/item/natural/melded/t2
	required_skill =  SKILL_LEVEL_APPRENTICE

/datum/arcyne_crafting_recipe/t3_meld
	name = "sorcerous weave"
	ingredients = list(
		/obj/item/natural/moltencore,
		/obj/item/natural/heartwoodcore,
		/obj/item/natural/elementalfragment,
	)
	output = /obj/item/natural/melded/t3
	required_skill =  SKILL_LEVEL_APPRENTICE

/datum/arcyne_crafting_recipe/t4_meld
	name = "magical confluence"
	ingredients = list(
		/obj/item/natural/abyssalflame,
		/obj/item/natural/sylvanessence,
		/obj/item/natural/elementalrelic,
	)
	output = /obj/item/natural/melded/t4
	required_skill = SKILL_LEVEL_JOURNEYMAN

/datum/arcyne_crafting_recipe/t5_meld
	name = "arcanic abberation"
	ingredients = list(
		/obj/item/natural/melded/t4,
		/obj/item/natural/voidstone,
	)
	output = /obj/item/natural/melded/t5
	required_skill = SKILL_LEVEL_JOURNEYMAN

/datum/arcyne_crafting_recipe/ley_linker
	name = "ley linker"
	ingredients = list(
		/obj/item/gem/amethyst,
		/obj/item/natural/infernalash,
		/obj/item/natural/fairydust,
	)
	output = /obj/item/pylon_linker
	required_skill = SKILL_LEVEL_NOVICE

/datum/arcyne_crafting_recipe/infernal_t1_to_t2
	name = "hellhound fang synthesis"
	ingredients = list(
		/obj/item/natural/infernalash,
		/obj/item/natural/infernalash,
		/obj/item/natural/infernalash,
	)
	output = /obj/item/natural/hellhoundfang
	required_skill = SKILL_LEVEL_NOVICE

/datum/arcyne_crafting_recipe/infernal_t2_to_t3
	name = "molten core synthesis"
	ingredients = list(
		/obj/item/natural/hellhoundfang,
		/obj/item/natural/hellhoundfang,
		/obj/item/natural/hellhoundfang,
	)
	output = /obj/item/natural/moltencore
	required_skill = SKILL_LEVEL_NOVICE

/datum/arcyne_crafting_recipe/infernal_t3_to_t4
	name = "abyssal flame synthesis"
	ingredients = list(
		/obj/item/natural/moltencore,
		/obj/item/natural/moltencore,
		/obj/item/natural/moltencore,
	)
	output = /obj/item/natural/abyssalflame
	required_skill = SKILL_LEVEL_NOVICE

/datum/arcyne_crafting_recipe/fairy_t1_to_t2
	name = "iridescent scale synthesis"
	ingredients = list(
		/obj/item/natural/fairydust,
		/obj/item/natural/fairydust,
		/obj/item/natural/fairydust,
	)
	output = /obj/item/natural/iridescentscale
	required_skill = SKILL_LEVEL_NOVICE

/datum/arcyne_crafting_recipe/fairy_t2_to_t3
	name = "heartwood core synthesis"
	ingredients = list(
		/obj/item/natural/iridescentscale,
		/obj/item/natural/iridescentscale,
		/obj/item/natural/iridescentscale,
	)
	output = /obj/item/natural/heartwoodcore
	required_skill = SKILL_LEVEL_NOVICE

/datum/arcyne_crafting_recipe/fairy_t3_to_t4
	name = "sylvan essence synthesis"
	ingredients = list(
		/obj/item/natural/heartwoodcore,
		/obj/item/natural/heartwoodcore,
		/obj/item/natural/heartwoodcore,
	)
	output = /obj/item/natural/sylvanessence
	required_skill = SKILL_LEVEL_NOVICE

/datum/arcyne_crafting_recipe/elemental_t1_to_t2
	name = "elemental shard synthesis"
	ingredients = list(
		/obj/item/natural/elementalmote,
		/obj/item/natural/elementalmote,
		/obj/item/natural/elementalmote,
	)
	output = /obj/item/natural/elementalshard
	required_skill = SKILL_LEVEL_NOVICE

/datum/arcyne_crafting_recipe/elemental_t2_to_t3
	name = "elemental fragment synthesis"
	ingredients = list(
		/obj/item/natural/elementalshard,
		/obj/item/natural/elementalshard,
		/obj/item/natural/elementalshard,
	)
	output = /obj/item/natural/elementalfragment
	required_skill = SKILL_LEVEL_NOVICE

/datum/arcyne_crafting_recipe/elemental_t3_to_t4
	name = "elemental relic synthesis"
	ingredients = list(
		/obj/item/natural/elementalfragment,
		/obj/item/natural/elementalfragment,
		/obj/item/natural/elementalfragment,
	)
	output = /obj/item/natural/elementalrelic
	required_skill = SKILL_LEVEL_NOVICE

/datum/arcyne_crafting_recipe/spell_focus
	name = "arcyne focus"
	ingredients = list(
		/obj/item/gem/amethyst,
		/obj/item/natural/infernalash,
	)
	output = /obj/item/spell_focus
	required_skill = SKILL_LEVEL_APPRENTICE

/datum/arcyne_crafting_recipe/arcyne_scroll
	name = "arcyne scroll"
	ingredients = list(
		/obj/item/natural/melded/t1,
		/obj/item/ore/cinnabar,
		/obj/item/paper,
	)
	output = /obj/item/arcyne_spellobject/scroll
	required_skill = SKILL_LEVEL_APPRENTICE

/datum/arcyne_crafting_recipe/spellstone_lesser
	name = "lesser arcyne spellstone"
	ingredients = list(
		/obj/item/natural/melded/t1,
		/obj/item/gem/amethyst,
		/obj/item/natural/stone,
	)
	output = /obj/item/arcyne_spellobject/spellstone/lesser
	required_skill = SKILL_LEVEL_APPRENTICE

/datum/arcyne_crafting_recipe/spellstone_greater
	name = "greater arcyne spellstone"
	ingredients = list(
		/obj/item/natural/melded/t2,
		/obj/item/gem/amethyst,
		/obj/item/gem/amethyst,
	)
	output = /obj/item/arcyne_spellobject/spellstone/greater
	required_skill = SKILL_LEVEL_JOURNEYMAN

/datum/arcyne_crafting_recipe/spellstone_supreme
	name = "supreme arcyne spellstone"
	ingredients = list(
		/obj/item/natural/melded/t3,
		/obj/item/gem/amethyst,
		/obj/item/gem/amethyst,
		/obj/item/gem/amethyst,
	)
	output = /obj/item/arcyne_spellobject/spellstone/supreme
	required_skill = SKILL_LEVEL_JOURNEYMAN

/datum/arcyne_crafting_recipe/arcyne_wand
	name = "arcyne wand"
	ingredients = list(
		/obj/item/natural/melded/t1,
		/obj/item/natural/wood/plank,
		/obj/item/gem/amethyst,
	)
	output = /obj/item/arcyne_spellobject/wand
	required_skill = SKILL_LEVEL_APPRENTICE

/datum/arcyne_crafting_recipe/arcyne_wand_greater
	name = "greater arcyne wand"
	ingredients = list(
		/obj/item/natural/melded/t2,
		/obj/item/natural/wood/plank,
		/obj/item/gem/amethyst,
		/obj/item/gem/amethyst,
	)
	output = /obj/item/arcyne_spellobject/wand/greater
	required_skill = SKILL_LEVEL_JOURNEYMAN

/datum/arcyne_crafting_recipe/arcyne_wand_chaotic
	name = "chaotic arcyne wand"
	ingredients = list(
		/obj/item/natural/melded/t2,
		/obj/item/natural/wood/plank,
		/obj/item/natural/voidstone,
	)
	output = /obj/item/arcyne_spellobject/wand/chaotic
	required_skill = SKILL_LEVEL_JOURNEYMAN
