/datum/rotation_network
	var/total_stress = 0
	var/used_stress = 0
	var/overstressed = FALSE
	var/list/obj/structure/connected = list()
	var/list/datum/rotation_segment/segments = list()

/datum/rotation_network/proc/add_connection(obj/structure/incoming)
	connected |= incoming
	incoming.rotation_network = src
	incoming.update_animation_effect()

/datum/rotation_network/proc/remove_connection(obj/structure/outgoing)
	if(outgoing.last_stress_generation)
		total_stress -= outgoing.last_stress_generation
	if(!outgoing.stress_generator)
		outgoing.rotation_direction = null
		outgoing.set_rotations_per_minute(0)
	if(outgoing.last_stress_added)
		used_stress -= outgoing.last_stress_added
		outgoing.last_stress_added = 0
	outgoing.rotation_network = null
	connected -= outgoing
	outgoing.update_animation_effect()

/datum/rotation_network/proc/check_stress()
	if(total_stress > 0 && total_stress < used_stress)
		breakdown()
	else if(overstressed)
		restore()

/datum/rotation_network/proc/breakdown()
	overstressed = TRUE
	for(var/obj/structure/child as anything in connected)
		if(QDELETED(child))
			continue
		child.add_shared_particles(/particles/sparks, time = 1 SECONDS)
	update_animation_effect()

/datum/rotation_network/proc/restore()
	overstressed = FALSE
	update_animation_effect()

/datum/rotation_network/proc/update_animation_effect()
	for(var/obj/structure/child in connected)
		child.update_animation_effect()

/datum/rotation_network/proc/build_segments()
	// Clear existing segments
	for(var/datum/rotation_segment/seg in segments)
		qdel(seg)
	segments = list()

	var/list/assigned = list() // node -> segment

	for(var/obj/structure/node in connected)
		if(assigned[node])
			continue

		// BFS to find all shaft-connected nodes with same rpm/dir
		var/datum/rotation_segment/seg = new()
		seg.network = src
		segments += seg

		var/list/to_visit = list(node)
		assigned[node] = seg

		while(length(to_visit))
			var/obj/structure/current = to_visit[1]
			to_visit.Cut(1, 2)
			seg.members += current
			current.segment = seg

			for(var/direction in GLOB.cardinals_multiz)
				var/edge_dir = direction
				if(!(edge_dir & current.dpdir))
					continue
				var/turf/T = get_step_multiz(current, direction)
				if(!T)
					continue
				for(var/obj/structure/neighbor in T.contents)
					if(assigned[neighbor])
						continue
					if(!(neighbor in connected))
						continue
					if(!(REVERSE_DIR(direction) & neighbor.dpdir))
						continue
					// Same segment if same rpm and direction (shaft connection)
					assigned[neighbor] = seg
					to_visit += neighbor

	// Now find segment boundary connections (cog sideways)
	for(var/datum/rotation_segment/seg in segments)
		for(var/obj/structure/node in seg.members)
			if(!istype(node, /obj/structure/rotation_piece/cog) && !istype(node, /obj/structure/water_pump))
				continue
			for(var/direction in GLOB.cardinals)
				if(direction & node.dpdir)
					continue // shaft direction, not a cog sideways connection
				var/turf/T = get_step(node, direction)
				if(!T)
					continue
				for(var/obj/structure/neighbor in T.contents)
					if(!(neighbor in connected))
						continue
					if(!istype(neighbor, /obj/structure/rotation_piece/cog) && !istype(neighbor, /obj/structure/water_pump))
						continue
					if(neighbor.dir != node.dir && neighbor.dir != REVERSE_DIR(node.dir))
						continue
					var/datum/rotation_segment/neighbor_seg = assigned[neighbor]
					if(!neighbor_seg || neighbor_seg == seg)
						continue
					// Check not already connected
					var/already_connected = FALSE
					for(var/datum/segment_connection/conn in seg.connections)
						if(conn.other == neighbor_seg)
							already_connected = TRUE
							break
					if(already_connected)
						continue
					var/datum/segment_connection/conn = new()
					conn.our_node = node
					conn.their_node = neighbor
					conn.other = neighbor_seg
					conn.flips_direction = TRUE
					if(istype(node, /obj/structure/rotation_piece/cog))
						var/obj/structure/rotation_piece/cog/cog = node
						conn.speed_ratio = istype(neighbor, /obj/structure/rotation_piece/cog) ? (cog.cog_size / neighbor.cog_size) : 1
					else
						conn.speed_ratio = 1
					seg.connections += conn

					var/datum/segment_connection/reverse_conn = new()
					reverse_conn.our_node = neighbor
					reverse_conn.their_node = node
					reverse_conn.other = seg
					reverse_conn.flips_direction = TRUE
					if(istype(neighbor, /obj/structure/rotation_piece/cog))
						var/obj/structure/rotation_piece/cog/cog = neighbor
						reverse_conn.speed_ratio = istype(node, /obj/structure/rotation_piece/cog) ? (cog.cog_size / node.cog_size) : 1
					else
						reverse_conn.speed_ratio = 1
					neighbor_seg.connections += reverse_conn

/datum/rotation_network/proc/propagate_from_generators()
	// Find all generator segments and BFS through segment graph
	var/list/datum/rotation_segment/visited_segs = list()
	var/list/datum/rotation_segment/to_visit = list()

	for(var/datum/rotation_segment/seg in segments)
		for(var/obj/structure/node in seg.members)
			if(!node.stress_generator)
				continue
			if(visited_segs[seg])
				continue
			visited_segs[seg] = TRUE
			seg.rotation_direction = node.rotation_direction
			seg.rotations_per_minute = node.rotations_per_minute
			to_visit += seg
			break

	while(length(to_visit))
		var/datum/rotation_segment/current_seg = to_visit[1]
		to_visit.Cut(1, 2)

		// Apply rpm/dir to all members
		for(var/obj/structure/node in current_seg.members)
			node.rotation_direction = current_seg.rotation_direction
			if(!node.stress_generator)
				node.set_rotations_per_minute(current_seg.rotations_per_minute)

		// Propagate to connected segments
		for(var/datum/segment_connection/conn in current_seg.connections)
			if(visited_segs[conn.other])
				continue
			var/obj/structure/neighbor_seg = conn.other
			neighbor_seg.rotation_direction = conn.flips_direction ? REVERSE_DIR(current_seg.rotation_direction) : current_seg.rotation_direction
			neighbor_seg.rotations_per_minute = current_seg.rotations_per_minute * conn.speed_ratio
			visited_segs[neighbor_seg] = TRUE
			to_visit += neighbor_seg

/datum/rotation_network/proc/rebuild_group()
	// Reset all non-generators
	for(var/obj/structure/child in connected)
		if(!child.stress_generator)
			child.rotation_direction = null
			child.set_rotations_per_minute(0)
			var/old_stress_use = child.stress_use
			child.set_stress_use(0, check_network = FALSE)
			child.set_stress_use(old_stress_use, check_network = FALSE)

	build_segments()
	propagate_from_generators()
	check_stress()
	update_animation_effect()

/datum/rotation_network/proc/reassess_group(obj/structure/deleted)
	connected -= deleted
	if(!length(connected))
		qdel(src)
		return

	// BFS to find all nodes still reachable from any remaining node
	// using both shaft and cog connections
	var/obj/structure/start = connected[1]
	var/list/reachable = list()
	reachable[start] = TRUE
	var/list/to_visit = list(start)

	while(length(to_visit))
		var/obj/structure/current = to_visit[1]
		to_visit.Cut(1, 2)

		// Shaft connections
		for(var/direction in GLOB.cardinals_multiz)
			var/turf/T = get_step_multiz(current, direction)
			if(!T)
				continue
			for(var/obj/structure/neighbor in T.contents)
				if(reachable[neighbor])
					continue
				if(!(neighbor in connected))
					continue
				if(!(direction & current.dpdir))
					continue
				if(!(REVERSE_DIR(direction) & neighbor.dpdir))
					continue
				reachable[neighbor] = TRUE
				to_visit += neighbor

		// Cog sideways connections
		if(istype(current, /obj/structure/rotation_piece/cog) || istype(current, /obj/structure/water_pump))
			for(var/direction in GLOB.cardinals)
				if(direction & current.dpdir)
					continue
				var/turf/T = get_step(current, direction)
				if(!T)
					continue
				for(var/obj/structure/neighbor in T.contents)
					if(reachable[neighbor])
						continue
					if(!(neighbor in connected))
						continue
					if(!istype(neighbor, /obj/structure/rotation_piece/cog) && !istype(neighbor, /obj/structure/water_pump))
						continue
					if(neighbor.dir != current.dir && neighbor.dir != REVERSE_DIR(current.dir))
						continue
					reachable[neighbor] = TRUE
					to_visit += neighbor

	if(length(reachable) == length(connected))
		rebuild_group()
		return

	// Split unreachable nodes into a new network
	var/datum/rotation_network/new_network = new
	for(var/obj/structure/child in connected)
		if(reachable[child])
			continue
		remove_connection(child)
		new_network.add_connection(child)
		if(child.stress_use)
			child.set_stress_use(child.stress_use, check_network = FALSE)
		if(child.stress_generator)
			new_network.total_stress += child.last_stress_generation
			child.set_stress_generation(child.last_stress_generation, check_network = FALSE)

	new_network.rebuild_group()
	rebuild_group()

/datum/rotation_segment
	var/datum/rotation_network/network
	var/rotation_direction
	var/rotations_per_minute
	var/list/obj/structure/members = list()
	var/list/datum/segment_connection/connections = list()

/datum/rotation_segment/Destroy()
	for(var/obj/structure/node in members)
		node.segment = null
	members = list()
	connections = list()
	network = null
	return ..()

/datum/segment_connection
	var/datum/rotation_segment/other
	var/obj/structure/our_node
	var/obj/structure/their_node
	var/flips_direction = FALSE
	var/speed_ratio = 1
