/datum/plant_def/potato
	name = "potato plant"
	icon_state = "potato"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/vegetable/potato
	produce_amount_min = 2
	produce_amount_max = 4
	water_drain_rate = 1 / (1 MINUTES)
	plant_family = FAMILY_SOLANACEAE
	nitrogen_requirement = 0
	phosphorus_requirement = 0
	potassium_requirement = 40
	nitrogen_production = 30
	phosphorus_production = 0
	potassium_production = 0
	seed_identity = "potato seedlings"
	rarity = PLANT_RARITY_COMMON

/datum/plant_def/potato/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.water_efficiency = TRAIT_GRADE_GOOD
