
/datum/repeatable_crafting_recipe/cooking/raw_griddle_cake
	name = "Raw Griddlecake"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/egg = 1,
		/obj/item/reagent_containers/food/snacks/butterdough_slice = 1,
	)
	attacked_atom = /obj/item/reagent_containers/food/snacks/butterdough_slice
	starting_atom = /obj/item/reagent_containers/food/snacks/egg
	output = /obj/item/reagent_containers/food/snacks/foodbase/griddlecake_raw
	required_table = TRUE
	minimum_skill_level = 1
	craft_time = 6 SECONDS
	crafting_sound = 'sound/foley/eggbreak.ogg'
	sound_volume = 100
	crafting_message = "work egg into the dough"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/unbaked_griddlecake
	abstract_type = /datum/repeatable_crafting_recipe/cooking/unbaked_griddlecake
	required_table = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/dropsound/gen_drop.ogg'
	extra_chance = 100
	attacked_atom = /obj/item/reagent_containers/food/snacks/foodbase/griddlecake_raw

/datum/repeatable_crafting_recipe/cooking/unbaked_griddlecake/lemon
	name = "Unbaked Lemon Griddlecake"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fruit/lemon = 1,
		/obj/item/reagent_containers/food/snacks/foodbase/griddlecake_raw = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/fruit/lemon
	output = /obj/item/reagent_containers/food/snacks/foodbase/lemongriddlecake_raw
	crafting_message = "add lemon to the griddlecake"

/datum/repeatable_crafting_recipe/cooking/unbaked_griddlecake/apple
	name = "Unbaked Apple Griddlecake"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fruit/apple = 1,
		/obj/item/reagent_containers/food/snacks/foodbase/griddlecake_raw = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/fruit/apple
	output = /obj/item/reagent_containers/food/snacks/foodbase/applegriddlecake_raw
	crafting_message = "add apple to the griddlecake"

/datum/repeatable_crafting_recipe/cooking/unbaked_griddlecake/dried_apple
	name = "Unbaked Dried Apple Griddlecake"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/apple_dried = 1,
		/obj/item/reagent_containers/food/snacks/foodbase/griddlecake_raw = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/apple_dried
	output = /obj/item/reagent_containers/food/snacks/foodbase/applegriddlecake_raw
	crafting_message = "add dried apple to the griddlecake"

/datum/repeatable_crafting_recipe/cooking/unbaked_griddlecake/berry
	name = "Unbaked Berry Griddlecake"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry = 1,
		/obj/item/reagent_containers/food/snacks/foodbase/griddlecake_raw = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry
	output = /obj/item/reagent_containers/food/snacks/foodbase/berrygriddlecake_raw
	crafting_message = "add jacksberry to the griddlecake"

/datum/repeatable_crafting_recipe/cooking/unbaked_griddlecake/raisin
	name = "Unbaked Raisin Griddlecake"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/raisins = 1,
		/obj/item/reagent_containers/food/snacks/foodbase/griddlecake_raw = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/raisins
	output = /obj/item/reagent_containers/food/snacks/foodbase/berrygriddlecake_raw
	crafting_message = "add raisins to the griddlecake"

/datum/repeatable_crafting_recipe/cooking/unbaked_griddlecake/berry_poison
	hides_from_books = TRUE
	name = "Unbaked Berry Griddlecake"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry/poison = 1,
		/obj/item/reagent_containers/food/snacks/foodbase/griddlecake_raw = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry/poison
	output = /obj/item/reagent_containers/food/snacks/foodbase/poisonberrygriddlecake_raw
	crafting_message = "add jacksberry to the griddlecake"

/datum/repeatable_crafting_recipe/cooking/unbaked_griddlecake/raisin_poison
	hides_from_books = TRUE
	name = "Unbaked Raisin Griddlecake"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/raisins/poison = 1,
		/obj/item/reagent_containers/food/snacks/foodbase/griddlecake_raw = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/raisins/poison
	output = /obj/item/reagent_containers/food/snacks/foodbase/poisonberrygriddlecake_raw
	crafting_message = "add raisins to the griddlecake"
