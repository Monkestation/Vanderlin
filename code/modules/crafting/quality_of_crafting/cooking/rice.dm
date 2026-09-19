/datum/repeatable_crafting_recipe/cooking/rice_pork
	name = "Rice and Pork"
	output = /obj/item/reagent_containers/food/snacks/ricepork
	craft_time = 2 SECONDS
	attacked_atom = /obj/item/reagent_containers/food/snacks/rice_cooked
	starting_atom = /obj/item/reagent_containers/food/snacks/cooked/ham
	requirements = list(
		/obj/item/reagent_containers/food/snacks/rice_cooked = 1,
		/obj/item/reagent_containers/food/snacks/cooked/ham = 1
	)
	crafting_message = "add cut pork to the rice"
	tool_usage = list(
		/obj/item/weapon/knife =  list("starts to cut up the pork", "start to cut up the pork")
	)

/datum/repeatable_crafting_recipe/cooking/rice_beef
	name = "Rice and Steak"
	output = /obj/item/reagent_containers/food/snacks/ricebeef
	craft_time = 2 SECONDS
	attacked_atom = /obj/item/reagent_containers/food/snacks/rice_cooked
	starting_atom = /obj/item/reagent_containers/food/snacks/cooked/frysteak
	requirements = list(
		/obj/item/reagent_containers/food/snacks/rice_cooked = 1,
		/obj/item/reagent_containers/food/snacks/cooked/frysteak = 1
	)
	crafting_message = "add cut steak to the rice"
	tool_usage = list(
		/obj/item/weapon/knife =  list("starts to cut up the steak", "start to cut up the steak")
	)

/datum/repeatable_crafting_recipe/cooking/rice_shrimp
	name = "Rice and Shrimp"
	output = /obj/item/reagent_containers/food/snacks/riceshrimp
	craft_time = 2 SECONDS
	attacked_atom = /obj/item/reagent_containers/food/snacks/rice_cooked
	starting_atom = /obj/item/reagent_containers/food/snacks/fryfish/shrimp
	requirements = list(
		/obj/item/reagent_containers/food/snacks/rice_cooked = 1,
		/obj/item/reagent_containers/food/snacks/fryfish/shrimp = 1
	)
	crafting_message = "add shrimp to the rice"

/datum/repeatable_crafting_recipe/cooking/rice_bird
	name = "Rice and Frybird"
	output = /obj/item/reagent_containers/food/snacks/ricebird
	craft_time = 2 SECONDS
	attacked_atom = /obj/item/reagent_containers/food/snacks/rice_cooked
	starting_atom = /obj/item/reagent_containers/food/snacks/cooked/frybird
	requirements = list(
		/obj/item/reagent_containers/food/snacks/rice_cooked = 1,
		/obj/item/reagent_containers/food/snacks/cooked/frybird = 1
	)
	crafting_message = "add frybird to the rice"

/datum/repeatable_crafting_recipe/cooking/rice_egg
	name = "Rice and Egg"
	output = /obj/item/reagent_containers/food/snacks/riceegg
	craft_time = 2 SECONDS
	attacked_atom = /obj/item/reagent_containers/food/snacks/rice_cooked
	starting_atom = /obj/item/reagent_containers/food/snacks/egg
	requirements = list(
		/obj/item/reagent_containers/food/snacks/rice_cooked = 1,
		/obj/item/reagent_containers/food/snacks/egg = 1
	)
	crafting_message = "crack an egg on the rice"

/datum/repeatable_crafting_recipe/cooking/rice_egg_cheese
	name = "Rice and Egg with Melted Cheese"
	output = /obj/item/reagent_containers/food/snacks/riceeggcheese
	craft_time = 6 SECONDS
	attacked_atom = /obj/item/reagent_containers/food/snacks/riceegg
	starting_atom = /obj/item/reagent_containers/food/snacks/cheddarslice
	requirements = list(
		/obj/item/reagent_containers/food/snacks/riceegg = 1,
		/obj/item/reagent_containers/food/snacks/cheddarslice = 1
	)
	crafting_message = "melt some cheese"

/datum/repeatable_crafting_recipe/cooking/rice_egg_cheese/alt
	name = "Rice and Egg with Melted Cheese (Alt)"
	attacked_atom = /obj/item/reagent_containers/food/snacks/riceegg
	starting_atom = /obj/item/reagent_containers/food/snacks/egg
	requirements = list(
		/obj/item/reagent_containers/food/snacks/ricecheese = 1,
		/obj/item/reagent_containers/food/snacks/egg = 1
	)
	crafting_message = "crack an egg ontop"

/datum/repeatable_crafting_recipe/cooking/rice_cheese
	name = "Rice and Melted Cheese"
	output = /obj/item/reagent_containers/food/snacks/ricecheese
	craft_time = 6 SECONDS
	attacked_atom = /obj/item/reagent_containers/food/snacks/rice_cooked
	starting_atom = /obj/item/reagent_containers/food/snacks/cheddarslice
	requirements = list(
		/obj/item/reagent_containers/food/snacks/rice_cooked = 1,
		/obj/item/reagent_containers/food/snacks/cheddarslice = 1
	)
	crafting_message = "melt some cheese"

/datum/repeatable_crafting_recipe/cooking/rice_beef_meal
	name = "Rice and Beef with Fried Cabbage"
	output = /obj/item/reagent_containers/food/snacks/ricebeefcar
	craft_time = 6 SECONDS
	attacked_atom = /obj/item/reagent_containers/food/snacks/ricebeef
	starting_atom = /obj/item/reagent_containers/food/snacks/cabbage_fried
	requirements = list(
		/obj/item/reagent_containers/food/snacks/ricebeef = 1,
		/obj/item/reagent_containers/food/snacks/cabbage_fried = 1
	)
	crafting_message = "add some fried cabbage"

/datum/repeatable_crafting_recipe/cooking/rice_chicken_meal
	name = "Rice and Frybird with Fried Cabbage"
	output = /obj/item/reagent_containers/food/snacks/ricebirdcar
	craft_time = 6 SECONDS
	attacked_atom = /obj/item/reagent_containers/food/snacks/ricebird
	starting_atom = /obj/item/reagent_containers/food/snacks/cabbage_fried
	requirements = list(
		/obj/item/reagent_containers/food/snacks/ricebird = 1,
		/obj/item/reagent_containers/food/snacks/cabbage_fried = 1
	)
	crafting_message = "add some fried cabbage"

/datum/repeatable_crafting_recipe/cooking/rice_pork_meal
	name = "Rice and Pork with Avocado"
	output = /obj/item/reagent_containers/food/snacks/riceporkcuc
	craft_time = 6 SECONDS
	attacked_atom = /obj/item/reagent_containers/food/snacks/ricepork
	starting_atom = /obj/item/reagent_containers/food/snacks/fruit/avocado_half
	requirements = list(
		/obj/item/reagent_containers/food/snacks/ricepork = 1,
		/obj/item/reagent_containers/food/snacks/fruit/avocado_half = 1
	)
	crafting_message = "add cut avocado to the rice"
	tool_usage = list(
		/obj/item/weapon/knife =  list("starts to cut up the avocado", "start to cut up the avocado")
	)

/datum/repeatable_crafting_recipe/cooking/rice_shrimp_meal
	name = "Rice and Shrimp with Fried Cabbage"
	output = /obj/item/reagent_containers/food/snacks/riceshrimpcar
	craft_time = 6 SECONDS
	attacked_atom = /obj/item/reagent_containers/food/snacks/riceshrimp
	starting_atom = /obj/item/reagent_containers/food/snacks/cabbage_fried
	requirements = list(
		/obj/item/reagent_containers/food/snacks/riceshrimp = 1,
		/obj/item/reagent_containers/food/snacks/cabbage_fried = 1
	)
	crafting_message = "add some fried cabbage"
