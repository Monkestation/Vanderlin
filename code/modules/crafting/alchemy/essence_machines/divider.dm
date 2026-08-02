/obj/machinery/essence/divider
	name = "essence divider"
	desc = "Splits incoming essence evenly across all connected outputs, skipping any that are full."
	icon = 'icons/roguetown/misc/splitter.dmi'
	icon_state = "divider"
	accepts_input = TRUE
	accepts_output = TRUE
	network_priority = 4

/obj/machinery/essence/divider/Initialize()
	. = ..()
	storage.max_total = 500
	storage.max_types = 15

/obj/machinery/essence/divider/process()
	if(!storage.contents.len)
		return

	var/list/valid_links = list()
	for(var/datum/essence_link/link in links)
		if(!link.active || link.source != src)
			continue
		var/obj/machinery/essence/sink = link.sink
		if(!sink || QDELETED(sink))
			continue
		valid_links += link

	if(!valid_links.len)
		return

	var/list/snapshot = storage.snapshot() // Freeze amounts before any transfers

	for(var/etype in snapshot)
		var/total = snapshot[etype] // Use frozen amount, not live storage
		if(total <= 0)
			continue

		var/list/eligible = list()
		for(var/datum/essence_link/link in valid_links)
			var/obj/machinery/essence/sink = link.sink
			if(sink.accepts_essence(etype) && sink.get_storage().space() > 0)
				eligible += link

		if(!eligible.len)
			continue

		var/share = round(total / eligible.len, 0.1)
		var/remainder = total

		for(var/i = 1; i <= eligible.len; i++)
			var/datum/essence_link/link = eligible[i]
			var/to_send = (i == eligible.len) ? remainder : share
			to_send = min(to_send, link.bandwidth)
			if(to_send <= 0)
				continue

			var/moved = storage.transfer_to(link.sink.get_storage(), etype, to_send)
			if(moved > 0)
				create_essence_flow_effect(link.sink, etype, moved)
				remainder -= moved

	if(network)
		network.invalidate_cache()

/obj/machinery/essence/divider/examine(mob/user)
	. = ..()
	var/output_count = 0
	for(var/datum/essence_link/link in links)
		if(link.active && link.source == src)
			output_count++
	. += span_notice("Splitting across [output_count] active output\s.")

// Accept all essence types as long as there's space
/obj/machinery/essence/divider/build_allowed_types()
	var/room = storage.space()
	if(room <= 0)
		return list()
	return list(/datum/thaumaturgical_essence = room)
