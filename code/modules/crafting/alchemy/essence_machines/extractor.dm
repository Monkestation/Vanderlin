/obj/machinery/essence/extractor
	name = "essence extractor"
	desc = "A slow but efficient machine that draws alchemical essences from a material over time, yielding far more than a standard splitter."
	icon = 'icons/roguetown/misc/splitter.dmi'
	icon_state = "extractor"
	accepts_input = FALSE
	accepts_output = TRUE
	network_priority = 3

	var/obj/item/current_item = null
	var/processing = FALSE
	var/list/tick_yields = list()   // essence_type -> amount per tick
	var/ticks_remaining = 0
	var/tick_interval = 3 SECONDS   // 15 ticks * 3s = 45 seconds base

/obj/machinery/essence/extractor/Initialize()
	. = ..()
	storage.max_total = 500
	storage.max_types = 15

/obj/machinery/essence/extractor/Destroy()
	current_item = null
	tick_yields = list()
	return ..()

/obj/machinery/essence/extractor/process()
	push_to_linked(storage)
	if(!processing)
		return

	if(ticks_remaining <= 0)
		finish_extraction()
		return

	// Drip essence each tick
	for(var/essence_type in tick_yields)
		storage.add(essence_type, tick_yields[essence_type])

	ticks_remaining--

	if(network)
		network.invalidate_cache()

/obj/machinery/essence/extractor/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/essence_connector))
		return ..()
	if(istype(I, /obj/item/essence_vial))
		return ..()

	if(processing)
		to_chat(user, span_warning("The extractor is already processing an item."))
		return

	if(current_item)
		to_chat(user, span_warning("The extractor already has an item loaded. Right-click to remove it."))
		return

	var/datum/natural_precursor/precursor = get_precursor_data(I)
	if(!precursor)
		to_chat(user, span_warning("[I] cannot be processed by the essence extractor."))
		return

	if(!user.transferItemToLoc(I, src))
		to_chat(user, span_warning("[I] is stuck to your hand!"))
		return

	current_item = I
	to_chat(user, span_info("You load [I] into the essence extractor."))
	return TRUE

/obj/machinery/essence/extractor/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(processing)
		to_chat(user, span_warning("The extractor is currently processing."))
		return
	if(!current_item)
		to_chat(user, span_warning("There's nothing loaded in the extractor."))
		return
	begin_extraction(user)

/obj/machinery/essence/extractor/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(processing)
		to_chat(user, span_warning("The extractor is currently processing."))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(current_item)
		current_item.forceMove(get_turf(src))
		current_item = null
		to_chat(user, span_info("You remove the item from the extractor."))
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/essence/extractor/proc/begin_extraction(mob/user)
	var/datum/natural_precursor/precursor = get_precursor_data(current_item)
	if(!precursor)
		to_chat(user, span_warning("Something went wrong reading the item's data."))
		return

	var/efficiency_bonus = GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/splitter_efficiency)
	var/speed_bonus     = GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/splitter_speed)

	// 15 base ticks over 45s; speed bonus compresses tick interval, keeping tick count fixed
	var/base_ticks = 15
	tick_interval = (45 SECONDS / base_ticks) / speed_bonus
	ticks_remaining = base_ticks

	// Build per-tick yield: 10x normal yield split evenly across all ticks
	tick_yields = list()
	for(var/essence_type in precursor.essence_yields)
		var/total = precursor.essence_yields[essence_type] * 10 * efficiency_bonus
		tick_yields[essence_type] = round(total / base_ticks, 0.1)

	processing = TRUE
	user.visible_message(span_info("[user] activates the essence extractor."))
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/essence/extractor/proc/finish_extraction()
	processing = FALSE
	tick_yields = list()
	ticks_remaining = 0

	qdel(current_item)
	current_item = null

	if(network)
		network.invalidate_cache()

	visible_message(span_info("The essence extractor hums quietly as it finishes."))
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/essence/extractor/examine(mob/user)
	. = ..()
	if(current_item)
		. += span_notice("Loaded: [current_item]")
		if(processing)
			. += span_notice("Extracting... [ticks_remaining] ticks remaining.")
	else
		. += span_notice("No item loaded.")

/obj/machinery/essence/extractor/build_allowed_types()
	return list()
