/datum/plant_def/sunflower
	name = "sunflowers"
	icon_state = "sunflower"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/sunflower
	produce_amount_min = 2
	produce_amount_max = 3
	maturation_time = VERY_FAST_GROWING
	water_drain_rate = 1 / (2 MINUTES)
	plant_family = FAMILY_ASTERACEAE
	nitrogen_requirement = 0
	phosphorus_requirement = 25
	potassium_requirement = 0
	potassium_production =  25
	nitrogen_production = 0
	phosphorus_production = 0
	seed_identity = "sunflower seeds"

/datum/plant_def/sunflower/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.growth_speed = TRAIT_GRADE_GOOD

/datum/plant_def/fyritiusflower
	name = "fyritius flowers"
	icon_state = "fyritius"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/fyritius
	produce_amount_min = 1
	produce_amount_max = 2
	maturation_time = FAST_GROWING
	water_drain_rate = 1 / (2 MINUTES)
	plant_family = FAMILY_ASTERACEAE
	nitrogen_requirement = 0
	phosphorus_requirement = 30
	potassium_requirement = 0
	potassium_production =  0
	nitrogen_production = 30
	phosphorus_production = 0
	seed_identity = "fyritius seeds"

/datum/plant_def/fyritiusflower/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.quality_trait = TRAIT_GRADE_GOOD
	base_genetics.disease_resistance = TRAIT_GRADE_GOOD

/datum/plant_def/manabloom
	name = "manabloom"
	icon_state = "manabloom"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/manabloom
	produce_amount_min = 1
	produce_amount_max = 2
	maturation_time = FAST_GROWING
	water_drain_rate = 1 / (2 MINUTES)
	can_grow_underground = TRUE
	plant_family = FAMILY_ASTERACEAE
	nitrogen_requirement = 0
	phosphorus_requirement = 35
	potassium_requirement = 0
	potassium_production =  35
	nitrogen_production = 0
	phosphorus_production = 0
	seed_identity = "manabloom seeds"
	honey_type = /obj/item/reagent_containers/food/snacks/spiderhoney/honey/luminescent

/datum/plant_def/manabloom/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.quality_trait = TRAIT_GRADE_GOOD
	base_genetics.water_efficiency = TRAIT_GRADE_GOOD

/datum/plant_def/poppy
	name = "poppies"
	icon_state = "poppy"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/poppy
	produce_amount_min = 1
	produce_amount_max = 2
	water_drain_rate = 1 / (2 MINUTES)
	plant_family = FAMILY_ASTERACEAE
	nitrogen_requirement = 0
	phosphorus_requirement = 0
	potassium_requirement = 40
	potassium_production =  0
	nitrogen_production = 40
	phosphorus_production = 0
	seed_identity = "poppy seeds"
	honey_type = /obj/item/reagent_containers/food/snacks/spiderhoney/honey/poppy

/datum/plant_def/poppy/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.quality_trait = TRAIT_GRADE_GOOD
	base_genetics.disease_resistance = TRAIT_GRADE_GOOD  // Alkaloids deter pests
