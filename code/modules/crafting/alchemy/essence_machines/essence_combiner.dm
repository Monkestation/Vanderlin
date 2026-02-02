
/obj/machinery/essence/combiner
	name = "essence combiner"
	desc = "An agitating element within a simple glass container, designed to blend essences together. Can handle multiple combination recipes simultaneously."
	icon = 'icons/roguetown/misc/splitter.dmi'
	icon_state = "combiner"
	density = TRUE
	anchored = TRUE
	processing_priority = 3

	var/max_concurrent_recipes = 3


/obj/machinery/essence/combiner/Initialize()
	. = ..()
	input_storage = new /datum/essence_storage(src)
	input_storage.max_total_capacity = 150
	input_storage.max_essence_types = 8

	output_storage = new /datum/essence_storage(src)
	output_storage.max_total_capacity = 100
	output_storage.max_essence_types = 6

/obj/machinery/essence/combiner/process()
	if(!connection_processing)
		return
	var/list/prioritized_connections = sort_connections_by_priority(output_connections)
	for(var/datum/essence_connection/connection in prioritized_connections)
		if(!connection.active || !connection.target)
			continue
		var/datum/essence_storage/target_storage = get_target_storage(connection.target)
		if(!target_storage)
			continue
		for(var/essence_type in output_storage.stored_essences)
			var/available = output_storage.get_essence_amount(essence_type)
			if(available > 0)
				if(!can_target_accept_essence(connection.target, essence_type))
					continue

				var/to_transfer = min(available, connection.transfer_rate)
				var/transferred = output_storage.transfer_to(target_storage, essence_type, to_transfer)
				if(transferred > 0)
					create_essence_transfer_effect(connection.target, essence_type, transferred)
					break

/obj/machinery/essence/combiner/update_overlays()
	. = ..()

	var/essence_percent = (output_storage.get_total_stored() + input_storage.get_total_stored()) / (input_storage.max_total_capacity + output_storage.max_total_capacity)
	if(!essence_percent)
		return
	var/level = clamp(CEILING(essence_percent * 7, 1), 1, 7)

	. += mutable_appearance(icon, "liquid_[level]", color = calculate_mixture_color())
	. += emissive_appearance(icon, "liquid_[level]", alpha = src.alpha)

	if(processing)
		. += mutable_appearance(icon, "combining", layer = src.layer + 0.01)

/obj/machinery/essence/combiner/examine(mob/user)
	. = ..()
	. += span_notice("Input Storage: [input_storage.get_total_stored()]/[input_storage.max_total_capacity] units")
	. += span_notice("Output Storage: [output_storage.get_total_stored()]/[output_storage.max_total_capacity] units")

	if(input_storage.stored_essences.len > 0)
		. += span_notice("Ready to combine:")
		for(var/essence_type in input_storage.stored_essences)
			var/datum/thaumaturgical_essence/essence = new essence_type
			if(HAS_TRAIT(user, TRAIT_LEGENDARY_ALCHEMIST))
				. += span_notice("Contains [input_storage.stored_essences[essence_type]] units of [essence.name].")
			else
				. += span_notice("Contains [input_storage.stored_essences[essence_type]] units of essence smelling of [essence.smells_like].")
			qdel(essence)


/obj/machinery/essence/combiner/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/essence_vial))
		var/obj/item/essence_vial/vial = I
		if(!vial.contained_essence || vial.essence_amount <= 0)
			// Check if we should extract from output or input storage
			var/list/extraction_options = list()
			if(length(output_storage.stored_essences))
				extraction_options["Extract from Output"] = "output"
			if(length(input_storage.stored_essences))
				extraction_options["Extract from Input"] = "input"

			if(!length(extraction_options))
				to_chat(user, span_warning("No essences available for extraction."))
				return

			var/storage_choice
			if(length(extraction_options) == 1)
				storage_choice = extraction_options[extraction_options[1]]
			else
				var/choice = input(user, "Extract from which storage?", "Storage Selection") in extraction_options
				if(!choice)
					return
				storage_choice = extraction_options[choice]

			var/datum/essence_storage/target_storage = (storage_choice == "output") ? output_storage : input_storage

			// Create radial menu for essence selection
			var/list/radial_options = list()
			var/list/essence_mapping = list()
			for(var/essence_type in target_storage.stored_essences)
				var/datum/thaumaturgical_essence/essence = new essence_type
				var/display_name
				if(HAS_TRAIT(user, TRAIT_LEGENDARY_ALCHEMIST))
					display_name = essence.name
				else
					display_name = "Essence smelling of [essence.smells_like]"
				var/option_key = "[display_name] ([target_storage.stored_essences[essence_type]] units)"
				var/datum/radial_menu_choice/choice = new()
				var/image/image = image(icon = 'icons/roguetown/misc/alchemy.dmi', icon_state = "essence")
				image.color = essence.color
				choice.image = image
				choice.name = display_name
				if(HAS_TRAIT(user, TRAIT_LEGENDARY_ALCHEMIST))
					choice.info = "Extract [essence.name] essence. Smells of [essence.smells_like]."
				else
					choice.info = "Extract unknown essence. Smells of [essence.smells_like]."
				radial_options[option_key] = choice
				essence_mapping[option_key] = essence_type
				qdel(essence)
			var/choice = show_radial_menu(user, src, radial_options, custom_check = CALLBACK(src, PROC_REF(check_menu_validity), user, vial), radial_slice_icon = "radial_thaum")
			if(!choice || !essence_mapping[choice])
				return
			var/essence_type = essence_mapping[choice]
			var/max_extract = min(target_storage.get_essence_amount(essence_type), vial.max_essence)
			var/amount_to_extract = min(max_extract, vial.extract_amount)
			if(amount_to_extract <= 0)
				to_chat(user, span_warning("Cannot extract any essence with current vial settings."))
				return
			var/extracted = target_storage.remove_essence(essence_type, amount_to_extract)
			if(extracted > 0)
				vial.contained_essence = new essence_type
				vial.essence_amount = extracted
				vial.update_appearance(UPDATE_OVERLAYS)
				to_chat(user, span_info("You extract [extracted] units of essence from the [storage_choice == "output" ? "output" : "input"]."))
				update_overlays()
			return
		if(processing)
			to_chat(user, span_warning("The combiner is currently processing."))
			return
		var/essence_type = vial.contained_essence.type
		var/amount = vial.essence_amount
		if(!input_storage.add_essence(essence_type, amount))
			to_chat(user, span_warning("The input storage cannot accept this essence (capacity or type limit reached)."))
			return
		to_chat(user, span_info("You pour the [vial.contained_essence.name] into the combiner's input."))
		vial.contained_essence = null
		vial.essence_amount = 0
		vial.update_appearance(UPDATE_OVERLAYS)
		update_overlays()
		return TRUE
	..()

/obj/machinery/essence/combiner/attack_hand(mob/user, list/modifiers)
	if(processing)
		to_chat(user, span_warning("The combiner is currently processing."))
		return

	var/choice = input(user, "What would you like to do?", "Essence Combiner") in list("Start Combining", "View Storage", "Clear Input", "Cancel")

	switch(choice)
		if("Start Combining")
			attempt_combination(user)
		if("View Storage")
			show_storage_status(user)
		if("Clear Input")
			clear_input_storage(user)

/obj/machinery/essence/combiner/proc/show_storage_status(mob/user)
	var/list/status_text = list()
	status_text += "=== Essence Combiner Status ==="
	status_text += ""
	status_text += "INPUT STORAGE:"
	status_text += "Capacity: [input_storage.get_total_stored()]/[input_storage.max_total_capacity] units"

	if(input_storage.stored_essences.len > 0)
		for(var/essence_type in input_storage.stored_essences)
			var/datum/thaumaturgical_essence/essence = new essence_type
			status_text += "- [essence.name]: [input_storage.stored_essences[essence_type]] units"
			qdel(essence)
	else
		status_text += "- Empty"

	status_text += ""
	status_text += "OUTPUT STORAGE:"
	status_text += "Capacity: [output_storage.get_total_stored()]/[output_storage.max_total_capacity] units"

	if(output_storage.stored_essences.len > 0)
		for(var/essence_type in output_storage.stored_essences)
			var/datum/thaumaturgical_essence/essence = new essence_type
			status_text += "- [essence.name]: [output_storage.stored_essences[essence_type]] units"
			qdel(essence)
	else
		status_text += "- Empty"

	to_chat(user, span_info(jointext(status_text, "\n")))

/obj/machinery/essence/combiner/proc/clear_input_storage(mob/user)
	if(length(input_storage.stored_essences) == 0)
		to_chat(user, span_warning("Input storage is already empty."))
		return
	for(var/essence_type in input_storage.stored_essences)
		var/amount = input_storage.stored_essences[essence_type]
		var/obj/item/essence_vial/new_vial = new(get_turf(src))
		new_vial.contained_essence = new essence_type
		new_vial.essence_amount = amount
		new_vial.update_appearance(UPDATE_OVERLAYS)

	input_storage.stored_essences = list()
	to_chat(user, span_info("You clear the input storage, creating vials for each essence."))

/obj/machinery/essence/combiner/proc/attempt_combination(mob/user)
	if(!length(input_storage.stored_essences))
		to_chat(user, span_warning("No essences loaded for combination."))
		return

	var/list/possible_recipes = list()
	var/list/available_essences = input_storage.stored_essences.Copy()
	var/efficiency_bonus = GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/combiner_output)

	while(possible_recipes.len < max_concurrent_recipes)
		var/datum/essence_combination/recipe = find_matching_combination(available_essences)
		if(!recipe)
			break
		if(user.get_skill_level(/datum/skill/craft/alchemy) < recipe.skill_required)
			qdel(recipe)
			break
		var/can_make = TRUE
		for(var/essence_type in recipe.inputs)
			var/required = recipe.inputs[essence_type]
			var/have = available_essences[essence_type] || 0
			if(have < required)
				can_make = FALSE
				break

		if(!can_make)
			qdel(recipe)
			break

		for(var/essence_type in recipe.inputs)
			var/required = recipe.inputs[essence_type]
			available_essences[essence_type] -= required
			if(available_essences[essence_type] <= 0)
				available_essences -= essence_type

		possible_recipes += recipe

	if(!possible_recipes.len)
		to_chat(user, span_warning("No combinations can be performed with current essences."))
		return

	var/total_output = 0
	for(var/datum/essence_combination/recipe in possible_recipes)
		total_output += round(recipe.output_amount * efficiency_bonus, 1)

	if(output_storage.get_available_space() < total_output)
		to_chat(user, span_warning("Not enough space in output storage for bulk combination."))
		for(var/datum/essence_combination/recipe in possible_recipes)
			qdel(recipe)
		return

	begin_bulk_combination(user, possible_recipes)


/obj/machinery/essence/combiner/proc/begin_bulk_combination(mob/living/user, list/recipes)
	processing = TRUE
	user.visible_message(span_info("[user] activates the essence combiner for bulk processing ([recipes.len] recipes)."))
	update_overlays()

	var/speed_divide = GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/combiner_speed)
	var/process_time = (5 SECONDS + (recipes.len * 2 SECONDS)) / speed_divide
	addtimer(CALLBACK(src, PROC_REF(finish_bulk_combination), user, recipes), process_time)

/obj/machinery/essence/combiner/proc/finish_bulk_combination(mob/living/user, list/recipes)
	var/list/produced_essences = list()
	var/efficiency_bonus = GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/combiner_output)

	for(var/datum/essence_combination/recipe in recipes)
		for(var/essence_type in recipe.inputs)
			var/required_amount = recipe.inputs[essence_type]
			input_storage.remove_essence(essence_type, required_amount)

		output_storage.add_essence(recipe.output_type, round(recipe.output_amount * efficiency_bonus, 1))

		var/datum/thaumaturgical_essence/output_essence = new recipe.output_type
		if(produced_essences[output_essence.name])
			produced_essences[output_essence.name] += round(recipe.output_amount * efficiency_bonus, 1)
		else
			produced_essences[output_essence.name] = round(recipe.output_amount * efficiency_bonus, 1)
		qdel(output_essence)
		qdel(recipe)

	processing = FALSE
	update_overlays()

	var/list/production_report = list()
	for(var/essence_name in produced_essences)
		production_report += "[essence_name] ([produced_essences[essence_name]] units)"

	user.visible_message(span_info("The essence combiner completes bulk processing, producing: [jointext(production_report, ", ")]"))
	var/boon = user.get_learning_boon(/datum/skill/craft/alchemy)
	var/amt2raise = user.STAINT * recipes.len
	user.adjust_experience(/datum/skill/craft/alchemy, amt2raise * boon, FALSE)


/obj/machinery/essence/combiner/proc/find_matching_combination(list/available_essences)
	for(var/recipe_path in subtypesof(/datum/essence_combination))
		var/datum/essence_combination/recipe = new recipe_path
		var/matches = TRUE
		for(var/essence_type in recipe.inputs)
			var/required_amount = recipe.inputs[essence_type]
			var/available_amount = available_essences[essence_type] || 0
			if(available_amount < required_amount)
				matches = FALSE
				break

		if(matches)
			return recipe
		qdel(recipe)

	return null

/obj/machinery/essence/combiner/proc/calculate_mixture_color()
	var/list/essence_contents = list()

	essence_contents |= input_storage.stored_essences
	essence_contents |= output_storage.stored_essences

	if(!length(essence_contents))
		return "#4A90E2"

	var/total_weight = 0
	var/r = 0, g = 0, b = 0

	for(var/essence_type in essence_contents)
		var/datum/thaumaturgical_essence/essence = new essence_type
		var/amount = essence_contents[essence_type]
		var/weight = amount * (essence.tier + 1) // Higher tier essences have more color influence

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
