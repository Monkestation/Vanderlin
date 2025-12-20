/datum/quality_calculator/metallurgy
	name = "Metallurgy Quality"

	quality_descriptors = list(
		"-1" = list(
			"name_prefix" = "awful",
			"description" = "",
		),
		"0" = list(
			"name_prefix" = "",
			"description" = "",
		),
		"1" = list(
			"name_prefix" = "",
			"description" = "",
		),
		"2" = list(
			"name_prefix" = list("refined", "processed"),
			"description" = "It shows signs of careful refinement.",
		),
		"3" = list(
			"name_prefix" = list("high-grade", "superior", "fine"),
			"description" = list(
				"It gleams with exceptional purity.",
				"The metal structure appears flawless.",
				"It radiates quality craftsmanship."
			),
		),
		"4" = list(
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

/datum/quality_calculator/metallurgy/apply_quality_to_item(obj/item/target, track_masterworks = FALSE)
	if(!target)
		return FALSE

	var/final_quality = calculate_final_quality()
	var/list/quality_data = get_quality_data(final_quality)

	if(!quality_data)
		return FALSE

	var/name_prefix = quality_data["name_prefix"]
	if(islist(name_prefix))
		var/list/names = name_prefix
		name_prefix = pick(names)

	var/description_prefix = quality_data["description"]
	if(islist(description_prefix))
		var/list/names = description_prefix
		description_prefix = pick(names)
	// Apply name prefix
	if(name_prefix && name_prefix != "")
		target.name = "[name_prefix] [target.name]"

	// Apply description prefix
	if(description_prefix && description_prefix != "")
		target.desc += "\n[description_prefix]"


	target.set_quality(final_quality)

	if(track_masterworks && final_quality >= 4)
		record_round_statistic(STATS_MASTERWORKS_FORGED, 1)

	return TRUE

/datum/quality_calculator/metallurgy/proc/apply_smelt_to_ingot(obj/item/target, final_quality = 0, track_masterworks = FALSE)
	if(!target)
		return FALSE
	final_quality = max(-1, CEILING(min(4, final_quality), 1))

	var/list/quality_data = get_quality_data(final_quality)

	if(!quality_data)
		return FALSE

	var/name_prefix = quality_data["name_prefix"]
	if(islist(name_prefix))
		var/list/names = name_prefix
		name_prefix = pick(names)
	var/description_prefix = quality_data["description"]
	if(islist(description_prefix))
		var/list/names = description_prefix
		description_prefix = pick(names)
	// Apply name prefix
	if(name_prefix && name_prefix != "")
		target.name = "[name_prefix] [target.name]"

	// Apply description prefix
	if(description_prefix && description_prefix != "")
		target.desc += "\n[description_prefix]"


	target.set_quality(final_quality)

	if(track_masterworks && final_quality >= 4)
		record_round_statistic(STATS_MASTERWORKS_FORGED, 1)

	return TRUE
