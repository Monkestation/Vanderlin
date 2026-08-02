/datum/repeatable_crafting_recipe/cooking/tamtoplate_base
	name = "Tamtoplate Base"
	category = "Vanderlin Cuisine"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/dough_flat = 1,
		/obj/item/reagent_containers/food/snacks/fruit/tamto_slice = 1,
	)
	attacked_atom = /obj/item/reagent_containers/food/snacks/dough_flat
	starting_atom = /obj/item/reagent_containers/food/snacks/fruit/tamto_slice
	output = /obj/item/reagent_containers/food/snacks/foodbase/tamtoplate_base
	required_table = TRUE
	minimum_skill_level = 2
	craft_time = 6 SECONDS
	crafting_sound = 'sound/foley/dropsound/gen_drop.ogg'
	sound_volume = 100
	crafting_message = "spread tomato sauce on dough"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/tamtoplate_cheese
	name = "Unbaked Cheese Tamtoplate"
	subtypes_allowed = TRUE
	category = "Vanderlin Cuisine"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/foodbase/tamtoplate_base = 1,
		/obj/item/reagent_containers/food/snacks/cheese = 1,
	)
	attacked_atom = /obj/item/reagent_containers/food/snacks/foodbase/tamtoplate_base
	starting_atom = /obj/item/reagent_containers/food/snacks/cheese
	output = /obj/item/reagent_containers/food/snacks/foodbase/tamtoplate_unfinished
	required_table = TRUE
	minimum_skill_level = 2
	craft_time = 6 SECONDS
	crafting_sound = 'sound/foley/dropsound/gen_drop.ogg'
	sound_volume = 100
	crafting_message = "spread tomato sauce on dough"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/uncooked_tamtoplate
	category = "Vanderlin Cuisine"
	abstract_type = /datum/repeatable_crafting_recipe/cooking/uncooked_tamtoplate
	required_table = TRUE
	craft_time = 3 SECONDS
	minimum_skill_level = 2
	crafting_sound = 'sound/foley/dropsound/gen_drop.ogg'
	extra_chance = 100
	attacked_atom = /obj/item/reagent_containers/food/snacks/foodbase/tamtoplate_unfinished

/datum/repeatable_crafting_recipe/cooking/uncooked_tamtoplate/meat
	name = "Unbaked Sausage Tamto Plate"
	subtypes_allowed = TRUE

	requirements = list(
		/obj/item/reagent_containers/food/snacks/meat/sausage = 1,
		/obj/item/reagent_containers/food/snacks/foodbase/tamtoplate_unfinished = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/meat/sausage
	output = /obj/item/reagent_containers/food/snacks/foodbase/tamtoplate_unfinished_meat
	crafting_message = "chop sausage onto the tamto plate"

/datum/repeatable_crafting_recipe/cooking/uncooked_tamtoplate/fish
	name = "Unbaked Fish Tamto Plate"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/meat/mince/fish = 1,
		/obj/item/reagent_containers/food/snacks/foodbase/tamtoplate_unfinished = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/meat/mince/fish
	output = /obj/item/reagent_containers/food/snacks/foodbase/tamtoplate_unfinished_fish
	crafting_message = "add fish mince onto the tamto plate"

/datum/repeatable_crafting_recipe/cooking/uncooked_tamtoplate/onion
	name = "Unbaked Onion Tamto Plate"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/veg/onion_sliced = 1,
		/obj/item/reagent_containers/food/snacks/foodbase/tamtoplate_unfinished = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/veg/onion_sliced
	output = /obj/item/reagent_containers/food/snacks/foodbase/tamtoplate_unfinished_onion
	crafting_message = "add sliced onions onto the tamto plate"
