/datum/container_craft/cooking/yuck_soup
	name = "Yuck Soup"
	created_reagent = /datum/reagent/yuck/cursed_soup
	requirements = list(/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry/poison = 1)
	max_optionals = 0
	crafting_time = 30 SECONDS
	hides_from_books = TRUE

/datum/container_craft/cooking/yuck_soup/poo
	requirements = list(/obj/item/natural/poo = 1)

/datum/container_craft/cooking/yuck_soup/toxicshrooms
	requirements = list(/obj/item/reagent_containers/food/snacks/truffles/toxic = 1)

/datum/container_craft/cooking/yuck_soup/worms
	requirements = list(/obj/item/natural/worms = 1)

/datum/container_craft/cooking/yuck_soup/rotten_food
	requirements = list(/obj/item/reagent_containers/food/snacks/rotten = 1)

/datum/container_craft/cooking/yuck_soup/organ
	requirements = list(/obj/item/organ = 1)

/datum/container_craft/cooking/yuck_soup/living_rat
	requirements = list(/obj/item/reagent_containers/food/snacks/smallrat = 1)


/datum/container_craft/cooking/gross_stew
	name = "Gross Stew"
	created_reagent = /datum/reagent/consumable/soup/stew/gross
	requirements = list(/obj/item/reagent_containers/food/snacks/smallrat/dead = 1)
	max_optionals = 0
	crafting_time = 30 SECONDS
	hides_from_books = TRUE

/datum/container_craft/cooking/gross_stew/bad_recipe
	requirements = list(/obj/item/reagent_containers/food/snacks/badrecipe = 1)
