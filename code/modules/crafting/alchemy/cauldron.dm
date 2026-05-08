/obj/machinery/essence/cauldron_node
	name = "cauldron essence node"
	desc = "An internal essence conduit."
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "cauldron1"
	density = FALSE
	anchored = TRUE
	accepts_input = TRUE
	accepts_output = TRUE  // Can push surplus back out
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/obj/machinery/light/fueled/cauldron/owner

/obj/machinery/essence/cauldron_node/Initialize(mapload, obj/machinery/light/fueled/cauldron/parent)
	. = ..()
	owner = parent
	storage.max_total = 300
	storage.max_types = 6

/obj/machinery/essence/cauldron_node/Destroy()
	owner = null
	return ..()

/obj/machinery/essence/cauldron_node/push_to_linked(datum/essence_storage/from_storage)
	push_surplus_to_linked(from_storage)

/obj/machinery/essence/cauldron_node/build_allowed_types()
	if(!owner || QDELETED(owner))
		return list()

	var/datum/alch_cauldron_recipe/recipe = owner.selected_recipe
	if(!recipe)
		return list() // No recipe, accept nothing from the network

	// Work out the cap per essence type based on what's already in
	// essence_contents plus what's in our own storage (in-transit).
	var/list/allowed = list()
	var/max_batches = owner.calculate_max_possible_batches(recipe)

	for(var/essence_type in recipe.required_essences)
		var/needed_total = recipe.required_essences[essence_type] * max_batches
		var/already_have = (owner.essence_contents[essence_type] || 0) + storage.get(essence_type)
		var/room = needed_total - already_have
		if(room > 0)
			allowed[essence_type] = room

	return allowed

/obj/machinery/essence/cauldron_node/show_link_beams()
	if(!links.len)
		return
	for(var/datum/essence_link/link in links)
		var/obj/machinery/essence/other = (link.source == src) ? link.sink : link.source
		if(!other || QDELETED(other))
			continue
		var/turf/other_turf = resolve_beam_turf(other)
		if(!other_turf)
			continue
		var/beam_color = (link.source == src) ? "#88CCFF" : "#FFAA44"
		owner.Beam(other_turf, icon_state = "light_beam", time = 1.5 SECONDS, beam_color = beam_color)



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
	var/list/essence_contents = list()
	var/max_essence_types = 6
	var/brewing = 0
	var/datum/weakref/lastuser
	fueluse = 20 MINUTES
	crossfire = FALSE

	var/datum/alch_cauldron_recipe/selected_recipe = null
	var/auto_repeat = FALSE
	var/obj/machinery/essence/cauldron_node/essence_node = null

/obj/machinery/light/fueled/cauldron/Initialize()
	. = ..()
	create_reagents(500, DRAINABLE | AMOUNT_VISIBLE | REFILLABLE)
	essence_node = new /obj/machinery/essence/cauldron_node(null, src) // nullspace

/obj/machinery/light/fueled/cauldron/Destroy()
	chem_splash(loc, 2, list(reagents))
	playsound(src, pick('sound/foley/water_land1.ogg','sound/foley/water_land2.ogg', 'sound/foley/water_land3.ogg'), 100, FALSE)
	if(essence_node && !QDELETED(essence_node))
		qdel(essence_node)
	essence_node = null
	lastuser = null
	selected_recipe = null
	return ..()

/obj/machinery/light/fueled/cauldron/examine(mob/user)
	. = ..()
	if(selected_recipe)
		. += span_info("Recipe selected: [initial(selected_recipe.recipe_name)]")
		if(auto_repeat)
			. += span_info("Auto-repeat is enabled. The cauldron will automatically brew when essences are available.")
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

	if(essence_node && essence_node.links.len)
		. += span_notice("Essence links: [essence_node.links.len] connected.")

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
		to_chat(user, span_info("Auto-repeat enabled. [src] will automatically brew [initial(selected_recipe.recipe_name)] when essences are available."))
	else
		to_chat(user, span_info("Auto-repeat disabled."))

/obj/machinery/light/fueled/cauldron/attackby_secondary(obj/item/I, mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!istype(I, /obj/item/essence_connector))
		return
	if(!essence_node || QDELETED(essence_node))
		to_chat(user, span_warning("The cauldron has no essence conduit."))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	essence_node.show_link_menu(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/light/fueled/cauldron/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/essence_connector)) // just return
		return

	if(istype(I, /obj/item/essence_vial))
		var/obj/item/essence_vial/vial = I
		if(!vial.contained_essence || vial.essence_amount <= 0)
			to_chat(user, span_warning("The vial is empty."))
			return

		if(essence_contents.len >= max_essence_types)
			to_chat(user, span_warning("The cauldron cannot hold any more essence types."))
			return

		var/essence_type = vial.contained_essence.type
		essence_contents[essence_type] = (essence_contents[essence_type] || 0) + vial.essence_amount

		to_chat(user, span_info("You pour the [vial.contained_essence.name] into the cauldron."))
		vial.contained_essence = null
		vial.essence_amount = 0
		vial.update_appearance(UPDATE_OVERLAYS)

		brewing = 0
		lastuser = WEAKREF(user)
		update_appearance(UPDATE_OVERLAYS)
		playsound(src, "bubbles", 100, TRUE)
		return

	return ..()

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
	on_recipe_changed()
	to_chat(user, span_info("Recipe set to: [initial(selected_recipe.recipe_name)]"))
	to_chat(user, span_notice("Alt-click the cauldron to enable auto-repeat mode."))

/obj/machinery/light/fueled/cauldron/proc/clear_recipe()
	selected_recipe = null
	auto_repeat = FALSE
	on_recipe_changed()

/obj/machinery/light/fueled/cauldron/proc/on_recipe_changed()
	// Push everything from essence_contents back into the node
	// so the network can redistribute what the new recipe doesn't need
	if(essence_node && !QDELETED(essence_node))
		for(var/essence_type in essence_contents.Copy())
			var/amount = essence_contents[essence_type]
			if(!amount)
				continue
			var/moved = essence_node.storage.add(essence_type, amount)
			essence_contents[essence_type] -= moved
			if(essence_contents[essence_type] <= 0)
				essence_contents -= essence_type
		if(essence_node.network)
			essence_node.network.invalidate_cache()
		// Now push_surplus_to_linked will eject whatever the new recipe doesn't want
		essence_node.push_surplus_to_linked(essence_node.storage)
	update_appearance(UPDATE_OVERLAYS)

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

// Drain from node into essence_contents, but never exceed the cap
// for the current recipe.
/obj/machinery/light/fueled/cauldron/proc/drain_from_node()
	if(!essence_node || QDELETED(essence_node))
		return
	var/datum/essence_storage/node_storage = essence_node.storage
	if(!node_storage || !node_storage.contents.len)
		return

	var/datum/alch_cauldron_recipe/recipe = selected_recipe
	var/max_batches = recipe ? calculate_max_possible_batches(recipe) : 0

	for(var/essence_type in node_storage.contents.Copy())
		var/available = node_storage.get(essence_type)
		if(!available)
			continue
		if(essence_contents.len >= max_essence_types && !essence_contents[essence_type])
			continue

		var/to_drain = available
		// Cap to recipe needs if we have a recipe and this type is in it
		if(recipe && max_batches > 0 && (essence_type in recipe.required_essences))
			var/needed_total = recipe.required_essences[essence_type] * max_batches
			var/already_have = essence_contents[essence_type] || 0
			to_drain = min(available, max(0, needed_total - already_have))

		if(to_drain <= 0)
			continue

		var/drained = node_storage.remove(essence_type, to_drain)
		essence_contents[essence_type] = (essence_contents[essence_type] || 0) + drained

	// Push anything left in the node that we don't need back out
	// (the network will route it elsewhere via push_to_linked)
	if(node_storage.contents.len)
		essence_node.push_to_linked(node_storage)

	update_appearance(UPDATE_OVERLAYS)

// How many batches could we theoretically make if we had infinite
// essences? Bounded only by storage capacity.
/obj/machinery/light/fueled/cauldron/proc/calculate_max_possible_batches(datum/alch_cauldron_recipe/recipe)
	if(!recipe || !recipe.required_essences.len)
		return 0

	// Each essence slot in essence_contents can hold at most its share
	// of the total cauldron capacity. Find the limiting type.
	var/min_batches = INFINITY
	for(var/essence_type in recipe.required_essences)
		var/required_per_batch = recipe.required_essences[essence_type]
		if(!required_per_batch)
			continue
		// How many of this type can the cauldron physically hold?
		var/type_cap = essence_node.storage.max_total / recipe.required_essences.len
		min_batches = min(min_batches, FLOOR(type_cap / required_per_batch, 1))

	return (min_batches == INFINITY) ? 0 : max(min_batches, 1)

/obj/machinery/light/fueled/cauldron/proc/has_required_essences()
	if(!selected_recipe)
		return FALSE
	for(var/essence_type in selected_recipe.required_essences)
		var/required = selected_recipe.required_essences[essence_type]
		var/current = essence_contents[essence_type] || 0
		if(current < required)
			return FALSE
	return TRUE

/obj/machinery/light/fueled/cauldron/process()
	..()

	if(!on)
		return

	drain_from_node()

	if(auto_repeat && selected_recipe && brewing == 0)
		if(!has_required_essences())
			return // Waiting for essences to arrive via network

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

				essence_contents = list()

				if(reagents)
					var/in_cauldron = src.reagents.get_reagent_amount(/datum/reagent/water)
					src.reagents.remove_reagent(/datum/reagent/water, in_cauldron)

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

				if(lastuser)
					var/mob/living/L = lastuser.resolve()
					record_featured_stat(FEATURED_STATS_ALCHEMISTS, L)
					record_round_statistic(STATS_POTIONS_BREWED, batch_count)
					var/boon = L.get_learning_boon(/datum/attribute/skill/craft/alchemy)
					var/amt2raise = GET_MOB_ATTRIBUTE_VALUE(L, STAT_INTELLIGENCE) * 2 * batch_count
					L.adjust_experience(/datum/attribute/skill/craft/alchemy, amt2raise * boon, FALSE)

				playsound(src, "bubbles", 100, TRUE)
				playsound(src, 'sound/misc/smelter_fin.ogg', 30, FALSE)
				brewing = 21
				update_appearance(UPDATE_OVERLAYS)

				if(auto_repeat && selected_recipe)
					brewing = 0 // Reset immediately for next batch
			else
				brewing = 0
				essence_contents = list()
				src.visible_message(span_info("The essences in the [src] fail to combine properly..."))
				playsound(src, 'sound/misc/smelter_fin.ogg', 30, FALSE)
				update_appearance(UPDATE_OVERLAYS)

/obj/machinery/light/fueled/cauldron/proc/calculate_mixture_color()
	if(essence_contents.len == 0)
		return "#4A90E2"

	var/total_weight = 0
	var/r = 0
	var/g = 0
	var/b = 0

	for(var/essence_type in essence_contents)
		var/datum/thaumaturgical_essence/essence = new essence_type
		var/amount = essence_contents[essence_type]
		var/weight = amount * (essence.tier + 1)

		total_weight += weight
		var/color_val = hex2num(copytext(essence.color, 2, 4))
		r += color_val * weight
		color_val = hex2num(copytext(essence.color, 4, 6))
		g += color_val * weight
		color_val = hex2num(copytext(essence.color, 6, 8))
		b += color_val * weight
		qdel(essence)

	if(total_weight == 0)
		return "#4A90E2"

	r = FLOOR(r / total_weight, 1)
	g = FLOOR(g / total_weight, 1)
	b = FLOOR(b / total_weight, 1)

	return rgb(r, g, b)

/obj/machinery/light/fueled/cauldron/proc/find_matching_recipe_with_batches()
	if(selected_recipe)
		var/batch_count = calculate_max_batches(selected_recipe)
		if(batch_count > 0)
			return list("recipe" = selected_recipe, "batches" = batch_count)

	for(var/recipe_path in subtypesof(/datum/alch_cauldron_recipe))
		var/datum/alch_cauldron_recipe/recipe = new recipe_path
		var/batch_count = calculate_max_batches(recipe)
		if(batch_count > 0)
			return list("recipe" = recipe, "batches" = batch_count)
		qdel(recipe)
	return null

/obj/machinery/light/fueled/cauldron/proc/calculate_max_batches(datum/alch_cauldron_recipe/recipe)
	if(!recipe.matches_essences(essence_contents))
		return 0

	var/min_batches = 999
	for(var/essence_type in recipe.required_essences)
		var/required_amount = recipe.required_essences[essence_type]
		var/available_amount = essence_contents[essence_type]
		if(!available_amount || available_amount < required_amount)
			return 0
		var/possible_batches = FLOOR(available_amount / required_amount, 1)
		min_batches = min(min_batches, possible_batches)

	return min_batches
