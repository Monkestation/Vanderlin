/datum/repeatable_crafting_recipe/cooking/masa_honey
	category = "Tiefling Cuisine"
	name = "Honeyed Sunreed Dough"
	subtypes_allowed = TRUE
	requirements = list(
		/obj/item/reagent_containers/food/snacks/spiderhoney = 1,
		/obj/item/reagent_containers/food/snacks/masa = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/spiderhoney
	attacked_atom = /obj/item/reagent_containers/food/snacks/masa
	output = /obj/item/reagent_containers/food/snacks/masa_honey
	required_table = TRUE
	craftdiff = 0
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading.ogg'
	crafting_message = "mix honey into dough"
	extra_chance = 100

/*	.................   Huskbuns   ................... */

/datum/repeatable_crafting_recipe/cooking/huskbun_husk
	category = "Tiefling Cuisine"
	name = "Sunreed Husk"
	requirements = list(
		/obj/item/natural/fibers = 1,
		/obj/item/reagent_containers/food/snacks/masa_slice = 1,
	)
	starting_atom = /obj/item/natural/fibers
	attacked_atom = /obj/item/reagent_containers/food/snacks/masa_slice
	output = /obj/item/reagent_containers/food/snacks/foodbase/huskbunbase
	required_table = TRUE
	craftdiff = 0
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading.ogg'
	crafting_message = "nest dough in husk"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/huskbun_husk_alt
	hides_from_books = TRUE
	name = "Sunreed Husk"
	requirements = list(
		/obj/item/natural/fibers = 1,
		/obj/item/reagent_containers/food/snacks/masa_slice = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/masa_slice
	attacked_atom = /obj/item/natural/fibers
	output = /obj/item/reagent_containers/food/snacks/foodbase/huskbunbase
	required_table = TRUE
	craftdiff = 0
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading.ogg'
	crafting_message = "nest dough in husk"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/huskbun
	category = "Tiefling Cuisine"
	abstract_type = /datum/repeatable_crafting_recipe/cooking/huskbun
	attacked_atom = /obj/item/reagent_containers/food/snacks/foodbase/huskbunbase
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/huskbun/mince
	name = "Raw Mince Huskbun"
	subtypes_allowed = TRUE

	requirements = list(
		/obj/item/reagent_containers/food/snacks/meat/mince = 1,
		/obj/item/reagent_containers/food/snacks/foodbase/huskbunbase = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/meat/mince
	output = /obj/item/reagent_containers/food/snacks/foodbase/huskbunraw/meat
	crafting_message = "add mince to the husk"

/datum/repeatable_crafting_recipe/cooking/huskbun/potato
	name = "Raw Potato Huskbun"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/veg/potato_sliced = 1,
		/obj/item/reagent_containers/food/snacks/foodbase/huskbunbase = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/veg/potato_sliced
	output = /obj/item/reagent_containers/food/snacks/foodbase/huskbunraw/potato
	crafting_message = "add potato to the husk"

/datum/repeatable_crafting_recipe/cooking/huskbun/onion
	name = "Raw Onion Huskbun"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/veg/onion_sliced = 1,
		/obj/item/reagent_containers/food/snacks/foodbase/huskbunbase = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/veg/onion_sliced
	output = /obj/item/reagent_containers/food/snacks/foodbase/huskbunraw/onion
	crafting_message = "add onion to the husk"

/datum/repeatable_crafting_recipe/cooking/huskbun/cheese
	name = "Raw Cheese Huskbun"
	subtypes_allowed = TRUE

	requirements = list(
		/obj/item/reagent_containers/food/snacks/cheese_wedge = 1,
		/obj/item/reagent_containers/food/snacks/foodbase/huskbunbase = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/cheese_wedge
	output = /obj/item/reagent_containers/food/snacks/foodbase/huskbunraw/cheese
	crafting_message = "add cheese to the husk"

/*	.................   Saigaitas   ................... */

/datum/repeatable_crafting_recipe/cooking/saigaita
	category = "Tiefling Cuisine"
	abstract_type = /datum/repeatable_crafting_recipe/cooking/saigaita
	attacked_atom = /obj/item/reagent_containers/food/snacks/masa_flat
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/saigaita/mince
	name = "Meat Saigaita"
	subtypes_allowed = TRUE

	requirements = list(
		/obj/item/reagent_containers/food/snacks/meat/mince = 1,
		/obj/item/reagent_containers/food/snacks/masa_flat = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/meat/mince
	output = /obj/item/reagent_containers/food/snacks/foodbase/saigaita/meat
	crafting_message = "add mince to the flat-cake"

/datum/repeatable_crafting_recipe/cooking/saigaita/potato
	name = "Potato Saigaita"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/veg/potato_sliced = 1,
		/obj/item/reagent_containers/food/snacks/masa_flat = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/veg/potato_sliced
	output = /obj/item/reagent_containers/food/snacks/foodbase/saigaita/potato
	crafting_message = "add potato to the flat-cake"

/datum/repeatable_crafting_recipe/cooking/saigaita/onion
	name = "Onion Saigaita"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/veg/onion_sliced = 1,
		/obj/item/reagent_containers/food/snacks/masa_flat = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/veg/onion_sliced
	output = /obj/item/reagent_containers/food/snacks/foodbase/saigaita/onion
	crafting_message = "add onion to the flat-cake"

/datum/repeatable_crafting_recipe/cooking/saigaita/cheese
	name = "Cheese Saigaita"
	subtypes_allowed = TRUE

	requirements = list(
		/obj/item/reagent_containers/food/snacks/cheese_wedge = 1,
		/obj/item/reagent_containers/food/snacks/masa_flat = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/cheese_wedge
	output = /obj/item/reagent_containers/food/snacks/foodbase/saigaita/cheese
	crafting_message = "add cheese to the flat-cake"

/datum/repeatable_crafting_recipe/cooking/saigaita/egg
	name = "Egg Saigaita"
	subtypes_allowed = TRUE

	requirements = list(
		/obj/item/reagent_containers/food/snacks/egg = 1,
		/obj/item/reagent_containers/food/snacks/masa_flat = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/egg
	output = /obj/item/reagent_containers/food/snacks/foodbase/saigaita/egg
	crafting_message = "add egg to the flat-cake"

/*	.................   Platos   ................... */

/datum/repeatable_crafting_recipe/cooking/plato_steak
	category = "Tiefling Cuisine"
	name = "Steak Plato"
	subtypes_allowed = TRUE
	requirements = list(
		/obj/item/reagent_containers/food/snacks/cooked/frysteak = 1,
		/obj/item/reagent_containers/food/snacks/tostada = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/cooked/frysteak
	attacked_atom = /obj/item/reagent_containers/food/snacks/tostada
	output = /obj/item/reagent_containers/food/snacks/tostada_meat
	required_table = TRUE
	craftdiff = 0
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/chopping_block.ogg'
	crafting_message = "mince frysteak onto the plato"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/plato_frybird
	category = "Tiefling Cuisine"
	name = "Frybird Plato"
	subtypes_allowed = TRUE
	requirements = list(
		/obj/item/reagent_containers/food/snacks/cooked/frybird = 1,
		/obj/item/reagent_containers/food/snacks/tostada = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/cooked/frybird
	attacked_atom = /obj/item/reagent_containers/food/snacks/tostada
	output = /obj/item/reagent_containers/food/snacks/tostada_meat/chicken
	required_table = TRUE
	craftdiff = 0
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/chopping_block.ogg'
	crafting_message = "mince frybird onto the plato"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/plato_fish
	category = "Tiefling Cuisine"
	name = "Fish Plato"
	subtypes_allowed = TRUE
	requirements = list(
		/obj/item/reagent_containers/food/snacks/fryfish = 1,
		/obj/item/reagent_containers/food/snacks/tostada = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/fryfish
	attacked_atom = /obj/item/reagent_containers/food/snacks/tostada
	output = /obj/item/reagent_containers/food/snacks/tostada_meat/fish
	required_table = TRUE
	craftdiff = 0
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/chopping_block.ogg'
	crafting_message = "mince fish onto the plato"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/plato_egg
	category = "Tiefling Cuisine"
	name = "Egg Plato"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/cooked/egg = 1,
		/obj/item/reagent_containers/food/snacks/tostada = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/cooked/egg
	attacked_atom = /obj/item/reagent_containers/food/snacks/tostada
	output = /obj/item/reagent_containers/food/snacks/tostada_meat/egg
	required_table = TRUE
	craftdiff = 0
	craft_time = 5 SECONDS
	crafting_message = "add egg to the plato"
	extra_chance = 100

/*	.................   Sun-Crackers   ................... */

/datum/repeatable_crafting_recipe/cooking/cocaumole_chippile
	category = "Tiefling Cuisine"
	name = "Cocaumole Sun-Crackers"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/cocaumole = 1,
		/obj/item/reagent_containers/food/snacks/chippile = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/cocaumole
	attacked_atom = /obj/item/reagent_containers/food/snacks/chippile
	output = /obj/item/reagent_containers/food/snacks/chippile/cocaumole
	required_table = TRUE
	craftdiff = 0
	craft_time = 5 SECONDS
	crafting_message = "smother sun-crackers with cocaumole"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/drowsbane_chippile
	category = "Tiefling Cuisine"
	name = "Drowsbane Sun-Crackers"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/drowsbanejam = 1,
		/obj/item/reagent_containers/food/snacks/chippile = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/drowsbanejam
	attacked_atom = /obj/item/reagent_containers/food/snacks/chippile
	output = /obj/item/reagent_containers/food/snacks/chippile/drowsbane
	required_table = TRUE
	craftdiff = 0
	craft_time = 5 SECONDS
	crafting_message = "smother sun-crackers with drowsbane"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/cocaumole_chip
	category = "Tiefling Cuisine"
	name = "Cocaumole Sun-Cracker"
	subtypes_allowed = TRUE
	requirements = list(
		/obj/item/reagent_containers/food/snacks/cocaumole = 1,
		/obj/item/reagent_containers/food/snacks/chip = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/chip
	attacked_atom = /obj/item/reagent_containers/food/snacks/cocaumole
	output = /obj/item/reagent_containers/food/snacks/chip_cocaumole
	required_table = TRUE
	craftdiff = 0
	craft_time = 1 SECONDS
	crafting_message = "dip sun-cracker in drowsbane"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/drowsbane_chip
	category = "Tiefling Cuisine"
	name = "Drowsbane Sun-Cracker"
	subtypes_allowed = TRUE
	requirements = list(
		/obj/item/reagent_containers/food/snacks/drowsbanejam = 1,
		/obj/item/reagent_containers/food/snacks/chip = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/chip
	attacked_atom = /obj/item/reagent_containers/food/snacks/drowsbanejam
	output = /obj/item/reagent_containers/food/snacks/chip_drowsbane
	required_table = TRUE
	craftdiff = 0
	craft_time = 1 SECONDS
	crafting_message = "dip sun-cracker in cocaumole"
	extra_chance = 100

/*	.................   Eighthscake   ................... */

/datum/repeatable_crafting_recipe/cooking/eighthscake_unbaked
	category = "Tiefling Cuisine"
	name = "Unbaked Eightscake"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/egg = 1,
		/obj/item/reagent_containers/food/snacks/masa = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/egg
	attacked_atom = /obj/item/reagent_containers/food/snacks/masa
	output = /obj/item/reagent_containers/food/snacks/eighthscake_unbaked
	required_table = TRUE
	craftdiff = 0
	craft_time = 9 SECONDS
	crafting_sound = 'sound/foley/eggbreak.ogg'
	crafting_message = "mix egg into the dough"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/lemon_eighthscake_unbaked
	category = "Tiefling Cuisine"
	category = "Cakes"
	name = "Unbaked Lemon Eighthscake"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fruit/lemon = 1,
		/obj/item/reagent_containers/food/snacks/eighthscake_unbaked = 1,
	)
	required_table = TRUE
	attacked_atom = /obj/item/reagent_containers/food/snacks/eighthscake_unbaked
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/fruit/lemon
	output = /obj/item/reagent_containers/food/snacks/eighthscake_unbaked/lemon
	craft_time = 9 SECONDS
	crafting_sound = 'sound/foley/dropsound/gen_drop.ogg'
	crafting_message = "adding juicy lemon bits"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/lime_eighthscake_unbaked
	category = "Tiefling Cuisine"
	category = "Cakes"
	name = "Unbaked Lime Eighthscake"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fruit/lime = 1,
		/obj/item/reagent_containers/food/snacks/eighthscake_unbaked = 1,
	)
	required_table = TRUE
	attacked_atom = /obj/item/reagent_containers/food/snacks/eighthscake_unbaked
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/fruit/lime
	output = /obj/item/reagent_containers/food/snacks/eighthscake_unbaked/lime
	craft_time = 9 SECONDS
	crafting_sound = 'sound/foley/dropsound/gen_drop.ogg'
	crafting_message = "adding juicy lime bits"
	extra_chance = 100
