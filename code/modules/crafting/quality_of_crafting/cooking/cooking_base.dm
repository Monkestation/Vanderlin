/proc/calculate_food_quality(cooking_skill, ingredient_quality, freshness, quality_modifier = 1.0)
	var/skill_factor = cooking_skill / 6
	var/freshness_factor = min(1, freshness / (5 MINUTES))

	var/skill_component = skill_factor * 1.5
	var/ingredient_component = ingredient_quality * 0.5
	var/freshness_component = freshness_factor * 0.5
	var/modifier_component = quality_modifier * 0.5
	var/final_quality = 1 + skill_component + ingredient_component + freshness_component + modifier_component
	// Ensures no skill = max quality 1, 1 skill = max quality 2, etc.
	var/skill_cap = 1 + cooking_skill

	// Apply both the skill cap and the absolute maximum of 4
	return min(4, min(skill_cap, final_quality))

// Shared method to apply quality descriptions to food
/proc/apply_food_quality(obj/item/reagent_containers/food/snacks/food_item, quality, rot_threshold = -0.5)
	food_item.eat_effect = null  // Clear previous effect

	// We only apply description changes if quality is good (2+) or really poor (rotting)
	if(quality <= rot_threshold)  // Bad quality - close to rotting
		food_item.name = pick("unappealing", "sloppy", "failed", "woeful", "soggy", "bland") + " [initial(food_item.name)]"
		food_item.desc = pick("It is made without love or care.",
							"It barely looks like food.",
							"It is a disgrace to cooking.",
							"Cooking that might cause a divorce.",
							"If there be gods of cooking they must be dead.",
							"Is this food?")
		food_item.tastes |= list("blandness" = 1)
		return

	// Normal quality (1-2) - keep default name/description
	if(quality < 2)
		return

	// Good quality (2+)
	if(quality >= 2 && quality < 3)
		food_item.eat_effect = /datum/status_effect/buff/foodbuff
		food_item.name = pick("tasty", "well-made", "appealing") + " [initial(food_item.name)]"
		food_item.desc = "[initial(food_item.desc)] It looks good."
		return

	// Great quality (3+)
	if(quality >= 3 && quality < 4)
		food_item.eat_effect = /datum/status_effect/buff/foodbuff
		food_item.name = pick("fine", "tasty", "well-made", "appealing", "appetising", "savory", "flavorful") + " [initial(food_item.name)]"
		food_item.desc = "[initial(food_item.desc)] [pick("It looks tasty.",
													"It smells good.",
													"This is fine cooking.",
													"It seem to call out to you.",
													"Your mouth waters at the sight.",
													"It will make a fine meal.",
													"It looks like good eating.")]"
		return

	// Masterful quality (4)
	if(quality >= 4)
		food_item.eat_effect = /datum/status_effect/buff/foodbuff
		food_item.name = pick("masterful", "exquisite", "perfected", "gourmet", "delicious") + " [initial(food_item.name)]"
		food_item.desc = "[initial(food_item.desc)] [pick("It looks perfect.",
													"It smells like heaven.",
													"It is a triumph of cooking.",
													"It is fit for royalty.",
													"It is a masterwork.")]"

/datum/repeatable_crafting_recipe/cooking
	abstract_type = /datum/repeatable_crafting_recipe/cooking
	skillcraft = /datum/skill/craft/cooking
	var/quality_modifier = 1.0  // Base modifier for recipe quality

/datum/repeatable_crafting_recipe/cooking/create_outputs(list/to_delete, mob/user)
	var/list/outputs = list()
	var/total_freshness = 0
	var/ingredient_count = 0
	var/highest_quality = 0

	// Calculate average freshness and find highest quality ingredient
	for(var/obj/item/reagent_containers/food_item in to_delete)
		if(istype(food_item, /obj/item/reagent_containers/food/snacks) || istype(food_item, /obj/item/grown))
			ingredient_count++

			// Check warming value for freshness (higher means fresher)
			if(istype(food_item, /obj/item/reagent_containers/food/snacks))
				var/obj/item/reagent_containers/food/snacks/F = food_item
				total_freshness += max(0, (F.warming + F.rotprocess))
				highest_quality = max(highest_quality, F.recipe_quality)

	// Calculate average freshness
	var/average_freshness = (ingredient_count > 0) ? (total_freshness / ingredient_count) : 0

	// Get the user's cooking skill
	var/cooking_skill = user.get_skill_level(/datum/skill/craft/cooking) + user.get_inspirational_bonus()

	// Create output items
	for(var/spawn_count = 1 to output_amount)
		var/obj/item/reagent_containers/food/snacks/new_item = new output(get_turf(user))
		new_item.sellprice = sellprice
		new_item.randomize_price()

		if(istype(new_item, /obj/item/reagent_containers/food/snacks))
			// Apply freshness to the new food item
			new_item.warming = min(5 MINUTES, average_freshness)

			// Calculate final quality based on ingredients, skill, and recipe
			apply_food_quality(new_item, cooking_skill, highest_quality, average_freshness)

		if(length(pass_types_in_end))
			var/list/parts = list()
			for(var/obj/item/listed as anything in to_delete)
				if(!is_type_in_list(listed, pass_types_in_end))
					continue
				parts += listed
			new_item.CheckParts(parts)

		new_item.OnCrafted(user.dir, user)

		outputs += new_item

	return outputs

/datum/repeatable_crafting_recipe/cooking/proc/apply_food_quality(obj/item/reagent_containers/food/snacks/food_item, cooking_skill, ingredient_quality, freshness)
	var/datum/quality_calculator/cooking/cook_calc = new(
		base_qual = 0,
		mat_qual = ingredient_quality,
		skill_qual = cooking_skill,
		perf_qual = 0,
		diff_mod = 0,
		components = 1,
		fresh = freshness,
		recipe_mod = quality_modifier
	)
	cook_calc.apply_quality_to_item(food_item)
	qdel(cook_calc)
