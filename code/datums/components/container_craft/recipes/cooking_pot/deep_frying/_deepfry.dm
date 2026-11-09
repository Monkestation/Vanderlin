/datum/container_craft/cooking/melt_tallow
	name = "Melt Tallow"
	category = "Deep Frying"
	required_chem_temp = 450
	requirements = list(
		/obj/item/reagent_containers/food/snacks/tallow = 1
	)
	reagent_requirements = null
	created_reagent = /datum/reagent/consumable/tallow
	created_amount = 100
	finished_smell = /datum/pollutant/food/fried_meat

/datum/container_craft/cooking/egg_wash
	abstract_type = /datum/container_craft/cooking/egg_wash
	required_container = /obj/item/reagent_containers/glass/bowl
	category = "Deep Frying"
	required_chem_temp = 0
	reagent_requirements = list(
		/datum/reagent/consumable/eggyolk = 10
	)
	craft_verb = "dredges "
	reagent_consume_mod = 0.5
	finished_smell = null
	crafting_time = 0.2 SECONDS

/datum/container_craft/cooking/egg_wash/poultry
	name = "Egg Washed Bird Meat"
	output = /obj/item/reagent_containers/food/snacks/meat/poultry/cutlet/egg_washed

/datum/container_craft/cooking/deep_fry
	abstract_type = /datum/container_craft/cooking/deep_fry
	category = "Deep Frying"
	reagent_requirements = list(
		/datum/reagent/consumable/tallow = 100
	)
	reagent_consume_mod = 0.1
	craft_verb = "fries "

/datum/container_craft/cooking/deep_fry/cutlet
	name = "Tender Birdmeat"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/meat/poultry/cutlet/coated = 1
	)
	output = /obj/item/reagent_containers/food/snacks/cooked/frybird/fried
