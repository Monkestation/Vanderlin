// Global tracking lists
GLOBAL_LIST_EMPTY(active_container_crafts)
GLOBAL_LIST_INIT(container_craft_to_singleton, init_container_crafts())

/proc/init_container_crafts()
	var/list/recipes = list()
	for(var/datum/container_craft/craft as anything in subtypesof(/datum/container_craft))
		if(IS_ABSTRACT(craft))
			continue
		recipes |= craft
		recipes[craft] = new craft
	return recipes

/datum/container_craft
	var/name = "GENERIC RECIPE CHANGE THIS"
	abstract_type = /datum/container_craft

	var/atom/output
	/// How many times the output is made. Preferrably for item outputs.
	var/output_amount = 1
	var/category

	var/user_craft = FALSE

	///if this is set we will only ever craft if only the contents are in the bag
	var/isolation_craft = FALSE

	var/list/requirements
	var/list/reagent_requirements
	///this needs a comment, basically if this is set we check for any of these in the path say /obj/item/sword, it will use /obj/item/sword/wooden
	var/list/wildcard_requirements

	//this is basically do we have any of these things in it on successful craft. Its up to the recipe to decide what to do with this information
	var/list/optional_requirements
	var/list/optional_wildcard_requirements
	var/list/optional_reagent_requirements

	var/subtype_reagents_allowed = FALSE

	///Maximum number of optional ingredients to use per craft, set to 0 for unlimited
	var/max_optionals = 0

	var/crafting_time = 0
	var/craft_priority = TRUE

	///this is literally just for html
	var/atom/movable/required_container
	var/craft_verb
	///do we show up in recipe guides
	var/hides_from_books = FALSE
	///our completed message
	var/complete_message = "Something smells good!"
	var/datum/skill/used_skill = /datum/skill/craft/cooking
	var/quality_modifier = 1.0  // Default modifier, recipes can override this
	///Path of looping_sound to use while cooking
	var/datum/looping_sound/cooking_sound

/**
 * Validates if recipe requirements are still met during crafting
 * @param obj/item/crafter The container being crafted in
 * @param list/obj/item/reserved_items List of actual item references reserved for this craft
 * @return TRUE if requirements are still met, FALSE otherwise
 */
/datum/container_craft/proc/requirements_still_met(obj/item/crafter, list/obj/item/reserved_items)
	if(length(reagent_requirements))
		for(var/reagent_type in reagent_requirements)
			if(!crafter.reagents.has_reagent(reagent_type, reagent_requirements[reagent_type], check_subtypes = subtype_reagents_allowed))
				return FALSE

	// Check that all reserved items still exist and are in the container
	for(var/obj/item/item in reserved_items)
		if(QDELETED(item) || item.loc != crafter)
			return FALSE

	return TRUE

/datum/container_craft/proc/try_craft(obj/item/crafter, list/pathed_items, mob/initiator, datum/callback/on_craft_start, datum/callback/on_craft_failed)
	var/highest_multiplier = 0

	// Check reagent requirements
	if(length(reagent_requirements))
		for(var/reagent_type in reagent_requirements)
			if(!crafter.reagents.has_reagent(reagent_type, reagent_requirements[reagent_type], check_subtypes = subtype_reagents_allowed))
				return FALSE
		// var/list/fake_reagents = reagent_requirements.Copy()
		// var/list/available_reagents = list()
		// for(var/datum/reagent/listed_reagent as anything in crafter.reagents.reagent_list)
		// 	available_reagents[listed_reagent.type] = listed_reagent.volume

		// for(var/required_path as anything in fake_reagents)
		// 	var/required_amount = fake_reagents[required_path]
		// 	for(var/path in available_reagents)
		// 		if(subtype_reagents_allowed ? !ispath(path, required_path) : path != required_path)
		// 			continue
		// 		required_amount -= available_reagents[path]
		// 		if(required_amount <= 0)
		// 			break
		// 	if(required_amount > 0)
		// 		return FALSE

	// Make copies to track what we're consuming
	var/list/fake_requirements = requirements?.Copy()
	var/list/fake_wildcards = wildcard_requirements?.Copy()
	var/list/available_items = pathed_items.Copy()

	// Process regular requirements first
	if(length(fake_requirements))
		for(var/requirement_path in fake_requirements)
			if(!available_items[requirement_path] || available_items[requirement_path] < fake_requirements[requirement_path])
				return FALSE

			var/potential_multiplier = FLOOR(available_items[requirement_path] / fake_requirements[requirement_path], 1)
			if(!highest_multiplier)
				highest_multiplier = potential_multiplier
			else if(potential_multiplier < highest_multiplier)
				highest_multiplier = potential_multiplier

			// Mark these items as consumed
			available_items[requirement_path] -= fake_requirements[requirement_path]
			if(available_items[requirement_path] <= 0)
				available_items -= requirement_path

	// Process wildcard requirements
	if(length(fake_wildcards))
		for(var/wildcard in fake_wildcards)
			var/needed = fake_wildcards[wildcard]
			var/found = 0

			// Find items that match this wildcard
			for(var/obj/item/path as anything in available_items)
				if(!ispath(path, wildcard))
					continue

				var/can_use = min(available_items[path], needed - found)
				found += can_use
				available_items[path] -= can_use

				if(available_items[path] <= 0)
					available_items -= path

				if(found >= needed)
					break

			// Check if we found enough items for this wildcard
			if(found < needed)
				return FALSE

			// Calculate multiplier based on what we found
			var/potential_multiplier = FLOOR(found / fake_wildcards[wildcard], 1)
			if(!highest_multiplier)
				highest_multiplier = potential_multiplier
			else if(potential_multiplier < highest_multiplier)
				highest_multiplier = potential_multiplier

	if(isolation_craft && length(available_items))
		return FALSE

	//if we don't have at least this nothing worked
	if(highest_multiplier < 1)
		return FALSE

	if(!initiator)
		initiator = get_mob_by_ckey(crafter.fingerprintslast)
	var/datum/callback/on_craft_start_ref = on_craft_start
	var/datum/callback/on_craft_fail_ref = on_craft_failed
	if(!on_craft_start_ref)
		on_craft_start_ref = create_start_callback(crafter, initiator, highest_multiplier)
	if(!on_craft_fail_ref)
		on_craft_fail_ref = create_fail_callback(crafter, initiator, highest_multiplier)
	new /datum/container_craft_operation(crafter, src, initiator, highest_multiplier, on_craft_start_ref, on_craft_fail_ref, cooking_sound)
	return TRUE

/datum/container_craft/proc/create_start_callback(crafter, initiator, highest_multiplier)
	return CALLBACK(crafter, TYPE_PROC_REF(/atom, visible_message), "The [lowertext(name)] starts to cook.")

/datum/container_craft/proc/create_fail_callback(crafter, initiator, highest_multiplier)
	return CALLBACK(crafter, TYPE_PROC_REF(/atom, visible_message), "The [lowertext(name)] stops cooking.")

/**
 * Handles the final execution of the craft after processing is complete
 */
/datum/container_craft/proc/execute_craft_completion(obj/item/crafter, mob/living/initiator, estimated_multiplier)
	for(var/i = 1 to estimated_multiplier)
		// First validate that all requirements are still present
		var/list/stored_items = list()
		for(var/obj/item/item in crafter.contents)
			stored_items |= item.type
			stored_items[item.type]++

		// Track which items to remove, indexed by type
		var/list/items_to_remove = list()
		// Track which actual item objects we'll remove
		var/list/obj/item/items_to_delete = list()

		var/list/passed_reagents = list()
		var/list/passed_wildcards = list()
		var/list/passed_requirements = list()
		var/list/found_optional_requirements = list()
		var/list/found_optional_wildcards = list()
		var/list/found_optional_reagents = list()

		if(length(reagent_requirements))
			for(var/reagent as anything in reagent_requirements)
				var/datum/reagent/reagent_found = crafter.reagents.has_reagent(reagent, reagent_requirements[reagent], check_subtypes = subtype_reagents_allowed)
				if(!reagent_found)
					return FALSE
				passed_reagents[reagent_found.type] = reagent_requirements[reagent]

		if(length(requirements))
			for(var/item_type in requirements)
				if(stored_items[item_type] < requirements[item_type])
					return FALSE
				passed_requirements |= item_type
				passed_requirements[item_type] = requirements[item_type]
				items_to_remove[item_type] = requirements[item_type]

		if(length(wildcard_requirements))
			var/list/wildcarded_types = list()
			for(var/wildcard in wildcard_requirements)
				var/items_found = 0
				var/amount_needed = wildcard_requirements[wildcard]

				for(var/obj/item/candidate_item in crafter.contents)
					if(ispath(candidate_item.type, wildcard) && !(candidate_item in items_to_delete))
						if(!wildcarded_types[candidate_item.type])
							wildcarded_types[candidate_item.type] = 0

						var/can_take = min(amount_needed - items_found, 1) // Take one at a time
						items_found += can_take
						wildcarded_types[candidate_item.type] += can_take

						if(can_take > 0)
							items_to_delete += candidate_item

						if(items_found >= amount_needed)
							break

				if(items_found < amount_needed)
					return FALSE

				passed_wildcards[wildcard] = wildcarded_types

		// Process optionals with respect to max_optionals

		// Build a list of all available optional items to consider
		var/list/potential_optionals = list()

		// Check optional requirements
		if(length(optional_requirements))
			for(var/opt_req in optional_requirements)
				if(stored_items[opt_req] >= optional_requirements[opt_req])
					potential_optionals += list(list(
						"type" = "requirement",
						"path" = opt_req,
						"amount" = optional_requirements[opt_req]
					))

		// Check optional wildcards
		if(length(optional_wildcard_requirements))
			for(var/opt_wildcard in optional_wildcard_requirements)
				var/remaining_wildcards = optional_wildcard_requirements[opt_wildcard]

				// Group candidate items by wildcard type
				var/list/wildcard_candidates = list()
				for(var/obj/item/candidate_item in crafter.contents)
					if(ispath(candidate_item.type, opt_wildcard) && !(candidate_item in items_to_delete))
						wildcard_candidates += candidate_item

				// Add each item as a potential optional
				for(var/obj/item/candidate_item in wildcard_candidates)
					if(remaining_wildcards > 0)
						potential_optionals += list(list(
							"type" = "wildcard",
							"wildcard_type" = opt_wildcard,
							"item" = candidate_item
						))
						remaining_wildcards--

		// Check optional reagents
		if(length(optional_reagent_requirements))
			for(var/opt_reagent in optional_reagent_requirements)
				if(crafter.reagents.has_reagent(opt_reagent, optional_reagent_requirements[opt_reagent], check_subtypes = subtype_reagents_allowed))
					potential_optionals += list(list(
						"type" = "reagent",
						"reagent" = opt_reagent,
						"amount" = optional_reagent_requirements[opt_reagent]
					))

		// Apply the cap and process the optionals
		var/optionals_used = 0
		for(var/list/optional in potential_optionals)
			if(max_optionals > 0 && optionals_used >= max_optionals)
				break

			if(optional["type"] == "requirement")
				var/opt_req = optional["path"]
				found_optional_requirements[opt_req] = optional["amount"]
				if(!items_to_remove[opt_req])
					items_to_remove[opt_req] = 0
				items_to_remove[opt_req] += optional["amount"]
				optionals_used++

			else if(optional["type"] == "wildcard")
				var/opt_wildcard = optional["wildcard_type"]
				var/obj/item/candidate_item = optional["item"]

				// Make sure we have a list for this wildcard type
				if(!islist(found_optional_wildcards[opt_wildcard]))
					found_optional_wildcards[opt_wildcard] = list()

				// Add the item to the list for this wildcard type
				found_optional_wildcards[opt_wildcard] += candidate_item
				items_to_delete += candidate_item
				optionals_used++

			else if(optional["type"] == "reagent")
				var/opt_reagent = optional["reagent"]
				found_optional_reagents[opt_reagent] = optional["amount"]
				optionals_used++

		// Remove reagents first
		for(var/reagent in passed_reagents)
			crafter.reagents.remove_reagent(reagent, passed_reagents[reagent])

		for(var/opt_reagent in found_optional_reagents)
			crafter.reagents.remove_reagent(opt_reagent, found_optional_reagents[opt_reagent])

		// Remove items by type
		for(var/item_type in items_to_remove)
			var/amount_to_remove = items_to_remove[item_type]
			for(var/obj/item/candidate_item in crafter.contents)
				if(amount_to_remove <= 0)
					break
				if(candidate_item.type == item_type && !(candidate_item in items_to_delete))
					items_to_delete += candidate_item
					amount_to_remove--

		for(var/obj/item/item_to_delete in items_to_delete)
			SEND_SIGNAL(crafter, COMSIG_TRY_STORAGE_TAKE, item_to_delete, get_turf(crafter))

		create_item(crafter, initiator, found_optional_requirements, found_optional_wildcards, found_optional_reagents, items_to_delete)

		initiator.mind?.add_sleep_experience(used_skill, initiator.STAINT * 0.5)
		// Remove all tracked items
		for(var/obj/item/item_to_delete in items_to_delete)
			qdel(item_to_delete)

	var/turf/turf = get_turf(crafter)
	turf.visible_message(span_green(complete_message))

/datum/container_craft/proc/create_item(obj/item/crafter, mob/living/initiator, list/found_optional_requirements, list/found_optional_wildcards, list/found_optional_reagents, list/removing_items)
	// Variables for quality calculation
	var/total_freshness = 0
	var/ingredient_count = 0
	var/highest_food_quality = 0
	var/highest_reagent_quality = 0
	var/total_reagent_volume = 0

	// Calculate average freshness and find highest quality ingredient
	for(var/obj/item/reagent_containers/food_item in removing_items)
		if(istype(food_item, /obj/item/reagent_containers/food/snacks) || istype(food_item, /obj/item/grown))
			ingredient_count++
			// Check warming value for freshness (higher means fresher)
			if(istype(food_item, /obj/item/reagent_containers/food/snacks))
				var/obj/item/reagent_containers/food/snacks/F = food_item
				total_freshness += max(0, (F.warming + F.rotprocess))
				highest_food_quality = max(highest_food_quality, F.recipe_quality )

	// Check reagent qualities in the crafter container
	if(crafter.reagents && crafter.reagents.reagent_list)
		for(var/datum/reagent/R in crafter.reagents.reagent_list)
			if(R.volume > 0)
				total_reagent_volume += R.volume
				// Weight the reagent quality by its volume
				highest_reagent_quality = max(highest_reagent_quality, R.recipe_quality)

	// Calculate average freshness
	var/average_freshness = (ingredient_count > 0) ? (total_freshness / ingredient_count) : 0

	// Get the initiator's cooking skill
	var/cooking_skill = initiator.get_skill_level(used_skill) + initiator.get_inspirational_bonus()

	if(HAS_TRAIT(initiator, TRAIT_LUCKY_COOK))
		// Every level above 9 increases the chance by 4%
		if(initiator.stat_roll(STATKEY_LCK, 4, 9))
			output_amount++

	// Create the output items
	for(var/j = 1 to output_amount)
		var/atom/created_output = new output(get_turf(crafter))

		// Apply quality and freshness if the output item is food
		if(istype(created_output, /obj/item/reagent_containers/food/snacks))
			var/obj/item/reagent_containers/food/snacks/food_item = created_output
			// Apply freshness to the new food item
			food_item.warming = min(5 MINUTES, average_freshness)

			// Calculate final quality based on ingredients, skill, and recipe
			apply_food_quality(food_item, cooking_skill, highest_food_quality, highest_reagent_quality, average_freshness)

		SEND_SIGNAL(crafter, COMSIG_TRY_STORAGE_INSERT, created_output, null, null, TRUE, TRUE)
		after_craft(created_output, crafter, initiator, found_optional_requirements, found_optional_wildcards, found_optional_reagents, removing_items)
		SEND_SIGNAL(crafter, COMSIG_CONTAINER_CRAFT_COMPLETE, created_output)

/**
 * Calculates the quality of crafted food based on cooking skill, ingredient quality, reagent quality, and freshness.
 *
 * @param cooking_skill The cooking skill level of the crafter
 * @param ingredient_quality The highest quality food ingredient used
 * @param reagent_quality The highest quality reagent used
 * @param freshness The average freshness of ingredients
 */
/datum/container_craft/proc/apply_food_quality(obj/item/reagent_containers/food/snacks/food_item, cooking_skill, ingredient_quality, reagent_quality, freshness)
	var/datum/quality_calculator/cooking/cook_calc = new(
		base_qual = 0,
		mat_qual = max(ingredient_quality, reagent_quality), // Use the higher of food or reagent quality
		skill_qual = cooking_skill,
		perf_qual = 0,
		diff_mod = 0,
		components = 1,
		fresh = freshness,
		recipe_mod = quality_modifier,
		reagent_qual = reagent_quality // Pass reagent quality separately if needed
	)
	cook_calc.apply_quality_to_item(food_item)
	qdel(cook_calc)


/datum/container_craft/proc/after_craft(atom/created_output, obj/item/crafter, mob/initiator, list/found_optional_requirements, list/found_optional_wildcards, list/found_optional_reagents, list/removing_items)
	// This is an extension point for specific crafting types to do additional processing
	// basically used exclusively for optional requirements
	return

/datum/container_craft/proc/get_real_time(atom/host, mob/user, estimated_multiplier)
	return crafting_time * estimated_multiplier

/datum/container_craft/proc/check_failure(obj/item/crafter, mob/user)
	return FALSE

/datum/container_craft/proc/generate_html(mob/user)
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
			.requirements {
				margin-bottom: 20px;
			}
			.optional {
				margin-top: 15px;
				font-style: italic;
			}
		</style>
		<body>
		  <div>
			<h1>[name]</h1>
			<div class="requirements">
			  <h2>Requirements</h2>
	"}

	// Add required items
	for(var/atom/path as anything in requirements)
		var/count = requirements[path]
		html += "[icon2html(new path, user)] [count] [initial(path.name)]<br>"

	// Add required reagents
	if(length(reagent_requirements))
		html += "<div class='reagents'><strong>Required Liquids:</strong><br>"
		for(var/reagent_type in reagent_requirements)
			var/reagent_amount = reagent_requirements[reagent_type]
			var/datum/reagent/R = new reagent_type
			html += "[UNIT_FORM_STRING(CEILING(reagent_amount, 1))] of [initial(R.name)]<br>"
			qdel(R)
		html += "</div>"

	// Add wildcard requirements
	if(length(wildcard_requirements))
		html += "<div class='requirements'><strong>Alternative Requirements:</strong><br>"
		for(var/atom/wildcard_type as anything  in wildcard_requirements)
			var/count = wildcard_requirements[wildcard_type]
			html += "[count] of any [wildcard_type.name]<br>"
		html += "</div>"

	// Add optional requirements if any
	if(max_optionals > 0)
		html += "<div class='optional'><strong>Optional ingredients (max [max_optionals]):</strong><br>"

		// Add specific optional requirements
		if(length(optional_requirements))
			for(var/atom/path as anything in optional_requirements)
				var/count = optional_requirements[path]
				html += "[icon2html(new path, user)] up to [count] of which can be [initial(path.name)]<br>"

		// Add wildcard optional requirements
		if(length(optional_wildcard_requirements))
			for(var/atom/wildcard_path as anything in optional_wildcard_requirements)
				var/count = optional_wildcard_requirements[wildcard_path]

				html += "Up to [count] of which can be any [wildcard_path.name]<br>"

		if(length(optional_reagent_requirements))
			for(var/datum/reagent/reagent as anything in optional_reagent_requirements)
				var/count = optional_reagent_requirements[reagent]
				html += "[UNIT_FORM_STRING(count)] of [reagent.name]"
		html += "</div>"

	html += {"
		</div>
		<div>
	"}

	html += "<strong class='scroll'>After [craft_verb][crafting_time * 0.1] Seconds<br>"
	if(required_container)
		var/obj/item/new_container = new required_container
		html += "[icon2html(new_container, user)] <strong class='scroll'>inside of a [initial(new_container.name)]<br>"
		qdel(new_container)

	// Result information
	html += "<strong class='scroll'>Creates<br>"
	html += extra_html()
	if(output)
		html += "[output_amount] [output.name]"

	html += {"
		</div>
		</div>
	</body>
	</html>
	"}

	return html

/datum/container_craft/proc/show_menu(mob/user)
	user << browse(generate_html(user), "window=container_craft;size=500x810")

/datum/container_craft/proc/extra_html()
	return
