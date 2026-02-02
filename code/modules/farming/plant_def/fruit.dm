/datum/plant_def/mango
	name = "mangga tree"
	icon_state = "mangotree"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/fruit/mango
	uproot_loot = list(/obj/item/grown/log/tree/small)
	perennial = TRUE
	produce_amount_min = 2
	produce_amount_max = 4
	produce_time = SLOW_PRODUCE_TIME
	plant_family = FAMILY_FRUIT
	nitrogen_requirement = 10
	phosphorus_requirement = 0
	potassium_requirement = 45
	nitrogen_production = 0
	phosphorus_production = 35
	potassium_production = 0
	seed_identity = "mangga seed"
	see_through = TRUE

/datum/plant_def/mango/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.water_efficiency = TRAIT_GRADE_GOOD
	base_genetics.disease_resistance = TRAIT_GRADE_GOOD
	base_genetics.cold_resistance = TRAIT_GRADE_POOR

/datum/plant_def/mangosteen
	name = "mangosteen tree"
	icon_state = "mangosteentree"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/fruit/mangosteen
	uproot_loot = list(/obj/item/grown/log/tree/small)
	perennial = TRUE
	produce_amount_min = 2
	produce_amount_max = 3
	produce_time = SLOW_PRODUCE_TIME
	plant_family = FAMILY_FRUIT
	nitrogen_requirement = 42
	phosphorus_requirement = 10
	potassium_requirement = 0
	nitrogen_production = 0
	phosphorus_production = 0
	potassium_production = 40
	seed_identity = "mangosteen seed"
	see_through = TRUE

/datum/plant_def/mangosteen/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.water_efficiency = TRAIT_GRADE_POOR
	base_genetics.quality_trait = TRAIT_GRADE_GOOD
	base_genetics.cold_resistance = TRAIT_GRADE_POOR

/datum/plant_def/avocado
	name = "avocado tree"
	icon_state = "avocadotree"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/fruit/avocado
	uproot_loot = list(/obj/item/grown/log/tree/small)
	perennial = TRUE
	produce_amount_min = 2
	produce_amount_max = 4
	produce_time = SLOW_PRODUCE_TIME
	plant_family = FAMILY_FRUIT
	nitrogen_requirement = 45
	phosphorus_requirement = 0
	potassium_requirement = 0
	nitrogen_production = 0
	phosphorus_production = 0
	potassium_production = 35
	seed_identity = "avocado seed"
	see_through = TRUE

/datum/plant_def/avocado/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.water_efficiency = TRAIT_GRADE_POOR
	base_genetics.quality_trait = TRAIT_GRADE_GOOD
	base_genetics.cold_resistance = TRAIT_GRADE_POOR

/datum/plant_def/pineapple
	name = "ananas plant"
	icon_state = "pineapple"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/fruit/pineapple
	uproot_loot = list(/obj/item/grown/log/tree/stick)
	perennial = FALSE
	produce_amount_min = 1
	produce_amount_max = 2
	plant_family = FAMILY_FRUIT
	nitrogen_requirement = 10
	phosphorus_requirement = 25
	potassium_requirement = 35
	nitrogen_production = 25
	phosphorus_production = 0
	potassium_production = 0
	seed_identity = "ananas seed"

/datum/plant_def/pineapple/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.water_efficiency = TRAIT_GRADE_GOOD
	base_genetics.growth_speed = TRAIT_GRADE_GOOD
	base_genetics.cold_resistance = TRAIT_GRADE_POOR

/datum/plant_def/dragonfruit
	name = "piyata cactus"
	icon_state = "dragonfruit"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/fruit/dragonfruit
	uproot_loot = list(/obj/item/grown/log/tree/stick)
	perennial = TRUE
	produce_amount_min = 2
	produce_amount_max = 3
	produce_time = SLOW_PRODUCE_TIME
	plant_family = FAMILY_FRUIT
	nitrogen_requirement = 10
	phosphorus_requirement = 20
	potassium_requirement = 30
	nitrogen_production = 20
	phosphorus_production = 0
	potassium_production = 0
	seed_identity = "piyata seed"
	can_grow_underground = TRUE

/datum/plant_def/dragonfruit/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.water_efficiency = TRAIT_GRADE_GOOD
	base_genetics.disease_resistance = TRAIT_GRADE_GOOD
