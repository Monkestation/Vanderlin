/datum/container_craft/cooking/oatmeal
	name = "Oatmeal"
	max_optionals = 2
	created_reagent = /datum/reagent/consumable/soup/oatmeal
	requirements = list(/obj/item/reagent_containers/food/snacks/produce/grain/oat = 1)
	optional_wildcard_requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fruit = 2,
		/obj/item/reagent_containers/food/snacks/produce/vegetable = 2
	)
	wording_choice = "mashed"
	crafting_time = 30 SECONDS

/datum/container_craft/cooking/sweet_sunreed //This uses grains so I'm putting it here.
	name = "Sweet Sunreed"
	created_reagent = /datum/reagent/consumable/soup/oatmeal/sunreed
	requirements = list(/obj/item/reagent_containers/food/snacks/produce/grain/sunreed = 1)
	max_optionals = 3
	optional_wildcard_requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/vegetable = 3
	)
	wording_choice = "mashed"
	finished_smell = /datum/pollutant/food/sweet_sunreed
	crafting_time = 35 SECONDS
