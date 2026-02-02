/obj/machinery/light/fueled/cauldron
	name = "cauldron"
	desc = "Bubble, Bubble, toil and trouble. A great iron cauldron for brewing potions from alchemical essences."
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "cauldron1"
	base_state = "cauldron"
	density = TRUE
	opacity = FALSE
	anchored = TRUE
	max_integrity = 300
	var/list/essence_contents = list() // essence_type = amount
	var/max_essence_types = 6
	var/brewing = 0
	var/datum/weakref/lastuser
	fueluse = 20 MINUTES
	crossfire = FALSE

	var/datum/alch_cauldron_recipe/selected_recipe = null
	var/auto_repeat = FALSE
	var/auto_pull_range = 10
	var/pulling_essences = FALSE

/obj/machinery/light/fueled/cauldron/Initialize()
	create_reagents(500, DRAINABLE | AMOUNT_VISIBLE | REFILLABLE)
	return ..()

/obj/machinery/light/fueled/cauldron/Destroy()
	chem_splash(loc, 2, list(reagents))
	playsound(src, pick('sound/foley/water_land1.ogg','sound/foley/water_land2.ogg', 'sound/foley/water_land3.ogg'), 100, FALSE)
	lastuser = null
	selected_recipe = null
	return ..()

/obj/machinery/light/fueled/cauldron/examine(mob/user)
	. = ..()
	if(selected_recipe)
		. += span_info("Recipe selected: [initial(selected_recipe.recipe_name)]")
		if(auto_repeat)
			. += span_info("Auto-repeat is enabled. The cauldron will automatically pull essences from nearby machinery.")
		else
			. += span_info("Auto-repeat is disabled. Alt-click to enable automatic brewing.")
	else
		. += span_notice("No recipe selected. Click with empty hand to select a recipe.")

	if(selected_recipe)
		. += span_notice("Required essences:")
		for(var/essence_type in selected_recipe.required_essences)
			var/datum/thaumaturgical_essence/essence = new essence_type
			var/required = selected_recipe.required_essences[essence_type]
			var/current = essence_contents[essence_type] || 0
			. += span_notice("  - [essence.name]: [current]/[required]")
			qdel(essence)

/obj/machinery/light/fueled/cauldron/attack_hand(mob/user)
	if(!user.default_can_use_topic(src))
		return

	show_recipe_menu(user)

/obj/machinery/light/fueled/cauldron/AltClick(mob/user, list/modifiers)
	. = ..()
	if(!user.default_can_use_topic(src))
		return

	if(!selected_recipe)
		to_chat(user, span_warning("You must select a recipe first."))
		return

	auto_repeat = !auto_repeat
	if(auto_repeat)
		to_chat(user, span_info("Auto-repeat enabled. [src] will automatically pull essences and brew [initial(selected_recipe.recipe_name)]."))
		if(!pulling_essences && brewing == 0)
			attempt_auto_pull_essences()
	else
		to_chat(user, span_info("Auto-repeat disabled."))

/obj/machinery/light/fueled/cauldron/proc/show_recipe_menu(mob/user)
	var/list/recipes = list()
	recipes["Clear Recipe"] = null

	for(var/recipe_path in subtypesof(/datum/alch_cauldron_recipe))
		var/datum/alch_cauldron_recipe/recipe = new recipe_path
		recipes[initial(recipe.recipe_name)] = recipe_path
		qdel(recipe)

	var/choice = input(user, "Select a recipe for the cauldron", "Cauldron Recipe") as null|anything in recipes
	if(!choice || !user.default_can_use_topic(src))
		return

	var/recipe_path = recipes[choice]
	if(!recipe_path)
		selected_recipe = null
		auto_repeat = FALSE
		to_chat(user, span_info("Recipe cleared."))
		return

	selected_recipe = new recipe_path
	to_chat(user, span_info("Recipe set to: [initial(selected_recipe.recipe_name)]"))
	to_chat(user, span_notice("Alt-click the cauldron to enable auto-repeat mode."))

/obj/machinery/light/fueled/cauldron/update_overlays()
	. = ..()
	if(!reagents?.total_volume || !LAZYLEN(essence_contents))
		return
	var/mutable_appearance/filling
	if(!brewing)
		filling = mutable_appearance('icons/roguetown/misc/alchemy.dmi', "cauldron_full")
	if(brewing > 0)
		filling = mutable_appearance('icons/roguetown/misc/alchemy.dmi', "cauldron_boiling")
	if(!filling)
		return
	filling.color = calculate_mixture_color()
	. += filling

/obj/machinery/light/fueled/cauldron/burn_out()
	brewing = 0
	return ..()

/obj/machinery/light/fueled/cauldron/proc/calculate_mixture_color()
	if(essence_contents.len == 0)
		return "#4A90E2" // Default water color

	var/total_weight = 0
	var/r = 0, g = 0, b = 0

	for(var/essence_type in essence_contents)
		var/datum/thaumaturgical_essence/essence = new essence_type
		var/amount = essence_contents[essence_type]
		var/weight = amount * (essence.tier + 1) // Higher tier essences have more color influence

		total_weight += weight
		var/color_val = hex2num(copytext(essence.color, 2, 4)) // R
		r += color_val * weight
		color_val = hex2num(copytext(essence.color, 4, 6)) // G
		g += color_val * weight
		color_val = hex2num(copytext(essence.color, 6, 8)) // B
		b += color_val * weight

		qdel(essence)

	if(total_weight == 0)
		return "#4A90E2"

	r = FLOOR(r / total_weight, 1)
	g = FLOOR(g / total_weight, 1)
	b = FLOOR(b / total_weight, 1)

	return rgb(r, g, b)

/obj/machinery/light/fueled/cauldron/attackby(obj/item/I, mob/user, list/modifiers)
	if(!istype(I, /obj/item/essence_vial))
		return ..()
	var/obj/item/essence_vial/vial = I
	if(!vial.contained_essence || vial.essence_amount <= 0)
		to_chat(user, span_warning("The vial is empty."))
		return

	if(essence_contents.len >= max_essence_types)
		to_chat(user, span_warning("The cauldron cannot hold any more essence types."))
		return

	var/essence_type = vial.contained_essence.type
	if(essence_contents[essence_type])
		essence_contents[essence_type] += vial.essence_amount
	else
		essence_contents[essence_type] = vial.essence_amount

	to_chat(user, span_info("You pour the [vial.contained_essence.name] into the cauldron."))
	vial.contained_essence = null
	vial.essence_amount = 0
	vial.update_appearance(UPDATE_OVERLAYS)

	brewing = 0 // Reset brewing when new ingredients added
	lastuser = WEAKREF(user)
	update_appearance(UPDATE_OVERLAYS)
	playsound(src, "bubbles", 100, TRUE)

/obj/machinery/light/fueled/cauldron/process()
	..()
	if(on)
		// Check if we should auto-pull essences
		if(auto_repeat && selected_recipe && brewing == 0 && !pulling_essences)
			if(!has_required_essences())
				attempt_auto_pull_essences()

		if(length(essence_contents))
			if(brewing < 20)
				if(src.reagents.has_reagent(/datum/reagent/water, 50))
					brewing++
					update_appearance(UPDATE_OVERLAYS)
					if(prob(10))
						playsound(src, "bubbles", 100, FALSE)
			else if(brewing == 20)
				var/list/recipe_result = find_matching_recipe_with_batches()
				if(recipe_result)
					var/datum/alch_cauldron_recipe/found_recipe = recipe_result["recipe"]
					var/batch_count = recipe_result["batches"]

					// Clear essences (consume all used essences)
					essence_contents = list()

					// Remove water and add product
					if(reagents)
						var/in_cauldron = src.reagents.get_reagent_amount(/datum/reagent/water)
						src.reagents.remove_reagent(/datum/reagent/water, in_cauldron)

					// Scale output by batch count
					if(found_recipe.output_reagents.len)
						var/list/scaled_reagents = list()
						for(var/reagent in found_recipe.output_reagents)
							scaled_reagents[reagent] = found_recipe.output_reagents[reagent] * batch_count
						src.reagents.add_reagent_list(scaled_reagents)

					if(found_recipe.output_items.len)
						for(var/itempath in found_recipe.output_items)
							for(var/i = 1 to batch_count)
								new itempath(get_turf(src))

					if(batch_count > 1)
						src.visible_message(span_info("The cauldron finishes boiling [batch_count] batches with a strong [found_recipe.smells_like] smell."))
					else
						src.visible_message(span_info("The cauldron finishes boiling with a faint [found_recipe.smells_like] smell."))

					// XP and stats (scaled by batch count)
					if(lastuser)
						var/mob/living/L = lastuser.resolve()
						record_featured_stat(FEATURED_STATS_ALCHEMISTS, L)
						record_round_statistic(STATS_POTIONS_BREWED, batch_count)
						var/boon = L.get_learning_boon(/datum/skill/craft/alchemy)
						var/amt2raise = L.STAINT * 2 * batch_count // More XP for multiple batches
						L.adjust_experience(/datum/skill/craft/alchemy, amt2raise * boon, FALSE)

					playsound(src, "bubbles", 100, TRUE)
					playsound(src, 'sound/misc/smelter_fin.ogg', 30, FALSE)
					brewing = 21
					update_appearance(UPDATE_OVERLAYS)
				else
					brewing = 0
					essence_contents = list() // Clear failed recipe
					src.visible_message(span_info("The essences in the [src] fail to combine properly..."))
					playsound(src, 'sound/misc/smelter_fin.ogg', 30, FALSE)
					update_appearance(UPDATE_OVERLAYS)

					// If auto-repeat is on and we failed, try again
					if(auto_repeat && selected_recipe)
						attempt_auto_pull_essences()

/obj/machinery/light/fueled/cauldron/proc/has_required_essences()
	if(!selected_recipe)
		return FALSE

	for(var/essence_type in selected_recipe.required_essences)
		var/required = selected_recipe.required_essences[essence_type]
		var/current = essence_contents[essence_type] || 0
		if(current < required)
			return FALSE

	return TRUE

/obj/machinery/light/fueled/cauldron/proc/attempt_auto_pull_essences()
	if(pulling_essences || !selected_recipe)
		return

	pulling_essences = TRUE
	do_auto_pull_essences()
	pulling_essences = FALSE

/obj/machinery/light/fueled/cauldron/proc/do_auto_pull_essences()
	for(var/essence_type in selected_recipe.required_essences)
		var/required = selected_recipe.required_essences[essence_type]
		var/current = essence_contents[essence_type] || 0
		var/needed = required - current

		if(needed <= 0)
			continue

		// Find nearby essence machinery with this essence type
		var/obj/machinery/essence/reservoir/source = find_essence_source(essence_type, needed)
		if(!source)
			return

		// Extract essence
		if(extract_essence_from_source(source, essence_type, needed))
			visible_message(span_info("[src] pulls essence from nearby machinery."))
			sleep(1 SECONDS) // Small delay between pulls for visual effect
		else
			visible_message(span_warning("[src] failed to extract essence from machinery!"))
			return

	// All essences acquired, reset brewing
	if(has_required_essences())
		brewing = 0
		update_appearance(UPDATE_OVERLAYS)

/obj/machinery/light/fueled/cauldron/proc/find_essence_source(essence_type, amount_needed)
	for(var/obj/machinery/essence/reservoir/reservoir in range(auto_pull_range, src))
		var/datum/essence_storage/storage = reservoir.return_storage()
		if(storage && storage.get_essence_amount(essence_type) >= amount_needed)
			return reservoir

	return null

/obj/machinery/light/fueled/cauldron/proc/extract_essence_from_source(obj/machinery/essence/reservoir/source, essence_type, amount)
	var/datum/essence_storage/storage = source.return_storage()
	if(!storage)
		return FALSE

	var/extracted = storage.remove_essence(essence_type, amount)
	if(extracted > 0)
		if(essence_contents[essence_type])
			essence_contents[essence_type] += extracted
		else
			essence_contents[essence_type] = extracted

		// Create visual effect
		var/turf/source_turf = get_turf(source)
		var/turf/target_turf = get_turf(src)
		if(source_turf && target_turf)
			new /obj/effect/essence_orb(source_turf, src, essence_type, 1 SECONDS)

		return TRUE

	return FALSE

/obj/machinery/light/fueled/cauldron/proc/find_matching_recipe_with_batches()
	// If we have a selected recipe, try it first
	if(selected_recipe)
		var/batch_count = calculate_max_batches(selected_recipe)
		if(batch_count > 0)
			return list("recipe" = selected_recipe, "batches" = batch_count)

	// Otherwise search all recipes (for manual pouring)
	for(var/recipe_path in subtypesof(/datum/alch_cauldron_recipe))
		var/datum/alch_cauldron_recipe/recipe = new recipe_path
		var/batch_count = calculate_max_batches(recipe)
		if(batch_count > 0)
			var/list/result = list("recipe" = recipe, "batches" = batch_count)
			return result
		qdel(recipe)
	return null

/obj/machinery/light/fueled/cauldron/proc/calculate_max_batches(datum/alch_cauldron_recipe/recipe)
	// Check if recipe matches at all first
	if(!recipe.matches_essences(essence_contents))
		return 0

	// Calculate how many complete batches we can make
	var/min_batches = 999 // Start high

	for(var/essence_type in recipe.required_essences)
		var/required_amount = recipe.required_essences[essence_type]
		var/available_amount = essence_contents[essence_type]

		if(!available_amount || available_amount < required_amount)
			return 0 // Can't make even one batch

		var/possible_batches = FLOOR(available_amount / required_amount, 1)
		min_batches = min(min_batches, possible_batches)

	return min_batches
