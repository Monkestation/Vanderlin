/datum/repeatable_crafting_recipe/cooking/dough
	name = "Dough"
	requirements = list(
		/obj/item/reagent_containers/powder/flour = 1,
		/obj/item/reagent_containers/food/snacks/dough_base = 1,
	)
	attacked_atom = /obj/item/reagent_containers/powder/flour
	starting_atom = /obj/item/reagent_containers/food/snacks/dough_base
	output = /obj/item/reagent_containers/food/snacks/dough
	required_table = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading.ogg'
	crafting_message = "knead in more flour"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/dough_alt
	hides_from_books = TRUE
	name = "Dough"
	requirements = list(
		/obj/item/reagent_containers/powder/flour = 1,
		/obj/item/reagent_containers/food/snacks/dough_base = 1,
	)
	starting_atom = /obj/item/reagent_containers/powder/flour
	attacked_atom = /obj/item/reagent_containers/food/snacks/dough_base
	output = /obj/item/reagent_containers/food/snacks/dough
	required_table = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading.ogg'
	crafting_message = "knead in more flour"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/butter_dough
	name = "Butter Dough"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/dough = 1,
		/obj/item/reagent_containers/food/snacks/butterslice = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/butterslice
	attacked_atom = /obj/item/reagent_containers/food/snacks/dough
	output = /obj/item/reagent_containers/food/snacks/butterdough
	required_table = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading_alt.ogg'
	crafting_message = "knead butter into the dough"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/raisin_dough_poison
	hides_from_books = TRUE
	name = "Raisin Dough"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/dough = 1,
		/obj/item/reagent_containers/food/snacks/raisins/poison = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/raisins/poison
	attacked_atom = /obj/item/reagent_containers/food/snacks/dough
	output = /obj/item/reagent_containers/food/snacks/raisindough_poison
	required_table = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading.ogg'
	crafting_message = "knead the dough and adding raisins"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/raisin_dough
	name = "Raisin Dough"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/dough = 1,
		/obj/item/reagent_containers/food/snacks/raisins = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/raisins
	attacked_atom = /obj/item/reagent_containers/food/snacks/dough
	output = /obj/item/reagent_containers/food/snacks/raisindough
	required_table = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading.ogg'
	crafting_message = "knead the dough and adding raisins"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/reform_dough
	name = "Reform Dough"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/dough_slice = 2,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/dough_slice
	attacked_atom = /obj/item/reagent_containers/food/snacks/dough_slice
	output = /obj/item/reagent_containers/food/snacks/dough
	required_table = TRUE
	craftdiff = 0
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading.ogg'
	crafting_message = "combine dough slices"
	extra_chance = 100
/datum/repeatable_crafting_recipe/cooking/honey_dough
	name = "Honey dough"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/dough = 1,
		/obj/item/reagent_containers/food/snacks/spiderhoney/honey = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/spiderhoney/honey
	attacked_atom = /obj/item/reagent_containers/food/snacks/dough
	output = /obj/item/reagent_containers/food/snacks/honey_dough
	required_table = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading_alt.ogg'
	crafting_message = "knead honey into the dough"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/gingerbread_dough
	name = "Gingerbread dough"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/honey_dough = 1,
		/obj/item/reagent_containers/powder/herbs = 1,
	)
	starting_atom = /obj/item/reagent_containers/powder/herbs
	attacked_atom = /obj/item/reagent_containers/food/snacks/honey_dough
	output = /obj/item/reagent_containers/food/snacks/gingerbread_dough
	required_table = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading_alt.ogg'
	crafting_message = "knead spices into the dough"
	extra_chance = 100
