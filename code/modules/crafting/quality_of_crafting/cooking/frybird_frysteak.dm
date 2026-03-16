/datum/repeatable_crafting_recipe/cooking/frybird
	abstract_type = /datum/repeatable_crafting_recipe/cooking/frybird
	attacked_atom = /obj/item/reagent_containers/food/snacks/cooked/frybird
	allow_inverse_start = TRUE
	extra_chance = 100
	craft_time = 2 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	required_table = TRUE

/datum/repeatable_crafting_recipe/cooking/frybird/potato
	name = "Frybird and Tatos"
	subtypes_allowed = TRUE
	requirements = list(
		/obj/item/reagent_containers/food/snacks/cooked/frybird = 1,
		/obj/item/reagent_containers/food/snacks/produce/vegetable/potato = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/vegetable/potato
	output = /obj/item/reagent_containers/food/snacks/cooked/frybird_tatos
	crafting_message = "combine some frybird and potato"
	blacklisted_paths = list(/obj/item/reagent_containers/food/snacks/produce/vegetable/potato)

/datum/repeatable_crafting_recipe/cooking/frybird/potato/create_blacklisted_paths()
	return

/datum/repeatable_crafting_recipe/cooking/frybird/herbs
	name = "Herbbird"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/cooked/frybird = 1,
		/obj/item/reagent_containers/powder/herbs = 1,
	)
	starting_atom = /obj/item/reagent_containers/powder/herbs
	output = /obj/item/reagent_containers/food/snacks/cooked/herbbird
	crafting_message = "rub some herbs into frybird"

/datum/repeatable_crafting_recipe/cooking/frysteak
	abstract_type = /datum/repeatable_crafting_recipe/cooking/frysteak
	attacked_atom = /obj/item/reagent_containers/food/snacks/cooked/frysteak
	allow_inverse_start = TRUE
	extra_chance = 100
	craft_time = 2 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	required_table = TRUE

/datum/repeatable_crafting_recipe/cooking/frysteak/potato
	name = "Frysteak and Tatos"
	subtypes_allowed = TRUE
	requirements = list(
		/obj/item/reagent_containers/food/snacks/cooked/frysteak = 1,
		/obj/item/reagent_containers/food/snacks/produce/vegetable/potato = 1,
	)
	starting_atom =/obj/item/reagent_containers/food/snacks/produce/vegetable/potato
	output = /obj/item/reagent_containers/food/snacks/cooked/frysteak_tatos
	crafting_message = "combine some frysteak and potato"
	blacklisted_paths = list(/obj/item/reagent_containers/food/snacks/produce/vegetable/potato)

/datum/repeatable_crafting_recipe/cooking/frysteak/potato/create_blacklisted_paths()
	return

/datum/repeatable_crafting_recipe/cooking/frysteak/onion
	name = "Frysteak and Onions"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/cooked/frysteak = 1,
		/obj/item/reagent_containers/food/snacks/onion_fried = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/onion_fried
	output = /obj/item/reagent_containers/food/snacks/cooked/frysteak_onion
	crafting_message = "combine some frysteak and onion"

/datum/repeatable_crafting_recipe/cooking/frysteak/herbs
	name = "Herbsteak"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/cooked/frysteak = 1,
		/obj/item/reagent_containers/powder/herbs = 1,
	)
	starting_atom = /obj/item/reagent_containers/powder/herbs
	output = /obj/item/reagent_containers/food/snacks/cooked/herbsteak
	crafting_message = "rub some herbs into frysteak"

/datum/repeatable_crafting_recipe/cooking/wiener
	abstract_type = /datum/repeatable_crafting_recipe/cooking/wiener
	attacked_atom = /obj/item/reagent_containers/food/snacks/cooked/sausage
	subtypes_allowed = TRUE
	allow_inverse_start = TRUE
	craft_time = 2 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/wiener/cabbage
	name = "Wiener on Whole Cabbage"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/cooked/sausage = 1,
		/obj/item/reagent_containers/food/snacks/produce/vegetable/cabbage = 1,
	)
	subtypes_allowed = TRUE
	starting_atom =/obj/item/reagent_containers/food/snacks/produce/vegetable/cabbage
	output = /obj/item/reagent_containers/food/snacks/cooked/sausage_cabbage
	crafting_message = "combine some sausage and cabbage"

/datum/repeatable_crafting_recipe/cooking/wiener/cabbage_fried
	name = "Wiener on Cooked Cabbage"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/cooked/sausage = 1,
		/obj/item/reagent_containers/food/snacks/cabbage_fried = 1,
	)
	subtypes_allowed = TRUE
	starting_atom = /obj/item/reagent_containers/food/snacks/cabbage_fried
	output = /obj/item/reagent_containers/food/snacks/cooked/sausage_cabbage
	crafting_message = "combine some sausage and cooked cabbage"

/datum/repeatable_crafting_recipe/cooking/wiener/potato
	name = "Wiener on Tato"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/cooked/sausage = 1,
		/obj/item/reagent_containers/food/snacks/produce/vegetable/potato = 1,
	)
	subtypes_allowed = TRUE
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/vegetable/potato
	output = /obj/item/reagent_containers/food/snacks/cooked/sausage_potato
	crafting_message = "combine some sausage and potato"
	blacklisted_paths = list(/obj/item/reagent_containers/food/snacks/produce/vegetable/potato)

/datum/repeatable_crafting_recipe/cooking/wiener/potato/create_blacklisted_paths()
	return

/datum/repeatable_crafting_recipe/cooking/wiener/onion
	name = "Wiener on Onions"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/cooked/sausage = 1,
		/obj/item/reagent_containers/food/snacks/onion_fried = 1,
	)
	subtypes_allowed = TRUE
	starting_atom =/obj/item/reagent_containers/food/snacks/onion_fried
	output = /obj/item/reagent_containers/food/snacks/cooked/sausage_onion
	crafting_message = "combine some sausage and onion"
