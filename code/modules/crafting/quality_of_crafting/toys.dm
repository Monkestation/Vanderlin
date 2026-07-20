

// ------------------------ Wood Toys ---------------------------- //

/datum/repeatable_crafting_recipe/crafting/orphan_toy
	abstract_type = /datum/repeatable_crafting_recipe/crafting/orphan_toy
	requirements = list(
		/obj/item/grown/log/tree/small= 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/knife
	allow_inverse_start = FALSE
	craft_time = 5 SECONDS
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/orphan_toy/dragon
	name = "Wooden Dragon Toy"
	output = /obj/item/orphan_toy/dragon

/datum/repeatable_crafting_recipe/crafting/orphan_toy/knight
	name = "Wooden Knight Toy"
	output = /obj/item/orphan_toy/knight

/datum/repeatable_crafting_recipe/crafting/orphan_toy/wizard
	name = "Wooden Wizard Toy"
	output = /obj/item/orphan_toy/wizard

/datum/repeatable_crafting_recipe/crafting/orphan_toy/bard
	name = "Wooden Bard Toy"
	output = /obj/item/orphan_toy/bard

/datum/repeatable_crafting_recipe/crafting/orphan_toy/goblin
	name = "Wooden Goblin Toy"
	output = /obj/item/orphan_toy/goblin

/datum/repeatable_crafting_recipe/crafting/orphan_toy/skeleton
	name = "Wooden Skeleton Toy"
	output = /obj/item/orphan_toy/skeleton

/datum/repeatable_crafting_recipe/crafting/orphan_toy/wolf
	name = "Wooden Volf Toy"
	output = /obj/item/orphan_toy/wolf

/datum/repeatable_crafting_recipe/crafting/orphan_toy/saiga
	name = "Wooden Saiga Toy"
	output = /obj/item/orphan_toy/saiga

/datum/repeatable_crafting_recipe/crafting/orphan_toy/coins
	name = "Wooden Coins"
	output = /obj/item/coin/wood/pile

/datum/repeatable_crafting_recipe/crafting/orphan_toy/crown
	name = "Wooden Crown"
	output = /obj/item/clothing/head/crown/wooden
	craftdiff = 3
