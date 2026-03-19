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

/datum/repeatable_crafting_recipe/cooking/masa
	category = "Tiefling Cuisine"
	name = "Sunreed Dough"
	requirements = list(
		/obj/item/reagent_containers/powder/sunreed_flour = 1,
		/obj/item/reagent_containers/food/snacks/masa_base = 1,
	)
	attacked_atom = /obj/item/reagent_containers/powder/sunreed_flour
	starting_atom = /obj/item/reagent_containers/food/snacks/masa_base
	output = /obj/item/reagent_containers/food/snacks/masa
	required_table = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading.ogg'
	crafting_message = "knead in more flour"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/masa_alt
	hides_from_books = TRUE
	name = "Sunreed Dough"
	requirements = list(
		/obj/item/reagent_containers/powder/sunreed_flour = 1,
		/obj/item/reagent_containers/food/snacks/masa_base = 1,
	)
	starting_atom = /obj/item/reagent_containers/powder/sunreed_flour
	attacked_atom = /obj/item/reagent_containers/food/snacks/masa_base
	output = /obj/item/reagent_containers/food/snacks/masa
	required_table = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading.ogg'
	crafting_message = "knead in more flour"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/raspberry_butter_dough
	category = "Holiday Food"
	name = "Raspberry Butterdough"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/butterdough = 1,
		/obj/item/reagent_containers/food/snacks/produce/fruit/raspberry = 1,
	)
	subtypes_allowed = TRUE
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/fruit/raspberry
	attacked_atom = /obj/item/reagent_containers/food/snacks/butterdough
	output = /obj/item/reagent_containers/food/snacks/raspberrybutterdough
	required_table = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading.ogg'
	crafting_message = "knead the dough and adding raspberries"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/raisin_butter_dough
	category = "Holiday Food"
	name = "Raisin Butterdough"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/butterdough = 1,
		/obj/item/reagent_containers/food/snacks/raisins = 1,
	)
	subtypes_allowed = FALSE
	starting_atom = /obj/item/reagent_containers/food/snacks/raisins
	attacked_atom = /obj/item/reagent_containers/food/snacks/butterdough
	output = /obj/item/reagent_containers/food/snacks/jacksberrybutterdough
	required_table = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading.ogg'
	crafting_message = "knead the dough and adding raisins"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/raisin_butter_dough_poison
	hides_from_books = TRUE
	name = "Raisin Butterdough"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/butterdough = 1,
		/obj/item/reagent_containers/food/snacks/raisins/poison = 1,
	)
	subtypes_allowed = TRUE
	starting_atom = /obj/item/reagent_containers/food/snacks/raisins/poison
	attacked_atom = /obj/item/reagent_containers/food/snacks/butterdough
	output = /obj/item/reagent_containers/food/snacks/jacksberrybutterdough/poison
	required_table = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading.ogg'
	crafting_message = "knead the dough and adding raisins"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/blackberry_butter_dough
	category = "Holiday Food"
	name = "Blackberry Butterdough"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/butterdough = 1,
		/obj/item/reagent_containers/food/snacks/produce/fruit/blackberry = 1,
	)
	subtypes_allowed = TRUE
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/fruit/blackberry
	attacked_atom = /obj/item/reagent_containers/food/snacks/butterdough
	output = /obj/item/reagent_containers/food/snacks/blackberrybutterdough
	required_table = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading.ogg'
	crafting_message = "knead the dough and adding blackberries"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/pear_butter_dough
	category = "Holiday Food"
	name = "Pear Butterdough"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/butterdough = 1,
		/obj/item/reagent_containers/food/snacks/pear_dried = 1,
	)
	subtypes_allowed = TRUE
	starting_atom = /obj/item/reagent_containers/food/snacks/pear_dried
	attacked_atom = /obj/item/reagent_containers/food/snacks/butterdough
	output = /obj/item/reagent_containers/food/snacks/pearbutterdough
	required_table = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading.ogg'
	crafting_message = "knead the dough and adding dried pears"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/pear_butter_dough
	category = "Holiday Food"
	name = "Pear Butterdough"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/butterdough = 1,
		/obj/item/reagent_containers/food/snacks/pear_dried = 1,
	)
	subtypes_allowed = TRUE
	starting_atom = /obj/item/reagent_containers/food/snacks/pear_dried
	attacked_atom = /obj/item/reagent_containers/food/snacks/butterdough
	output = /obj/item/reagent_containers/food/snacks/pearbutterdough
	required_table = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading.ogg'
	crafting_message = "knead the dough and adding dried pears"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/tangerine_butter_dough
	category = "Holiday Food"
	name = "Tangerine Butterdough"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/butterdough = 1,
		/obj/item/reagent_containers/food/snacks/tangerine_dried = 1,
	)
	subtypes_allowed = TRUE
	starting_atom = /obj/item/reagent_containers/food/snacks/tangerine_dried
	attacked_atom = /obj/item/reagent_containers/food/snacks/butterdough
	output = /obj/item/reagent_containers/food/snacks/tangerinebutterdough
	required_table = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading.ogg'
	crafting_message = "knead the dough and adding dried tangerines"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/plum_butter_dough
	category = "Holiday Food"
	name = "Plum Butterdough"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/butterdough = 1,
		/obj/item/reagent_containers/food/snacks/plum_dried = 1,
	)
	subtypes_allowed = TRUE
	starting_atom = /obj/item/reagent_containers/food/snacks/plum_dried
	attacked_atom = /obj/item/reagent_containers/food/snacks/butterdough
	output = /obj/item/reagent_containers/food/snacks/plumbutterdough
	required_table = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading.ogg'
	crafting_message = "knead the dough and adding dried plums"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/lemon_butter_dough
	category = "Holiday Food"
	name = "Lemon Butterdough"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/butterdough = 1,
		/obj/item/reagent_containers/food/snacks/produce/fruit/lemon = 1,
	)
	subtypes_allowed = TRUE
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/fruit/lemon
	attacked_atom = /obj/item/reagent_containers/food/snacks/butterdough
	output = /obj/item/reagent_containers/food/snacks/lemonbutterdough
	required_table = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading.ogg'
	crafting_message = "knead the dough and adding lemons"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/chocolate_butter_dough
	category = "Holiday Food"
	name = "Chocolate Butterdough"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/butterdough = 1,
		/obj/item/reagent_containers/food/snacks/chocolate = 1,
	)
	subtypes_allowed = TRUE
	starting_atom = /obj/item/reagent_containers/food/snacks/chocolate
	attacked_atom = /obj/item/reagent_containers/food/snacks/butterdough
	output = /obj/item/reagent_containers/food/snacks/chocolatebutterdough
	required_table = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading.ogg'
	crafting_message = "knead the dough and adding chocolate bits"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/raisin_dough
	name = "Raisin Dough"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/dough = 1,
		/obj/item/reagent_containers/food/snacks/raisins = 1,
	)
	subtypes_allowed = TRUE
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

/datum/repeatable_crafting_recipe/cooking/reform_masa
	hides_from_books = TRUE
	name = "Reform Sunreed Dough"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/masa_slice = 2,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/masa_slice
	attacked_atom = /obj/item/reagent_containers/food/snacks/masa_slice
	output = /obj/item/reagent_containers/food/snacks/masa
	required_table = TRUE
	craftdiff = 0
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading.ogg'
	crafting_message = "combine dough slices"
	extra_chance = 100
