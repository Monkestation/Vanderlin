/datum/plant_def/sugarcane
	name = "sugarcane"
	icon_state = "sugarcane"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/sugarcane
	perennial = TRUE
	produce_amount_min = 2
	produce_amount_max = 3
	produce_time = SLOW_PRODUCE_TIME
	plant_family = FAMILY_GRAIN
	nitrogen_requirement = 50  // Grains are heavy N feeders
	phosphorus_requirement = 0
	potassium_requirement = 0
	nitrogen_production = 0
	phosphorus_production = 0
	potassium_production = 40
	seed_identity = "sugarcane seeds"
	see_through = TRUE

/datum/plant_def/sugarcane/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.water_efficiency = TRAIT_GRADE_POOR  // Loves water

/datum/plant_def/wheat
	name = "wheat stalks"
	icon_state = "wheat"
	produce_type = /obj/item/natural/chaff/wheat
	produce_amount_min = 2
	produce_amount_max = 4
	uproot_loot = list(/obj/item/natural/fibers, /obj/item/natural/fibers)
	maturation_time = FAST_GROWING
	produce_time = FAST_PRODUCE_TIME
	plant_family = FAMILY_GRAIN
	nitrogen_requirement = 40  // Grains are heavy N feeders
	phosphorus_requirement = 0
	potassium_requirement = 0
	nitrogen_production = 0
	phosphorus_production = 0
	potassium_production = 20
	seed_identity = "wheat seeds"

/datum/plant_def/wheat/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.quality_trait = TRAIT_GRADE_GOOD

/datum/plant_def/oat
	name = "oat stalks"
	icon_state = "oat"
	produce_type = /obj/item/natural/chaff/oat
	produce_amount_min = 2
	produce_amount_max = 4
	uproot_loot = list(/obj/item/natural/fibers, /obj/item/natural/fibers)
	maturation_time = FAST_GROWING
	produce_time = FAST_PRODUCE_TIME
	plant_family = FAMILY_GRAIN
	nitrogen_requirement = 35  // Grains are heavy N feeders
	phosphorus_requirement = 0
	potassium_requirement = 0
	nitrogen_production = 0
	phosphorus_production = 0
	potassium_production = 15
	seed_identity = "oat seeds"

/datum/plant_def/oat/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.cold_resistance = TRAIT_GRADE_GOOD
	base_genetics.water_efficiency = TRAIT_GRADE_GOOD

/datum/plant_def/sunreed
	name = "sunreed reeds"
	icon_state = "maize"
	produce_type = /obj/item/natural/chaff/sunreed
	produce_amount_min = 2
	produce_amount_max = 4
	uproot_loot = list(/obj/item/natural/fibers, /obj/item/natural/fibers)
	maturation_time = FAST_GROWING
	produce_time = FAST_PRODUCE_TIME
	plant_family = FAMILY_GRAIN
	nitrogen_requirement = 25
	phosphorus_requirement = 0
	potassium_requirement = 0
	nitrogen_production = 0
	phosphorus_production = 0
	potassium_production = 10
	seed_identity = "sunreed seeds"

/datum/plant_def/oat/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.disease_resistance = TRAIT_GRADE_GOOD
