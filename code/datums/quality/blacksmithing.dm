/datum/quality_calculator/blacksmithing
	name = "Blacksmithing Quality"
	var/minigame_success = 0

/datum/quality_calculator/blacksmithing/calculate_final_quality()
	var/avg_material = floor(material_quality / num_components)

	// Skill factor (0 to 1)
	var/skill_factor = skill_quality / 6
	var/performance_factor = min(1.2, minigame_success / 100)

	// --- FORGIVING WEIGHTS ---
	var/skill_component = skill_factor * 3.0      // Max +3.0
	var/material_component = avg_material * 1.5   // Max +6.0
	var/performance_component = performance_factor * 3.0 // Max +3.6 (120 score)

	var/hit_penalty = floor(performance_quality * 0.5)
	var/difficulty_penalty = floor(difficulty_modifier * 0.3)

	var/raw_quality = skill_component + material_component + performance_component - hit_penalty - difficulty_penalty

	var/final_quality = raw_quality
	if(raw_quality > skill_quality)
		var/excess = raw_quality - skill_quality
		final_quality = skill_quality + (excess * 0.8) // High retention (80%)

	return clamp(round(final_quality), -10, 8)
