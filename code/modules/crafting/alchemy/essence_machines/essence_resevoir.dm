/obj/machinery/essence/reservoir
	name = "essence reservoir"
	desc = "A large glass sphere for storing massive quantities of alchemical essences."
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "essence_tank"
	density = TRUE
	anchored = TRUE
	var/datum/essence_storage/storage

	var/list/allowed_essence_types = list() // Empty list = allow all types
	var/filter_mode = FALSE // FALSE = allow all, TRUE = whitelist mode

	var/void_mode = FALSE // TRUE = continuously destroy stored essences
	var/void_rate = 10 // Units of essence destroyed per process cycle

	processing_priority = 1

/obj/machinery/essence/reservoir/Initialize()
	. = ..()
	storage = new /datum/essence_storage(src)
	storage.max_total_capacity = 1000
	storage.max_essence_types = 25

/obj/machinery/essence/reservoir/Destroy()
	if(storage)
		qdel(storage)
	return ..()

/obj/machinery/essence/reservoir/update_overlays()
	. = ..()

	var/essence_percent = (storage.get_total_stored()) / (storage.max_total_capacity)
	if(!essence_percent)
		return
	var/level = clamp(CEILING(essence_percent * 5, 1), 1, 5)

	. += mutable_appearance(icon, "liquid_[level]", color = calculate_mixture_color())
	. += emissive_appearance(icon, "liquid_[level]", alpha = src.alpha)

/obj/machinery/essence/reservoir/return_storage()
	return storage

/obj/machinery/essence/reservoir/process()
	// Handle void mode processing
	if(void_mode && GLOB.thaumic_research?.has_research(/datum/thaumic_research_node/resevoir_decay))
		if(storage.get_total_stored() > 0)
			var/total_voided = 0
			var/remaining_void_capacity = void_rate

			// Void essences randomly to make it feel more chaotic
			var/list/essence_types_to_void = storage.stored_essences.Copy()
			while(remaining_void_capacity > 0 && length(essence_types_to_void))
				var/essence_type = pick(essence_types_to_void)
				var/available = storage.get_essence_amount(essence_type)
				if(available <= 0)
					essence_types_to_void -= essence_type
					continue

				var/to_void = min(available, remaining_void_capacity, rand(1, 5)) // Random amount 1-5
				var/voided = storage.remove_essence(essence_type, to_void)
				total_voided += voided
				remaining_void_capacity -= voided

				if(storage.get_essence_amount(essence_type) <= 0)
					essence_types_to_void -= essence_type

			if(total_voided > 0)
				update_appearance(UPDATE_OVERLAYS)
				// Create void effect
				var/datum/effect_system/spark_spread/quantum/void_effect = new
				void_effect.set_up(3, 0, src)
				void_effect.start()

	// Handle normal connection processing
	if(!connection_processing || !output_connections.len)
		return
	var/list/prioritized_connections = sort_connections_by_priority(output_connections)
	for(var/datum/essence_connection/connection in prioritized_connections)
		if(!connection.active || !connection.target)
			continue
		var/datum/essence_storage/target_storage = get_target_storage(connection.target)
		if(!target_storage)
			continue
		var/essence_transferred = FALSE
		for(var/essence_type in storage.stored_essences)
			var/available = storage.get_essence_amount(essence_type)
			if(available > 0)
				if(!can_target_accept_essence(connection.target, essence_type))
					continue

				var/to_transfer = min(available, connection.transfer_rate)
				var/transferred = storage.transfer_to(target_storage, essence_type, to_transfer)
				if(transferred > 0)
					create_essence_transfer_effect(connection.target, essence_type, transferred)
					essence_transferred = TRUE
					break // Only transfer one type per cycle per connection

		if(essence_transferred)
			continue

/obj/machinery/essence/reservoir/is_essence_allowed(essence_type)
	if(!filter_mode)
		return TRUE // No filtering active

	if(!length(allowed_essence_types))
		return TRUE // Empty whitelist = accept all

	return (essence_type in allowed_essence_types)

/obj/machinery/essence/reservoir/proc/can_accept_essence(essence_type)
	if(!is_essence_allowed(essence_type))
		return FALSE

	if(storage.get_available_space() <= 0)
		return FALSE

	if(!(essence_type in storage.stored_essences) && storage.stored_essences.len >= storage.max_essence_types)
		return FALSE

	return TRUE

/obj/machinery/essence/reservoir/proc/toggle_filter_mode(mob/user)
	filter_mode = !filter_mode
	if(filter_mode)
		to_chat(user, span_info("Filter mode enabled. Only allowed essence types will be accepted."))
	else
		to_chat(user, span_info("Filter mode disabled. All essence types will be accepted."))

/obj/machinery/essence/reservoir/proc/add_essence_filter(essence_type, mob/user)
	if(essence_type in allowed_essence_types)
		to_chat(user, span_warning("This essence type is already in the filter list."))
		return FALSE

	allowed_essence_types += essence_type
	var/datum/thaumaturgical_essence/essence = new essence_type
	to_chat(user, span_info("[essence.name] added to allowed essence types."))
	qdel(essence)
	return TRUE

/obj/machinery/essence/reservoir/proc/remove_essence_filter(essence_type, mob/user)
	if(!(essence_type in allowed_essence_types))
		to_chat(user, span_warning("This essence type is not in the filter list."))
		return FALSE

	allowed_essence_types -= essence_type
	var/datum/thaumaturgical_essence/essence = new essence_type
	to_chat(user, span_info("[essence.name] removed from allowed essence types."))
	qdel(essence)
	return TRUE

/obj/machinery/essence/reservoir/proc/show_filter_menu(mob/user)
	var/list/options = list()
	options["Toggle Filter Mode ([filter_mode ? "ON" : "OFF"])"] = "toggle_filter"

	if(GLOB.thaumic_research?.has_research(/datum/thaumic_research_node/resevoir_decay))
		options["Toggle Void Mode ([void_mode ? "ON" : "OFF"])"] = "toggle_void"
		if(void_mode)
			options["Adjust Void Rate ([void_rate]/cycle)"] = "adjust_void"

	options["Add Essence Type to Filter"] = "add"

	if(allowed_essence_types.len > 0)
		options["Remove Essence Type from Filter"] = "remove"
		options["Clear All Filters"] = "clear"

	options["View Current Filters"] = "view"
	options["Cancel"] = "cancel"

	var/choice = input(user, "Essence Filter Configuration", "Filter Menu") in options
	if(!choice || choice == "cancel")
		return

	switch(options[choice])
		if("toggle_filter")
			toggle_filter_mode(user)

		if("toggle_void")
			toggle_void_mode(user)

		if("adjust_void")
			adjust_void_rate(user)

		if("add")
			var/list/available_types = list()
			for(var/essence_type in storage.stored_essences)
				var/datum/thaumaturgical_essence/essence = new essence_type
				available_types["[essence.name]"] = essence_type
				qdel(essence)
			var/list/common_essences = list(
				/datum/thaumaturgical_essence/fire,
				/datum/thaumaturgical_essence/water,
				/datum/thaumaturgical_essence/earth,
				/datum/thaumaturgical_essence/air,
				/datum/thaumaturgical_essence/life,
			)

			for(var/essence_type in common_essences)
				var/datum/thaumaturgical_essence/essence = new essence_type
				if(!(essence.name in available_types))
					available_types["[essence.name]"] = essence_type
				qdel(essence)

			if(!length(available_types))
				to_chat(user, span_warning("No essence types available to add to filter."))
				return

			var/selected = input(user, "Select essence type to add to filter:", "Add Filter") in available_types
			if(selected)
				add_essence_filter(available_types[selected], user)

		if("remove")
			var/list/filter_options = list()
			for(var/essence_type in allowed_essence_types)
				var/datum/thaumaturgical_essence/essence = new essence_type
				filter_options["[essence.name]"] = essence_type
				qdel(essence)

			var/selected = input(user, "Select essence type to remove from filter:", "Remove Filter") in filter_options
			if(selected)
				remove_essence_filter(filter_options[selected], user)

		if("clear")
			allowed_essence_types.Cut()
			to_chat(user, span_info("All essence filters cleared."))

		if("view")
			if(!length(allowed_essence_types))
				to_chat(user, span_info("No essence filters configured."))
			else
				to_chat(user, span_info("Allowed essence types:"))
				for(var/essence_type in allowed_essence_types)
					var/datum/thaumaturgical_essence/essence = new essence_type
					to_chat(user, span_info("- [essence.name]"))
					qdel(essence)

/obj/machinery/essence/reservoir/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/essence_vial))
		var/obj/item/essence_vial/vial = I
		if(!vial.contained_essence || vial.essence_amount <= 0)
			if(!length(storage.stored_essences))
				to_chat(user, span_warning("The reservoir is empty."))
				return
			// Create radial menu for essence selection
			var/list/radial_options = list()
			var/list/essence_mapping = list()
			for(var/essence_type in storage.stored_essences)
				var/datum/thaumaturgical_essence/essence = new essence_type
				var/display_name
				if(HAS_TRAIT(user, TRAIT_LEGENDARY_ALCHEMIST))
					display_name = essence.name
				else
					display_name = "Essence smelling of [essence.smells_like]"
				var/option_key = "[display_name] ([storage.stored_essences[essence_type]] units)"
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
			var/max_extract = min(storage.get_essence_amount(essence_type), vial.max_essence)
			var/amount_to_extract = min(max_extract, vial.extract_amount)
			if(amount_to_extract <= 0)
				to_chat(user, span_warning("Cannot extract any essence with current vial settings."))
				return
			var/extracted = storage.remove_essence(essence_type, amount_to_extract)
			if(extracted > 0)
				vial.contained_essence = new essence_type
				vial.essence_amount = extracted
				vial.update_appearance(UPDATE_OVERLAYS)
				to_chat(user, span_info("You extract [extracted] units of essence from the reservoir."))
			return
		var/essence_type = vial.contained_essence.type
		var/amount = vial.essence_amount
		if(!can_accept_essence(essence_type))
			if(filter_mode)
				to_chat(user, span_warning("This reservoir's filter does not allow [vial.contained_essence.name]."))
			else
				to_chat(user, span_warning("The reservoir cannot accept this essence (capacity or type limit reached)."))
			return
		if(!storage.add_essence(essence_type, amount))
			to_chat(user, span_warning("The reservoir cannot accept this essence (capacity or type limit reached)."))
			return
		to_chat(user, span_info("You pour the [vial.contained_essence.name] into the reservoir."))
		vial.contained_essence = null
		vial.essence_amount = 0
		vial.update_appearance(UPDATE_OVERLAYS)
		return TRUE
	..()

/obj/machinery/essence/reservoir/attack_hand(mob/living/user)
	. = ..()
	show_filter_menu(user)

/obj/machinery/essence/reservoir/examine(mob/user)
	. = ..()
	. += span_notice("Capacity: [storage.get_total_stored()]/[storage.max_total_capacity] units")
	. += span_notice("Available space: [storage.get_available_space()] units")

	if(filter_mode)
		. += span_notice("Filter Mode: ACTIVE")
		if(allowed_essence_types.len > 0)
			. += span_notice("Allowed essence types: [allowed_essence_types.len]")
		else
			. += span_notice("Filter list is empty (accepting all types)")
	else
		. += span_notice("Filter Mode: DISABLED")

	if(storage.stored_essences.len > 0)
		. += span_notice("Stored essences:")
		for(var/essence_type in storage.stored_essences)
			var/datum/thaumaturgical_essence/essence = new essence_type
			if(HAS_TRAIT(user, TRAIT_LEGENDARY_ALCHEMIST))
				. += span_notice("Contains [storage.stored_essences[essence_type]] units of [essence.name].")
			else
				. += span_notice("Contains [storage.stored_essences[essence_type]] units of essence smelling of [essence.smells_like].")
			qdel(essence)
	else
		. += span_notice("The reservoir is empty.")


/obj/machinery/essence/reservoir/proc/toggle_void_mode(mob/user)
	if(!GLOB.thaumic_research || !GLOB.thaumic_research.has_research(/datum/thaumic_research_node/resevoir_decay))
		to_chat(user, span_warning("You lack the knowledge to operate this reservoir in void mode."))
		return FALSE

	void_mode = !void_mode
	if(void_mode)
		to_chat(user, span_warning("Void mode enabled. This reservoir will continuously destroy stored essences!"))
		to_chat(user, span_danger("Warning: Essences will be permanently lost at a rate of [void_rate] units per cycle."))
	else
		to_chat(user, span_info("Void mode disabled. Normal operation resumed."))

	update_appearance(UPDATE_OVERLAYS)
	return TRUE

/obj/machinery/essence/reservoir/proc/adjust_void_rate(mob/user)
	if(!void_mode)
		to_chat(user, span_warning("Void mode must be enabled to adjust void rate."))
		return

	var/new_rate = input(user, "Set void rate (units destroyed per cycle):", "Void Rate", void_rate) as num|null
	if(isnull(new_rate))
		return

	new_rate = clamp(new_rate, 1, 50)
	void_rate = new_rate
	to_chat(user, span_info("Void rate set to [void_rate] units per cycle."))

/obj/machinery/essence/reservoir/proc/calculate_mixture_color()
	var/list/essence_contents = list()

	essence_contents |= storage.stored_essences

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


/obj/machinery/essence/reservoir/filled
	var/list/essence_list = list()

/obj/machinery/essence/reservoir/filled/Initialize()
	. = ..()
	for(var/datum/thaumaturgical_essence/essence as anything in essence_list)
		storage.add_essence(essence, essence_list[essence])

/obj/machinery/essence/reservoir/filled/life
	essence_list = list(/datum/thaumaturgical_essence/life = 1000)

