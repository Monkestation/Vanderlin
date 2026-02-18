
/datum/quality_calculator/metallurgy
	name = "Metallurgy Quality"

	quality_descriptors = alist(
		SMELTERY_QUALITY_SPOIL = list(
			"name_prefix" = "awful",
			"description" = "",
		),
		SMELTERY_QUALITY_POOR = list(
			"name_prefix" = "",
			"description" = "",
		),
		SMELTERY_QUALITY_NORMAL = list(
			"name_prefix" = "",
			"description" = "",
		),
		SMELTERY_QUALITY_GOOD = list(
			"name_prefix" = list("refined", "processed"),
			"description" = "It shows signs of careful refinement.",
		),
		SMELTERY_QUALITY_GREAT = list(
			"name_prefix" = list("high-grade", "superior", "fine"),
			"description" = list(
				"It gleams with exceptional purity.",
				"The metal structure appears flawless.",
				"It radiates quality craftsmanship."
			),
		),
		SMELTERY_QUALITY_EXCELLENT = list(
			"name_prefix" = list("pristine", "flawless", "legendary"),
			"description" = list(
				"It represents the pinnacle of metallurgical perfection.",
				"The metal seems to shine with inner light.",
				"This is a masterwork of refinement."
			),
		)
	)

/datum/quality_calculator/metallurgy/calculate_final_quality()
	var/skill_factor = skill_quality / 8 // Smaller impact than others
	var/material_factor = material_quality * 0.1 // Minor factor
	var/reagent_factor = reagent_quality * 0.9 // Major factor

	var/final_quality = material_factor + skill_factor + reagent_factor
	return max(-1, CEILING(min(4, final_quality), 1))

/datum/quality_calculator/metallurgy/apply_quality_to_item(obj/item/target, track_creation, quality_override)
	if(!target)
		return FALSE

	if(quality_override)
		quality_override = clamp(ceil(quality_override), SMELTERY_QUALITY_SPOIL, SMELTERY_QUALITY_EXCELLENT)

	. = ..(target, track_creation, quality_override)

/datum/quality_calculator/metallurgy/track_item_creation(obj/item/target, final_quality)
	if(final_quality >= SMELTERY_QUALITY_EXCELLENT)
		record_round_statistic(STATS_MASTERWORKS_FORGED, 1)
