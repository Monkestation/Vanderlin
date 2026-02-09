/datum/container_craft/cooking
	abstract_type = /datum/container_craft/cooking
	category = "Soups"
	crafting_time = 5 SECONDS
	reagent_requirements = list(
		/datum/reagent/water = 25
	)
	craft_verb = "cooking for "
	required_container = /obj/item/reagent_containers/glass/bucket/pot
	var/datum/reagent/created_reagent
	var/water_conversion = 1
	var/datum/pollutant/finished_smell
	///the amount we pollute
	var/pollute_amount = 600
	///our required_baking temperature
	var/required_chem_temp = 374
	///what we add for optionals ie chunks of
	var/wording_choice = "chunks of"
	cooking_sound = /datum/looping_sound/boiling

/datum/container_craft/cooking/try_craft(obj/item/crafter, list/pathed_items, mob/initiator, datum/callback/on_craft_start, datum/callback/on_craft_failed)
	if(crafter.reagents.chem_temp < required_chem_temp)
		return FALSE
	. = ..()

/datum/container_craft/cooking/check_failure(obj/item/crafter, mob/user)
	if(crafter.reagents.chem_temp < required_chem_temp)
		return TRUE
	return FALSE

/datum/container_craft/cooking/get_real_time(atom/host, mob/user, estimated_multiplier)
	var/real_cooking_time = crafting_time * estimated_multiplier
	if(user.mind)
		real_cooking_time /= 1 + (user.get_skill_level(/datum/skill/craft/cooking, TRUE) * 0.5)
		real_cooking_time = round(real_cooking_time)
	return real_cooking_time

/datum/container_craft/cooking/create_item(obj/item/crafter, mob/initiator, list/found_optional_requirements, list/found_optional_wildcards, list/found_optional_reagents, list/removing_items)
	if(created_reagent)
		var/turf/pot_turf = get_turf(crafter)
		var/datum/reagent/first = reagent_requirements[1]
		var/reagent_amount = reagent_requirements[first]

		// Calculate reagent quality based on ingredients and cooking skill
		var/calculated_quality = calculate_reagent_quality(crafter, initiator, removing_items)

		for(var/j = 1 to output_amount)
			// Create quality data for the new reagent
			var/list/quality_data = list(
				"quality" = calculated_quality,
			)

			// Add the reagent with quality data
			crafter.reagents.add_reagent(created_reagent, reagent_amount * water_conversion, quality_data)

			after_craft(null, crafter, initiator, found_optional_requirements, found_optional_wildcards, found_optional_reagents, removing_items)
			if(finished_smell)
				pot_turf.pollute_turf(finished_smell, pollute_amount)
			initiator.nobles_seen_servant_work()
		playsound(pot_turf, "bubbles", 30, TRUE)
	else
		..()

/**
 * Calculates the quality of the reagent to be created based on ingredients and cooking skill
 *
 * @param obj/item/crafter The container being used for crafting
 * @param mob/initiator The person doing the cooking
 * @param list/removing_items The ingredients being consumed
 * @return The calculated reagent quality (1-4)
 */
/datum/container_craft/cooking/proc/calculate_reagent_quality(obj/item/crafter, mob/initiator, list/removing_items)
	// Variables for quality calculation
	var/total_freshness = 0
	var/ingredient_count = 0
	var/highest_food_quality = 0
	var/highest_input_reagent_quality = 0
	var/total_reagent_volume = 0

	// Calculate average freshness and find highest quality food ingredient
	for(var/obj/item/reagent_containers/food_item in removing_items)
		if(istype(food_item, /obj/item/reagent_containers/food/snacks) || istype(food_item, /obj/item/grown))
			ingredient_count++
			// Check warming value for freshness (higher means fresher)
			if(istype(food_item, /obj/item/reagent_containers/food/snacks))
				var/obj/item/reagent_containers/food/snacks/F = food_item
				total_freshness += max(0, (F.warming + F.rotprocess))
				highest_food_quality = max(highest_food_quality, F.recipe_quality )

			// Also check reagents in the food items
			if(food_item.reagents && food_item.reagents.reagent_list)
				for(var/datum/reagent/R in food_item.reagents.reagent_list)
					if(R.volume > 0)
						total_reagent_volume += R.volume
						highest_input_reagent_quality = max(highest_input_reagent_quality, R.recipe_quality)

	// Check reagent qualities already in the crafter container (like the water)
	if(crafter.reagents && crafter.reagents.reagent_list)
		for(var/datum/reagent/R in crafter.reagents.reagent_list)
			if(R.volume > 0)
				total_reagent_volume += R.volume
				highest_input_reagent_quality = max(highest_input_reagent_quality, R.recipe_quality)

	// Calculate average freshness
	var/average_freshness = (ingredient_count > 0) ? (total_freshness / ingredient_count) : 0

	// Get the initiator's cooking skill
	var/cooking_skill = initiator.get_skill_level(/datum/skill/craft/cooking) + initiator.get_inspirational_bonus()

	// Use the quality calculator to determine final quality
	var/datum/quality_calculator/cooking/cook_calc = new(
		base_qual = 0,
		mat_qual = max(highest_food_quality, highest_input_reagent_quality), // Use the higher of food or reagent quality
		skill_qual = cooking_skill,
		perf_qual = 0,
		diff_mod = 0,
		components = 1,
		fresh = average_freshness,
		recipe_mod = quality_modifier,
		reagent_qual = highest_input_reagent_quality
	)

	var/final_quality = cook_calc.calculate_final_quality()
	qdel(cook_calc)

	return CLAMP(final_quality, 1, 4)

/datum/container_craft/cooking/after_craft(atom/created_output, obj/item/crafter, mob/initiator, list/found_optional_requirements, list/found_optional_wildcards, list/found_optional_reagents, list/removing_items)
	. = ..()
	var/datum/reagent/found_product = crafter.reagents.get_reagent(created_reagent)
	if(!found_product)
		return

	// Update reagent name with optional ingredients
	if(length(found_optional_wildcards))
		var/extra_string = " with [wording_choice] "
		var/extra_taste = "with hints of "
		var/first_ingredient = TRUE
		var/list/all_used_ingredients = list()
		for(var/wildcard_type in found_optional_wildcards)
			var/list/items = found_optional_wildcards[wildcard_type]
			for(var/obj/item/ingredient in items)
				all_used_ingredients += ingredient
		for(var/obj/item/ingredient in all_used_ingredients)
			if(first_ingredient)
				extra_string += ingredient.name
				extra_taste += ingredient.name
				first_ingredient = FALSE
			else
				extra_string += " and [ingredient.name]"
				extra_taste += " and [ingredient.name]"
		found_product.name += extra_string
		found_product.taste_description += extra_taste
		found_product.add_data("custom_name", found_product.name)
		found_product.add_data("custom_tastes", found_product.taste_description)

	// Optionally modify reagent properties based on quality
	apply_quality_effects_to_reagent(found_product)

/**
 * Applies quality-based effects to the created reagent
 *
 * @param datum/reagent/reagent The reagent to modify
 */
/datum/container_craft/cooking/proc/apply_quality_effects_to_reagent(datum/reagent/reagent)
	if(!reagent)
		return

	// Modify reagent properties based on quality
	switch(reagent.recipe_quality)
		if(1) // Poor quality
			reagent.metabolization_rate *= 1.2 // Metabolizes faster (less effective)

		if(2) // Standard quality
			EMPTY_BLOCK_GUARD // No modifications - baseline

		if(3) // High quality
			// High quality is more effective
			reagent.metabolization_rate *= 0.9 // Metabolizes slower (more effective)

		if(4) // Premium quality
			// Premium quality is much more effective
			reagent.metabolization_rate *= 0.75 // Metabolizes much slower (very effective)

	// Update description to reflect quality
	var/quality_desc = reagent.get_recipe_quality_desc()
	if(reagent.description && !findtext(reagent.description, quality_desc))
		reagent.description += " This appears to be [quality_desc]."

/datum/container_craft/cooking/extra_html()
	var/html
	var/datum/reagent/first = reagent_requirements[1]
	var/result_amount = reagent_requirements[first]
	if(water_conversion > 0)
		result_amount = CEILING((result_amount * water_conversion), 1)
	html += "[UNIT_FORM_STRING(result_amount)] of [initial(created_reagent.name)]<br>"
	return html
