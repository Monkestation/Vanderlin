/datum/brewing_recipe
	abstract_type = /datum/brewing_recipe
	var/name = "Alcohols"
	var/category = "Alcohols"
	///the type path of the reagent
	var/datum/reagent/reagent_to_brew = /datum/reagent/consumable/ethanol
	///What reagent needs to be in the keg for this recipe to show up as an option?
	var/datum/reagent/pre_reqs
	///the crops typepath we need goes typepath = amount. Amount is not just how many based on potency value up to a cap it adds values.
	var/list/needed_crops = list()
	///the type paths of needed reagents in typepath = amount
	var/list/needed_reagents = list()
	///list of items that aren't crops we need
	var/list/needed_items = list()
	///our brewing time in deci seconds should use the SECONDS MINUTES HOURS helpers
	var/brew_time = 1 SECONDS
	///the price this gets at cargo. each bottle gets a value of sell_value / brewed_amount
	var/sell_value = 0
	///amount of brewed creations used when either canning or bottling. this is for liquids
	var/brewed_amount = 1
	///each bottle or canning gives how this much reagents. used with brewed_amount
	var/per_brew_amount = 50
	///helpful hints
	var/helpful_hints
	///if we have a secondary name some do if you want to hide the ugly info
	var/secondary_name
	///typepath of our output if set we also make this item. this is for nonliquids
	var/atom/brewed_item
	///amount of brewed items. this is used with brewed_item
	var/brewed_item_count = 1
	///the reagent we get at different age times
	var/list/age_times = list()
	///the heat we need to be kept at
	var/heat_required
	///The verb (gerund) that is displayed when starting the recipe
	var/start_verb = "brewing"
	///Quality modifier for this specific recipe (affects final quality)
	var/quality_modifier = 1.0

/datum/brewing_recipe/proc/after_finish_attackby(mob/living/user, obj/item/attacked_item, atom/source)
	if(!istype(attacked_item, /obj/item/bottle_kit))
		return FALSE
	var/name_to_use = secondary_name ? secondary_name : name
	user.visible_message(span_info("[user] begins bottling [lowertext(name_to_use)]."))
	if(!do_after(user, 5 SECONDS, source))
		return FALSE
	return TRUE

/datum/brewing_recipe/proc/create_items(mob/user, obj/item/attacked_item, atom/source, number_of_repeats)
	var/obj/structure/fermentation_keg/source_keg = source
	var/obj/item/bottle_kit/bottle_kit = attacked_item
	var/bottle_name = secondary_name ? "[lowertext(secondary_name)]" : "[lowertext(name)]"

	// Calculate quality for the brewed reagents using the improved system
	var/calculated_quality = calculate_brewing_quality(user, source_keg)

	for(var/i in 1 to (brewed_amount * number_of_repeats))
		var/obj/item/reagent_containers/glass/bottle/brewing_bottle/bottle_made = new /obj/item/reagent_containers/glass/bottle/brewing_bottle(get_turf(source))
		bottle_made.icon_state = "[bottle_kit.glass_colour]"
		bottle_made.name = "brewer's bottle of [bottle_name]"
		bottle_made.sellprice = round(sell_value / brewed_amount)
		bottle_made.desc = "A bottle of locally-brewed [SSmapping.config.map_name] [bottle_name]."

		// Add reagent with quality
		var/list/quality_data = list("quality" = calculated_quality)
		bottle_made.reagents.add_reagent(reagent_to_brew, per_brew_amount, quality_data)

		// Apply quality effects using the quality calculator
		apply_brewing_quality_effects(bottle_made, user, source_keg, calculated_quality)

	return

/**
 * Applies brewing quality effects to the bottle using the quality calculator
 *
 * @param obj/item/bottle The bottle to modify
 * @param mob/user The brewer
 * @param obj/structure/fermentation_keg/keg The source keg
 * @param quality The calculated quality level
 */
/datum/brewing_recipe/proc/apply_brewing_quality_effects(obj/item/bottle, mob/user, obj/structure/fermentation_keg/keg, quality)
	// Get brewing skill for the quality calculator
	var/brewing_skill = 0
	if(user.mind)
		brewing_skill = user.get_skill_level(/datum/skill/craft/cooking) + user.get_inspirational_bonus() || 0

	// Create quality calculator with the calculated quality
	var/datum/quality_calculator/brewing/brew_calc = new(
		base_qual = 0,
		mat_qual = quality,
		skill_qual = brewing_skill,
		perf_qual = 0,
		diff_mod = 0,
		components = 1,
		fresh = 0, // Freshness already factored into quality calculation
		recipe_mod = quality_modifier
	)

	brew_calc.apply_quality_to_item(bottle)
	qdel(brew_calc)

/**
 * Calculates the quality of the brewed reagent based on ingredients and brewing skill
 * Following the same pattern as the cooking system
 *
 * @param mob/user The person doing the brewing
 * @param obj/structure/fermentation_keg/keg The keg containing ingredients
 * @return The calculated reagent quality (1-4)
 */
/datum/brewing_recipe/proc/calculate_brewing_quality(mob/user, obj/structure/fermentation_keg/keg)
	// Variables for quality calculation (matching cooking system pattern)
	var/total_freshness = 0
	var/ingredient_count = 0
	var/highest_food_quality = 0
	var/highest_input_reagent_quality = 0
	var/total_reagent_volume = 0

	// Calculate average freshness and find highest quality food ingredient from crops
	if(keg.recipe_crop_stocks && length(keg.recipe_crop_stocks))
		for(var/crop_type in keg.recipe_crop_stocks)
			if(islist(keg.recipe_crop_stocks[crop_type]))
				var/list/crop_data = keg.recipe_crop_stocks[crop_type]
				var/crop_amount = crop_data["amount"] || 0
				if(crop_amount > 0)
					ingredient_count++
					// Use freshness from stored data
					if(crop_data["freshness"])
						total_freshness += crop_data["freshness"]
					// Use quality from stored data
					if(crop_data["quality"])
						highest_food_quality = max(highest_food_quality, crop_data["quality"])
			else
				// Fallback for simple numeric storage
				var/crop_amount = keg.recipe_crop_stocks[crop_type]
				if(crop_amount > 0)
					ingredient_count++
					highest_food_quality = max(highest_food_quality, 1) // Default quality

	// Check reagent qualities already in the keg (like water, alcohol base, etc.)
	if(keg.reagents && keg.reagents.reagent_list)
		for(var/datum/reagent/R in keg.reagents.reagent_list)
			if(R.volume > 0)
				total_reagent_volume += R.volume
				if(R.recipe_quality)
					highest_input_reagent_quality = max(highest_input_reagent_quality, R.recipe_quality)

	// Calculate average freshness
	var/average_freshness = (ingredient_count > 0) ? (total_freshness / ingredient_count) : 0

	// Get the user's brewing skill (with cooking as fallback)
	var/brewing_skill = 0
	if(user.mind)
		brewing_skill = user.get_skill_level(/datum/skill/craft/cooking) + user.get_inspirational_bonus() || 0

	// Use the quality calculator to determine final quality (matching cooking system)
	var/datum/quality_calculator/brewing/brew_calc = new(
		base_qual = 0,
		mat_qual = max(highest_food_quality, highest_input_reagent_quality), // Use the higher of food or reagent quality
		skill_qual = brewing_skill,
		perf_qual = 0,
		diff_mod = 0,
		components = 1,
		fresh = average_freshness,
		recipe_mod = quality_modifier,
		reagent_qual = highest_input_reagent_quality
	)

	var/final_quality = brew_calc.calculate_final_quality()
	qdel(brew_calc)

	return CLAMP(final_quality, 1, 4)

/datum/brewing_recipe/proc/generate_html(mob/user)
	var/client/client = user
	if(!istype(client))
		client = user.client
	SSassets.transport.send_assets(client, list("try4_border.png", "try4.png", "slop_menustyle2.css"))
	user << browse_rsc('html/book.png')
	var/html = {"
		<!DOCTYPE html>
		<html lang="en">
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>

		<style>
			@import url('https://fonts.googleapis.com/css2?family=Charm:wght@700&display=swap');
			body {
				font-family: "Charm", cursive;
				font-size: 1.2em;
				text-align: center;
				margin: 20px;
				background-color: #f4efe6;
				color: #3e2723;
				background-color: rgb(31, 20, 24);
				background:
					url('[SSassets.transport.get_asset_url("try4_border.png")]'),
					url('book.png');
				background-repeat: no-repeat;
				background-attachment: fixed;
				background-size: 100% 100%;

			}
			h1 {
				text-align: center;
				font-size: 2em;
				border-bottom: 2px solid #3e2723;
				padding-bottom: 10px;
				margin-bottom: 10px;
			}
			.icon {
				width: 64px;
				height: 64px;
				vertical-align: middle;
				margin-right: 10px;
			}
		</style>
		<body>
		  <div>
		    <h1>[name]</h1>
		    <div>
			  <h2>Brewing Time: [brew_time / 10] Seconds </h2>
			  <h2>Requirements</h2>
		"}
	if(length(age_times))
		html += "<h2>Will Continue to age after brewing.</h2>"
	if(helpful_hints)
		html += "<strong>[helpful_hints]</strong><br>"
	if(pre_reqs)
		html += "<strong>Requires that you have [initial(pre_reqs.name)] present.</strong><br>"
	if(heat_required)
		html += "<strong>Requires that this be made in a heated vessel thats at least [heat_required - 273.1]C.</strong><br>"

	if(length(needed_crops) || length(needed_items))
		html += "<h3>Items Required</h3>"
		for(var/atom/path as anything in needed_crops)
			var/count = needed_crops[path]
			html += "[icon2html(new path, user)] [count] parts [initial(path.name)]<br>"
		for(var/atom/path as anything in needed_items)
			var/count = needed_items[path]
			html += "[count] parts [initial(path.name)]<br>"
		html += "<br>"
	if(length(needed_reagents))
		html += "<h3>Liquids Required</h3>"
		for(var/atom/path as anything in needed_reagents)
			var/count = needed_reagents[path]
			html += "[UNIT_FORM_STRING(FLOOR(count, 1))] of [initial(path.name)]<br>"
		html += "<br>"

	if(brewed_amount)
		html += "Produces: [UNIT_FORM_STRING(FLOOR((per_brew_amount * brewed_amount), 1))] of [name]"
	if(brewed_item)
		html += "Produces: [icon2html(new brewed_item, user)] [(brewed_item_count)] [initial(brewed_item.name)]"
	html += {"
		</div>
		<div>
		"}

	if(length(age_times))
		for(var/datum/reagent/path as anything in age_times)
			html += "After aging for [age_times[path] * 0.1] Seconds, becomes [initial(path.name)].<br>"

	html += {"
		</div>
		</div>
	</body>
	</html>
	"}
	return html

/datum/brewing_recipe/proc/show_menu(mob/user)
	user << browse(generate_html(user),"window=recipe;size=500x810")
