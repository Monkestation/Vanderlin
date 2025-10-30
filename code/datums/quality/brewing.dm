/datum/quality_calculator/brewing
	name = "Brewing Quality"

	quality_descriptors = list(
		"-1" = list(
			"name_prefix" = list("spoiled", "rancid", "failed", "putrid", "foul"),
			"description" = list(
				"This brew has gone terribly wrong.",
				"The smell alone is enough to make you gag.",
				"This is barely recognizable as alcohol.",
				"Something went horribly wrong in the brewing process.",
				"This might actually be poisonous."
			),
			"price_modifier" = 0.2
		),
		"0" = list(
			"name_prefix" = "",
			"description" = "",
			"price_modifier" = 0.8
		),
		"1" = list(
			"name_prefix" = list("weak", "watery", "poor", "substandard"),
			"description" = list(
				"This brew appears poorly made with an unpleasant aroma.",
				"The color is off and it smells strange.",
				"This tastes like it was made by someone who doesn't know what they're doing."
			),
			"price_modifier" = 0.6
		),
		"2" = list(
			"name_prefix" = "",
			"description" = "This appears to be a standard quality brew.",
			"price_modifier" = 1.0
		),
		"3" = list(
			"name_prefix" = list("fine", "quality", "well-crafted", "premium"),
			"description" = list(
				"This brew has an excellent aroma and rich color.",
				"The craftsmanship is evident in every sip.",
				"This shows the skill of an experienced brewer."
			),
			"price_modifier" = 1.4
		),
		"4" = list(
			"name_prefix" = list("masterful", "exquisite", "artisan", "legendary", "perfect"),
			"description" = list(
				"This is a masterfully crafted brew with perfect clarity and an intoxicating bouquet.",
				"This represents the pinnacle of brewing artistry.",
				"This brew is so perfect it belongs in a museum.",
				"The gods themselves would be jealous of this brew."
			),
			"price_modifier" = 2.0
		)
	)

	var/freshness = 0
	var/recipe_quality_modifier = 1.0
	var/aging_bonus = 0

/datum/quality_calculator/brewing/New(base_qual = 0, mat_qual = 0, skill_qual = 0, perf_qual = 0, diff_mod = 0, components = 1, reagent_qual = 0, fresh = 0, recipe_mod = 1.0, aging_bonus = 0)
	freshness = fresh
	recipe_quality_modifier = recipe_mod
	src.aging_bonus = aging_bonus
	..()

/datum/quality_calculator/brewing/calculate_final_quality()
	var/brewing_skill = skill_quality
	var/ingredient_quality = material_quality
	var/skill_factor = brewing_skill / 6
	var/freshness_factor = min(1, freshness / (5 MINUTES))

	var/skill_component = skill_factor * 1.5
	var/ingredient_component = ingredient_quality * 0.5
	var/freshness_component = freshness_factor * 0.3
	var/aging_component = aging_bonus * 0.4 // Unique to brewing
	var/recipe_component = recipe_quality_modifier * 0.3

	var/final_quality = 1 + skill_component + ingredient_component + freshness_component + aging_component + recipe_component

	// Apply skill cap and absolute maximum
	var/skill_cap = 1 + brewing_skill
	return min(4, min(skill_cap, final_quality))

/datum/quality_calculator/brewing/get_quality_tier(quality_value)
	var/best_tier = -1
	for(var/tier_str in quality_descriptors)
		var/tier = text2num(tier_str)
		if(quality_value >= tier && tier > best_tier)
			best_tier = tier
	return best_tier

/datum/quality_calculator/brewing/get_quality_data(quality_value = null)
	if(isnull(quality_value))
		quality_value = calculate_final_quality()

	var/tier = get_quality_tier(quality_value)
	var/tier_str = num2text(tier)
	return quality_descriptors[tier_str]

/datum/quality_calculator/brewing/apply_quality_to_item(obj/item/target, track_masterworks = FALSE)
	if(!istype(target, /obj/item/reagent_containers/glass/bottle))
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

	apply_brewing_quality_modifiers(target, quality_data)

	// Track masterworks if enabled (quality 4)
	if(track_masterworks && final_quality >= 4)
		record_round_statistic(STATS_MASTERWORKS_FORGED, 1) // TODO! Make this an actual unique brewing type

	return TRUE

/datum/quality_calculator/brewing/proc/apply_brewing_quality_modifiers(obj/item/reagent_containers/glass/bottle/bottle, list/quality_data)
	// Apply name prefix
	var/name_prefix = quality_data["name_prefix"]
	if(name_prefix && name_prefix != "")
		if(islist(name_prefix))
			name_prefix = pick(name_prefix)
		// Insert the prefix before "bottle of"
		var/bottle_pos = findtext(bottle.name, " bottle of ")
		if(bottle_pos)
			bottle.name = copytext(bottle.name, 1, bottle_pos) + " [name_prefix] bottle of " + copytext(bottle.name, bottle_pos + 11)
		else
			bottle.name = "[name_prefix] [bottle.name]"

	// Apply description
	var/description = quality_data["description"]
	if(description && description != "")
		if(islist(description))
			description = pick(description)
		bottle.desc += " [description]"

	// Apply price modifier
	var/price_modifier = quality_data["price_modifier"]
	if(price_modifier && bottle.sellprice)
		bottle.sellprice = round(bottle.sellprice * price_modifier)
