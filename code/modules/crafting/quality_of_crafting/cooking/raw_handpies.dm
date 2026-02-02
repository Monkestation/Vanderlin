/datum/repeatable_crafting_recipe/cooking/handpie
	abstract_type = /datum/repeatable_crafting_recipe/cooking/handpie
	attacked_atom = /obj/item/reagent_containers/food/snacks/piedough
	craft_time = 6 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/handpie/mushroom
	name = "Raw Mushroom Handpie"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/truffles = 1,
		/obj/item/reagent_containers/food/snacks/piedough = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/truffles
	output = /obj/item/reagent_containers/food/snacks/foodbase/handpieraw/mushroom
	crafting_message = "add mushrooms to the handpie"

/datum/repeatable_crafting_recipe/cooking/handpie/mince
	name = "Raw Mince Handpie"

	subtypes_allowed = TRUE
	requirements = list(
		/obj/item/reagent_containers/food/snacks/meat/mince/beef = 1,
		/obj/item/reagent_containers/food/snacks/piedough = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/meat/mince/beef
	output = /obj/item/reagent_containers/food/snacks/foodbase/handpieraw/mince
	crafting_message = "add mince to the handpie"

/datum/repeatable_crafting_recipe/cooking/handpie/berry_poison
	hides_from_books = TRUE
	name = "Raw Berry Handpie"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry/poison = 1,
		/obj/item/reagent_containers/food/snacks/piedough = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry/poison
	output = /obj/item/reagent_containers/food/snacks/foodbase/handpieraw/poison
	crafting_message = "add berry to the handpie"

/datum/repeatable_crafting_recipe/cooking/handpie/berry
	name = "Raw Berry Handpie"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry = 1,
		/obj/item/reagent_containers/food/snacks/piedough = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry
	output = /obj/item/reagent_containers/food/snacks/foodbase/handpieraw/berry
	crafting_message = "add berry to the handpie"

/datum/repeatable_crafting_recipe/cooking/handpie/apple
	name = "Raw Apple Handpie"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fruit/apple = 1,
		/obj/item/reagent_containers/food/snacks/piedough = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/fruit/apple
	output = /obj/item/reagent_containers/food/snacks/foodbase/handpieraw/apple
	crafting_message = "add apple to the handpie"

/datum/repeatable_crafting_recipe/cooking/handpie/cheese
	name = "Raw Cheese Handpie"
	subtypes_allowed = TRUE
	requirements = list(
		/obj/item/reagent_containers/food/snacks/cheese = 1,
		/obj/item/reagent_containers/food/snacks/piedough = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/cheese
	output = /obj/item/reagent_containers/food/snacks/foodbase/handpieraw/cheese
	crafting_message = "add cheese to the handpie"

/datum/repeatable_crafting_recipe/cooking/handpie/cheddar
	name = "Raw Cheddar Cheese Handpie"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/cheese_wedge = 1,
		/obj/item/reagent_containers/food/snacks/piedough = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/cheese_wedge
	output = /obj/item/reagent_containers/food/snacks/foodbase/handpieraw/cheese
	crafting_message = "add cheddar to the handpie"
