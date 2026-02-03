/// Crafting recipes that should be viewable at anything. The bare necessities for wilderness survival

/datum/repeatable_crafting_recipe/survival
	abstract_type = /datum/repeatable_crafting_recipe/survival
	category = "Survival"
	subtypes_allowed = TRUE
	craftdiff = 0

/datum/repeatable_crafting_recipe/survival/cloth
	name = "cloth"
	requirements = list(
		/obj/item/natural/fibers = 2
	)
	tool_usage = list(
		/obj/item/needle = list("starts to sew", "start to sew")
	)

	starting_atom = /obj/item/needle
	attacked_atom = /obj/item/natural/fibers
	skillcraft = /datum/skill/misc/sewing
	output = /obj/item/natural/cloth

/datum/repeatable_crafting_recipe/survival/thorn_needle
	name = "thorn needle"
	requirements = list(
		/obj/item/natural/fibers = 1,
		/obj/item/natural/thorn = 1,
	)

	starting_atom = /obj/item/natural/fibers
	attacked_atom = /obj/item/natural/thorn
	allow_inverse_start = TRUE
	output = /obj/item/needle/thorn

/datum/repeatable_crafting_recipe/survival/rope
	name = "rope"
	requirements = list(
		/obj/item/natural/fibers = 3
	)

	starting_atom = /obj/item/natural/fibers
	attacked_atom = /obj/item/natural/fibers
	output = /obj/item/rope
	crafting_message = "starts to braid some fibers"

/datum/repeatable_crafting_recipe/survival/woodenbucket
	name = "wooden bucket"
	requirements = list(
		/obj/item/grown/log/tree/small = 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/knife
	output = /obj/item/reagent_containers/glass/bucket/wooden
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/survival/torch
	name = "torch"
	requirements = list(
		/obj/item/natural/fibers = 1,
		/obj/item/grown/log/tree/stick = 1,
	)

	starting_atom = /obj/item/natural/fibers
	attacked_atom = /obj/item/grown/log/tree/stick
	allow_inverse_start = TRUE
	output = /obj/item/flashlight/flare/torch

/datum/repeatable_crafting_recipe/survival/stake
	name = "wooden stake"
	requirements = list(
		/obj/item/grown/log/tree/stick= 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/stick
	starting_atom = /obj/item/weapon/knife
	output = /obj/item/grown/log/tree/stake

/datum/repeatable_crafting_recipe/survival/wood_hammer
	name = "wooden hammer"
	requirements = list(
		/obj/item/grown/log/tree/small= 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/knife
	output = /obj/item/weapon/hammer/wood
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/survival/fiber_fuse
	name = "fiber fuse"
	requirements = list(
		/obj/item/natural/fibers = 2,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to cut"), span_notice("start to cut"), 'sound/items/sharpen_long1.ogg'),
	)
	attacked_atom = /obj/item/natural/fibers
	starting_atom = /obj/item/weapon/knife
	output = /obj/item/fuse/fiber
	craft_time = 2 SECONDS

/datum/repeatable_crafting_recipe/survival/woodclub
	name = "wood club"
	requirements = list(
		/obj/item/grown/log/tree/small= 1,
		/obj/item/natural/fibers= 1,
	)
	starting_atom = /obj/item/grown/log/tree/small
	attacked_atom = /obj/item/natural/fibers
	allow_inverse_start = TRUE
	output = /obj/item/weapon/mace/woodclub

/datum/repeatable_crafting_recipe/survival/woodstaff
	name = "wood staff"
	requirements = list(
		/obj/item/grown/log/tree/small= 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/knife
	output = /obj/item/weapon/polearm/woodstaff
	output_amount = 2
	required_intent = /datum/intent/dagger/cut
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/survival/stone_axe
	name = "stone axe"
	requirements = list(
		/obj/item/natural/stone = 1,
		/obj/item/grown/log/tree/small = 1,
	)

	attacked_atom = /obj/item/natural/stone
	starting_atom = /obj/item/grown/log/tree/small
	allow_inverse_start = TRUE
	output = /obj/item/weapon/axe/stone

/datum/repeatable_crafting_recipe/survival/stone_knife
	name = "stone knife"
	requirements = list(
		/obj/item/natural/stone = 1,
		/obj/item/grown/log/tree/stick = 1,
	)

	attacked_atom = /obj/item/natural/stone
	starting_atom = /obj/item/grown/log/tree/stick
	allow_inverse_start = TRUE
	output = /obj/item/weapon/knife/stone

/datum/repeatable_crafting_recipe/survival/stone_hoe
	name = "stone hoe"
	requirements = list(
		/obj/item/natural/stone = 2,
		/obj/item/natural/fibers = 1,
		/obj/item/grown/log/tree/stick = 1,
	)

	attacked_atom = /obj/item/natural/stone
	starting_atom = /obj/item/grown/log/tree/stick
	allow_inverse_start = TRUE
	output = /obj/item/weapon/hoe/stone

/datum/repeatable_crafting_recipe/survival/stone_pick
	name = "stone pick"
	requirements = list(
		/obj/item/natural/stone = 2,
		/obj/item/grown/log/tree/stick = 1,
	)

	attacked_atom = /obj/item/natural/stone
	starting_atom = /obj/item/grown/log/tree/stick
	allow_inverse_start = TRUE
	output = /obj/item/weapon/pick/stone

/datum/repeatable_crafting_recipe/survival/stone_spear
	name = "stone spear"
	requirements = list(
		/obj/item/natural/stone = 1,
		/obj/item/weapon/polearm/woodstaff = 1,
	)

	starting_atom = /obj/item/weapon/polearm/woodstaff
	attacked_atom = /obj/item/natural/stone
	output = /obj/item/weapon/polearm/spear/stone

/datum/repeatable_crafting_recipe/survival/stone_pot
	name = "stone pot"
	requirements = list(
		/obj/item/natural/stone = 2,
	)

	starting_atom = /obj/item/natural/stone
	attacked_atom = /obj/item/natural/stone
	output = /obj/item/reagent_containers/glass/bucket/pot

/datum/repeatable_crafting_recipe/survival/flint
	name = "flint"
	requirements = list(
		/obj/item/natural/stone = 1,
		/obj/item/ingot/iron = 1,
	)
	attacked_atom = /obj/item/natural/stone
	starting_atom  = /obj/item/ingot/iron
	allow_inverse_start = TRUE
	output = /obj/item/flint
	skillcraft = /datum/skill/craft/engineering

/datum/repeatable_crafting_recipe/survival/bag
	name = "sack"
	requirements = list(
		/obj/item/natural/cloth = 1,
		/obj/item/natural/fibers = 1,
	)
	tool_usage = list(
		/obj/item/needle = list("starts to sew", "start to sew")
	)
	starting_atom = /obj/item/needle
	attacked_atom = /obj/item/natural/cloth
	output = /obj/item/storage/sack
	skillcraft = /datum/skill/misc/sewing

/datum/repeatable_crafting_recipe/survival/sack_clothing
	name = "head sack"
	requirements = list(
		/obj/item/natural/cloth = 2,
		/obj/item/natural/fibers = 1,
	)
	tool_usage = list(
		/obj/item/needle = list("starts to sew", "start to sew")
	)
	starting_atom = /obj/item/needle
	attacked_atom = /obj/item/natural/cloth
	output = /obj/item/clothing/head/sack
	craftdiff = 1
	skillcraft = /datum/skill/misc/sewing
	subtypes_allowed = TRUE

/datum/repeatable_crafting_recipe/survival/clay
	name = "clay lump"
	requirements = list(
		/obj/item/natural/dirtclod= 3,
	)
	reagent_requirements = list(
		/datum/reagent/water = 10
	)
	attacked_atom = /obj/item/natural/dirtclod
	starting_atom = /obj/item/natural/dirtclod
	output = /obj/item/natural/clay

/datum/repeatable_crafting_recipe/survival/wicker_basket
	name = "wicker basket"
	requirements = list(
		/obj/item/natural/fibers = 6,
	)
	attacked_atom = /obj/item/natural/fibers
	starting_atom  = /obj/item/natural/fibers
	output = /obj/structure/closet/crate/chest/wicker
	craftdiff = 1

/datum/repeatable_crafting_recipe/survival/wicker_handbasket
	name = "wicker handbasket"
	requirements = list(
		/obj/item/natural/fibers = 3,
	)
	attacked_atom = /obj/item/natural/fibers
	starting_atom  = /obj/item/natural/fibers
	output = /obj/item/storage/handbasket
	craftdiff = 1

/datum/repeatable_crafting_recipe/survival/bone_spear
	name = "bone spear"
	requirements = list(
		/obj/item/weapon/polearm/woodstaff = 1,
		/obj/item/alch/bone= 2,
		/obj/item/natural/fibers = 1,
	)
	attacked_atom = /obj/item/weapon/polearm/woodstaff
	starting_atom = /obj/item/natural/fibers
	output = /obj/item/weapon/polearm/spear/bonespear
	craftdiff = 2

/datum/repeatable_crafting_recipe/survival/bone_axe
	name = "bone axe"
	requirements = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/alch/bone= 2,
		/obj/item/natural/fibers = 1,
	)
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom= /obj/item/natural/fibers
	allow_inverse_start = TRUE
	output = /obj/item/weapon/axe/boneaxe
	craftdiff = 2

/datum/repeatable_crafting_recipe/survival/claybrick
	name = "raw claybrick"
	requirements = list(
		/obj/item/natural/clay = 1
	)
	tool_usage = list(
		/obj/item/grown/log = list("starts to mold", "start to mold")
	)

	starting_atom = /obj/item/grown/log
	attacked_atom = /obj/item/natural/clay
	skillcraft = /datum/skill/craft/masonry
	output = /obj/item/natural/raw_brick

/datum/repeatable_crafting_recipe/survival/mushmound
	name = "mushroom mound"
	requirements = list(
		/obj/item/natural/chaff = 2,
		/obj/item/natural/poo = 2,
	)
	attacked_atom = /obj/item/natural/poo
	starting_atom = /obj/item/natural/chaff
	output = /obj/structure/soil/mushmound
	craftdiff = 0
