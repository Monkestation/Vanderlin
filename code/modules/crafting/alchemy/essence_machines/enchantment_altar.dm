//TODO: Sounds, Visuals
/obj/machinery/essence/enchantment_altar
	name = "enchanting table"
	desc = "A pedestal made of obsidian, it acts as an alchemical focus to allow for an item to be infused and enchanted with the essences of the environment."
	icon = 'icons/roguetown/misc/altar.dmi'
	icon_state = "altar"
	density = TRUE
	anchored = TRUE

	var/datum/essence_storage/altar_storage
	var/obj/item/placed_item = null
	var/enchanting = FALSE
	var/enchantment_time = 30 SECONDS

	// Recipe preselection variables
	var/datum/enchantment/selected_recipe = null
	var/list/recipe_progress = list()  // Tracks how much of each essence type we have for the recipe

	// Visual effects
	var/list/active_particles = list()

/obj/machinery/essence/enchantment_altar/Initialize()
	. = ..()
	altar_storage = new /datum/essence_storage(src)
	altar_storage.max_total_capacity = 500
	altar_storage.max_essence_types = 15

	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/essence/enchantment_altar/Destroy()
	if(altar_storage)
		qdel(altar_storage)
	if(placed_item)
		placed_item.forceMove(get_turf(src))
	placed_item = null
	if(selected_recipe)
		qdel(selected_recipe)
	return ..()

/obj/machinery/essence/enchantment_altar/update_overlays()
	. = ..()

	if(placed_item)
		var/mutable_appearance/item_overlay = mutable_appearance(placed_item.icon, placed_item.icon_state)
		item_overlay.pixel_y = 8
		var/matrix/matrix = matrix()
		matrix.Scale(0.5, 0.5)
		item_overlay.transform = matrix
		item_overlay.alpha = 122
		item_overlay.color = COLOR_CYAN

		. += item_overlay

	if(altar_storage.get_total_stored() > 0)
		var/mutable_appearance/glow = mutable_appearance(icon, "altar_glow")
		glow.color = get_dominant_essence_color()
		. += glow

	if(selected_recipe)
		var/mutable_appearance/recipe_indicator = mutable_appearance(icon, "recipe_selected")
		. += recipe_indicator

	if(enchanting)
		var/mutable_appearance/enchant_effect = mutable_appearance(icon, "enchanting")
		. += enchant_effect

	var/mutable_appearance/crystal = mutable_appearance(icon, "crystal")
	. += crystal

/obj/machinery/essence/enchantment_altar/return_storage()
	return altar_storage

/obj/machinery/essence/enchantment_altar/is_essence_allowed(essence_type)
	if(!selected_recipe)
		return FALSE // No recipe selected, accept anything

	if(!(essence_type in selected_recipe.essence_recipe))
		return FALSE // Not needed for recipe

	var/needed = selected_recipe.essence_recipe[essence_type]
	var/current = altar_storage.get_essence_amount(essence_type)
	var/remaining_needed = needed - current

	if(remaining_needed <= 0)
		return FALSE // Already have enough

	return TRUE

/obj/machinery/essence/enchantment_altar/can_target_accept_essence(target, essence_type)
	return is_essence_allowed(essence_type)

/obj/machinery/essence/enchantment_altar/process()
	if(!connection_processing || !selected_recipe || enchanting)
		return

	// Pull essences from connected sources if recipe isn't complete
	if(recipe_is_complete())
		return

	var/list/recipe = selected_recipe.essence_recipe

	for(var/datum/essence_connection/connection in input_connections)
		if(!connection.active || !connection.source)
			continue

		var/obj/machinery/essence/source = connection.source
		var/datum/essence_storage/source_storage = source.return_storage()

		if(!source_storage)
			continue

		// Check what essences we need
		for(var/essence_type in recipe)
			var/required = recipe[essence_type]
			var/current = altar_storage.get_essence_amount(essence_type)
			var/needed = required - current

			if(needed <= 0)
				continue

			var/available = source_storage.get_essence_amount(essence_type)
			if(available <= 0)
				continue

			var/to_transfer = min(needed, available, connection.transfer_rate)
			var/transferred = source_storage.transfer_to(altar_storage, essence_type, to_transfer)

			if(transferred > 0)
				create_essence_transfer_effect(source, essence_type, transferred)
				update_recipe_progress()
				update_appearance(UPDATE_OVERLAYS)
				return // Only transfer one essence type per process tick

/obj/machinery/essence/enchantment_altar/proc/get_dominant_essence_color()
	var/highest_amount = 0
	var/dominant_color = "#FFFFFF"

	for(var/essence_type in altar_storage.stored_essences)
		var/amount = altar_storage.get_essence_amount(essence_type)
		if(amount > highest_amount)
			highest_amount = amount
			var/datum/thaumaturgical_essence/essence = new essence_type
			dominant_color = essence.color
			qdel(essence)

	return dominant_color

/obj/machinery/essence/enchantment_altar/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/essence_vial))
		var/obj/item/essence_vial/vial = I
		if(!vial.contained_essence || vial.essence_amount <= 0)
			if(!length(altar_storage.stored_essences))
				to_chat(user, span_warning("The altar has no essences stored."))
				return

			var/list/available_essences = list()
			for(var/essence_type in altar_storage.stored_essences)
				var/datum/thaumaturgical_essence/essence = new essence_type
				available_essences["[essence.name] ([altar_storage.stored_essences[essence_type]] units)"] = essence_type
				qdel(essence)

			var/choice = input(user, "Which essence would you like to extract?", "Extract Essence") in available_essences
			if(!choice)
				return

			var/essence_type = available_essences[choice]
			var/max_extract = min(altar_storage.get_essence_amount(essence_type), vial.max_essence)
			var/amount_to_extract = input(user, "How much would you like to extract? (Max: [max_extract])", "Extract Amount", max_extract) as num

			if(amount_to_extract <= 0 || amount_to_extract > max_extract)
				return

			var/extracted = altar_storage.remove_essence(essence_type, amount_to_extract)
			if(extracted > 0)
				vial.contained_essence = new essence_type
				vial.essence_amount = extracted
				vial.update_appearance(UPDATE_OVERLAYS)
				to_chat(user, span_info("You extract [extracted] units of essence from the altar."))
				update_appearance(UPDATE_OVERLAYS)
			return

		var/essence_type = vial.contained_essence.type
		var/amount = vial.essence_amount

		if(selected_recipe)
			if(!can_accept_essence(essence_type, amount, user))
				return

		if(!altar_storage.add_essence(essence_type, amount))
			to_chat(user, span_warning("The altar cannot store any more essence."))
			return

		to_chat(user, span_info("You pour the [vial.contained_essence.name] into the altar."))
		vial.contained_essence = null
		vial.essence_amount = 0
		vial.update_appearance(UPDATE_OVERLAYS)

		// Update recipe progress if we have a selected recipe
		if(selected_recipe)
			update_recipe_progress()

		update_appearance(UPDATE_OVERLAYS)
		return TRUE

	// Handle placing items for enchantment
	if(!placed_item && !enchanting)
		if(user.transferItemToLoc(I, src))
			placed_item = I
			to_chat(user, span_info("You place [I] on the altar."))
			update_appearance(UPDATE_OVERLAYS)
		return TRUE

	..()

/obj/machinery/essence/enchantment_altar/proc/can_accept_essence(essence_type, amount, mob/user)
	if(!selected_recipe || !selected_recipe.essence_recipe)
		return FALSE  // No recipe selected, accept nothing

	var/list/recipe = selected_recipe.essence_recipe

	if(!(essence_type in recipe))
		to_chat(user, span_warning("The selected recipe '[selected_recipe.enchantment_name]' doesn't require [essence_type]. Clear the recipe selection to add other essences."))
		return FALSE

	var/required = recipe[essence_type]
	var/current = altar_storage.get_essence_amount(essence_type)
	var/remaining_needed = required - current

	if(remaining_needed <= 0)
		to_chat(user, span_warning("The recipe already has enough of this essence type."))
		return FALSE

	if(amount > remaining_needed)
		to_chat(user, span_notice("The recipe only needs [remaining_needed] more units of this essence, but you're adding [amount]. Excess will be stored."))

	return TRUE

/obj/machinery/essence/enchantment_altar/proc/update_recipe_progress()
	if(!selected_recipe || !selected_recipe.essence_recipe)
		return

	recipe_progress.Cut()
	var/list/recipe = selected_recipe.essence_recipe

	for(var/essence_type in recipe)
		var/required = recipe[essence_type]
		var/current = altar_storage.get_essence_amount(essence_type)
		recipe_progress[essence_type] = min(current, required)

/obj/machinery/essence/enchantment_altar/attack_hand(mob/living/user)
	. = ..()

	if(enchanting)
		to_chat(user, span_warning("The altar is currently enchanting an item."))
		return
	show_main_menu(user)

/obj/machinery/essence/enchantment_altar/proc/show_main_menu(mob/user)
	var/list/options = list()

	if(placed_item)
		if(selected_recipe)
			if(recipe_is_complete())
				options["Begin Enchantment"] = "enchant"
			else
				options["Check Recipe Progress"] = "progress"
		else
			options["Select Recipe"] = "select_recipe"
		options["Remove Item"] = "remove_item"
	else
		options["Place an item on the altar first"] = "info"

	if(selected_recipe)
		options["Clear Recipe Selection"] = "clear_recipe"
		options["View Recipe Details"] = "recipe_details"
	else if(!placed_item)
		options["Browse Available Recipes"] = "browse_recipes"

	options["Cancel"] = "cancel"

	var/choice = input(user, "Enchantment Altar Menu:", "Altar Controls") in options
	if(!choice || choice == "cancel")
		return
	choice = options[choice]

	switch(choice)
		if("enchant")
			begin_enchantment(selected_recipe.type, user)
		if("progress")
			show_recipe_progress(user)
		if("select_recipe")
			show_recipe_selection(user)
		if("remove_item")
			remove_placed_item(user)
		if("clear_recipe")
			clear_recipe_selection(user)
		if("recipe_details")
			show_recipe_details(user)
		if("browse_recipes")
			show_recipe_selection(user, TRUE)
		if("info")
			to_chat(user, span_notice("Place an item on the altar to begin enchanting."))

/obj/machinery/essence/enchantment_altar/proc/show_recipe_selection(mob/user, browse_only = FALSE)
	var/list/available_enchantments = get_all_enchantments()

	if(!length(available_enchantments))
		to_chat(user, span_warning("No enchantment recipes are available."))
		return

	var/list/options = list()
	for(var/datum/enchantment/enchantment_path as anything in available_enchantments)
		var/recipe_text = get_recipe_text(enchantment_path)
		options["[initial(enchantment_path.enchantment_name)] - [recipe_text]"] = enchantment_path

	var/choice = browser_input_list(user, browse_only ? "Browse Available Recipes:" : "Select a recipe for [placed_item]:", "Recipe Selection", options)
	if(!choice)
		return

	var/datum/enchantment/enchant = options[choice]

	if(!enchant)
		return

	if(browse_only)
		var/datum/enchantment/temp_enchant = new enchant
		show_single_recipe_details(temp_enchant, user)
		qdel(temp_enchant)
	else
		select_recipe(enchant, user)

/obj/machinery/essence/enchantment_altar/proc/select_recipe(enchantment_path, mob/user)
	if(selected_recipe)
		qdel(selected_recipe)

	selected_recipe = new enchantment_path
	update_recipe_progress()
	update_appearance(UPDATE_OVERLAYS)

	to_chat(user, span_info("Recipe '[selected_recipe.enchantment_name]' selected. The altar will now only accept essences needed for this recipe."))
	show_recipe_details(user)

/obj/machinery/essence/enchantment_altar/proc/clear_recipe_selection(mob/user)
	if(selected_recipe)
		to_chat(user, span_info("Recipe selection cleared. The altar will now accept any essences."))
		qdel(selected_recipe)
		selected_recipe = null
		recipe_progress.Cut()
		update_appearance(UPDATE_OVERLAYS)

/obj/machinery/essence/enchantment_altar/proc/show_recipe_progress(mob/user)
	if(!selected_recipe)
		return

	to_chat(user, span_info("Recipe Progress for '[selected_recipe.enchantment_name]':"))

	var/list/recipe = selected_recipe.essence_recipe
	var/all_complete = TRUE

	for(var/essence_type in recipe)
		var/required = recipe[essence_type]
		var/current = altar_storage.get_essence_amount(essence_type)
		var/have_enough = current >= required

		if(!have_enough)
			all_complete = FALSE

		var/datum/thaumaturgical_essence/essence = new essence_type
		var/status_color = have_enough ? "green" : "red"
		to_chat(user, span_info("- <font color='[status_color]'>[essence.name]: [current]/[required]</font>"))
		qdel(essence)

	if(all_complete)
		to_chat(user, span_info("<font color='green'>Recipe is complete! You can now begin enchantment.</font>"))
	else
		to_chat(user, span_info("<font color='yellow'>Recipe is incomplete. Add more essences to continue.</font>"))

/obj/machinery/essence/enchantment_altar/proc/show_recipe_details(mob/user)
	if(!selected_recipe)
		return

	show_single_recipe_details(selected_recipe, user)

/obj/machinery/essence/enchantment_altar/proc/show_single_recipe_details(datum/enchantment/enchant, mob/user)
	to_chat(user, span_info("=== [enchant.enchantment_name] ==="))
	if(enchant.examine_text)
		to_chat(user, span_info("Description: [enchant.examine_text]"))

	to_chat(user, span_info("Required Essences:"))
	for(var/essence_type in enchant.essence_recipe)
		var/required = enchant.essence_recipe[essence_type]
		var/datum/thaumaturgical_essence/essence = new essence_type
		to_chat(user, span_info("- [essence.name]: [required] units"))
		qdel(essence)

/obj/machinery/essence/enchantment_altar/proc/recipe_is_complete()
	if(!selected_recipe)
		return FALSE

	var/list/recipe = selected_recipe.essence_recipe
	for(var/essence_type in recipe)
		var/required = recipe[essence_type]
		var/current = altar_storage.get_essence_amount(essence_type)
		if(current < required)
			return FALSE

	return TRUE

/obj/machinery/essence/enchantment_altar/proc/get_all_enchantments()
	return subtypesof(/datum/enchantment)

/obj/machinery/essence/enchantment_altar/proc/can_craft_enchantment(enchantment_path)
	var/datum/enchantment/temp_enchant = new enchantment_path
	var/list/recipe = temp_enchant.essence_recipe
	qdel(temp_enchant)

	if(!recipe)
		return FALSE

	for(var/essence_type in recipe)
		var/required = recipe[essence_type]
		var/available = altar_storage.get_essence_amount(essence_type)
		if(available < required)
			return FALSE

	return TRUE

/obj/machinery/essence/enchantment_altar/proc/get_recipe_text(enchantment_path)
	var/datum/enchantment/temp_enchant = new enchantment_path
	var/list/recipe = temp_enchant.essence_recipe
	qdel(temp_enchant)

	if(!recipe)
		return "Unknown Recipe"

	var/list/recipe_parts = list()
	for(var/essence_type in recipe)
		var/datum/thaumaturgical_essence/essence = new essence_type
		recipe_parts += "[recipe[essence_type]] [essence.name]"
		qdel(essence)

	return jointext(recipe_parts, ", ")

/obj/machinery/essence/enchantment_altar/proc/begin_enchantment(enchantment_path, mob/user)
	if(enchanting || !placed_item)
		return

	var/datum/enchantment/temp_enchant = new enchantment_path
	var/list/recipe = temp_enchant.essence_recipe
	var/enchant_name = temp_enchant.enchantment_name
	qdel(temp_enchant)

	if(!recipe || !can_craft_enchantment(enchantment_path))
		to_chat(user, span_warning("You don't have the required essences for this enchantment."))
		return

	// Consume essences
	for(var/essence_type in recipe)
		var/required = recipe[essence_type]
		altar_storage.remove_essence(essence_type, required)

	enchanting = TRUE
	update_appearance(UPDATE_OVERLAYS)

	to_chat(user, span_info("You begin enchanting [placed_item] with [enchant_name]..."))

	create_enchantment_effects()

	addtimer(CALLBACK(src, PROC_REF(complete_enchantment), enchantment_path, user), enchantment_time)

/obj/machinery/essence/enchantment_altar/proc/create_enchantment_effects()
	var/turf/T = get_turf(src)
	if(T)
		for(var/i = 1 to 5)
			var/obj/effect/temp_visual/sparkle/S = new(T)
			S.pixel_x = S.base_pixel_x + rand(-16, 16)
			S.pixel_y = S.base_pixel_y + rand(-8, 24)
		//playsound(T, 'sound/magic/enchant_start.ogg', 50, TRUE)

/obj/machinery/essence/enchantment_altar/proc/complete_enchantment(enchantment_path, mob/user)
	if(!placed_item)
		enchanting = FALSE
		update_appearance(UPDATE_OVERLAYS)
		return

	// Apply enchantment
	placed_item.enchant(enchantment_path)

	var/datum/enchantment/temp_enchant = new enchantment_path
	to_chat(user, span_info("[placed_item] has been successfully enchanted with [temp_enchant.enchantment_name]!"))
	qdel(temp_enchant)

	var/turf/T = get_turf(src)
	if(T)
		for(var/i = 1 to 8)
			var/obj/effect/temp_visual/sparkle/S = new(T)
			S.pixel_x = S.base_pixel_x + rand(-24, 24)
			S.pixel_y = S.base_pixel_y + rand(-12, 32)
		//playsound(T, 'sound/magic/enchant_complete.ogg', 60, TRUE)

	if(selected_recipe)
		qdel(selected_recipe)
		selected_recipe = null
		recipe_progress.Cut()

	if(user && placed_item.loc == src)
		user.put_in_hands(placed_item)
	else
		placed_item.forceMove(T)

	placed_item = null
	enchanting = FALSE
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/essence/enchantment_altar/proc/remove_placed_item(mob/user)
	if(!placed_item)
		return

	if(enchanting)
		to_chat(user, span_warning("You cannot remove the item while it's being enchanted."))
		return

	if(user)
		user.put_in_hands(placed_item)
	else
		placed_item.forceMove(get_turf(src))

	to_chat(user, span_info("You remove [placed_item] from the altar."))
	placed_item = null
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/essence/enchantment_altar/examine(mob/user)
	. = ..()

	if(placed_item)
		. += span_notice("There is [placed_item] placed on the altar.")
	else
		. += span_notice("The altar is empty. Place an item on it to begin enchanting.")

	if(selected_recipe)
		. += span_info("Selected Recipe: [selected_recipe.enchantment_name]")
		var/complete = recipe_is_complete()
		. += span_info("Recipe Status: [complete ? "Complete" : "Incomplete"]")

	if(altar_storage.get_total_stored() > 0)
		. += span_notice("Stored essences ([altar_storage.get_total_stored()]/[altar_storage.max_total_capacity]):")
		for(var/essence_type in altar_storage.stored_essences)
			var/datum/thaumaturgical_essence/essence = new essence_type
			var/amount_text = "[altar_storage.stored_essences[essence_type]] units"
			if(selected_recipe && selected_recipe.essence_recipe && (essence_type in selected_recipe.essence_recipe))
				var/required = selected_recipe.essence_recipe[essence_type]
				var/current = altar_storage.stored_essences[essence_type]
				amount_text += " ([min(current, required)]/[required] for recipe)"

			if(HAS_TRAIT(user, TRAIT_LEGENDARY_ALCHEMIST))
				. += span_notice("Contains [amount_text] units of [essence.name].")
			else
				. += span_notice("Contains [amount_text] units of essence smelling of [essence.smells_like].")

			qdel(essence)
	else
		. += span_notice("No essences are currently stored in the altar.")

	if(enchanting)
		. += span_warning("The altar is currently enchanting an item.")

/obj/effect/temp_visual/sparkle
	icon = 'icons/effects/effects.dmi'
	icon_state = "phasein"
	duration = 2 SECONDS
	randomdir = TRUE

/obj/effect/temp_visual/sparkle/Initialize()
	. = ..()
	animate(src, alpha = 0, time = duration)
