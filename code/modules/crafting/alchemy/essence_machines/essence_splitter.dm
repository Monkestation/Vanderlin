/obj/machinery/essence/splitter
	name = "essence splitter"
	desc = "A rather mundane machine used to extract alchemical essences from natural materials. Can process multiple items at once for efficiency."
	icon = 'icons/roguetown/misc/splitter.dmi'
	icon_state = "splitter"
	density = TRUE
	anchored = TRUE
	var/list/current_items = list()
	var/max_items = 6
	var/datum/essence_storage/storage
	processing_priority = 2

/obj/machinery/essence/splitter/Initialize()
	. = ..()
	storage = new /datum/essence_storage(src)
	storage.max_total_capacity = 500
	storage.max_essence_types = 15

	if(GLOB.thaumic_research.has_research(/datum/thaumic_research_node/splitter_efficiency/five))
		max_items = 8
	else if(GLOB.thaumic_research.has_research(/datum/thaumic_research_node/splitter_efficiency/six))
		max_items = 12

/obj/machinery/essence/splitter/Destroy()
	if(storage)
		qdel(storage)
	return ..()

/obj/machinery/essence/splitter/process()
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

/obj/machinery/essence/splitter/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/essence_connector))
		return

	if(GLOB.thaumic_research.has_research(/datum/thaumic_research_node/splitter_efficiency/five))
		max_items = 8
		storage.max_total_capacity = 800
	else if(GLOB.thaumic_research.has_research(/datum/thaumic_research_node/splitter_efficiency/six))
		max_items = 12
		storage.max_total_capacity = 1200

	if(istype(I, /obj/item/essence_vial))
		var/obj/item/essence_vial/vial = I
		if(vial.contained_essence || vial.essence_amount > 0)
			to_chat(user, span_warning("The vial must be empty to extract essences."))
			return

		if(!length(storage.stored_essences))
			to_chat(user, span_warning("The splitter contains no essences to extract."))
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
			to_chat(user, span_info("You extract [extracted] units of essence into the vial."))
		return

	if(processing)
		to_chat(user, span_warning("The splitter is currently processing."))
		return

	if(current_items.len >= max_items)
		to_chat(user, span_warning("The splitter is full. Maximum [max_items] items can be processed at once."))
		return

	var/datum/natural_precursor/precursor = get_precursor_data(I)
	if(!precursor)
		to_chat(user, span_warning("[I] cannot be processed by the essence splitter."))
		return

	if(!user.transferItemToLoc(I, src))
		to_chat(user, span_warning("[I] is stuck to your hand!"))
		return

	current_items += I
	to_chat(user, span_info("You place [I] into the essence splitter. ([current_items.len]/[max_items] slots used)"))
	return TRUE

/obj/machinery/essence/splitter/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(processing)
		to_chat(user, span_warning("The splitter is currently processing."))
		return

	begin_bulk_splitting(user)

/obj/machinery/essence/splitter/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(processing)
		to_chat(user, span_warning("The splitter is currently processing."))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	remove_all_items(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/essence/splitter/proc/remove_all_items(mob/user)
	for(var/obj/item/I in current_items)
		I.forceMove(get_turf(src))

	to_chat(user, span_info("You remove all items from the splitter."))
	current_items = list()

/obj/machinery/essence/splitter/proc/begin_bulk_splitting(mob/user)
	if(!current_items.len)
		return

	var/total_essence_yield = 0
	var/list/all_precursors = list()

	var/efficiency_bonus = GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/splitter_efficiency)
	for(var/obj/item/I in current_items)
		var/datum/natural_precursor/precursor = get_precursor_data(I)
		if(precursor)
			all_precursors += precursor
			for(var/essence_type in precursor.essence_yields)
				total_essence_yield += round(precursor.essence_yields[essence_type] * efficiency_bonus, 1)

	if(storage.get_available_space() < total_essence_yield)
		to_chat(user, span_warning("The splitter doesn't have enough storage space for this bulk operation."))
		return

	processing = TRUE
	user.visible_message(span_info("[user] activates the essence splitter."))
	update_overlays()

	var/speed_divide = GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/splitter_speed)
	var/process_time = (3 SECONDS + (length(current_items) * 1 SECONDS)) / speed_divide
	addtimer(CALLBACK(src, PROC_REF(finish_bulk_splitting), all_precursors, user), process_time)

/obj/machinery/essence/splitter/proc/finish_bulk_splitting(list/precursors, mob/living/user)
	flick_overlay_view(image(icon, src, "split", ABOVE_MOB_LAYER), 1.2 SECONDS)

	var/efficiency_bonus = GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/splitter_efficiency)
	var/list/total_produced = list()
	for(var/datum/natural_precursor/precursor in precursors)
		for(var/essence_type in precursor.essence_yields)
			var/amount = precursor.essence_yields[essence_type]
			if(storage.add_essence(essence_type, round(amount * efficiency_bonus, 1)))
				if(total_produced[essence_type])
					total_produced[essence_type] += round(amount * efficiency_bonus, 1)
				else
					total_produced[essence_type] = round(amount * efficiency_bonus, 1)

	for(var/obj/item/I in current_items)
		qdel(I)
	current_items = list()
	processing = FALSE

	user.visible_message(span_info("The essence splitter sparks."))

	var/boon = user.get_learning_boon(/datum/skill/craft/alchemy)
	var/amt2raise = (user.STAINT * precursors.len) / 2
	user.adjust_experience(/datum/skill/craft/alchemy, amt2raise * boon, FALSE)

/obj/machinery/essence/splitter/examine(mob/user)
	. = ..()
	. += span_notice("Storage: [storage.get_total_stored()]/[storage.max_total_capacity] units")
	. += span_notice("Processing slots: [current_items.len]/[max_items] used")

	if(output_connections.len > 0)
		. += span_notice("Output connections: [output_connections.len]")

	if(storage.stored_essences.len > 0)
		. += span_notice("Stored essences:")
		for(var/essence_type in storage.stored_essences)
			var/datum/thaumaturgical_essence/essence = new essence_type
			if(HAS_TRAIT(user, TRAIT_LEGENDARY_ALCHEMIST))
				. += span_notice("Contains [storage.stored_essences[essence_type]] units of [essence.name].")
			else
				. += span_notice("Contains [storage.stored_essences[essence_type]] units of essence smelling of [essence.smells_like].")
			qdel(essence)
