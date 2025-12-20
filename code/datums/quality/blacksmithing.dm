/datum/quality_calculator/blacksmithing
	name = "Blacksmithing Quality"
	var/minigame_success = 0

/datum/quality_calculator/blacksmithing/calculate_final_quality()
	var/avg_material = floor(material_quality / num_components)

	// skill_quality = player's blacksmithing skill level (0-6)
	// performance_quality = number of hits taken
	// minigame_success = minigame score (0-100+)

	// Skill factor for quality contribution (0 to 1)
	var/skill_factor = skill_quality / 6

	// Performance factor from minigame (0 to 1.2)
	var/performance_factor = min(1.2, minigame_success / 100)

	// Quality components
	var/skill_component = skill_factor * 2.5 // Max +2.5 at skill 6
	var/material_component = avg_material * 0.8
	var/performance_component = performance_factor * 2.0 // Max +2.4 for perfect minigame

	// Penalties
	var/hit_penalty = floor(performance_quality * 0.4) // More hits = worse
	var/difficulty_penalty = floor(difficulty_modifier * 0.6) // Harder recipes = harder to perfect

	var/final_quality = skill_component + material_component + performance_component - hit_penalty - difficulty_penalty

	// Soft cap: quality above skill level is penalized
	// This allows masterworks with good materials, but makes them harder at low skill
	if(final_quality > skill_quality)
		var/excess = final_quality - skill_quality
		final_quality = skill_quality + (excess * 0.5) // 50% of excess quality counts

	return clamp(round(final_quality), -10, 8)
