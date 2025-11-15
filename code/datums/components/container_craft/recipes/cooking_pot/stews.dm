/datum/container_craft/cooking/potato_stew
	name = "Potato Stew"
	created_reagent = /datum/reagent/consumable/soup/veggie/potato
	requirements = list(/obj/item/reagent_containers/food/snacks/veg/potato_sliced = 1)
	max_optionals = 3
	optional_wildcard_requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/vegetable = 3
	)
	finished_smell = /datum/pollutant/food/potato_stew
	crafting_time = 40 SECONDS

/datum/container_craft/cooking/onion_stew
	name = "Onion Stew"
	created_reagent = /datum/reagent/consumable/soup/veggie/onion
	requirements = list(/obj/item/reagent_containers/food/snacks/veg/onion_sliced = 1)
	max_optionals = 3
	optional_wildcard_requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/vegetable = 3
	)
	finished_smell = /datum/pollutant/food/onion_stew
	crafting_time = 30 SECONDS

/datum/container_craft/cooking/cabbage_stew
	name = "Cabbage Stew"
	created_reagent = /datum/reagent/consumable/soup/veggie/cabbage
	requirements = list(/obj/item/reagent_containers/food/snacks/veg/cabbage_sliced = 1)
	max_optionals = 3
	optional_wildcard_requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/vegetable = 3
	)
	finished_smell = /datum/pollutant/food/cabbage_stew
	crafting_time = 35 SECONDS

/datum/container_craft/cooking/turnip_stew
	name = "Turnip Stew"
	created_reagent = /datum/reagent/consumable/soup/veggie/turnip
	requirements = list(/obj/item/reagent_containers/food/snacks/veg/turnip_sliced = 1)
	max_optionals = 3
	optional_wildcard_requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/vegetable = 3
	)
	finished_smell = /datum/pollutant/food/turnip_stew
	crafting_time = 35 SECONDS

/datum/container_craft/cooking/fish_stew
	name = "Fish Stew"
	created_reagent = /datum/reagent/consumable/soup/stew/fish
	requirements = list(/obj/item/reagent_containers/food/snacks/meat/mince/fish = 1)
	max_optionals = 3
	optional_wildcard_requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/vegetable = 3
	)
	finished_smell = /datum/pollutant/food/fish_stew
	crafting_time = 40 SECONDS

/datum/container_craft/cooking/chicken_stew
	name = "Chicken Stew"
	created_reagent = /datum/reagent/consumable/soup/stew/chicken
	requirements = list(/obj/item/reagent_containers/food/snacks/meat/mince/poultry = 1)
	max_optionals = 3
	optional_wildcard_requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/vegetable = 3
	)
	finished_smell = /datum/pollutant/food/chicken_stew
	crafting_time = 45 SECONDS

/datum/container_craft/cooking/chicken_stew/cutlet
	requirements = list(/obj/item/reagent_containers/food/snacks/meat/poultry/cutlet = 1)

/datum/container_craft/cooking/questionable_stew
	name = "Questionable Stew"
	created_reagent = /datum/reagent/consumable/soup/stew/gross
	requirements = list(/obj/item/reagent_containers/food/snacks/meat/strange = 1)
	max_optionals = 3
	optional_wildcard_requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/vegetable = 3
	)
	finished_smell = /datum/pollutant/food/potato_stew
	crafting_time = 45 SECONDS

/datum/container_craft/cooking/generic_meat_stew //this is a generic so its removed from the subtypes of and added back so its always bottom of the list
	name = "Meat Stew"
	created_reagent = /datum/reagent/consumable/soup/stew/meat
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/meat = 1)
	max_optionals = 3
	optional_wildcard_requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/vegetable = 3
	)
	finished_smell = /datum/pollutant/food/meat_stew
	crafting_time = 45 SECONDS
	craft_priority = FALSE

/datum/container_craft/cooking/truffle_stew
	name = "Truffle Stew"
	created_reagent = /datum/reagent/consumable/soup/stew/truffle
	requirements = list(/obj/item/reagent_containers/food/snacks/truffles = 1)
	max_optionals = 3
	optional_wildcard_requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/vegetable = 3
	)
	finished_smell = /datum/pollutant/food/truffle_stew
	crafting_time = 40 SECONDS

/datum/container_craft/cooking/borowiki_stew
	name = "Borowiki Stew"
	created_reagent = /datum/reagent/consumable/soup/stew/borowiki
	requirements = list(/obj/item/reagent_containers/food/snacks/produce/mushroom/borowiki = 1)
	max_optionals = 3
	optional_wildcard_requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/vegetable = 3
	)
	finished_smell = /datum/pollutant/food/borowiki_stew
	crafting_time = 40 SECONDS
