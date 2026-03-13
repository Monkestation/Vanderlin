/datum/plant_genetics
	/// Yield multiplier (affects produce amount)
	var/yield_trait = TRAIT_GRADE_AVERAGE
	/// Disease resistance (affects pest/disease damage)
	var/disease_resistance = TRAIT_GRADE_AVERAGE
	/// Quality potential (affects maximum quality achievable)
	var/quality_trait = TRAIT_GRADE_AVERAGE
	/// Growth speed (affects maturation time)
	var/growth_speed = TRAIT_GRADE_AVERAGE
	/// Water efficiency (affects water consumption)
	var/water_efficiency = TRAIT_GRADE_AVERAGE
	/// Cold resistance (affects frost damage)
	var/cold_resistance = TRAIT_GRADE_AVERAGE
	/// Generation number (for tracking breeding lines)
	var/generation = 1
	/// Parent genetics for lineage tracking
	var/datum/plant_genetics/parent_a
	var/datum/plant_genetics/parent_b
	/// Unique variety name if this is a special cultivar
	var/variety_name
	/// What string to add in front of the plant_def seed_identity
	var/seed_identity_modifier

/datum/plant_genetics/New(datum/plant_def/plant_def_instance)
	. = ..()
	if(istype(plant_def_instance))
		plant_def_instance.set_genetic_tendencies(src)
	// Add some random variation to base genetics
	randomize_traits(10)  // ±10 points variation

/datum/plant_genetics/proc/randomize_traits(variation = 20)
	yield_trait = clamp(yield_trait + rand(-variation, variation), 0, TRAIT_GRADE_EXCELLENT)
	disease_resistance = clamp(disease_resistance + rand(-variation, variation), 0, TRAIT_GRADE_EXCELLENT)
	quality_trait = clamp(quality_trait + rand(-variation, variation), 0, TRAIT_GRADE_EXCELLENT)
	growth_speed = clamp(growth_speed + rand(-variation, variation), 0, TRAIT_GRADE_EXCELLENT)
	water_efficiency = clamp(water_efficiency + rand(-variation, variation), 0, TRAIT_GRADE_EXCELLENT)
	cold_resistance = clamp(cold_resistance + rand(-variation, variation), 0, TRAIT_GRADE_EXCELLENT)

/datum/plant_genetics/proc/crossbreed_with(datum/plant_genetics/other)
	var/datum/plant_genetics/offspring = new()

	// Inherit traits from both parents with some randomization
	offspring.yield_trait = inherit_trait(yield_trait, other.yield_trait)
	offspring.disease_resistance = inherit_trait(disease_resistance, other.disease_resistance)
	offspring.quality_trait = inherit_trait(quality_trait, other.quality_trait)
	offspring.growth_speed = inherit_trait(growth_speed, other.growth_speed)
	offspring.water_efficiency = inherit_trait(water_efficiency, other.water_efficiency)
	offspring.cold_resistance = inherit_trait(cold_resistance, other.cold_resistance)

	offspring.generation = max(generation, other.generation) + 1
	offspring.parent_a = src
	offspring.parent_b = other

	// Check for mutations
	if(prob(BASE_MUTATION_CHANCE))
		offspring.mutate_traits()

	return offspring

/datum/plant_genetics/proc/copy()
	var/datum/plant_genetics/new_genetics = new()
	new_genetics.yield_trait = yield_trait
	new_genetics.disease_resistance = disease_resistance
	new_genetics.quality_trait = quality_trait
	new_genetics.growth_speed = growth_speed
	new_genetics.water_efficiency = water_efficiency
	new_genetics.cold_resistance = cold_resistance
	new_genetics.generation = generation + 1
	new_genetics.variety_name = variety_name
	// Note: parent references are not copied to avoid circular references
	return new_genetics

/datum/plant_genetics/proc/inherit_trait(trait_a, trait_b)
	// Weighted average with some randomization
	var/base_value = (trait_a + trait_b) / 2
	var/variation = rand(-15, 15)  // ±15 point variation
	return clamp(base_value + variation, 10, 100)

/// Mutate traits to improve them
/datum/plant_genetics/proc/mutate_traits(amount = 1)
	for(var/i in 1 to amount)
		switch(rand(1,6))
			if(TRAIT_YIELD)
				yield_trait = clamp(yield_trait + rand(10, 15), 0, TRAIT_GRADE_EXCELLENT)
			if(TRAIT_DISEASE_RESISTANCE)
				disease_resistance = clamp(disease_resistance + rand(10, 15), 0, TRAIT_GRADE_EXCELLENT)
			if(TRAIT_QUALITY)
				quality_trait = clamp(quality_trait + rand(10, 15), 0, TRAIT_GRADE_EXCELLENT)
			if(TRAIT_GROWTH_SPEED)
				growth_speed = clamp(growth_speed + rand(10, 15), 0, TRAIT_GRADE_EXCELLENT)
			if(TRAIT_WATER_EFFICIENCY)
				water_efficiency = clamp(water_efficiency + rand(10, 15), 0, TRAIT_GRADE_EXCELLENT)
			if(TRAIT_COLD_RESISTANCE)
				cold_resistance = clamp(cold_resistance + rand(10, 15), 0, TRAIT_GRADE_EXCELLENT)
