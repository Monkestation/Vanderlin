/datum/plant_def/jacksberry
	name = "jacksberry bush"
	icon_state = "berry"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry
	uproot_loot = list(/obj/item/grown/log/tree/stick)
	perennial = TRUE
	produce_amount_min = 2
	produce_amount_max = 3
	maturation_time = FAST_GROWING
	produce_time = SLOW_PRODUCE_TIME
	plant_family = FAMILY_ROSACEAE
	nitrogen_requirement = 0
	phosphorus_requirement = 35
	potassium_requirement = 0
	nitrogen_production = 0
	phosphorus_production = 0
	potassium_production = 25
	seed_identity = "berry seeds"

/datum/plant_def/jacksberry_poison
	name = "jacksberry bush"
	icon_state = "berry"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry/poison
	uproot_loot = list(/obj/item/grown/log/tree/stick)
	perennial = TRUE
	produce_amount_min = 2
	produce_amount_max = 3
	maturation_time = FAST_GROWING
	produce_time = SLOW_PRODUCE_TIME
	plant_family = FAMILY_ROSACEAE
	nitrogen_requirement = 0
	phosphorus_requirement = 0
	potassium_requirement = 35
	nitrogen_production = 0
	phosphorus_production = 25
	potassium_production = 0
	seed_identity = "berry seeds"

/datum/plant_def/jacksberry_poison/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.disease_resistance = TRAIT_GRADE_GOOD  // Poisonous = pest resistant

/datum/plant_def/strawberry
	name = "strawberry bush"
	icon_state = "strawberry"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/fruit/strawberry
	uproot_loot = list(/obj/item/grown/log/tree/stick)
	perennial = TRUE
	produce_amount_min = 2
	produce_amount_max = 3
	maturation_time = FAST_GROWING
	produce_time = SLOW_PRODUCE_TIME
	plant_family = FAMILY_ROSACEAE
	nitrogen_requirement = 0
	phosphorus_requirement = 35
	potassium_requirement = 0
	nitrogen_production = 0
	phosphorus_production = 0
	potassium_production = 25
	seed_identity = "strawberry seeds"

/datum/plant_def/strawberry/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.quality_trait = TRAIT_GRADE_GOOD

/datum/plant_def/blackberry
	name = "blackberry bush"
	icon_state = "blackberry"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/fruit/blackberry
	uproot_loot = list(/obj/item/grown/log/tree/stick)
	perennial = TRUE
	produce_amount_min = 2
	produce_amount_max = 3
	maturation_time = FAST_GROWING
	produce_time = SLOW_PRODUCE_TIME
	plant_family = FAMILY_ROSACEAE
	nitrogen_requirement = 28
	phosphorus_requirement = 0
	potassium_requirement = 0
	nitrogen_production = 0
	phosphorus_production = 0
	potassium_production = 25
	seed_identity = "blackberry seeds"

/datum/plant_def/blackberry/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.disease_resistance = TRAIT_GRADE_GOOD  // Thorny = pest resistant
	base_genetics.cold_resistance = TRAIT_GRADE_GOOD

/datum/plant_def/raspberry
	name = "raspberry bush"
	icon_state = "raspberry"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/fruit/raspberry
	uproot_loot = list(/obj/item/grown/log/tree/stick)
	perennial = TRUE
	produce_amount_min = 2
	produce_amount_max = 3
	maturation_time = FAST_GROWING
	produce_time = SLOW_PRODUCE_TIME
	plant_family = FAMILY_ROSACEAE
	nitrogen_requirement = 0
	phosphorus_requirement = 0
	potassium_requirement = 38
	nitrogen_production = 20
	phosphorus_production = 0
	potassium_production = 0
	seed_identity = "raspberry seeds"

/datum/plant_def/raspberry/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.cold_resistance = TRAIT_GRADE_GOOD

/datum/plant_def/tamto
	name = "tamto vine"
	icon_state = "mato"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/fruit/tamto
	uproot_loot = list(/obj/item/grown/log/tree/stick)
	perennial = TRUE
	produce_amount_min = 2
	produce_amount_max = 3
	maturation_time = FAST_GROWING
	produce_time = SLOW_PRODUCE_TIME
	plant_family = FAMILY_ROSACEAE
	nitrogen_requirement = 0
	phosphorus_requirement = 0
	potassium_requirement = 30
	nitrogen_production = 0
	phosphorus_production = 20
	potassium_production = 0
	seed_identity = "tamto seeds"

/datum/plant_def/tamto/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.water_efficiency = TRAIT_GRADE_POOR //These grow submerged in water, so they drink a LOT.
	base_genetics.cold_resistance = TRAIT_GRADE_GOOD

/datum/plant_def/plum
	see_through = TRUE
	name = "plum tree"
	icon_state = "plumtree"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/fruit/plum
	uproot_loot = list(/obj/item/grown/log/tree/small)
	perennial = TRUE
	produce_amount_min = 2
	produce_amount_max = 3
	produce_time = SLOW_PRODUCE_TIME
	plant_family = FAMILY_ROSACEAE
	nitrogen_requirement = 35
	phosphorus_requirement = 0
	potassium_requirement = 0
	nitrogen_production = 0
	phosphorus_production = 32
	potassium_production = 0
	seed_identity = "plum seeds"

/datum/plant_def/plum/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.disease_resistance = TRAIT_GRADE_GOOD

/datum/plant_def/apple
	see_through = TRUE
	name = "apple tree"
	icon_state = "apple"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/fruit/apple
	uproot_loot = list(/obj/item/grown/log/tree/small)
	perennial = TRUE
	produce_amount_min = 2
	produce_amount_max = 3
	produce_time = SLOW_PRODUCE_TIME
	plant_family = FAMILY_ROSACEAE
	nitrogen_requirement = 0
	phosphorus_requirement = 0
	potassium_requirement = 40
	nitrogen_production = 0
	phosphorus_production = 30
	potassium_production = 0
	seed_identity = "apple seeds"

/datum/plant_def/apple/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.cold_resistance = TRAIT_GRADE_GOOD
	base_genetics.disease_resistance = TRAIT_GRADE_GOOD

/datum/plant_def/pear
	see_through = TRUE
	name = "pear tree"
	icon_state = "pear"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/fruit/pear
	uproot_loot = list(/obj/item/grown/log/tree/small)
	perennial = TRUE
	produce_amount_min = 2
	produce_amount_max = 3
	produce_time = SLOW_PRODUCE_TIME
	plant_family = FAMILY_ROSACEAE
	nitrogen_requirement = 0
	phosphorus_requirement = 0
	potassium_requirement = 38
	nitrogen_production = 32
	phosphorus_production = 0
	potassium_production = 0
	seed_identity = "pear seeds"

/datum/plant_def/pear/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.water_efficiency = TRAIT_GRADE_GOOD
	base_genetics.disease_resistance = TRAIT_GRADE_GOOD

/datum/plant_def/pompkaun
	name = "pompkaun vine"
	icon_state = "pompkaun"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/fruit/pompkaun
	produce_amount_min = 2
	produce_amount_max = 3
	produce_time = SLOW_PRODUCE_TIME
	plant_family = FAMILY_ROSACEAE
	nitrogen_requirement = 0
	phosphorus_requirement = 0
	potassium_requirement = 35
	nitrogen_production = 0
	phosphorus_production = 20
	potassium_production = 0
	seed_identity = "pompkaun seeds"

/datum/plant_def/pompkaun/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.cold_resistance = TRAIT_GRADE_GOOD
