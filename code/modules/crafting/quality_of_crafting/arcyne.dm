/datum/repeatable_crafting_recipe/arcyne
	abstract_type = /datum/repeatable_crafting_recipe/arcyne
	skillcraft = /datum/attribute/skill/magic/arcane
	craftdiff = 0
	category = "Arcyne"
	allow_inverse_start = TRUE

/datum/repeatable_crafting_recipe/arcyne/arcana
	name = "amethyst transmutation"
	output = /obj/item/gem/amethyst
	reagent_requirements = list(
		/datum/reagent/medicine/manapot = 15
	)
	requirements = list(
		/obj/item/natural/stone = TRUE
	)
	tool_usage = list(
		/obj/item/weapon/knife = list("starts to carve out a rune", "start to carve a rune")
	)

	attacked_atom = /obj/item/natural/stone
	starting_atom = /obj/item/weapon/knife
	allow_inverse_start = FALSE
	subtypes_allowed = TRUE // so you can use any subtype of knife
	reagent_subtypes_allowed = TRUE // so normal mana potions can be used as well as weak ones.

/datum/repeatable_crafting_recipe/arcyne/infernal_feather
	name = "infernal feather"
	reagent_requirements = list()
	tool_usage = list()
	requirements = list(
		/obj/item/natural/infernalash = 2,
		/obj/item/natural/feather = 1,
	)
	output = /obj/item/natural/feather/infernal
	attacked_atom = /obj/item/natural/feather
	starting_atom = /obj/item/natural/infernalash
	craftdiff = 2

/datum/repeatable_crafting_recipe/arcyne/sending_stone
	name = "sending stones"
	reagent_requirements = list()
	requirements = list(
		/obj/item/gem/amethyst = 2,
		/obj/item/natural/stone = 2,
		/obj/item/natural/melded/t1 = 1,
	)
	starting_atom = /obj/item/gem/amethyst
	attacked_atom = /obj/item/natural/stone
	output = /obj/item/sendingstonesummoner
	craftdiff = 2

/datum/repeatable_crafting_recipe/arcyne/voidlamptern
	name = "void lamptern"
	reagent_requirements = list()
	tool_usage = list()
	requirements = list(
		/obj/item/natural/melded/t1  = 1,
		/obj/item/natural/obsidian = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
	)
	output = /obj/item/flashlight/flare/torch/lantern/voidlamptern
	starting_atom = /obj/item/flashlight/flare/torch/lantern
	attacked_atom = /obj/item/natural/obsidian
	craftdiff = 2

/datum/repeatable_crafting_recipe/arcyne/nomagicglove
	name = "mana binding gloves"
	reagent_requirements = list()
	tool_usage = list()
	requirements = list(
		/obj/item/natural/melded/t3  = 1,
		/obj/item/clothing/gloves/leather = 1,
		/obj/item/gem = 1,
	)
	output = /obj/item/clothing/gloves/nomagic
	starting_atom = /obj/item/gem
	attacked_atom = /obj/item/clothing/gloves/leather
	allow_inverse_start = FALSE
	subtypes_allowed = TRUE
	craftdiff = 3

/datum/repeatable_crafting_recipe/arcyne/temporalhourglass
	name = "temporal hourglass"
	reagent_requirements = list()
	tool_usage = list()
	requirements = list(
		/obj/item/natural/wood/plank = 4,
		/obj/item/natural/melded/t2  = 1,
		/obj/item/natural/glass = 1,
		/obj/item/gem = 1,
	)
	output = /obj/item/hourglass/temporal
	starting_atom = /obj/item/natural/glass
	attacked_atom = /obj/item/natural/melded/t2
	subtypes_allowed = TRUE
	craftdiff = 3

/datum/repeatable_crafting_recipe/arcyne/shimmeringlens
	name = "shimmering lens"
	reagent_requirements = list()
	tool_usage = list()
	requirements = list(
		/obj/item/natural/melded/t1  = 1,
		/obj/item/natural/leyline = 1,
		/obj/item/natural/iridescentscale = 1,
	)
	output = /obj/item/clothing/ring/shimmeringlens
	starting_atom = /obj/item/natural/iridescentscale
	attacked_atom = /obj/item/natural/leyline
	craftdiff = 2

/datum/repeatable_crafting_recipe/arcyne/mimictrinket
	name = "mimic trinket"
	reagent_requirements = list()
	tool_usage = list()
	requirements = list(
		/obj/item/natural/melded/t2  = 1,
		/obj/item/natural/wood/plank = 2,
	)
	output = /obj/item/mimictrinket
	starting_atom = /obj/item/natural/wood/plank
	attacked_atom = /obj/item/natural/melded/t2
	craftdiff = 3

/datum/repeatable_crafting_recipe/arcyne/binding
	name = "binding shackles"
	reagent_requirements = list()
	tool_usage = list()
	requirements = list(
		/obj/item/natural/melded/t2  = 1,
		/obj/item/ingot/iron = 2,
	)
	output = /obj/item/rope/chain/bindingshackles
	starting_atom = /obj/item/ingot/iron
	attacked_atom = /obj/item/natural/melded/t2
	craftdiff = 2

/datum/repeatable_crafting_recipe/arcyne/focus
	name = "primordial quartz focus"
	requirements = list(
		/obj/item/natural/melded/t2  = 1,
		/obj/item/ingot/gold = 1,
		/obj/item/mana_battery/mana_crystal/small
	)

	starting_atom = /obj/item/natural/melded/t2
	attacked_atom = /obj/item/mana_battery/mana_crystal/small

	output = /obj/item/mana_battery/mana_crystal/small/focus
	craftdiff = 2

/datum/repeatable_crafting_recipe/arcyne/sigil
	name = "arcyne sigil"
	reagent_requirements = list()
	tool_usage = list()
	requirements = list(
		/obj/item/natural/melded/t3  = 1,
		/obj/item/natural/leyline = 1,
	)
	output = /obj/item/clothing/ring/arcanesigil
	starting_atom = /obj/item/natural/leyline
	attacked_atom = /obj/item/natural/melded/t3
	craftdiff = 2

/datum/repeatable_crafting_recipe/arcyne/mana_chalk
	name = "mana infused chalk"
	requirements = list(
		/obj/item/ore/cinnabar = 1,
	)
	reagent_requirements = list(
		/datum/reagent/medicine/manapot/weak = 15,
	)
	starting_atom = /obj/item/ore/cinnabar
	attacked_atom = /obj/item/reagent_containers/glass
	output = /obj/item/chalk
	output_amount = 1
	craft_time = 1 SECONDS
	subtypes_allowed = TRUE

/datum/repeatable_crafting_recipe/arcyne/mana_chalk_natural
	name = "natural mana infused chalk"
	requirements = list(
		/obj/item/reagent_containers/powder/manabloom = 1,
		/obj/item/mana_battery/mana_crystal/small = 1
	)
	starting_atom = /obj/item/reagent_containers/powder/manabloom
	attacked_atom = /obj/item/mana_battery/mana_crystal/small
	output = /obj/item/chalk/natural
	output_amount = 1
	craft_time = 1 SECONDS
	subtypes_allowed = TRUE

/datum/repeatable_crafting_recipe/arcyne/t1_meld
	name = "arcanic meld"
	reagent_requirements = list()
	tool_usage = list()
	requirements = list(
		/obj/item/natural/infernalash = 1,
		/obj/item/natural/fairydust = 1,
		/obj/item/natural/elementalmote = 1,
	)
	output = /obj/item/natural/melded/t1
	starting_atom = /obj/item/natural/infernalash
	attacked_atom = /obj/item/natural/elementalmote
	craftdiff = 2

/datum/repeatable_crafting_recipe/arcyne/t2_meld
	name = "dense arcanic meld"
	reagent_requirements = list()
	tool_usage = list()
	requirements = list(
		/obj/item/natural/hellhoundfang = 1,
		/obj/item/natural/iridescentscale = 1,
		/obj/item/natural/elementalshard = 1,
	)
	output = /obj/item/natural/melded/t2
	starting_atom = /obj/item/natural/hellhoundfang
	attacked_atom = /obj/item/natural/elementalshard
	craftdiff = 2

/datum/repeatable_crafting_recipe/arcyne/t3_meld
	name = "sorcerous weave"
	reagent_requirements = list()
	tool_usage = list()
	requirements = list(
		/obj/item/natural/moltencore = 1,
		/obj/item/natural/heartwoodcore = 1,
		/obj/item/natural/elementalfragment = 1,
	)
	output = /obj/item/natural/melded/t3
	starting_atom = /obj/item/natural/heartwoodcore
	attacked_atom = /obj/item/natural/moltencore
	craftdiff = 2

/datum/repeatable_crafting_recipe/arcyne/t4_meld
	name = "magical confluence"
	reagent_requirements = list()
	tool_usage = list()
	requirements = list(
		/obj/item/natural/abyssalflame = 1,
		/obj/item/natural/sylvanessence = 1,
		/obj/item/natural/elementalrelic = 1
	)
	output = /obj/item/natural/melded/t4
	starting_atom = /obj/item/natural/abyssalflame
	attacked_atom = /obj/item/natural/elementalrelic
	craftdiff = 2

/datum/repeatable_crafting_recipe/arcyne/t5_meld
	name = "arcanic abberation"
	reagent_requirements = list()
	tool_usage = list()
	requirements = list(
		/obj/item/natural/melded/t4 = 1,
		/obj/item/natural/voidstone = 1,
	)
	output = /obj/item/natural/melded/t5
	starting_atom = /obj/item/natural/voidstone
	attacked_atom = /obj/item/natural/melded/t4
	craftdiff = 2
