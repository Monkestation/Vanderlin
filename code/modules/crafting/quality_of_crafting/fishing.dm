/datum/repeatable_crafting_recipe/fishing
	abstract_type = /datum/repeatable_crafting_recipe/fishing
	category = "Fishing"
	allow_inverse_start = TRUE

/datum/repeatable_crafting_recipe/fishing/bait
	name = "red bait"
	output = /obj/item/fishing/lure/meat
	output_amount = 6
	starting_atom = /obj/item/reagent_containers/food/snacks/meat/mince/fish
	requirements = list(
		/obj/item/reagent_containers/food/snacks/meat/mince/fish = 2,
	)
	attacked_atom = /obj/item/reagent_containers/food/snacks/meat/mince/fish
	allow_inverse_start = FALSE

	craft_time = 2 SECONDS
	crafting_message = "starts rolling some bait"
	craftdiff = 0

/datum/repeatable_crafting_recipe/fishing/bait/dough
	name = "doughy bait"
	output = /obj/item/fishing/lure/dough
	starting_atom = /obj/item/reagent_containers/food/snacks/dough_slice
	requirements = list(
		/obj/item/reagent_containers/powder/flour = 2,
	)
	attacked_atom = /obj/item/reagent_containers/powder/flour
	allow_inverse_start = TRUE

/datum/repeatable_crafting_recipe/fishing/bait/gray
	name = "gray bait"
	output = /obj/item/fishing/lure/gray
	output_amount = 5
	starting_atom = /obj/item/reagent_containers/food/snacks/meat/mince/fish
	requirements = list(
		/obj/item/reagent_containers/food/snacks/meat/mince/fish = 1,
		/obj/item/reagent_containers/powder/flour = 1,
	)
	attacked_atom = /obj/item/reagent_containers/powder/flour
	allow_inverse_start = TRUE

/datum/repeatable_crafting_recipe/fishing/bait/speckled
	name = "speckled bait"
	output = /obj/item/fishing/lure/speckled
	output_amount = 3
	starting_atom = /obj/item/reagent_containers/food/snacks/meat/mince/fish
	requirements = list(
		/obj/item/reagent_containers/food/snacks/meat/mince/fish = 1,
		/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry = 1,
		/obj/item/reagent_containers/powder/flour = 1,
	)
	attacked_atom = /obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry
	allow_inverse_start = TRUE

/datum/repeatable_crafting_recipe/fishing/reel
	name = "twine fishing line"
	output = /obj/item/fishing/reel/twine
	starting_atom = /obj/item/natural/fibers
	requirements = list(
		/obj/item/natural/fibers = 2,
	)
	attacked_atom = /obj/item/natural/fibers
	allow_inverse_start = FALSE
	crafting_message = "starts weaving a reel"

/datum/repeatable_crafting_recipe/fishing/reel/silk
	name = "silk fishing line"
	requirements = list(
		/obj/item/natural/silk = 2,
	)
	starting_atom = /obj/item/natural/silk
	attacked_atom = /obj/item/natural/silk
	allow_inverse_start = FALSE
	output = /obj/item/fishing/reel/silk

/datum/repeatable_crafting_recipe/fishing/reel/leather
	name = "leather fishing line"
	requirements = list(
		/obj/item/natural/hide = 1,
		/obj/item/natural/fibers = 1,
	)
	starting_atom = /obj/item/natural/fibers
	attacked_atom = /obj/item/natural/hide
	allow_inverse_start = TRUE
	output = /obj/item/fishing/reel/leather

/datum/repeatable_crafting_recipe/fishing/bobber
	name = "wooden bobber"
	output = /obj/item/fishing/line/bobber
	starting_atom = /obj/item/grown/log/tree/stick
	requirements = list(
		/obj/item/natural/fibers = 2,
		/obj/item/grown/log/tree/stick = 1,
	)
	attacked_atom = /obj/item/natural/fibers

/datum/repeatable_crafting_recipe/fishing/bobber/stone
	name = "stone sinker"
	output = /obj/item/fishing/line/sinker
	starting_atom = /obj/item/natural/stone
	requirements = list(
		/obj/item/natural/fibers = 2,
		/obj/item/natural/stone = 1,
	)
	attacked_atom = /obj/item/natural/fibers

/datum/repeatable_crafting_recipe/fishing/hook
	name = "wooden fishing hook"
	output = /obj/item/fishing/hook/wooden
	starting_atom = /obj/item/grown/log/tree/stick
	requirements = list(
		/obj/item/grown/log/tree/stick = 2,
	)
	attacked_atom = /obj/item/grown/log/tree/stick
	allow_inverse_start = FALSE

/datum/repeatable_crafting_recipe/fishing/hook/thorn
	name = "thorn fishing hook"
	output = /obj/item/fishing/hook/thorn
	starting_atom = /obj/item/natural/thorn
	requirements = list(
		/obj/item/natural/thorn = 2,
	)
	attacked_atom = /obj/item/natural/thorn
	allow_inverse_start = FALSE

/datum/repeatable_crafting_recipe/fishing/fishingrod
	name = "Fishing Rod"
	output = /obj/item/fishingrod/crafted
	requirements = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/fibers = 2,
	)
	starting_atom = /obj/item/grown/log/tree/small
	attacked_atom = /obj/item/natural/fibers
