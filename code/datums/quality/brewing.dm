/datum/quality_calculator/brewing
	name = "Brewing Quality"
	quality_descriptors = alist(
		COOK_QUALITY_TERRIBLE = list(
			"brew_prefix" = list("spoiled", "rancid", "failed", "putrid", "foul"),
			"description" = list(
				"This brew has gone terribly wrong.",
				"The smell alone is enough to make you gag.",
				"This is barely recognizable as alcohol.",
				"Something went horribly wrong in the brewing process.",
			),
			"price_modifier" = 0.6
		),
		COOK_QUALITY_POOR = list(
			"brew_prefix" = list("cheap", "low-quality"),
			"description" = "Tastes like piss.",
			"price_modifier" = 0.8
		),
		COOK_QUALITY_NORMAL = list(
			"description" = "This appears to be a standard quality brew.",
			"price_modifier" = 1.0
		),
		COOK_QUALITY_NICE = list(
			"brew_prefix" = "fine",
			"description" = list(
				"This shows the skill of an experienced brewer."
			),
			"price_modifier" = 1.2
		),
		COOK_QUALITY_GOOD = list(
			"brew_prefix" = list("quality", "well-crafted", "premium"),
			"description" = list(
				"This brew has an excellent aroma and rich color.",
				"The craftsmanship is evident in every sip.",
			),
			"price_modifier" = 1.4
		),
		COOK_QUALITY_VERYGOOD = list(
			"brew_prefix" = list("masterful", "exquisite", "artisan", "legendary", "perfect"),
			"description" = list(
				"This is a masterfully crafted brew with perfect clarity and an intoxicating bouquet.",
				"This represents the pinnacle of brewing artistry.",
				"This brew is so perfect it belongs in a vault.",
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
	if(brew_prefix)
		// Insert the prefix before "bottle of"
		var/bottle_pos = findtext(bottle.name, " bottle of ")
		if(bottle_pos)
			bottle.name = copytext(bottle.name, 1, bottle_pos) + " [brew_prefix] bottle of " + copytext(bottle.name, bottle_pos + 11)
		else
			bottle.name = "[brew_prefix] [bottle.name]"

/datum/quality_calculator/brewing/track_item_creation(obj/item/target, final_quality)
	// Track masterworks if enabled (quality 4)
	if(final_quality >= COOK_QUALITY_VERYGOOD)
		record_round_statistic(STATS_MASTERWORKS_PRODUCED, 1) // TODO! Make this an actual unique brewing type
