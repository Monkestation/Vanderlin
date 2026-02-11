/obj/machinery/essence/test_tube
	name = "homonculus breeding tube"
	desc = "A large glass tank for creating gnome homunculi."
	icon = 'icons/roguetown/misc/splitter.dmi'
	icon_state = "essence_tank"
	density = TRUE
	anchored = TRUE
	var/datum/essence_storage/storage

	// Filter system
	var/list/allowed_essence_types = list(/datum/thaumaturgical_essence/life)

	var/gnome_progress = 0
	processing_priority = 1

/obj/machinery/essence/test_tube/Initialize()
	. = ..()
	storage = new /datum/essence_storage(src)
	storage.max_total_capacity = 1000
	storage.max_essence_types = 1

/obj/machinery/essence/test_tube/Destroy()
	if(storage)
		qdel(storage)
	return ..()

/obj/machinery/essence/test_tube/update_overlays()
	. = ..()

	if(gnome_progress)
		var/image/gnome_overlay = image('icons/mob/gnome2.dmi', "gnome-tube")
		gnome_overlay.pixel_y = 6
		gnome_overlay.layer = layer - 0.1
		. += gnome_overlay

	var/essence_percent = (storage.get_total_stored()) / (100)
	if(!essence_percent)
		return
	var/level = clamp(CEILING(essence_percent * 4, 1), 1, 4)

	. += mutable_appearance(icon, "tank_[level]", color = calculate_mixture_color())
	. += emissive_appearance(icon, "tank_[level]", alpha = src.alpha)

/obj/machinery/essence/test_tube/return_storage()
	return storage

/obj/machinery/essence/test_tube/process()
	if(!GLOB.thaumic_research?.has_research(/datum/thaumic_research_node/machines/gnomes))
		return
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

/obj/machinery/essence/test_tube/is_essence_allowed(essence_type)
	return (essence_type in allowed_essence_types)

/obj/machinery/essence/test_tube/proc/can_accept_essence(essence_type)
	if(!is_essence_allowed(essence_type))
		return FALSE
	if(storage.get_available_space() <= 0)
		return FALSE
	if(!(essence_type in storage.stored_essences) && storage.stored_essences.len >= storage.max_essence_types)
		return FALSE

	return TRUE

/obj/machinery/essence/test_tube/attack_hand(mob/living/user)
	. = ..()
	if(!GLOB.thaumic_research?.has_research(/datum/thaumic_research_node/machines/gnomes))
		to_chat(user, span_warning("I have no idea how this works."))
		return
	var/essence_amount = 200 * GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/gnome_efficency)
	if(!storage.has_essence(/datum/thaumaturgical_essence/life, essence_amount))
		to_chat(user, span_warning("The tube requires at least [essence_amount] units of life essence to begin the process."))
		return
	if(gnome_progress)
		to_chat(user, span_notice("A gnome is already growing in the tube. Please wait..."))
		return

	to_chat(user, span_info("You activate the breeding process. The life essence begins to swirl and coalesce..."))

	gnome_progress = TRUE
	var/sound_time = 10 SECONDS * GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/gnome_speed)
	var/grow_time = 30 SECONDS * GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/gnome_speed)
	addtimer(CALLBACK(src, PROC_REF(create_gnome), user), grow_time)
	addtimer(CALLBACK(src, PROC_REF(growth_sound_feedback)), sound_time)
	addtimer(CALLBACK(src, PROC_REF(growth_sound_feedback)), sound_time)
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/essence/test_tube/proc/growth_sound_feedback()
	if(gnome_progress)
		visible_message(span_notice("The essence in [src] bubbles and shifts as the homunculus develops."))

/obj/machinery/essence/test_tube/proc/create_gnome(mob/living/user)
	var/essence_amount = 200 * GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/gnome_efficency)
	if(!storage.has_essence(/datum/thaumaturgical_essence/life, essence_amount))
		to_chat(user, span_warning("Insufficient life essence! The process fails..."))
		gnome_progress = FALSE
		update_appearance(UPDATE_OVERLAYS)
		return

	storage.remove_essence(/datum/thaumaturgical_essence/life, essence_amount)
	gnome_progress = FALSE
	update_appearance(UPDATE_OVERLAYS)

	// Success sounds and effects
	visible_message(span_info("The crystalline tube glows brightly as the homunculus reaches maturity!"))

	var/hat_chance = 1 - GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/gnome_hat_chance)
	var/mob/living/simple_animal/hostile/gnome_homunculus/gnome = new(get_turf(src))
	gnome.tamed(user)
	gnome.color = COLOR_PINK

	if(hat_chance)
		gnome.hat()

	animate(gnome, color = COLOR_WHITE, time = 45 SECONDS)

	to_chat(user, span_boldnotice("Your gnome homunculus has been successfully created!"))


/obj/machinery/essence/test_tube/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/essence_vial))
		var/obj/item/essence_vial/vial = I
		if(!vial.contained_essence || vial.essence_amount <= 0)
			if(!length(storage.stored_essences))
				to_chat(user, span_warning("The test tube is empty."))
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
				to_chat(user, span_info("You extract [extracted] units of essence from the test tube."))
			return
		var/essence_type = vial.contained_essence.type
		var/amount = vial.essence_amount
		if(!can_accept_essence(essence_type))
			to_chat(user, span_warning("The test tube cannot accept this essence."))
			return
		if(!storage.add_essence(essence_type, amount))
			to_chat(user, span_warning("The test tube cannot accept this essence."))
			return
		to_chat(user, span_info("You pour the [vial.contained_essence.name] into the test tube."))
		vial.contained_essence = null
		vial.essence_amount = 0
		vial.update_appearance(UPDATE_OVERLAYS)
		return TRUE
	..()

/obj/machinery/essence/test_tube/examine(mob/user)
	. = ..()
	. += span_notice("Capacity: [storage.get_total_stored()]/[storage.max_total_capacity] units")
	. += span_notice("Available space: [storage.get_available_space()] units")

	var/essence_amount = 200 * GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/gnome_efficency)

	if(gnome_progress)
		. += span_boldnotice("A gnome homunculus is currently developing inside the tube.")

	if(storage.has_essence(/datum/thaumaturgical_essence/life, essence_amount))
		. += span_info("The tube contains enough life essence to begin the breeding process.")
	else if(storage.has_essence(/datum/thaumaturgical_essence/life))
		. += span_warning("The tube needs at least [essence_amount] units of life essence to breed a homunculus.")

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
		. += span_notice("The test tube is empty.")


/obj/machinery/essence/test_tube/proc/calculate_mixture_color()
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
