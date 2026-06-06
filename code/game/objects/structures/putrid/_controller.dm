/obj/effect/meatvine_controller
	var/list/obj/structure/meatvine/vines = list()
	var/isdying = FALSE

	// Growth thresholds
	var/slowdown_size = 2000000
	var/collapse_size = 10000000
	var/reached_collapse_size = FALSE
	var/reached_slowdown_size = FALSE

	// Papameat spawning - DYNAMIC BASED ON AREA SIZE
	var/papameat_spawn_threshold = 30
	var/papameat_vines_per_papameat = 100
	var/list/obj/structure/meatvine/papameat/papameats = list()

	// Organic matter feeding system
	var/organic_matter = 0
	var/organic_matter_max = 2000
	var/organic_matter_per_spread = 2
	var/organic_matter_per_humor = 250

	// Feed tracking for humor spawning
	var/total_feeds = 0
	var/feeds_per_humor = 3
	var/humor_spawn_chance = 5

	// Wall generation system
	var/list/wall_segments = list()
	var/wall_generation_cooldown = 0
	var/min_wall_generation_interval = 50
	var/wall_budget = 0
	var/wall_budget_per_tick = 0.5
	var/wall_cost = 10

	var/consumed_resource_pool = 0
	var/consumed_resource_max = 500
	var/consumed_resource_regen_rate = 2

	var/hive_spread_chance = 50

	// Wall pattern preferences
	var/list/wall_patterns = list(
		"corridor" = 3,
		"chamber" = 2,
		"snake" = 4,
		"junction" = 2
	)

	// Papameat death mechanics
	var/vines_lost_per_papameat_death = 150

	var/list/blocked_spread_locations = list()
	var/list/obstacle_targets = list()
	var/list/cooldown_obstacles = list()
	var/bridge_request_cooldown = 0
	var/bridge_request_interval = 10

	var/list/obj/structure/meatvine/lair/lairs = list()
	var/lair_spawn_threshold = 10
	var/lair_vines_per_lair = 30
	var/min_lair_spacing = 5

	var/list/mobs = list()

/obj/effect/meatvine_controller/Initialize(mapload, ...)
	. = ..()
	if(!isfloorturf(loc))
		return INITIALIZE_HINT_QDEL

	var/obj/structure/meatvine/SV = locate() in src.loc
	if(!SV)
		spawn_spacevine_piece(src.loc)
	else
		SV.master = src
		vines += SV

	// Register with subsystem instead of SSfastprocess
	START_PROCESSING(SSobj, src)

/obj/effect/meatvine_controller/proc/die()
	isdying = TRUE

/obj/effect/meatvine_controller/Destroy()
	STOP_PROCESSING(SSobj, src)
	papameats.Cut()
	lairs.Cut()
	wall_segments.Cut()
	return ..()

/obj/effect/meatvine_controller/proc/spawn_spacevine_piece(turf/location, piece_type = /obj/structure/meatvine/floor)
	var/obj/structure/meatvine/SV = new piece_type(location)
	SV.master = src
	vines += SV

	// Track papameats and lairs separately
	if(istype(SV, /obj/structure/meatvine/papameat))
		papameats += SV
	if(istype(SV, /obj/structure/meatvine/lair))
		lairs += SV
	SSmeatvines.register_vine(SV)

// All the helper procs remain the same
/obj/effect/meatvine_controller/proc/get_max_lairs()
	if(vines.len < lair_spawn_threshold)
		return 0
	return max(1, round((vines.len - lair_spawn_threshold) / lair_vines_per_lair) + 1)

/obj/effect/meatvine_controller/proc/can_spawn_lair()
	var/max_lairs = get_max_lairs()
	if(max_lairs <= 0)
		return FALSE
	if(lairs.len >= max_lairs)
		return FALSE
	return TRUE

/obj/effect/meatvine_controller/proc/can_spawn_lair_at(turf/T)
	if(!can_spawn_lair())
		return FALSE

	for(var/obj/structure/meatvine/lair/existing_lair in lairs)
		if(get_dist(T, existing_lair) < min_lair_spacing)
			return FALSE

	for(var/obj/structure/meatvine/papameat/PM in papameats)
		if(get_dist(T, PM) < 8)
			return FALSE

	return TRUE

/obj/effect/meatvine_controller/proc/get_max_papameats()
	if(vines.len < papameat_spawn_threshold)
		return 0
	return max(1, round((vines.len - papameat_spawn_threshold) / papameat_vines_per_papameat) + 1)

/obj/effect/meatvine_controller/proc/can_spawn_papameat()
	var/max_papameats = get_max_papameats()
	if(max_papameats <= 0)
		return FALSE
	if(papameats.len >= max_papameats)
		return FALSE
	return TRUE

/obj/effect/meatvine_controller/proc/try_spawn_papameat()
	if(!can_spawn_papameat())
		return FALSE

	var/list/candidates = list()
	for(var/obj/structure/meatvine/floor/SV in vines)
		if(istype(SV, /obj/structure/meatvine/papameat))
			continue
		if(!isfloorturf(SV.loc))
			continue
		if(!check_papameat_clearance(SV.loc))
			continue

		var/min_dist = INFINITY
		for(var/obj/structure/meatvine/papameat/PM in papameats)
			var/dist = get_dist(SV, PM)
			if(dist < min_dist)
				min_dist = dist
		if(min_dist > 10)
			candidates += SV

	if(!length(candidates))
		for(var/obj/structure/meatvine/floor/SV in vines)
			if(!istype(SV, /obj/structure/meatvine/papameat))
				if(check_papameat_clearance(SV.loc))
					candidates += SV

	if(!length(candidates))
		return FALSE

	var/obj/structure/meatvine/floor/chosen = pick(candidates)
	var/turf/spawn_loc = get_turf(chosen)

	vines -= chosen
	qdel(chosen)

	spawn_spacevine_piece(spawn_loc, /obj/structure/meatvine/papameat)
	return TRUE

/obj/effect/meatvine_controller/proc/check_papameat_clearance(turf/center)
	for(var/turf/T in range(2, center))
		if(!isfloorturf(T))
			return FALSE
		if(T.is_blocked_turf())
			return FALSE
		if(locate(/obj/structure/meatvine/heavy) in T)
			return FALSE
		if(locate(/obj/structure/meatvine/papameat) in T)
			return FALSE
		if(locate(/obj/structure/meatvine/lair) in T)
			return FALSE
	return TRUE

/obj/effect/meatvine_controller/proc/feed_organic_matter(amount)
	organic_matter = min(organic_matter + amount, organic_matter_max)
	consumed_resource_pool = min(consumed_resource_max, consumed_resource_pool + amount)
	total_feeds++

	var/turf/T = get_turf(src)
	if(T)
		T.pollute_turf(/datum/pollutant/rot, 50)

	if(total_feeds >= feeds_per_humor)
		try_spawn_humor_from_feeds()

/obj/effect/meatvine_controller/proc/try_spawn_humor()
	if(organic_matter < organic_matter_per_humor)
		return FALSE
	if(!prob(humor_spawn_chance))
		return FALSE
	return spawn_humor_node()

/obj/effect/meatvine_controller/proc/try_spawn_humor_from_feeds()
	if(total_feeds < feeds_per_humor)
		return FALSE
	total_feeds -= feeds_per_humor
	return spawn_humor_node()

/obj/effect/meatvine_controller/proc/spawn_humor_node()
	var/list/spawn_locations = list()

	for(var/obj/structure/meatvine/papameat/PM in papameats)
		if(PM.master == src)
			spawn_locations += get_turf(PM)

	if(!length(spawn_locations))
		spawn_locations += get_turf(src)

	var/turf/spawn_turf = pick(spawn_locations)
	var/obj/item/chimeric_node/humor = new()
	humor.forceMove(spawn_turf)

	// Setup node (simplified - add your full setup code here)
	if(organic_matter >= organic_matter_per_humor)
		organic_matter -= organic_matter_per_humor

	return TRUE

/obj/effect/meatvine_controller/proc/papameat_destroyed(obj/structure/meatvine/papameat/dead_papameat)
	papameats -= dead_papameat

	var/vines_to_kill = min(vines_lost_per_papameat_death, vines.len - 1)
	if(vines_to_kill <= 0)
		return

	var/list/vine_distances = list()
	for(var/obj/structure/meatvine/SV in vines)
		if(istype(SV, /obj/structure/meatvine/papameat))
			continue

		var/min_dist = INFINITY
		for(var/obj/structure/meatvine/papameat/PM in papameats)
			var/dist = get_dist(SV, PM)
			if(dist < min_dist)
				min_dist = dist

		if(min_dist == INFINITY)
			min_dist = get_dist(SV, src)

		vine_distances[SV] = min_dist

	var/list/sorted_vines = sortTim(vine_distances, GLOBAL_PROC_REF(cmp_numeric_dsc), associative = TRUE)

	var/killed = 0
	for(var/obj/structure/meatvine/SV in sorted_vines)
		if(killed >= vines_to_kill)
			break

		SV.rot()
		vines -= SV
		killed++

	var/turf/death_turf = get_turf(dead_papameat)
	if(death_turf)
		death_turf.pollute_turf(/datum/pollutant/rot, 200)

	if(!length(papameats))
		die()

/obj/effect/meatvine_controller/proc/lair_destroyed(obj/structure/meatvine/lair/dead_lair)
	lairs -= dead_lair

// MAIN PROCESS - This now only handles controller-level logic
// Individual vine spreading/growth is handled by the subsystem
/obj/effect/meatvine_controller/process()
	if(!vines.len)
		qdel(src)
		return

	// Try to spawn papameat if needed
	if(prob(10))
		try_spawn_papameat()

	// Try to spawn humor from organic matter
	if(organic_matter >= organic_matter_per_humor)
		try_spawn_humor()

	// Clean up dead papameats
	for(var/obj/structure/meatvine/papameat/PM in papameats)
		if(QDELETED(PM) || PM.master != src)
			papameats -= PM

	// Update size thresholds
	if(vines.len >= collapse_size && !reached_collapse_size)
		reached_collapse_size = TRUE
	if(vines.len >= slowdown_size && !reached_slowdown_size)
		reached_slowdown_size = TRUE

	// Wall generation
	if(vines.len >= min_wall_generation_interval)
		wall_budget += wall_budget_per_tick

		if(wall_budget >= wall_cost && wall_generation_cooldown <= 0)
			if(prob(15))
				attempt_wall_generation()

	update_wall_segments()

	if(wall_generation_cooldown > 0)
		wall_generation_cooldown--

	if(bridge_request_cooldown > 0)
		bridge_request_cooldown--

	if(bridge_request_cooldown <= 0 && prob(20))
		check_for_bridge_opportunities()

	// Clean up dead lairs
	for(var/obj/structure/meatvine/lair/L in lairs)
		if(QDELETED(L) || L.master != src)
			lairs -= L

	// Regenerate resource pool
	if(consumed_resource_pool < consumed_resource_max)
		consumed_resource_pool = min(consumed_resource_pool + consumed_resource_regen_rate, consumed_resource_max)

	SEND_SIGNAL(src, COMSIG_MEATVINE_RESOURCE_CHANGE, consumed_resource_pool)

/obj/effect/meatvine_controller/proc/consume_client_mob(mob/living/C)
	if(!C.client)
		return FALSE

	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = new(get_turf(C))
	consumed.master = src
	consumed.generate_monitor()
	C.client.mob = consumed
	consumed.ckey = C.ckey

	to_chat(consumed, "<span class='userdanger'>You have been consumed by the meatvine! You can now spread it using your abilities.</span>")
	return TRUE

/obj/effect/meatvine_controller/proc/try_spend_resources(amount)
	if(consumed_resource_pool >= amount)
		consumed_resource_pool -= amount
		return TRUE
	return FALSE

// Wall generation procs (keeping all your existing wall logic)
/obj/effect/meatvine_controller/proc/attempt_wall_generation()
	if(wall_budget < wall_cost)
		return FALSE

	var/pattern = pickweight(wall_patterns)
	var/list/candidates = list()

	for(var/obj/structure/meatvine/floor/SV in vines)
		if(istype(SV, /obj/structure/meatvine/papameat))
			continue
		if(!isfloorturf(SV.loc))
			continue

		var/open_count = 0
		for(var/direction in GLOB.cardinals)
			var/turf/T = get_step(SV.loc, direction)
			if(isfloorturf(T) && !locate(/obj/structure/meatvine/heavy, T))
				open_count++

		if(open_count >= 2)
			candidates += SV

	if(!length(candidates))
		return FALSE

	var/obj/structure/meatvine/start_vine = pick(candidates)
	var/turf/start_loc = get_turf(start_vine)

	var/datum/wall_segment/segment
	switch(pattern)
		if("corridor")
			segment = generate_corridor(start_loc)
		if("chamber")
			segment = generate_chamber(start_loc)
		if("snake")
			segment = generate_snake_wall(start_loc)
		if("junction")
			segment = generate_junction(start_loc)

	if(segment)
		if(!validate_wall_segment(segment))
			qdel(segment)
			return FALSE

		wall_segments += segment
		wall_budget -= wall_cost
		wall_generation_cooldown = rand(30, 60)
		return TRUE

	return FALSE

/obj/effect/meatvine_controller/proc/update_wall_segments()
	for(var/datum/wall_segment/segment in wall_segments)
		if(!length(segment.planned_walls))
			wall_segments -= segment
			qdel(segment)
			continue

		if(length(segment.planned_walls) % 3 == 0)
			if(!validate_wall_segment(segment))
				wall_segments -= segment
				qdel(segment)
				continue

		for(var/i = 1 to segment.growth_rate)
			if(!length(segment.planned_walls))
				break

			var/turf/T = segment.planned_walls[1]
			segment.planned_walls -= T

			var/obj/structure/meatvine/floor/existing = locate() in T
			if(existing && !istype(existing, /obj/structure/meatvine/heavy))
				vines -= existing
				qdel(existing)

			if(can_place_wall_at(T))
				spawn_spacevine_piece(T, /obj/structure/meatvine/heavy)

/obj/effect/meatvine_controller/proc/generate_corridor(turf/start_loc)
	var/direction = pick(GLOB.cardinals)
	var/perpendicular = turn(direction, pick(90, -90))

	var/datum/wall_segment/segment = new()
	segment.pattern_type = "corridor"
	segment.growth_rate = 1

	var/turf/current = start_loc
	var/length = rand(4, 8)
	for(var/i = 1 to length)
		var/turf/next = get_step(current, direction)
		if(!can_place_wall_at(next))
			break
		segment.planned_walls += next
		current = next

	current = get_step(start_loc, perpendicular)
	if(!can_place_wall_at(current))
		current = get_step(start_loc, turn(perpendicular, 180))

	if(can_place_wall_at(current))
		segment.planned_walls += current
		for(var/i = 1 to length)
			var/turf/next = get_step(current, direction)
			if(!can_place_wall_at(next))
				break
			segment.planned_walls += next
			current = next

	return length(segment.planned_walls) >= 4 ? segment : null

/obj/effect/meatvine_controller/proc/generate_chamber(turf/start_loc)
	var/datum/wall_segment/segment = new()
	segment.pattern_type = "chamber"
	segment.growth_rate = 1

	var/width = rand(3, 6)
	var/height = rand(3, 6)

	for(var/x = 0 to width)
		var/turf/top = locate(start_loc.x + x, start_loc.y + height, start_loc.z)
		var/turf/bottom = locate(start_loc.x + x, start_loc.y, start_loc.z)

		if(can_place_wall_at(top))
			segment.planned_walls += top
		if(can_place_wall_at(bottom))
			segment.planned_walls += bottom

	for(var/y = 1 to height - 1)
		var/turf/left = locate(start_loc.x, start_loc.y + y, start_loc.z)
		var/turf/right = locate(start_loc.x + width, start_loc.y + y, start_loc.z)

		if(can_place_wall_at(left))
			segment.planned_walls += left
		if(can_place_wall_at(right))
			segment.planned_walls += right

	if(length(segment.planned_walls) > 3)
		segment.planned_walls -= pick(segment.planned_walls)

	return length(segment.planned_walls) >= 6 ? segment : null

/obj/effect/meatvine_controller/proc/generate_snake_wall(turf/start_loc)
	var/datum/wall_segment/segment = new()
	segment.pattern_type = "snake"
	segment.growth_rate = 1

	var/turf/current = start_loc
	var/current_dir = pick(GLOB.cardinals)
	var/length = rand(6, 12)

	for(var/i = 1 to length)
		var/turf/next = get_step(current, current_dir)

		if(!can_place_wall_at(next))
			var/new_dir = pick(turn(current_dir, 90), turn(current_dir, -90))
			next = get_step(current, new_dir)

			if(!can_place_wall_at(next))
				break
			current_dir = new_dir

		segment.planned_walls += next
		current = next

		if(prob(30))
			current_dir = pick(turn(current_dir, 90), turn(current_dir, -90))

	return length(segment.planned_walls) >= 4 ? segment : null

/obj/effect/meatvine_controller/proc/generate_junction(turf/start_loc)
	var/datum/wall_segment/segment = new()
	segment.pattern_type = "junction"
	segment.growth_rate = 1

	var/main_dir = pick(GLOB.cardinals)
	var/make_plus = prob(50)

	var/length = rand(3, 5)
	for(var/i = -length to length)
		var/turf/T = get_step_multiz(start_loc, main_dir, i)
		if(can_place_wall_at(T))
			segment.planned_walls += T

	var/cross_dir = turn(main_dir, 90)
	for(var/i = 1 to length)
		var/turf/T = get_step_multiz(start_loc, cross_dir, i)
		if(can_place_wall_at(T))
			segment.planned_walls += T

	if(make_plus)
		cross_dir = turn(main_dir, -90)
		for(var/i = 1 to length)
			var/turf/T = get_step_multiz(start_loc, cross_dir, i)
			if(can_place_wall_at(T))
				segment.planned_walls += T

	return length(segment.planned_walls) >= 5 ? segment : null

/obj/effect/meatvine_controller/proc/can_place_wall_at(turf/T)
	if(!isfloorturf(T))
		return FALSE
	if(T.is_blocked_turf())
		return FALSE

	if(locate(/obj/structure/meatvine/heavy, T))
		return FALSE

	for(var/obj/structure/meatvine/papameat/PM in range(3, T))
		return FALSE

	if(locate(/obj/structure/meatvine/lair, T))
		return FALSE

	return TRUE

/obj/effect/meatvine_controller/proc/validate_wall_segment(datum/wall_segment/segment)
	if(!length(segment.planned_walls))
		return FALSE

	var/list/protected_structures = list()
	for(var/obj/structure/meatvine/papameat/PM in papameats)
		if(PM.master == src)
			protected_structures += PM

	for(var/obj/structure/meatvine/lair/L in vines)
		if(L.master == src)
			protected_structures += L

	if(!length(protected_structures))
		return TRUE

	for(var/obj/structure/meatvine/protected in protected_structures)
		if(would_enclose_structure(protected, segment.planned_walls))
			return FALSE

	return TRUE

/obj/effect/meatvine_controller/proc/check_for_bridge_opportunities()
	if(!length(vines))
		return

	// Sample some vines to check for blocked spreads
	var/checks = min(10, vines.len)
	for(var/i = 1 to checks)
		var/obj/structure/meatvine/SV = pick(vines)
		var/turf/vine_turf = get_turf(SV)

		for(var/direction in GLOB.cardinals)
			var/turf/blocked = get_step(vine_turf, direction)

			// Check if this location blocks spreading
			if(!can_spread_to(blocked))
				// Look ahead to see if we can bridge across
				var/turf/bridge_target = find_bridge_target(vine_turf, direction)
				if(bridge_target)
					request_bridge(blocked, bridge_target)
					bridge_request_cooldown = bridge_request_interval
					return

/obj/effect/meatvine_controller/proc/can_spread_to(turf/T)
	if(!T)
		return FALSE
	if(istype(T, /turf/open/openspace))
		return FALSE
	if(istype(T, /turf/open/water))
		return FALSE
	if(istype(T, /turf/open/lava))
		return FALSE
	return TRUE


/obj/effect/meatvine_controller/proc/find_bridge_target(turf/start, direction)
	// Look up to 3 tiles ahead in the direction
	var/turf/current = start

	for(var/i = 1 to 3)
		current = get_step(current, direction)
		if(!current)
			return null

		// If we find a valid spread location, this is our bridge target
		if(can_spread_to(current) && isfloorturf(current))
			// Make sure there's not already a vine here
			if(!locate(/obj/structure/meatvine) in current)
				return current

	return null

/obj/effect/meatvine_controller/proc/request_bridge(turf/blocked_turf, turf/target_turf)
	// Store this bridge request
	var/datum/bridge_request/request = new()
	request.blocked_location = blocked_turf
	request.target_location = target_turf
	request.timestamp = world.time

	blocked_spread_locations += request

/obj/effect/meatvine_controller/proc/mark_obstacle_for_destruction(atom/obstacle)
	if(obstacle in obstacle_targets)
		return
	if(obstacle in cooldown_obstacles)
		return

	obstacle_targets += obstacle

/obj/effect/meatvine_controller/proc/check_obstacle_destroyed(atom/obstacle)
	if(obstacle in obstacle_targets)
		obstacle_targets -= obstacle

/obj/effect/meatvine_controller/proc/cooldown_obstacle(atom/obstacle)
	if(obstacle in obstacle_targets)
		obstacle_targets -= obstacle

		cooldown_obstacles |= obstacle
		addtimer(CALLBACK(src, PROC_REF(readd_obstacle), obstacle), 2 MINUTES)

/obj/effect/meatvine_controller/proc/readd_obstacle(atom/obstacle)
	cooldown_obstacles -= obstacle
	obstacle_targets |= obstacle

/obj/effect/meatvine_controller/proc/would_enclose_structure(obj/structure/meatvine/structure, list/new_walls)
	var/turf/center = get_turf(structure)
	if(!center)
		return FALSE

	var/check_range = istype(structure, /obj/structure/meatvine/papameat) ? 3 : 2

	var/escape_routes = 0
	var/list/checked_dirs = list()

	for(var/direction in GLOB.cardinals)
		if(has_path_out(center, direction, new_walls, check_range))
			escape_routes++
			checked_dirs += direction

			if(escape_routes >= 2)
				return FALSE

	return escape_routes < 2

/obj/effect/meatvine_controller/proc/has_path_out(turf/start, initial_direction, list/planned_walls, max_distance = 3)
	var/turf/current = start

	for(var/i = 1 to max_distance)
		current = get_step(current, initial_direction)
		if(!current || !isfloorturf(current))
			return FALSE

		if(current in planned_walls)
			return FALSE

		if(locate(/obj/structure/meatvine/heavy, current))
			return FALSE

	return TRUE

/obj/effect/meatvine_controller/proc/get_step_multiz(turf/start, direction, distance)
	var/turf/current = start
	for(var/i = 1 to abs(distance))
		if(distance > 0)
			current = get_step(current, direction)
		else
			current = get_step(current, turn(direction, 180))
		if(!current)
			return null
	return current

/obj/effect/meatvine_controller/proc/add_hive_tracker(atom/target, timer)
	for(var/mob/living/simple_animal/hostile/retaliate/meatvine/mob in mobs)
		mob.add_team_tracker(target, timer)

/datum/wall_segment
	var/pattern_type = "generic"
	var/list/planned_walls = list()
	var/growth_rate = 1

/datum/bridge_request
	var/turf/blocked_location
	var/turf/target_location
	var/timestamp
