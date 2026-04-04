
/datum/plant_def/tea
	name = "tea bush"
	icon = 'icons/roguetown/misc/crops.dmi'
	icon_state = "tea"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/tea
	uproot_loot = list(/obj/item/grown/log/tree/stick)
	perennial = TRUE
	produce_amount_min = 1
	produce_amount_max = 3
	maturation_time = FAST_GROWING
	produce_time = SLOW_PRODUCE_TIME
	water_drain_rate = 1 / (2 MINUTES)
	can_grow_underground = FALSE  // Tea needs sunlight
	plant_family = FAMILY_THEACEAE
	// Tea bushes are efficient with nutrients
	nitrogen_requirement = 0
	phosphorus_requirement = 25
	potassium_requirement = 0
	nitrogen_production = 25
	phosphorus_production = 0
	potassium_production = 0
	seed_identity = "tea seeds"
	rarity = PLANT_RARITY_RARE

/datum/plant_def/tea/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.quality_trait = TRAIT_GRADE_GOOD  // Tea is prized for quality
	base_genetics.disease_resistance = TRAIT_GRADE_GOOD  // Natural compounds provide some resistance
	base_genetics.water_efficiency = TRAIT_GRADE_GOOD  // Adapted to various climates
