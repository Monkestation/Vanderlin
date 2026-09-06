#define PNEUMATIC_BASE_DELAY 2 SECONDS // deciseconds per hop at 1 RPM
#define PNEUMATIC_MIN_DELAY 0.1 SECONDS // fastest possible hop delay
#define PNEUMATIC_IDLE_DELAY 5 SECONDS// hop delay when network rpm is 0 (crawl)

//generic stub proc, for the most part you want to override this. Tries to insert items into storage if possible.
/atom/movable/proc/try_pneumatic_insert(list/atom/movable/things)
	for(var/atom/movable/thing as anything in things)
		if(SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, thing, null, TRUE, FALSE))
			SEND_SIGNAL(src, COMSIG_ATOM_PSEUDO_INSERT)
			things -= thing
	return things

/datum/pneumatic_network
	var/list/obj/structure/pneumatic_tube/members = list()
	var/rpm = 0

/datum/pneumatic_network/proc/add_member(obj/structure/pneumatic_tube/pipe)
	if(!pipe)
		return
	if(pipe.pneumatic_network && pipe.pneumatic_network != src)
		pipe.pneumatic_network.members -= pipe
	members |= pipe
	pipe.pneumatic_network = src

/datum/pneumatic_network/proc/remove_member(obj/structure/pneumatic_tube/pipe)
	members -= pipe
	if(pipe && pipe.pneumatic_network == src)
		pipe.pneumatic_network = null
	if(!length(members))
		qdel(src)
		return
	rebuild()

/datum/pneumatic_network/proc/rebuild()
	if(!length(members))
		qdel(src)
		return

	var/list/obj/structure/pneumatic_tube/unvisited = members.Copy()
	var/is_first_cluster = TRUE

	while(length(unvisited))
		var/obj/structure/pneumatic_tube/start_pipe = unvisited[1]
		unvisited -= start_pipe

		var/list/obj/structure/pneumatic_tube/cluster = list(start_pipe)
		var/list/obj/structure/pneumatic_tube/queue = list(start_pipe)

		while(length(queue))
			var/obj/structure/pneumatic_tube/curr = queue[length(queue)]
			queue.len--

			for(var/obj/structure/pneumatic_tube/neighbor in curr.get_connected_pipes())
				if(neighbor in unvisited)
					unvisited -= neighbor
					cluster += neighbor
					queue += neighbor

		if(is_first_cluster)
			members = cluster
			for(var/obj/structure/pneumatic_tube/pipe in cluster)
				pipe.pneumatic_network = src
			is_first_cluster = FALSE
		else
			var/datum/pneumatic_network/new_net = new()
			new_net.rpm = rpm
			for(var/obj/structure/pneumatic_tube/pipe in cluster)
				new_net.add_member(pipe)

/datum/pneumatic_network/proc/merge(datum/pneumatic_network/other)
	if(!other || other == src)
		return
	for(var/obj/structure/pneumatic_tube/pipe as anything in other.members)
		add_member(pipe)
	other.members.Cut()
	qdel(other)

/datum/pneumatic_network/proc/set_rpm(new_rpm)
	rpm = max(0, new_rpm)

/datum/pneumatic_network/proc/get_step_delay()
	if(rpm <= 0)
		return PNEUMATIC_IDLE_DELAY
	return max(PNEUMATIC_MIN_DELAY, round(PNEUMATIC_BASE_DELAY / (rpm * 0.1)))

/datum/pneumatic_network/Destroy()
	for(var/obj/structure/pneumatic_tube/pipe as anything in members)
		if(pipe.pneumatic_network == src)
			pipe.pneumatic_network = null
	members = null
	return ..()

/obj/structure/pneumatic_tube
	name = "pneumatic tube"
	desc = "An underfloor pneumatic tube. It only couples to pipes of a matching colour."
	icon_state = "base"
	icon = 'icons/roguetown/misc/pneumatics.dmi'
	anchored = TRUE
	density = FALSE
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN
	plane = FLOOR_PLANE
	layer = DISPOSAL_PIPE_LAYER
	max_integrity = 200
	/// Maps direction flags ("1", "2", "4", "8", "16", "32") to connection states.
	var/list/connected = list("2" = 0, "1" = 0, "8" = 0, "4" = 0, "16" = 0, "32" = 0)
	var/datum/pneumatic_network/pneumatic_network

	/// Direct sort filter installed on this pipe segment.
	var/list/sort_filter
	/// Associative list mapping direction strings ("1", "2", "4", "8") to type lists.
	/// Used for junction sorting toward specific outgoing directions.
	var/list/sort_filters
	/// Indicates whether a puller module item is currently installed on this segment.
	var/has_puller_module = FALSE
	/// Limit on items ingested per suction cycle.
	var/max_pull_amount = 10
	/// Whether a lock module is installed on this segment.
	var/has_lock_module = FALSE
	///locked segments refuse to intake or relay parcels.
	var/locked = FALSE

/obj/structure/pneumatic_tube/Initialize(mapload)
	. = ..()
	scan_connections()

/obj/structure/pneumatic_tube/Destroy()
	var/turf/old_turf = get_turf(src)
	for(var/direction in GLOB.cardinals)
		var/turf/neighbor_turf = get_step(old_turf, direction)
		for(var/obj/structure/pneumatic_tube/neighbor in neighbor_turf)
			if(!istype(neighbor))
				continue
			if(neighbor.color == color)
				neighbor.unset_connection(REVERSE_DIR(direction))
	connected = null
	if(pneumatic_network)
		pneumatic_network.remove_member(src)
		pneumatic_network = null
	if(has_puller_module)
		has_puller_module = FALSE
		for(var/obj/item/pneumatic_puller/puller in src)
			puller.forceMove(get_turf(src))
	for(var/obj/structure/pneumatic_tube_parcel/parcel in src)
		expel_parcel(parcel)

	return ..()

/obj/structure/pneumatic_tube/get_mechanics_examine(mob/user)
	. = ..()
	if(has_lock_module)
		. += span_notice("This pipe has a lock module installed, giving it redstone signal with flip between lock states.")
		if(has_puller_module)
			. += span_notice("While locked with a puller module it will also disable the puller module.")
	if(has_puller_module)
		. += span_notice("This pipe has a puller module installed, it will try to pull items from the exposed end of the pipe.")

/obj/structure/pneumatic_tube/proc/enable_lock_module()
	has_lock_module = TRUE
	redstone_structure = TRUE
	var/turf/T = get_turf(src)
	last_redstone_power = T ? T.get_turf_power() : 0
	if(last_redstone_power > 0)
		set_locked(!locked)

/obj/structure/pneumatic_tube/proc/disable_lock_module()
	has_lock_module = FALSE
	redstone_structure = FALSE
	set_locked(FALSE)

/obj/structure/pneumatic_tube/redstone_triggered(datum/source)
	if(!has_lock_module)
		return ..()
	set_locked(!locked)

/obj/structure/pneumatic_tube/proc/set_locked(new_locked)
	if(locked == new_locked)
		return
	locked = new_locked
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/pneumatic_tube/proc/start_pull_loop()
	if(!has_puller_module || QDELETED(src))
		return

	attempt_pull()
	var/next_delay = pneumatic_network ? pneumatic_network.get_step_delay() : PNEUMATIC_IDLE_DELAY
	addtimer(CALLBACK(src, PROC_REF(start_pull_loop)), next_delay)

/// Returns turfs adjacent to open/unconnected sides of this pipe segment.
/obj/structure/pneumatic_tube/proc/get_open_intake_turfs()
	var/list/turf/open_turfs = list()
	var/list/connected_dirs = list()

	for(var/dir_string in connected)
		if(connected[dir_string])
			connected_dirs += text2num(dir_string)

	// If the pipe is connected on 2 or more sides (or 0 sides), it has no open intake mouth.
	if(length(connected_dirs) != 1)
		return open_turfs

	var/opp_dir = REVERSE_DIR(connected_dirs[1])
	var/opp_str = "[opp_dir]"

	if((opp_str in connected) && !connected[opp_str])
		var/turf/target = get_step_multiz(src, opp_dir)
		if(target && target != get_turf(src))
			open_turfs += target

	return open_turfs

/obj/structure/pneumatic_tube/proc/attempt_pull()
	if(!has_puller_module || locked || QDELETED(src))
		return

	var/list/turf/target_turfs = get_open_intake_turfs()
	if(!length(target_turfs))
		return

	var/list/atom/movable/items_to_pull = list()

	for(var/turf/target_turf in target_turfs)
		if(length(items_to_pull) >= max_pull_amount)
			break

		// 1. Pull from storage containers on target turf
		for(var/atom/movable/container in target_turf)
			if(!container.contents.len || container == src)
				continue

			var/list/atom/movable/contents_copy = container.contents.Copy()
			for(var/atom/movable/thing in contents_copy)
				if(length(items_to_pull) >= max_pull_amount)
					break
				if(!can_pull_item(thing))
					continue

				SEND_SIGNAL(container, COMSIG_TRY_STORAGE_TAKE, thing, target_turf)
				if(thing.loc == target_turf)
					items_to_pull += thing

		// 2. Pull loose items directly on target turf
		for(var/atom/movable/thing in target_turf)
			if(length(items_to_pull) >= max_pull_amount)
				break
			if(thing.anchored || istype(thing, /obj/structure/pneumatic_tube_parcel))
				continue
			if(can_pull_item(thing) && !(thing in items_to_pull))
				items_to_pull += thing

	var/turf/first_turf = target_turfs[1]
	if(length(items_to_pull))
		var/obj/structure/pneumatic_tube_parcel/parcel = new(get_turf(src))
		parcel.load(items_to_pull)
		receive_parcel(parcel, first_turf)

/// Checks if an item passes the direct sort filter (if one exists on this segment).
/obj/structure/pneumatic_tube/proc/can_pull_item(atom/movable/thing)
	if(QDELETED(thing) || thing.anchored)
		return FALSE

	// Direct sort filter check
	if(length(sort_filter))
		var/matched = FALSE
		for(var/filter_type in sort_filter)
			if(istype(thing, filter_type))
				matched = TRUE
				break
		if(!matched)
			return FALSE

	return TRUE

///checks our cardinals for color matches
/obj/structure/pneumatic_tube/proc/scan_connections()
	for(var/direction in GLOB.cardinals_multiz)
		var/turf/neighbor_turf = get_step_multiz(src, direction)
		for(var/obj/structure/pneumatic_tube/neighbor in neighbor_turf)
			if(!istype(neighbor))
				continue
			if((color && neighbor.color) && (neighbor.color != color))
				continue
			var/dir_to = get_dir_multiz(src, neighbor)
			set_connection(dir_to)
			neighbor.set_connection(REVERSE_DIR(dir_to))
			merge_networks(neighbor)

/obj/structure/pneumatic_tube/proc/set_connection(dir)
	connected["[dir]"] = 1
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/pneumatic_tube/proc/unset_connection(dir)
	connected["[dir]"] = 0
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/pneumatic_tube/update_overlays()
	. = ..()
	var/new_icon_state = ""
	var/vertical = FALSE

	for(var/dir_string in connected)
		if(!connected[dir_string])
			continue
		var/dir_num = text2num(dir_string)
		if(dir_num & ALL_CARDINALS)
			new_icon_state += dir_string
		else if(dir_num & UP)
			. += "up"
			vertical = TRUE
		else if(dir_num & DOWN)
			. += "down"
			vertical = TRUE

	if(new_icon_state)
		icon_state = new_icon_state
	else
		icon_state = vertical ? "" : "base"

///returns a list of matched pipes
/obj/structure/pneumatic_tube/proc/get_connected_pipes()
	var/list/result = list()
	for(var/dir_string in connected)
		if(!connected[dir_string])
			continue
		var/dir_num = text2num(dir_string)
		var/turf/neighbor_turf = get_step_multiz(src, dir_num)
		var/rev_dir_str = "[REVERSE_DIR(dir_num)]"
		for(var/obj/structure/pneumatic_tube/neighbor in neighbor_turf)
			if(neighbor.locked)
				continue
			if((((!color || !neighbor.color) || (neighbor.color == color))) && neighbor.connected[rev_dir_str])
				result += neighbor
				break
	return result

/obj/structure/pneumatic_tube/proc/get_pipe_at_dir(direction)
	if(!direction || !connected["[direction]"])
		return null
	var/turf/neighbor_turf = get_step_multiz(src, direction)
	var/rev_dir_str = "[REVERSE_DIR(direction)]"
	for(var/obj/structure/pneumatic_tube/neighbor in neighbor_turf)
		if(neighbor.color == color && neighbor.connected[rev_dir_str])
			return neighbor
	return null

/obj/structure/pneumatic_tube/proc/set_sort_filter_for_dir(dir, list/types)
	if(!sort_filters)
		sort_filters = list()
	sort_filters["[dir]"] = types ? types.Copy() : null

/obj/structure/pneumatic_tube/proc/merge_networks(obj/structure/pneumatic_tube/other)
	if(!pneumatic_network)
		pneumatic_network = new /datum/pneumatic_network()
		pneumatic_network.add_member(src)
	if(!other.pneumatic_network)
		pneumatic_network.add_member(other)
	else
		pneumatic_network.merge(other.pneumatic_network)

///Handles the dispatch of a parcel, filters split parcels if possible.
/obj/structure/pneumatic_tube/proc/receive_parcel(obj/structure/pneumatic_tube_parcel/parcel, obj/structure/pneumatic_tube/came_from)
	if(QDELETED(parcel))
		return
	if(locked)
		expel_parcel(parcel, came_from)
		return
	parcel.forceMove(src)
	parcel.current_pipe = src

	var/list/obj/structure/pneumatic_tube/candidate_pipes = get_connected_pipes()
	if(came_from)
		candidate_pipes -= came_from

	if(!length(candidate_pipes))
		expel_parcel(parcel, came_from)
		return

	var/list/obj/structure/pneumatic_tube/unfiltered_candidates = list()

	for(var/obj/structure/pneumatic_tube/next_pipe as anything in candidate_pipes)
		if(QDELETED(parcel) || !length(parcel.contents))
			break

		var/dir_str = "[get_dir_multiz(src, next_pipe)]"
		var/list/active_filter = null

		if(sort_filters && length(sort_filters[dir_str]))
			active_filter = sort_filters[dir_str]
		else if(length(next_pipe.sort_filter))
			active_filter = next_pipe.sort_filter

		if(length(active_filter))
			var/list/matched_items = list()
			for(var/atom/movable/thing as anything in parcel.contents)
				for(var/filter_type in active_filter)
					if(istype(thing, filter_type))
						matched_items += thing
						break

			if(length(matched_items))
				var/obj/structure/pneumatic_tube_parcel/sorted_parcel = new(loc)
				sorted_parcel.load(matched_items)
				var/sort_delay = pneumatic_network ? pneumatic_network.get_step_delay() : PNEUMATIC_IDLE_DELAY
				addtimer(CALLBACK(next_pipe, PROC_REF(receive_parcel), sorted_parcel, src), sort_delay)
		else
			unfiltered_candidates += next_pipe

	if(QDELETED(parcel))
		return

	if(!length(parcel.contents))
		qdel(parcel)
		return

	//random sort for leftover
	var/obj/structure/pneumatic_tube/chosen_next = null
	if(length(unfiltered_candidates))
		chosen_next = pick(unfiltered_candidates)
	else if(length(candidate_pipes))
		chosen_next = pick(candidate_pipes)

	if(chosen_next)
		var/delay = pneumatic_network ? pneumatic_network.get_step_delay() : PNEUMATIC_IDLE_DELAY
		addtimer(CALLBACK(chosen_next, PROC_REF(receive_parcel), parcel, src), delay)
	else
		expel_parcel(parcel, came_from)

///attempts to shove the parcel into objects or throws it
/obj/structure/pneumatic_tube/proc/expel_parcel(obj/structure/pneumatic_tube_parcel/parcel, obj/structure/pneumatic_tube/came_from)
	var/exit_dir = came_from ? get_dir_multiz(came_from, src) : (dir || SOUTH)
	var/turf/exit_turf = get_turf(src)
	var/turf/ahead_turf = get_step_multiz(exit_turf, exit_dir)

	var/list/atom/movable/leftover = parcel.contents.Copy()

	if(ahead_turf)
		for(var/obj/structure in ahead_turf)
			if(!length(leftover))
				break
			leftover = structure.try_pneumatic_insert(leftover)

	if(length(leftover))
		var/rpm = pneumatic_network ? pneumatic_network.rpm : 0
		var/throw_range = max(0, round(rpm / 10))
		var/throw_speed = max(1, round(rpm / 20))
		var/stagger_delay = pneumatic_network ? pneumatic_network.get_step_delay() : PNEUMATIC_IDLE_DELAY

		var/delay_acc = 0
		for(var/atom/movable/thing as anything in leftover)
			thing.forceMove(src)
			if(delay_acc == 0)
				expel_single_item(thing, exit_turf, ahead_turf, exit_dir, throw_range, throw_speed)
			else
				addtimer(CALLBACK(src, PROC_REF(expel_single_item), thing, exit_turf, ahead_turf, exit_dir, throw_range, throw_speed), delay_acc)
			delay_acc += stagger_delay

	qdel(parcel)

/// Expels and throws a single item from the tube after a stagger delay.
/obj/structure/pneumatic_tube/proc/expel_single_item(atom/movable/thing, turf/exit_turf, turf/ahead_turf, exit_dir, throw_range, throw_speed)
	if(QDELETED(thing))
		return
	thing.forceMove(exit_turf)
	if(throw_range > 0 && ahead_turf)
		thing.safe_throw_at(get_edge_target_turf(ahead_turf, exit_dir), throw_range, throw_speed)

/obj/structure/pneumatic_tube_parcel
	name = "pneumatic parcel"
	invisibility = INVISIBILITY_MAXIMUM
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	anchored = TRUE
	density = FALSE
	var/obj/structure/pneumatic_tube/current_pipe

/obj/structure/pneumatic_tube_parcel/proc/load(list/atom/movable/things)
	for(var/atom/movable/thing as anything in things)
		thing.forceMove(src)

/obj/item/pneumatic_sorter
	name = "pneumatic sorting module"
	desc = "Click an item to add its type to the filter. Click a pneumatic tube to start configuring, then click a connected pipe to route filtered items there (or click the same pipe again to set a direct segment filter)."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "metalizer"
	w_class = WEIGHT_CLASS_SMALL
	var/list/filter_types = list()
	var/obj/structure/pneumatic_tube/configuring_pipe

/obj/item/pneumatic_sorter/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return ..()

	if(istype(target, /obj/structure/redstone/observer))
		var/obj/structure/redstone/observer/obs = target
		if(!length(filter_types))
			to_chat(user, span_warning("The sort filter is empty."))
			return
		obs.filter_types = filter_types.Copy()
		to_chat(user, span_notice("Installed detection filter on [obs]."))
		return

	if(istype(target, /obj/structure/pneumatic_tube))
		var/obj/structure/pneumatic_tube/pipe = target
		if(configuring_pipe)
			if(pipe == configuring_pipe)
				pipe.sort_filter = filter_types.Copy()
				to_chat(user, span_notice("Installed direct sort filter on [pipe]."))
				configuring_pipe = null
				return

			if(pipe in configuring_pipe.get_connected_pipes())
				var/dir_to_target = get_dir(configuring_pipe, pipe)
				configuring_pipe.set_sort_filter_for_dir(dir_to_target, filter_types)
				to_chat(user, span_notice("[configuring_pipe] will now route filtered items toward [pipe]."))
				configuring_pipe = null
				return
			else
				to_chat(user, span_warning("[pipe] is not connected to [configuring_pipe]. Resetting selection."))
				configuring_pipe = null
				return

		if(!length(filter_types))
			to_chat(user, span_warning("The sort filter is empty."))
			return

		configuring_pipe = pipe
		to_chat(user, span_notice("Sort filter selected for [pipe]. Click a connected pipe to route filtered items, or click [pipe] again to set a direct segment filter."))
		return

	if(isitem(target) && target != src)
		var/type_to_add = target.type
		if(type_to_add in filter_types)
			to_chat(user, span_warning("[target] is already in the sort filter."))
		else
			filter_types += type_to_add
			to_chat(user, span_notice("Added [target] to the sort filter."))
		return

	return ..()

/obj/item/pneumatic_sorter/attack_self(mob/user)
	if(!length(filter_types))
		to_chat(user, span_notice("The sort filter is empty."))
		return
	var/choice = tgui_input_list(user, "Select an entry to remove.", "Conveyor Sorter", filter_types)
	if(!choice || !(choice in filter_types))
		return
	filter_types -= choice
	to_chat(user, span_notice("Removed [choice] from the sort filter."))

/obj/item/pneumatic_puller
	name = "pneumatic puller module"
	desc = "An attachment for pneumatic tubes that continuously suctions items from the turf in front of the pipe."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "metalizer"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/pneumatic_puller/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return ..()

	if(istype(target, /obj/structure/pneumatic_tube))
		var/obj/structure/pneumatic_tube/pipe = target
		if(pipe.has_puller_module)
			to_chat(user, span_warning("[pipe] already has a puller module attached."))
			return

		pipe.has_puller_module = TRUE
		to_chat(user, span_notice("You attach [src] to [pipe]."))
		user.transferItemToLoc(src, pipe)
		pipe.start_pull_loop()
		return

	return ..()

/obj/item/pneumatic_lock
	name = "pneumatic lock module"
	desc = "An attachment for pneumatic tubes that toggles the tube locked or unlocked each time it receives redstone power, can also be installed in a rail.."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "metalizer"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/pneumatic_lock/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return ..()

	if(istype(target, /obj/structure/pneumatic_tube))
		var/obj/structure/pneumatic_tube/pipe = target
		if(pipe.has_lock_module)
			to_chat(user, span_warning("[pipe] already has a lock module attached."))
			return

		to_chat(user, span_notice("You attach [src] to [pipe]."))
		user.transferItemToLoc(src, pipe)
		pipe.enable_lock_module()
		return

	if(istype(target, /obj/structure/minecart_rail))
		var/obj/structure/minecart_rail/rail = target
		if(rail.has_lock_module)
			to_chat(user, span_warning("[rail] already has a lock module attached."))
			return
		to_chat(user, span_notice("You attach [src] to [rail]."))
		user.transferItemToLoc(src, rail)
		rail.has_lock_module = TRUE
		rail.update_animation_effect()
		return

	return ..()

#undef PNEUMATIC_BASE_DELAY
#undef PNEUMATIC_MIN_DELAY
#undef PNEUMATIC_IDLE_DELAY
