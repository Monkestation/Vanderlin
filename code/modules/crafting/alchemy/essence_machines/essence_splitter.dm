/obj/machinery/essence/splitter
	name = "essence splitter"
	desc = "A rather mundane machine used to extract alchemical essences from natural materials. Can process multiple items at once for efficiency."
	icon = 'icons/roguetown/misc/splitter.dmi'
	icon_state = "splitter"
	accepts_input = FALSE  // Splitters don't receive essence from the network; they produce it
	accepts_output = TRUE
	network_priority = 3   // Process before most consumers

	var/list/current_items = list()
	var/max_items = 6
	var/processing = FALSE

/obj/machinery/essence/splitter/Initialize()
	. = ..()
	storage.max_total = 5000 //okay
	storage.max_types = 15

	if(GLOB.thaumic_research.has_research(/datum/thaumic_research_node/splitter_efficiency/five))
		max_items = 8
	else if(GLOB.thaumic_research.has_research(/datum/thaumic_research_node/splitter_efficiency/six))
		max_items = 12

/obj/machinery/essence/splitter/Destroy()
	// Storage and network cleanup handled by parent
	current_items = list()
	return ..()

// The splitter produces essence; it should push outward each tick rather than pull.
/obj/machinery/essence/splitter/process()
	if(!processing)
		push_to_linked(storage)

/obj/machinery/essence/splitter/attackby(obj/item/I, mob/user, list/modifiers)
	// Let the parent handle essence_connector and essence_vial interactions first
	if(istype(I, /obj/item/essence_connector))
		return ..()

	if(istype(I, /obj/item/essence_vial))
		return ..()  // Parent's handle_vial covers both fill and extract

	// Research bonuses are re-evaluated on each interaction
	if(GLOB.thaumic_research.has_research(/datum/thaumic_research_node/splitter_efficiency/five))
		max_items = 8
		storage.max_total = 8000
	else if(GLOB.thaumic_research.has_research(/datum/thaumic_research_node/splitter_efficiency/six))
		max_items = 12
		storage.max_total = 12000

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

	if(storage.space() < total_essence_yield)
		to_chat(user, span_warning("The splitter doesn't have enough storage space for this bulk operation."))
		return

	processing = TRUE
	user.visible_message(span_info("[user] activates the essence splitter."))
	update_appearance(UPDATE_OVERLAYS)

	var/speed_divide = GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/splitter_speed)
	var/process_time = (3 SECONDS + (length(current_items) * 1 SECONDS)) / speed_divide
	addtimer(CALLBACK(src, PROC_REF(finish_bulk_splitting), all_precursors, user), process_time)

/obj/machinery/essence/splitter/proc/finish_bulk_splitting(list/precursors, mob/living/user)
	flick_overlay_view(mutable_appearance(icon, "split", ABOVE_MOB_LAYER), 1.2 SECONDS)

	var/efficiency_bonus = GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/splitter_efficiency)
	for(var/datum/natural_precursor/precursor in precursors)
		for(var/essence_type in precursor.essence_yields)
			var/amount = round(precursor.essence_yields[essence_type] * efficiency_bonus, 1)
			storage.add(essence_type, amount)

	for(var/obj/item/I in current_items)
		qdel(I)
	current_items = list()
	processing = FALSE

	// Invalidate the network cache now that our storage contents changed
	if(network)
		network.invalidate_cache()

	user.visible_message(span_info("The essence splitter sparks."))

	var/boon = user.get_learning_boon(/datum/attribute/skill/craft/alchemy)
	var/amt2raise = (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE) * precursors.len) / 2
	user.adjust_experience(/datum/attribute/skill/craft/alchemy, amt2raise * boon, FALSE)

/obj/machinery/essence/splitter/examine(mob/user)
	. = ..()
	. += span_notice("Processing slots: [current_items.len]/[max_items] used")

// Splitters don't accept incoming essence from the network; they only push out.
/obj/machinery/essence/splitter/build_allowed_types()
	return list()
