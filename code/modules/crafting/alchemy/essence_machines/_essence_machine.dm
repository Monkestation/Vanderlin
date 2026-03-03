/atom/proc/on_transfer_in(essence_type, amount, datum/essence_storage/source)

/obj/machinery/essence
	var/processing = FALSE
	var/datum/essence_storage/input_storage
	var/datum/essence_storage/output_storage
	var/list/output_connections = list()
	var/list/input_connections = list()
	var/connection_processing = FALSE
	var/processing_priority

/obj/machinery/essence/Destroy()
	clear_all_connections()
	if(input_storage)
		qdel(input_storage)
	if(output_storage)
		qdel(output_storage)
	return ..()

/obj/machinery/essence/proc/check_menu_validity(mob/user, obj/item/essence_vial/vial)
	return user && vial && (vial in user.contents) && !vial.contained_essence && vial.essence_amount <= 0

/obj/machinery/essence/proc/is_essence_allowed(essence_type)
	return TRUE

/obj/machinery/essence/proc/can_target_accept_essence(obj/machinery/essence/target, essence_type)
	return target.is_essence_allowed(essence_type)

/obj/machinery/essence/proc/create_essence_transfer_effect(obj/machinery/target, essence_type, amount)
	var/turf/source_turf = get_turf(src)
	if(!source_turf)
		return

	var/turf/target_turf = get_turf(target)
	var/distance = get_dist(source_turf, target_turf)
	var/travel_time = max(1 SECONDS, min(3 SECONDS, distance * 0.3 SECONDS))

	new /obj/effect/essence_orb(source_turf, target, essence_type, travel_time)

	//playsound(src, 'sound/misc/essence_transfer.ogg', 25, TRUE)

/obj/machinery/essence/proc/get_target_storage(obj/machinery/essence/target)
	if(!istype(target))
		return null
	return target?.return_storage()

/obj/machinery/essence/proc/return_storage()
	return input_storage

/obj/machinery/essence/proc/sort_connections_by_priority(list/connections)
	var/list/prioritized = list()
	var/list/reservoirs = list()
	var/list/splitters = list()
	var/list/combiners = list()
	var/list/others = list()

	for(var/datum/essence_connection/connection in connections)
		if(!connection.target)
			continue

		if(istype(connection.target, /obj/machinery/essence/reservoir))
			reservoirs += connection
		else if(istype(connection.target, /obj/machinery/essence/splitter))
			splitters += connection
		else if(istype(connection.target, /obj/machinery/essence/combiner))
			combiners += connection
		else
			others += connection

	prioritized += reservoirs
	prioritized += splitters
	prioritized += combiners
	prioritized += others

	return prioritized

/obj/machinery/essence/attackby_secondary(obj/item/weapon, mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!istype(weapon, /obj/item/essence_connector))
		return
	if(length(output_connections) || length(input_connections))
		show_connection_menu(user)

	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/essence/proc/show_connection_menu(mob/user)
	var/list/options = list()

	if(length(output_connections))
		options["View Outputs"] = "outputs"
	if(length(input_connections))
		options["View Inputs"] = "inputs"
	if(length(output_connections) || length(input_connections))
		options["Clear All Connections"] = "clear_all"

	if(!length(options))
		to_chat(user, span_info("[src] has no connections."))
		return

	var/choice = input(user, "Connection Management", "Choose action") as null|anything in options
	if(!choice || !Adjacent(user))
		return

	switch(options[choice])
		if("outputs")
			show_connections_list(user, output_connections, "Output")
		if("inputs")
			show_connections_list(user, input_connections, "Input")
		if("clear_all")
			clear_all_connections()
			to_chat(user, span_info("All connections cleared from [src]."))

/obj/machinery/essence/proc/show_connections_list(mob/user, list/connections, type_name)
	var/list/conn_list = list()
	for(var/datum/essence_connection/conn in connections)
		var/obj/machinery/other = (conn.source == src) ? conn.target : conn.source
		if(!other || QDELETED(other))
			continue
		conn_list["[other.name] ([other.x],[other.y])"] = conn

	if(!length(conn_list))
		to_chat(user, span_info("No valid [type_name] connections."))
		return

	var/choice = input(user, "[type_name] Connections", "Select connection to remove") as null|anything in conn_list
	if(!choice || !Adjacent(user))
		return

	var/datum/essence_connection/conn = conn_list[choice]
	remove_connection(conn)
	to_chat(user, span_info("Connection removed."))

/obj/machinery/essence/proc/can_connect_to(obj/machinery/essence/target)
	// Override in subtypes for specific connection rules
	return TRUE

/obj/machinery/essence/proc/is_connected_to(obj/machinery/essence/target)
	for(var/datum/essence_connection/conn in output_connections)
		if(conn.target == target)
			return TRUE
	return FALSE

/obj/machinery/essence/proc/create_connection(obj/machinery/essence/target, mob/user)
	var/datum/essence_connection/connection = new()
	connection.source = src
	connection.target = target
	connection.established_by = user?.ckey

	output_connections += connection
	target.input_connections += connection

	Beam(target, "light_beam", time = 1 SECONDS)

	if(!connection_processing)
		connection_processing = TRUE
		START_PROCESSING(SSobj, src)

	return connection

/obj/machinery/essence/proc/remove_connection(datum/essence_connection/connection)
	if(!connection)
		return

	output_connections -= connection
	input_connections -= connection

	if(connection.source && connection.source != src)
		connection.source.output_connections -= connection
	if(connection.target && connection.target != src)
		connection.target.input_connections -= connection

	qdel(connection)

	// Stop processing if no more connections
	if(!length(output_connections) && connection_processing)
		connection_processing = FALSE
		STOP_PROCESSING(SSobj, src)

/obj/machinery/essence/proc/clear_all_connections()
	var/list/all_connections = output_connections + input_connections
	for(var/datum/essence_connection/conn in all_connections)
		remove_connection(conn)

/obj/machinery/essence/proc/cleanup_broken_connections()
	// Clean up connections to deleted objects
	for(var/datum/essence_connection/conn in output_connections.Copy())
		if(!conn.target || QDELETED(conn.target))
			remove_connection(conn)

	for(var/datum/essence_connection/conn in input_connections.Copy())
		if(!conn.source || QDELETED(conn.source))
			remove_connection(conn)
