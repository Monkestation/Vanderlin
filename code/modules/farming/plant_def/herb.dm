/datum/plant_def/swampweed
	name = "swampweed"
	icon_state = "swampweed"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/swampweed
	produce_amount_min = 2
	produce_amount_max = 4
	water_drain_rate = 0
	plant_family = FAMILY_HERB
	nitrogen_requirement = 15
	phosphorus_requirement = 0
	potassium_requirement = 0
	nitrogen_production = 0
	phosphorus_production = 0
	potassium_production = 15
	seed_identity = "swampweed seeds"
	honey_type = /obj/item/reagent_containers/food/snacks/spiderhoney/honey/mad

/datum/plant_def/swampweed/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.water_efficiency = TRAIT_GRADE_GOOD
	base_genetics.disease_resistance = TRAIT_GRADE_GOOD

/datum/plant_def/westleach
	name = "westleach leaf"
	icon_state = "westleach"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/westleach
	produce_amount_min = 2
	produce_amount_max = 4
	maturation_time = FAST_GROWING
	produce_time = FAST_PRODUCE_TIME
	plant_family = FAMILY_HERB
	nitrogen_requirement = 0
	phosphorus_requirement = 20
	potassium_requirement = 0
	nitrogen_production = 20
	phosphorus_production = 0
	potassium_production = 0
	seed_identity = "westleach leaf seeds"
