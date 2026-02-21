/datum/quality_calculator/cooking
	name = "Cooking Quality"

	quality_descriptors = alist(
		-1 = list(
			"name_prefix" = list("unappealing", "sloppy", "failed", "woeful", "soggy", "bland"),
			"description" = list(
				"It is made without love or care.",
				"It barely looks like food.",
				"It is a disgrace to cooking.",
				"Cooking that might cause a divorce.",
				"If there be gods of cooking they must be dead.",
				"Is this food?"
			),
			"eat_effect" = null,
			"tastes" = list("blandness" = 1)
		),
		0 = list(
			"name_prefix" = "",
			"description" = "",
			"eat_effect" = null,
			"tastes" = null
		),
		1 = list(
			"name_prefix" = "",
			"description" = "",
			"eat_effect" = null,
			"tastes" = null
		),
		2 = list(
			"name_prefix" = list("tasty", "well-made", "appealing"),
			"description" = "It looks good.",
			"eat_effect" = /datum/status_effect/buff/foodbuff,
			"tastes" = null
		),
		3 = list(
			"name_prefix" = list("fine", "tasty", "well-made", "appealing", "appetising", "savory", "flavorful"),
			"description" = list(
				"It looks tasty.",
				"It smells good.",
				"This is fine cooking.",
				"It seem to call out to you.",
				"Your mouth waters at the sight.",
				"It will make a fine meal.",
				"It looks like good eating."
			),
			"eat_effect" = /datum/status_effect/buff/foodbuff,
			"tastes" = null
		),
		4 = list(
			"name_prefix" = list("masterful", "exquisite", "perfected", "gourmet", "delicious"),
			"description" = list(
				"It looks perfect.",
				"It smells like heaven.",
				"It is a triumph of cooking.",
				"It is fit for royalty.",
				"It is a masterwork."
			),
			"eat_effect" = /datum/status_effect/buff/foodbuff,
			"tastes" = null
		)
	)

	var/freshness = 0
	var/recipe_quality_modifier = 1.0

/datum/quality_calculator/cooking/New(mat_qual = 0, skill_qual = 0, components = 1, reagent_qual = 0, fresh = 0, recipe_mod = 1.0)
	freshness = fresh
	recipe_quality_modifier = recipe_mod
	..()

/datum/quality_calculator/cooking/calculate_final_quality()
	var/cooking_skill = skill_quality
	var/ingredient_quality = material_quality
	var/skill_factor = cooking_skill / 6
	var/freshness_factor = min(1, freshness / (5 MINUTES))

	var/skill_component = skill_factor * 1.5
	var/ingredient_component = ingredient_quality * 0.4
	var/reagent_component = reagent_quality * 0.3
	var/freshness_component = freshness_factor * 0.5
	var/modifier_component = recipe_quality_modifier * 0.5

	var/final_quality = 1 + skill_component + ingredient_component + reagent_component + freshness_component + modifier_component

	// Apply skill cap and absolute maximum
	var/skill_cap = 1 + cooking_skill
	return min(COOK_QUALITY_VERYGOOD, min(skill_cap, final_quality))

/datum/quality_calculator/cooking/apply_quality_to_item(obj/item/reagent_containers/food/snacks/food_item, track_creation)
	if(!istype(food_item))
		return FALSE

	. = ..()
	if(!.)
		return

	var/list/quality_data = .

	// Clear previous effect
	food_item.eat_effect = null
	// Apply eat effect
	var/eat_effect = quality_data["eat_effect"]
	if(eat_effect)
		food_item.eat_effect = eat_effect

	// Apply taste modifiers
	var/list/tastes = quality_data["tastes"]
	if(tastes && islist(tastes))
		if(!food_item.tastes)
			food_item.tastes = list()
		for(var/taste in tastes)
			food_item.tastes[taste] = tastes[taste]

/datum/quality_calculator/cooking/track_item_creation(obj/item/target, final_quality)
	// Track masterworks if enabled (quality 4)
	if(final_quality >= COOK_QUALITY_VERYGOOD)
		record_round_statistic(STATS_MASTERWORKS_FORGED, 1) // TODO! Make this an actual unique type
