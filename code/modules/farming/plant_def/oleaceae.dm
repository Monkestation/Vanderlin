/datum/plant_def/ollie
	name = "ollie tree"
	icon_state = "ollietree"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/fruit/ollie
	uproot_loot = list(/obj/item/grown/log/tree/small)
	perennial = TRUE
	produce_amount_min = 2
	produce_amount_max = 3
	produce_time = SLOW_PRODUCE_TIME
	plant_family = FAMILY_OLEACEAE
	nitrogen_requirement = 15
	phosphorus_requirement = 0
	potassium_requirement = 25
	nitrogen_production = 0
	phosphorus_production = 25
	potassium_production = 0
	seed_identity = "ollie seeds"
	see_through = TRUE
