/datum/orderless_slapcraft/food
	abstract_type = /datum/orderless_slapcraft/food

	/// Tracks the total freshness of ingredients
	var/total_freshness = 0
	/// Tracks number of ingredients with freshness
	var/ingredient_count = 0
	/// Tracks highest quality ingredient
	var/highest_quality = 0

/datum/orderless_slapcraft/food/get_action_time(obj/item/attacking_item, mob/user)
	return (action_time - ((user?.get_skill_level(related_skill, TRUE)) * 5))

/datum/orderless_slapcraft/food/before_process_item(obj/item/attacking_item, mob/user)
	track_ingredient_quality(attacking_item)
	return TRUE

/datum/orderless_slapcraft/food/process_finishing_item(obj/item/attacking_item, mob/user)
	track_ingredient_quality(attacking_item)
	return TRUE

/datum/orderless_slapcraft/food/handle_output_item(mob/user, obj/item/reagent_containers/food/snacks/new_item)
	if(istype(new_item))
		// Calculate average freshness
		var/average_freshness = (ingredient_count > 0) ? (total_freshness / ingredient_count) : 0
		// Get the user's cooking skill
		var/cooking_skill = user.get_skill_level(/datum/skill/craft/cooking) + user.get_inspirational_bonus()
		// Apply freshness to the new food item
		new_item.warming = min(5 MINUTES, average_freshness)

		var/datum/quality_calculator/cooking/cook_calc = new(
			base_qual = 0,
			mat_qual = highest_quality,
			skill_qual = cooking_skill,
			perf_qual = 0,
			diff_mod = 0,
			components = 1,
			fresh = average_freshness,
			recipe_mod = 1.0
		)

		// Apply descriptive modifications based on quality
		cook_calc.apply_quality_to_item(new_item)
		qdel(cook_calc)

/datum/orderless_slapcraft/food/proc/track_ingredient_quality(obj/item/food_item)
	// Track the ingredient for quality calculation
	atoms_to_pass += food_item

	// Track freshness and quality
	if(istype(food_item, /obj/item/reagent_containers/food/snacks) || istype(food_item, /obj/item/grown))
		STOP_PROCESSING(SSobj, food_item)
		ingredient_count++

		// Check warming value for freshness (higher means fresher)
		if(istype(food_item, /obj/item/reagent_containers/food/snacks))
			var/obj/item/reagent_containers/food/snacks/F = food_item
			total_freshness += max(0, (F.warming + F.rotprocess))
			highest_quality = max(highest_quality, F.recipe_quality )
