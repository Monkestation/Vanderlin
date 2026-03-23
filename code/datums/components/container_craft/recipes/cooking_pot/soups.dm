/datum/container_craft/cooking/egg_soup
	name = "Egg Soup"
	created_reagent = /datum/reagent/consumable/soup/egg
	requirements = list(/obj/item/reagent_containers/food/snacks/egg = 1)
	max_optionals = 2
	optional_wildcard_requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/vegetable = 2
	)
	finished_smell = /datum/pollutant/food/egg_soup
	crafting_time = 40 SECONDS

/datum/container_craft/cooking/tamto_soup
	name = "Tamto Soup"
	created_reagent = /datum/reagent/consumable/soup/veggie/tamto
	requirements = list(/obj/item/reagent_containers/food/snacks/fruit/tamto_slice = 1)
	max_optionals = 2
	optional_wildcard_requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/vegetable = 2
	)
	finished_smell = /datum/pollutant/food/tamto_soup
	crafting_time = 40 SECONDS

/datum/container_craft/cooking/pompkaun_soup
	name ="Pompkaun Soup"
	created_reagent = /datum/reagent/consumable/soup/veggie/pompkaun
	requirements = list(/obj/item/reagent_containers/food/snacks/fruit/pompkaun_goo = 1)
	max_optionals = 2
	optional_wildcard_requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/vegetable = 2
	)
	finished_smell = /datum/pollutant/food/pompkaun_soup
	crafting_time = 40 SECONDS

/datum/container_craft/cooking/cheese_soup
	name = "Cheese Soup"
	created_reagent = /datum/reagent/consumable/soup/cheese
	requirements = list(/obj/item/reagent_containers/food/snacks/cheese = 1)
	max_optionals = 2
	optional_wildcard_requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/vegetable = 2
	)
	finished_smell = /datum/pollutant/food/cheese_soup
	crafting_time = 40 SECONDS

/datum/container_craft/cooking/cheese_soup/wedge
	requirements = list(/obj/item/reagent_containers/food/snacks/cheese_wedge = 1)
