
/**
 * Creates a directed link from [source] to [sink] and merges their
 * networks if they were previously separate.
 * Returns the new datum/essence_link or null on failure.
 */
/proc/essence_create_link(obj/machinery/essence/source, obj/machinery/essence/sink)
	if(!source || !sink || source == sink)
		return null
	if(!source.can_link_to(sink))
		return null
	// Prevent duplicate links
	for(var/datum/essence_link/existing in source.links)
		if((existing.source == source && existing.sink == sink) || \
		   (existing.source == sink   && existing.sink == source))
			return null

	var/datum/essence_link/link = new()
	link.source = source
	link.sink = sink

	source.links += link
	sink.links   += link

	// Ensure both machines have a network before merging
	if(!source.network)
		source.network = new /datum/essence_network()
		source.network.add_machine(source)
	if(!sink.network)
		sink.network = new /datum/essence_network()
		sink.network.add_machine(sink)

	if(source.network != sink.network)
		source.network.merge(sink.network)

	source.network.add_link(link)
	source.network.invalidate_cache()

	source.on_link_changed()
	sink.on_link_changed()

	// Visual confirmation
	var/atom/sink_target = sink
	if(istype(sink, /obj/machinery/essence/cauldron_node))
		var/obj/machinery/essence/cauldron_node/proxy = sink
		sink_target = proxy.owner

	var/atom/source_target = source
	if(istype(source, /obj/machinery/essence/cauldron_node))
		var/obj/machinery/essence/cauldron_node/proxy = source
		source_target = proxy.owner

	source_target.Beam(sink_target, "light_beam", time = 1 SECONDS)

	return link

/**
 * Removes a link and re-partitions the cluster in case the removal
 * split it into two separate components.
 */
/proc/essence_remove_link(datum/essence_link/link)
	if(!link)
		return
	var/obj/machinery/essence/source = link.source
	var/obj/machinery/essence/sink = link.sink

	if(source && !QDELETED(source))
		source.links -= link
	if(sink && !QDELETED(sink))
		sink.links -= link

	var/datum/essence_network/old_net = source?.network || sink?.network
	if(old_net)
		old_net.rebuild_after_split()
		if(!old_net.machines.len)
			qdel(old_net)

	qdel(link)

	if(source && !QDELETED(source)) source.on_link_changed()
	if(sink   && !QDELETED(sink))   sink.on_link_changed()

/**
 * Removes all links touching [machine] and cleans up its network membership.
 */
/proc/essence_disconnect_machine(obj/machinery/essence/machine)
	for(var/datum/essence_link/link in machine.links.Copy())
		essence_remove_link(link)
	if(machine.network)
		machine.network.remove_machine(machine)
		if(!machine.network.machines.len)
			qdel(machine.network)
		machine.network = null

/datum/essence_network
	/// All machines in this cluster. assoc: [machine] = TRUE
	var/list/machines = list()
	/// All links whose both endpoints are in this cluster. assoc: [link] = TRUE
	var/list/links = list()
	/// Cached allowed-types per machine. assoc: [machine] = list(etype = max)
	/// Rebuilt lazily whenever cache_dirty = TRUE.
	var/list/allowed_cache = list()
	var/cache_dirty = TRUE

/datum/essence_network/proc/add_machine(obj/machinery/essence/machine)
	if(machine in machines)
		return
	machines[machine] = TRUE
	machine.network = src
	cache_dirty = TRUE

/datum/essence_network/proc/remove_machine(obj/machinery/essence/machine)
	machines -= machine
	allowed_cache -= machine
	if(machine.network == src)
		machine.network = null

/datum/essence_network/proc/add_link(datum/essence_link/link)
	links[link] = TRUE

/datum/essence_network/proc/remove_link(datum/essence_link/link)
	links -= link

/datum/essence_network/proc/get_allowed_types(obj/machinery/essence/machine)
	if(cache_dirty)
		rebuild_cache()
	return allowed_cache[machine] || list()

/datum/essence_network/proc/invalidate_cache()
	cache_dirty = TRUE

/datum/essence_network/proc/rebuild_cache()
	allowed_cache = list()
	for(var/obj/machinery/essence/machine in machines)
		allowed_cache[machine] = machine.build_allowed_types()
	cache_dirty = FALSE

/datum/essence_network/proc/merge(datum/essence_network/other)
	if(!other || other == src)
		return
	for(var/obj/machinery/essence/machine in other.machines)
		add_machine(machine)
	for(var/datum/essence_link/link in other.links)
		links[link] = TRUE
	other.machines = list()
	other.links = list()
	cache_dirty = TRUE

/datum/essence_network/proc/get_demand(list/excluded_types = list())
	var/list/demand = list()
	for(var/obj/machinery/essence/machine in machines)
		var/skip = FALSE
		for(var/excluded in excluded_types)
			if(istype(machine, excluded))
				skip = TRUE
				break
		if(skip)
			continue
		var/list/wanted = machine.build_allowed_types()
		for(var/etype in wanted)
			demand[etype] = (demand[etype] || 0) + wanted[etype]
	return demand

/**
 * Called after a link is removed. Re-floods the graph from every machine
 * that was in this network and assigns new network datums to any components
 * that are no longer reachable from each other.
 *
 * Algorithm: BFS from the first unvisited machine each pass; machines not
 * reachable from the previous seed get their own fresh network datum.
 */
/datum/essence_network/proc/rebuild_after_split()
	var/list/unvisited = machines.Copy()

	//we reassign from scratch to not cause headaches
	for(var/obj/machinery/essence/machine in unvisited)
		machine.network = null
	machines = list()
	links = list()
	allowed_cache = list()

	var/first = TRUE
	while(unvisited.len)
		var/obj/machinery/essence/seed = unvisited[1]
		var/datum/essence_network/net = first ? src : new /datum/essence_network()
		first = FALSE

		var/list/queue = list(seed)
		var/list/visited = list()
		while(queue.len)
			var/obj/machinery/essence/current = queue[1]
			queue.Cut(1, 2)
			if(current in visited)
				continue
			visited[current] = TRUE
			unvisited -= current
			net.add_machine(current)
			for(var/datum/essence_link/link in current.links)
				net.add_link(link)
				var/obj/machinery/essence/neighbor = \
					(link.source == current) ? link.sink : link.source
				if(neighbor && !QDELETED(neighbor) && !(neighbor in visited))
					queue += neighbor

		net.cache_dirty = TRUE

/obj/machinery/essence/proc/create_essence_transfer_effect(obj/machinery/target, essence_type, amount)
	var/turf/source_turf = get_turf(src)
	if(!source_turf)
		return

	var/turf/target_turf = get_turf(target)
	var/distance = get_dist(source_turf, target_turf)
	var/travel_time = max(1 SECONDS, min(3 SECONDS, distance * 0.3 SECONDS))

	new /obj/effect/essence_orb(source_turf, target, essence_type, travel_time)

/*
 * source -> sink is the preferred flow direction (producers link to consumers).
 */

/datum/essence_link
	var/obj/machinery/essence/source
	var/obj/machinery/essence/sink
	/// Max units transferred per process tick in either direction
	var/bandwidth = 20
	var/active = TRUE
	/// ckey of the player who drew this link
	var/creator = ""

/datum/essence_link/Destroy()
	source = null
	sink = null
	return ..()


/datum/essence_storage
	var/list/contents = list()
	var/max_total = 1000
	var/max_types = 10
	var/obj/machinery/essence/owner

/datum/essence_storage/New(atom/O)
	owner = O

/datum/essence_storage/Destroy()
	contents = null
	owner = null
	return ..()

/datum/essence_storage/proc/get(essence_type)
	return contents[essence_type] || 0

/datum/essence_storage/proc/total()
	var/t = 0
	for(var/e in contents)
		t += contents[e]
	return t

/datum/essence_storage/proc/space()
	return max(0, max_total - total())

/datum/essence_storage/proc/has(essence_type, amount = 1)
	return get(essence_type) >= amount

/datum/essence_storage/proc/type_count()
	return contents.len

/datum/essence_storage/proc/add(essence_type, amount)
	if(amount <= 0)
		return 0
	if(!(essence_type in contents) && contents.len >= max_types)
		return 0
	var/room = space()
	if(room <= 0)
		return 0
	var/actual = min(amount, room)
	contents[essence_type] = (contents[essence_type] || 0) + actual
	if(owner)
		owner.on_storage_changed(essence_type, actual, TRUE)
	return actual

/datum/essence_storage/proc/remove(essence_type, amount)
	if(amount <= 0 || !(essence_type in contents))
		return 0
	var/have = contents[essence_type]
	var/actual = min(amount, have)
	contents[essence_type] = have - actual
	if(contents[essence_type] <= 0)
		contents -= essence_type
	if(owner)
		owner.on_storage_changed(essence_type, actual, FALSE)
	return actual

/datum/essence_storage/proc/transfer_to(datum/essence_storage/target, essence_type, amount)
	if(!target)
		return 0
	var/to_move = min(amount, get(essence_type))
	if(to_move <= 0)
		return 0
	var/actually_added = target.add(essence_type, to_move)
	remove(essence_type, actually_added)
	if(actually_added > 0)
		// Re-evaluate both ends of the transfer immediately (doesn't do much unless we add split network)
		if(owner?.network)
			owner.network.invalidate_cache()
		if(target.owner?.network && target.owner.network != owner?.network)
			target.owner.network.invalidate_cache()
	create_essence_transfer_effect(target.owner, essence_type, amount)
	owner.network.rebuild_cache() // this unfortunately needs to be done on transfer solely because of the fact that some things are smart adapaters
	return actually_added

/datum/essence_storage/proc/create_essence_transfer_effect(obj/machinery/target, essence_type, amount)
	var/turf/source_turf = get_turf(owner)
	if(istype(owner, /obj/machinery/essence/cauldron_node))
		var/obj/machinery/essence/cauldron_node/proxy = owner
		source_turf = get_turf(proxy.owner)

	if(!source_turf)
		return

	var/atom/target_proxy = target
	if(istype(target, /obj/machinery/essence/cauldron_node))
		var/obj/machinery/essence/cauldron_node/proxy = target
		target_proxy = proxy.owner

	var/turf/target_turf = get_turf(target_proxy)
	var/distance = get_dist(source_turf, target_turf)
	var/travel_time = max(1 SECONDS, min(3 SECONDS, distance * 0.3 SECONDS))

	new /obj/effect/essence_orb(source_turf, target_turf, essence_type, travel_time)

/datum/essence_storage/proc/clear()
	contents = list()

/datum/essence_storage/proc/snapshot()
	return contents.Copy()
