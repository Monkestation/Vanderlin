/datum/plant_def/coffee
	name = "coffee bush"
	icon = 'icons/roguetown/misc/crops.dmi'
	icon_state = "coffee"
	produce_type = /obj/item/reagent_containers/food/snacks/produce/coffee
	uproot_loot = list(/obj/item/grown/log/tree/stick)
	perennial = TRUE
	produce_amount_min = 0
	produce_amount_max = 3
	maturation_time = FAST_GROWING
	produce_time = SLOW_PRODUCE_TIME
	water_drain_rate = 1 / (2 MINUTES)
	can_grow_underground = FALSE  // Coffee needs sunlight
	plant_family = FAMILY_RUBIACEAE
	// Coffee bushes need moderate nutrients
	nitrogen_requirement = 25
	phosphorus_requirement = 0
	potassium_requirement = 0
	nitrogen_production = 0
	phosphorus_production = 0
	potassium_production = 25
	seed_identity = "coffee seeds"
	rarity = PLANT_RARITY_EXOTIC

/datum/plant_def/coffee/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.quality_trait = TRAIT_GRADE_GOOD  // Coffee is prized for quality
	base_genetics.water_efficiency = TRAIT_GRADE_AVERAGE  // Needs consistent moisture
