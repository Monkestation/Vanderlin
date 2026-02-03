
/datum/bee_genetics
	var/efficiency = 1.0
	var/aggression = 0
	var/lifespan = 1.0
	var/color = "#FFD700"
	var/disease_resistance = 1.0

/datum/bee_genetics/proc/mutate(mutation_strength = 10)
	efficiency += rand(-mutation_strength, mutation_strength) / 100
	aggression += rand(-mutation_strength/2, mutation_strength/2)
	lifespan += rand(-mutation_strength, mutation_strength) / 100
	disease_resistance += rand(-mutation_strength, mutation_strength) / 100
	clamp_values()

/datum/bee_genetics/proc/clamp_values()
	efficiency = clamp(efficiency, 0.5, 2.0)
	aggression = clamp(aggression, 0, 100)
	lifespan = clamp(lifespan, 0.5, 2.0)
	disease_resistance = clamp(disease_resistance, 0.5, 2.0)

/datum/bee_genetics/proc/copy()
	var/datum/bee_genetics/G = new()
	G.efficiency = efficiency
	G.aggression = aggression
	G.lifespan = lifespan
	G.color = color
	G.disease_resistance = disease_resistance
	return G

/datum/bee_genetics/proc/apply_to_bee(obj/effect/bees/bee)
	bee.bee_efficiency = efficiency
	bee.bee_aggression = aggression
	bee.bee_lifespan = lifespan
	bee.bee_color = color
	bee.bee_disease_resistance = disease_resistance
