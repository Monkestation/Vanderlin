/datum/plant_def/cabbage
	name = "cabbage patch"
	icon_state = "cabbage"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/vegetable/cabbage
	produce_amount_min = 2
	produce_amount_max = 3
	maturation_time = FAST_GROWING
	plant_family = FAMILY_BRASSICA
	nitrogen_requirement = 40  // Leafy greens need lots of N
	phosphorus_requirement = 0
	potassium_requirement = 0
	nitrogen_production = 0
	phosphorus_production = 30
	potassium_production = 0
	seed_identity = "cabbage seeds"
	rarity = PLANT_RARITY_COMMON

/datum/plant_def/cabbage/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.growth_speed = TRAIT_GRADE_GOOD
	base_genetics.cold_resistance = TRAIT_GRADE_GOOD
