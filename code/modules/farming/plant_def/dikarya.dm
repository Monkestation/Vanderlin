/datum/plant_def/mushroom
	plant_family = FAMILY_DIKARYA
	can_grow_underground = TRUE
	mound_growth = TRUE
	produce_amount_min = 1
	produce_amount_max = 4
	potassium_requirement = 0 // Ash won't work well as fertilizer for these

/* Cultivars */
/datum/plant_def/mushroom/capillus
	name = "capillus mort cluster"
	icon_state = "capillus"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/mushroom/capillus
	produce_amount_min = 2
	produce_amount_max = 5
	produce_time = FAST_PRODUCE_TIME
	nitrogen_requirement = 0
	phosphorus_requirement = 30 // Grows well with its companion, borowiki
	nitrogen_production = 20
	phosphorus_production = 0
	potassium_production = 0
	seed_identity = "capillus mort spores"

/datum/plant_def/mushroom/capillus/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.growth_speed = TRAIT_GRADE_GOOD
	base_genetics.cold_resistance = TRAIT_GRADE_POOR
	base_genetics.water_efficiency = TRAIT_GRADE_POOR

/datum/plant_def/mushroom/borowiki
	name = "borowiki cluster"
	icon_state = "borowiki"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/mushroom/borowiki
	produce_amount_min = 2
	produce_amount_max = 5
	produce_time = DEFAULT_PRODUCE_TIME
	nitrogen_requirement = 40 // Borowiki is a cultivar that produces more and heartier mushrooms, but requires more N than most.
	phosphorus_requirement = 0
	nitrogen_production = 0
	phosphorus_production = 20
	potassium_production = 0
	seed_identity = "borowiki spores"

/datum/plant_def/mushroom/borowiki/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.growth_speed = TRAIT_GRADE_GOOD
	base_genetics.water_efficiency = TRAIT_GRADE_GOOD

/* Wild varieties */
/datum/plant_def/mushroom/waddle
	name = "waddle cluster"
	icon_state = "waddle"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/mushroom/waddle
	produce_time = SLOW_PRODUCE_TIME
	nitrogen_requirement = 35
	phosphorus_requirement = 0
	nitrogen_production = 0
	phosphorus_production = 24
	potassium_production = 0
	seed_identity = "waddle spores"

/datum/plant_def/mushroom/waddle/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.growth_speed = TRAIT_GRADE_GOOD

/datum/plant_def/mushroom/merkel
	name = "merkel cluster"
	icon_state = "merkel"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/mushroom/merkel
	produce_time = SLOW_PRODUCE_TIME
	nitrogen_requirement = 38
	phosphorus_requirement = 0
	nitrogen_production = 16
	phosphorus_production = 20 // Wider production spread that makes the wait more worthwhile
	potassium_production = 12
	seed_identity = "merkel spores"

/datum/plant_def/mushroom/merkel/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.growth_speed = TRAIT_GRADE_POOR // Grow slowly
	base_genetics.cold_resistance = TRAIT_GRADE_GOOD // But grow in a wider range of conditions

/datum/plant_def/mushroom/caveweep
	name = "caveweep cluster"
	icon_state = "caveweep"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/mushroom/caveweep
	produce_time = SLOW_PRODUCE_TIME
	nitrogen_requirement = 32
	phosphorus_requirement = 0
	nitrogen_production = 0
	phosphorus_production = 26
	potassium_production = 0
	seed_identity = "caveweep spores"

/datum/plant_def/mushroom/caveweep/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.growth_speed = TRAIT_GRADE_POOR
	base_genetics.cold_resistance = TRAIT_GRADE_GOOD // Can grow in colder conditions
	base_genetics.water_efficiency = TRAIT_GRADE_GOOD

/* /datum/plant_def/mushroom/chanterelle
	name = "chanterelle cluster"
	icon_state = "chanterelle"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/mushroom/chanterelle
	produce_time = DEFAULT_PRODUCE_TIME
	nitrogen_requirement = 32
	phosphorus_requirement = 0
	nitrogen_production = 0
	phosphorus_production = 0
	potassium_production = 28
	seed_identity = "chanterelle spores"

/datum/plant_def/mushroom/chanterelle/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.growth_speed = TRAIT_GRADE_GOOD
	base_genetics.cold_resistance = TRAIT_GRADE_POOR
	base_genetics.water_efficiency = TRAIT_GRADE_GOOD */ // Saving this for later expansion and rework
