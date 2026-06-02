/obj/machinery/essence
	density = TRUE
	anchored = TRUE

	/// The cluster this machine belongs to. Null when isolated.
	var/datum/essence_network/network = null
	/// Every link touching this machine (inbound or outbound).
	var/list/links = list()
	/// Primary storage.
	var/datum/essence_storage/storage
	/// SSobj processing priority. Lower = processed earlier in the tick.
	var/network_priority = 5
	/// FALSE = other machines cannot draw an inbound link to this one.
	var/accepts_input = TRUE
	/// FALSE = this machine cannot be the source of an outbound link.
	var/accepts_output = TRUE

/obj/machinery/essence/Initialize()
	. = ..()
	storage = new /datum/essence_storage(src)

/obj/machinery/essence/Destroy()
	essence_disconnect_machine(src)
	if(storage)
		qdel(storage)
		storage = null
	links = list()
	return ..()

/obj/machinery/essence/proc/get_storage()
	RETURN_TYPE(/datum/essence_storage)
	return storage

/**
 * Return assoc list [essence_type = max_ligulae] describing what this machine
 * will accept right now. Used to populate the network's allowed-type cache.
 * Empty list = accept nothing (machine is full, busy, or has no recipe).
 */
/obj/machinery/essence/proc/build_allowed_types()
	var/room = storage.space()
	if(room <= 0)
		return list()
	return list(/datum/thaumaturgical_essence = room)

/**
 * True if this machine will accept [essence_type] right now.
 * Uses the network cache when in a cluster, or calls build_allowed_types()
 * directly when isolated.
 */
/obj/machinery/essence/proc/accepts_essence(essence_type)
	var/list/allowed = network \
		? network.get_allowed_types(src) \
		: build_allowed_types()
	for(var/allowed_type in allowed)
		if(ispath(essence_type, allowed_type))
			return TRUE
	return FALSE

/obj/machinery/essence/proc/on_storage_changed(essence_type, amount, added)
	if(network)
		network.invalidate_cache()
	update_appearance()

/obj/machinery/essence/proc/can_link_to(obj/machinery/essence/target)
	return accepts_output && target.accepts_input

/// Fired after any link touching this machine is added or removed.
/obj/machinery/essence/proc/on_link_changed()
	update_appearance(UPDATE_OVERLAYS)

///like push to link but for specialized types
/obj/machinery/essence/proc/push_surplus_to_linked(datum/essence_storage/from_storage)
	if(!from_storage || !from_storage.contents.len || !links.len)
		return
	var/list/wanted = build_allowed_types()
	for(var/essence_type in from_storage.contents.Copy())
		if(essence_type in wanted)
			continue
		var/amount = from_storage.get(essence_type)
		from_storage.remove(essence_type, amount)
		var/datum/essence_storage/surplus = new(null)
		surplus.max_total = amount
		surplus.max_types = 1
		surplus.add(essence_type, amount)
		for(var/datum/essence_link/link in links)
			if(!link.active || link.source != src)
				continue
			var/obj/machinery/essence/sink = link.sink
			if(!sink || QDELETED(sink))
				continue
			var/datum/essence_storage/sink_store = sink.get_storage()
			if(!sink_store || !sink.accepts_essence(essence_type))
				continue
			var/moved = surplus.transfer_to(sink_store, essence_type, link.bandwidth)
			if(moved > 0)
				create_essence_flow_effect(sink, essence_type, moved)
				break
		if(surplus.contents.len)
			from_storage.add(essence_type, surplus.get(essence_type))
		qdel(surplus)

/**
 * Push essence from [from_storage] out through every outbound link.
 * Sends one essence type per link per tick to avoid flooding.
 */
/obj/machinery/essence/proc/push_to_linked(datum/essence_storage/from_storage)
	if(!from_storage || !from_storage.contents.len)
		return
	for(var/datum/essence_link/link in links)
		if(!link.active || link.source != src)
			continue
		var/obj/machinery/essence/sink = link.sink
		if(!sink || QDELETED(sink))
			continue
		var/datum/essence_storage/sink_store = sink.get_storage()
		if(!sink_store)
			continue
		for(var/etype in from_storage.snapshot())
			if(!sink.accepts_essence(etype))
				continue
			var/deficit = sink.get_allowed_amount(etype)
			if(deficit <= 0)
				continue
			var/moved = from_storage.transfer_to(sink_store, etype, min(link.bandwidth, deficit))
			if(moved > 0)
				create_essence_flow_effect(sink, etype, moved)
				break

/obj/machinery/essence/proc/get_allowed_amount(essence_type)
	var/list/allowed = network \
		? network.get_allowed_types(src) \
		: build_allowed_types()
	for(var/allowed_type in allowed)
		if(ispath(essence_type, allowed_type))
			return allowed[allowed_type]
	return 0

/**
 * Pull essence from every inbound link into [into_storage].
 * Only pulls types this machine currently accepts.
 */
/obj/machinery/essence/proc/pull_from_linked(datum/essence_storage/into_storage)
	for(var/datum/essence_link/link in links)
		if(!link.active || link.sink != src)
			continue
		var/obj/machinery/essence/source = link.source
		if(!source || QDELETED(source))
			continue
		var/datum/essence_storage/src_store = source.get_storage()
		if(!src_store)
			continue
		for(var/etype in src_store.snapshot())
			if(!accepts_essence(etype))
				continue
			var/deficit = get_allowed_amount(etype)
			if(deficit <= 0)
				continue
			var/moved = src_store.transfer_to(into_storage, etype, min(link.bandwidth, deficit))
			if(moved > 0)
				create_essence_flow_effect(source, etype, moved)
				break

/// Spawns a travelling orb effect to visualise essence moving between machines.
/obj/machinery/essence/proc/create_essence_flow_effect(obj/machinery/target, essence_type, amount)
	var/turf/source_turf = get_turf(src)
	if(!source_turf)
		return
	var/distance = get_dist(source_turf, get_turf(target))
	var/travel_time = max(1 SECONDS, min(3 SECONDS, distance * 0.3 SECONDS))
	new /obj/effect/essence_orb(source_turf, target, essence_type, travel_time)

/obj/machinery/essence/get_mechanics_examine(mob/user)
	var/list/lines = list()
	lines += span_notice("Storage: [storage.total()]/[storage.max_total] ligulae \
		([storage.type_count()]/[storage.max_types] types)")

	if(storage.contents.len)
		for(var/etype in storage.contents)
			var/datum/thaumaturgical_essence/e = new etype
			var/label = HAS_TRAIT(user, TRAIT_LEGENDARY_ALCHEMIST) \
				? e.name : "essence smelling of [e.smells_like]"
			lines += span_notice("  - [label]: [storage.contents[etype]] ligulae")
			qdel(e)
	else
		lines += span_notice("  (empty)")

	var/inbound = 0; var/outbound = 0
	for(var/datum/essence_link/link in links)
		if(link.sink == src) inbound++
		if(link.source == src) outbound++
	if(inbound || outbound)
		lines += span_notice("Ethereal links: [inbound] inbound, [outbound] outbound")
	if(network)
		lines += span_notice("Network: [network.machines.len] connected machine(s)")

	return lines

/obj/machinery/essence/attackby_secondary(obj/item/weapon, mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!istype(weapon, /obj/item/essence_connector))
		return
	show_link_menu(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/essence/proc/show_link_menu(mob/user)
	var/list/opts = list()
	var/inbound = 0; var/outbound = 0
	for(var/datum/essence_link/link in links)
		if(link.sink == src) inbound++
		if(link.source == src) outbound++
	if(outbound) opts["View outbound links ([outbound])"] = "out"
	if(inbound)  opts["View inbound links ([inbound])"] = "in"
	if(links.len) opts["Remove all links"]          = "clear"
	if(!opts.len)
		to_chat(user, span_info("[src] has no ethereal links."))
		return
	var/choice = input(user, "Link management", "Essence Links") as null|anything in opts
	if(!choice || (!Adjacent(user) && !istype(src, /obj/machinery/essence/cauldron_node)))
		return
	switch(opts[choice])
		if("out")   show_link_list(user, "outbound", TRUE)
		if("in")    show_link_list(user, "inbound",  FALSE)
		if("clear")
			for(var/datum/essence_link/link in links.Copy())
				essence_remove_link(link)
			to_chat(user, span_info("All links removed from [src]."))

/obj/machinery/essence/proc/show_link_list(mob/user, label, outbound)
	var/list/display = list()
	for(var/datum/essence_link/link in links)
		var/is_out = (link.source == src)
		if(is_out != outbound)
			continue
		var/obj/machinery/essence/other = outbound ? link.sink : link.source
		if(!other || QDELETED(other))
			continue
		display["[other.name] at ([other.x],[other.y])"] = link
	if(!display.len)
		to_chat(user, span_info("No valid [label] links."))
		return
	var/choice = input(user, "Select a [label] link to remove", "Links") \
		as null|anything in display
	if(!choice || !Adjacent(user))
		return
	essence_remove_link(display[choice])
	to_chat(user, span_info("Link removed."))

/obj/machinery/essence/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/essence_connector))
		return ..()
	if(istype(I, /obj/item/essence_vial))
		handle_vial(I, user)
		return
	return ..()

/obj/machinery/essence/proc/handle_vial(obj/item/essence_vial/vial, mob/user)
	if(!vial.contained_essence || vial.essence_amount <= 0)
		extract_to_vial(vial, user)
		return
	var/etype = vial.contained_essence.type
	if(!accepts_essence(etype))
		to_chat(user, span_warning("This machine cannot accept that essence right now."))
		return
	var/moved = storage.add(etype, vial.essence_amount)
	if(moved > 0)
		vial.essence_amount -= moved
		if(vial.essence_amount <= 0)
			vial.contained_essence = null
		vial.update_appearance(UPDATE_OVERLAYS)
		to_chat(user, span_info("You pour [moved] ligulae into [src]."))

/obj/machinery/essence/proc/extract_to_vial(obj/item/essence_vial/vial, mob/user)
	if(!storage.contents.len)
		to_chat(user, span_warning("[src] is empty."))
		return
	var/list/radial = list()
	var/list/emap = list()
	for(var/etype in storage.contents)
		var/datum/thaumaturgical_essence/e = new etype
		var/label = HAS_TRAIT(user, TRAIT_LEGENDARY_ALCHEMIST) \
			? "[e.name] ([storage.contents[etype]] ligulae)" \
			: "Essence of [e.smells_like] ([storage.contents[etype]] ligulae)"
		var/datum/radial_menu_choice/rmc = new()
		var/image/img = image(icon='icons/roguetown/misc/alchemy.dmi', icon_state="essence")
		img.color = e.color
		rmc.image = img
		rmc.name = label
		radial[label] = rmc
		emap[label] = etype
		qdel(e)
	var/choice = show_radial_menu(user, src, radial,
		custom_check = CALLBACK(src, PROC_REF(check_vial_menu_valid), user, vial),
		radial_slice_icon = "radial_thaum")
	if(!choice || !emap[choice])
		return
	var/chosen = emap[choice]
	var/to_take = min(storage.get(chosen), vial.max_essence, vial.extract_amount)
	if(to_take <= 0)
		to_chat(user, span_warning("Cannot extract with current vial settings."))
		return
	var/extracted = storage.remove(chosen, to_take)
	if(extracted > 0)
		vial.contained_essence = new chosen
		vial.essence_amount = extracted
		vial.update_appearance(UPDATE_OVERLAYS)
		to_chat(user, span_info("You extract [extracted] ligulae from [src]."))

/obj/machinery/essence/proc/check_vial_menu_valid(mob/user, obj/item/essence_vial/vial)
	return user && vial && (vial in user.contents) \
		&& (!vial.contained_essence || vial.essence_amount <= 0)

/obj/machinery/essence/reservoir/proc/calculate_mixture_color()
	if(!storage.contents.len)
		return "#4A90E2"

	var/total_weight = 0
	var/r = 0
	var/g = 0
	var/b = 0

	for(var/essence_type in storage.contents)
		var/datum/thaumaturgical_essence/essence = new essence_type
		var/amount = storage.contents[essence_type]
		var/weight = amount * (essence.tier + 1)
		total_weight += weight
		r += hex2num(copytext(essence.color, 2, 4)) * weight
		g += hex2num(copytext(essence.color, 4, 6)) * weight
		b += hex2num(copytext(essence.color, 6, 8)) * weight
		qdel(essence)

	if(!total_weight)
		return "#4A90E2"

	return rgb(FLOOR(r / total_weight, 1), FLOOR(g / total_weight, 1), FLOOR(b / total_weight, 1))

// Called on any essence machine or cauldron when the mouse enters,
// if the user is holding a connector. Draws beams for every link
// touching that machine. Blue = outbound, amber = inbound.

/obj/machinery/essence/proc/show_link_beams()
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
		src.Beam(other_turf, icon_state = "light_beam", time = 1.5 SECONDS, beam_color = beam_color)

/obj/machinery/essence/proc/resolve_beam_turf(obj/machinery/essence/machine)
	if(istype(machine, /obj/machinery/essence/cauldron_node))
		var/obj/machinery/essence/cauldron_node/node = machine
		return node.owner ? get_turf(node.owner) : null
	return get_turf(machine)

/obj/machinery/essence/MouseEntered(location, control, params)
	. = ..()
	var/mob/user = usr
	if(!istype(user))
		return
	if(!istype(user.get_active_held_item(), /obj/item/essence_connector))
		return
	show_link_beams()

// Cauldrons aren't essence machines so they need their own hook,
// proxying through to the hidden node's links.
/obj/machinery/light/fueled/cauldron/MouseEntered(location, control, params)
	. = ..()
	var/mob/user = usr
	if(!istype(user))
		return
	if(!istype(user.get_active_held_item(), /obj/item/essence_connector))
		return
	if(!essence_node || QDELETED(essence_node) || !essence_node.links.len)
		return
	essence_node.show_link_beams()

/obj/effect/temp_visual/sparkle
	icon = 'icons/effects/effects.dmi'
	icon_state = "phasein"
	duration = 2 SECONDS
	randomdir = TRUE

/obj/effect/temp_visual/sparkle/Initialize()
	. = ..()
	animate(src, alpha = 0, time = duration)
