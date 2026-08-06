/datum/quality_calculator/brewing
	name = "Brewing Quality"

	quality_descriptors = alist(
		-1 = list(
			"brew_prefix" = list("spoiled", "rancid", "failed", "putrid", "foul"),
			"description" = list(
				"This brew has gone terribly wrong.",
				"The smell alone is enough to make you gag.",
				"This is barely recognizable as alcohol.",
				"Something went horribly wrong in the brewing process.",
				"This might actually be poisonous."
			),
			"price_modifier" = 0.2
		),
		0 = list(
			"brew_prefix" = "",
			"description" = "",
			"price_modifier" = 0.8
		),
		1 = list(
			"brew_prefix" = list("weak", "watery", "poor", "substandard"),
			"description" = list(
				"This brew appears poorly made with an unpleasant aroma.",
				"The color is off and it smells strange.",
				"This tastes like it was made by someone who doesn't know what they're doing."
			),
			"price_modifier" = 0.6
		),
		2 = list(
			"brew_prefix" = "",
			"description" = "This appears to be a standard quality brew.",
			"price_modifier" = 1.0
		),
		3 = list(
			"brew_prefix" = list("fine", "quality", "well-crafted", "premium"),
			"description" = list(
				"This brew has an excellent aroma and rich color.",
				"The craftsmanship is evident in every sip.",
				"This shows the skill of an experienced brewer."
			),
			"price_modifier" = 1.4
		),
		4 = list(
			"brew_prefix" = list("masterful", "exquisite", "artisan", "legendary", "perfect"),
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

/datum/quality_calculator/brewing/New(mat_qual = 0, skill_qual = 0, components = 1, reagent_qual = 0, fresh = 0, recipe_mod = 1.0, aging_bonus = 0)
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
	return min(COOK_QUALITY_VERYGOOD, min(skill_cap, final_quality))

/datum/quality_calculator/brewing/apply_quality_to_item(obj/item/reagent_containers/glass/bottle/bottle, track_creation)
	if(!istype(bottle))
		return FALSE

	. = ..()
	if(!.)
		return

	var/list/quality_data = .

	// Apply name prefix
	var/brew_prefix = quality_data["brew_prefix"]
	if(islist(brew_prefix))
		brew_prefix = pick(brew_prefix)
	if(brew_prefix && brew_prefix != "")
		// Insert the prefix before "bottle of"
		var/bottle_pos = findtext(bottle.name, " bottle of ")
		if(bottle_pos)
			bottle.name = copytext(bottle.name, 1, bottle_pos) + " [brew_prefix] bottle of " + copytext(bottle.name, bottle_pos + 11)
		else
			bottle.name = "[brew_prefix] [bottle.name]"

/datum/quality_calculator/brewing/track_item_creation(obj/item/target, final_quality)
	// Track masterworks if enabled (quality 4)
	if(final_quality >= COOK_QUALITY_VERYGOOD)
		record_round_statistic(STATS_MASTERWORKS_FORGED, 1) // TODO! Make this an actual unique brewing type
