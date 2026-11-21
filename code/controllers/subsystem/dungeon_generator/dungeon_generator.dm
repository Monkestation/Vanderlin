/datum/dungeon_mob_record
	var/mob_type
	var/turf/spawn_turf
	var/depth = 0

SUBSYSTEM_DEF(dungeon_generator)
	name = "Matthios Creation"
	wait = 1 SECONDS

	init_order = INIT_ORDER_DUNGEON
	runlevels = RUNLEVEL_GAME | RUNLEVEL_INIT | RUNLEVEL_LOBBY
	lazy_load = FALSE

	var/list/parent_types = list()
	var/list/created_types = list()
	var/list/markers = list()
	var/list/placed_types = list()

	var/dungeon_z = -1 // The definite z level of the first level

	/// helper -> depth of the room that owns it (rooms placed from it get this + 1)
	var/list/marker_depths = list()
	/// Room depth (rooms away from the start) at which a room counts as "fully far out" (factor 1.0)
	var/depth_full_scale = 12
	/// How hard rare rooms are pushed outward. 0 = no effect.
	/// A room with remoteness r gets weight multiplier 1 + strength * r * (2 * depth_factor - 1)
	var/rare_depth_strength = 2
	/// Highest rarity value among all concrete templates, cached when created_types is built
	var/max_rarity = 1

	var/list/loot_spawners = list()
	/// Total loot value spread across the whole dungeon
	var/loot_budget = BASE_LOOTPOOL_SIZE
	/// Budget left over after the last distribution
	var/loot_remaining = 0
	/// Spawner weight = spawn_weight * (1 + depth_factor * loot_depth_bias). Higher = loot clusters further out.
	var/loot_depth_bias = 3
	var/loot_distributed = FALSE
	///list of all the dungeon waystones
	var/list/dungeon_waystones = list()
	/// Living tracked mobs -> their record
	var/list/mob_records = list()
	/// Records of mobs that died / were deleted, waiting to be respawned
	var/list/dead_records = list()

	/// turf of an unresolved helper -> direction it was facing
	var/list/dead_ends = list()
	/// Longest tunnel we're willing to carve
	var/carve_max_length = 14
	/// Used only if no neighbouring wall type can be sampled
	var/carve_wall_fallback = /turf/closed/mineral/bedrock

	/// Search gives up after expanding this many tiles
	var/carve_max_nodes = 800
	/// Paths costing more than this are discarded (roughly tunnel length)
	var/carve_max_cost = 40
	/// Extra cost for changing direction. Higher = straighter tunnels
	var/carve_turn_cost = 1.5
	/// Random per-step cost, makes tunnels meander instead of picking the same shape every time
	var/carve_wiggle = 0.6
	/// Extra cost for breaching an existing wall tile
	var/carve_wall_cost = 4
	/// Open tiles within this many steps of the dead end are its own hallway, not valid targets
	var/carve_exclude_depth = 8

/datum/controller/subsystem/dungeon_generator/Initialize(start_timeofday)

	while(length(markers))
		for(var/obj/effect/dungeon_directional_helper/helper as anything in markers)
			markers -= helper
			if(!get_turf(helper))
				marker_depths -= helper
				continue
			if(dungeon_z == -1)
				dungeon_z = helper.z // this shouldn't ever fail i think
			find_soulmate(helper.dir, get_turf(helper), helper)
			marker_depths -= helper

	carve_dead_ends()
	distribute_loot()
	return ..()

/datum/controller/subsystem/dungeon_generator/fire(resumed)
	if(!length(markers))
		// Generation finished loot is good to spawn now
		if(!loot_distributed)
			carve_dead_ends()
			distribute_loot()
		return

	var/current_run = 0
	for(var/obj/effect/dungeon_directional_helper/helper as anything in markers)
		if(current_run >= 4)
			return
		markers -= helper
		if(!get_turf(helper))
			marker_depths -= helper
			continue
		find_soulmate(helper.dir, get_turf(helper), helper)
		marker_depths -= helper
		if(TICK_CHECK_LOW)
			return
		current_run++

/datum/controller/subsystem/dungeon_generator/proc/setup_template_caches()
	if(!length(parent_types))
		for(var/datum/map_template/dungeon/path as anything in subtypesof(/datum/map_template/dungeon))
			if(!IS_ABSTRACT(path))
				continue
			if(!initial(path.type_weight))
				continue
			parent_types += path
			parent_types[path] = initial(path.type_weight)

	if(!length(created_types))
		for(var/datum/map_template/dungeon/path as anything in subtypesof(/datum/map_template/dungeon))
			if(IS_ABSTRACT(path))
				continue
			var/datum/map_template/dungeon/template = new path
			created_types[template] = template.rarity
		max_rarity = 1
		for(var/datum/map_template/dungeon/template in created_types)
			max_rarity = max(max_rarity, template.rarity || 1)

/// 0..1 for how far out a room is, based on room depth.
/// z_level is unused now that delve levels are gone, but kept so existing callers don't break.
/datum/controller/subsystem/dungeon_generator/proc/get_depth_factor(room_depth, z_level)
	return clamp(room_depth / max(depth_full_scale, 1), 0, 1)

/// Weight of a template at a given depth. 0 means it cannot appear here.
/// Common rooms (rarity == max_rarity) are unaffected; the rarer a room is, the more it
/// is suppressed near the start and boosted far out.
/datum/controller/subsystem/dungeon_generator/proc/get_depth_weight(datum/map_template/dungeon/template, room_depth, depth_factor)
	if(room_depth < template.min_depth)
		return 0
	var/base_weight = template.rarity || 1
	var/remoteness = 1 - clamp(base_weight / max_rarity, 0, 1)
	var/multiplier = 1 + rare_depth_strength * remoteness * ((depth_factor * 2) - 1)
	return base_weight * max(multiplier, 0.05)

/// Builds template -> weight.
/// only_picked = TRUE keeps just subtypes of picked_type; FALSE keeps everything except picked_type and entries.
/datum/controller/subsystem/dungeon_generator/proc/build_weighted_templates(room_depth, depth_factor, picked_type, only_picked, apply_depth = TRUE)
	var/list/result = list()
	for(var/datum/map_template/dungeon/template in created_types)
		if(only_picked)
			if(!istype(template, picked_type))
				continue
		else if(istype(template, picked_type))
			continue
		var/weight = template.rarity || 1
		if(apply_depth)
			weight = get_depth_weight(template, room_depth, depth_factor)
		weight *= get_occurrence_multiplier(template)
		if(weight <= 0)
			continue
		result[template] = weight
	return result

/// 0 once a template has hit its placement limit, otherwise a falloff based on how many times it's been placed.
/datum/controller/subsystem/dungeon_generator/proc/get_occurrence_multiplier(datum/map_template/dungeon/template)
	var/count = placed_types[template.type] || 0
	var/limit = template.unique ? 1 : template.max_occurrences
	if(limit && count >= limit)
		return 0
	if(template.repeat_falloff && count)
		return (1 - clamp(template.repeat_falloff, 0, 1)) ** count
	return 1

/// Weighted pick from an assoc list of thing -> numeric weight. Does not remove the result.
/datum/controller/subsystem/dungeon_generator/proc/pick_weighted_key(list/weighted)
	if(!length(weighted))
		return null
	var/total = 0
	for(var/key in weighted)
		total += weighted[key]
	var/chosen = rand() * total
	for(var/key in weighted)
		chosen -= weighted[key]
		if(chosen <= 0)
			return key
	return weighted[length(weighted)] ? weighted[length(weighted)] : null

/// Keeps drawing templates (without replacement) until one fits. Returns list(template, turf) or null.
/datum/controller/subsystem/dungeon_generator/proc/place_from_candidates(list/candidates, direction, turf/creator)
	while(length(candidates))
		var/datum/map_template/dungeon/template = pick_weighted_key(candidates)
		if(!template)
			return null
		candidates -= template

		var/turf/true_spawn = calculate_spawn_position(template, direction, creator)
		if(!true_spawn || !validate_spawn_area(template, true_spawn))
			continue

		if(!template.load(true_spawn))
			continue

		return list(template, true_spawn)
	return null

/// Bookkeeping after a room is loaded: counters, depth for its helpers, registration of its loot spawners.
/datum/controller/subsystem/dungeon_generator/proc/register_placed_room(datum/map_template/dungeon/template, turf/true_spawn, room_depth)
	placed_types |= template.type
	placed_types[template.type]++

	for(var/turf/room_turf in template.get_affected_turfs(true_spawn))
		for(var/obj/effect/dungeon_directional_helper/helper in room_turf)
			marker_depths[helper] = room_depth
		for(var/obj/effect/dungeon_loot_spawner/spawner in room_turf)
			spawner.depth = room_depth
			loot_spawners |= spawner
		for(var/obj/structure/waystone/dungeon/stone in room_turf)
			stone.depth = room_depth
			dungeon_waystones |= stone
		for(var/mob/living/mob in room_turf)
			if(mob.client)
				continue
			register_dungeon_mob(mob, room_depth)

/datum/controller/subsystem/dungeon_generator/proc/register_dungeon_mob(mob/living/mob, room_depth, turf/spawn_turf)
	var/datum/dungeon_mob_record/record = new
	record.mob_type = mob.type
	record.spawn_turf = spawn_turf || get_turf(mob)
	record.depth = room_depth
	mob_records[mob] = record
	RegisterSignal(mob, COMSIG_LIVING_DEATH, PROC_REF(on_dungeon_mob_gone))
	RegisterSignal(mob, COMSIG_QDELETING, PROC_REF(on_dungeon_mob_gone))

/// Handles both death and deletion (gibbing/qdel without dying). Extra signal args are ignored because of that.
/datum/controller/subsystem/dungeon_generator/proc/on_dungeon_mob_gone(mob/living/source)
	SIGNAL_HANDLER
	var/datum/dungeon_mob_record/record = mob_records[source]
	if(!record)
		return
	mob_records -= source
	UnregisterSignal(source, list(COMSIG_LIVING_DEATH, COMSIG_QDELETING))
	dead_records += record

/datum/controller/subsystem/dungeon_generator/proc/find_soulmate(direction, turf/creator, obj/effect/dungeon_directional_helper/looking_for_love)
	creator = get_step(creator, direction)
	if(!creator)
		return
	if(creator.type != /turf/closed/dungeon_void)
		return

	//depth of the room that owns this helper + 1
	var/room_depth = (marker_depths[looking_for_love] || 0) + 1
	var/depth_factor = get_depth_factor(room_depth, creator.z)

	switch(direction)
		if(NORTH)
			direction = SOUTH
		if(SOUTH)
			direction = NORTH
		if(EAST)
			direction = WEST
		if(WEST)
			direction = EAST

	setup_template_caches()

	var/picked_type = pickweight(parent_types)

	if(try_pickedtype_first(picked_type, direction, creator, looking_for_love, room_depth, depth_factor, FALSE))
		return

	// Fallback: anything that isn't the picked type or an entry, weighted by depth.
	if(!GET_TURF_ABOVE(creator))
		message_admins("[ADMIN_JMP(creator)] A dungeon piece was set to spawn on a top level z. This is not intended, there is a bad template.")
		return

	var/list/candidates = build_weighted_templates(room_depth, depth_factor, picked_type, FALSE, TRUE)
	var/list/placed = place_from_candidates(candidates, direction, creator)
	if(!placed)
		dead_ends[get_turf(looking_for_love)] = looking_for_love.dir
		return

	var/datum/map_template/dungeon/template = placed[1]
	var/turf/true_spawn = placed[2]
	register_placed_room(template, true_spawn, room_depth)

/datum/controller/subsystem/dungeon_generator/proc/carve_dead_ends()
	var/carved = 0
	for(var/turf/start as anything in dead_ends)
		var/dir = dead_ends[start]
		dead_ends -= start
		var/list/path = find_carve_path(start, dir)
		if(!length(path))
			continue
		carve_path(path, start, dir)
		carved++
		CHECK_TICK
	return carved

/// Tiles near the dead end that must not count as a destination (its own hallway and walls).
/datum/controller/subsystem/dungeon_generator/proc/get_carve_exclusion(turf/start)
	var/list/excluded = list()
	var/list/depth = list()
	var/list/queue = list(start)
	depth[start] = 0
	excluded[start] = TRUE
	var/head = 1
	while(head <= length(queue))
		var/turf/current = queue[head++]
		for(var/turf/wall in RANGE_TURFS(1, current))
			if(wall.density && wall.type != /turf/closed/dungeon_void)
				excluded[wall] = TRUE
		if(depth[current] >= carve_exclude_depth)
			continue
		for(var/step_dir in GLOB.cardinals)
			var/turf/next = get_step(current, step_dir)
			if(!next || excluded[next] || next.density || next.type == /turf/closed/dungeon_void)
				continue
			excluded[next] = TRUE
			depth[next] = depth[current] + 1
			queue += next
	return excluded

/// Cheapest path from the dead end to any walkable tile that isn't its own hallway.
/// Returns the turfs to carve (void and any breached wall), or null.
/datum/controller/subsystem/dungeon_generator/proc/find_carve_path(turf/start, dir)
	var/turf/first = get_step(start, dir)
	if(!first || first.type != /turf/closed/dungeon_void)
		return null

	var/list/excluded = get_carve_exclusion(start)
	var/list/cost = list()
	var/list/came_from = list()
	var/list/arrive_dir = list()
	var/list/walls_used = list()
	var/list/closed = list()
	var/list/open_set = list(first)
	cost[first] = 0
	came_from[first] = start
	arrive_dir[first] = dir
	walls_used[first] = 0
	var/expanded = 0

	while(length(open_set) && expanded < carve_max_nodes)
		// Pop the cheapest node (linear scan is fine at this size)
		var/turf/current = open_set[1]
		for(var/turf/candidate as anything in open_set)
			if(cost[candidate] < cost[current])
				current = candidate
		open_set -= current
		closed[current] = TRUE
		expanded++

		var/current_is_wall = current.density && current.type != /turf/closed/dungeon_void

		for(var/step_dir in GLOB.cardinals)
			var/turf/next = get_step(current, step_dir)
			if(!next || closed[next] || excluded[next])
				continue

			// Reached something walkable that isn't our own hallway: done.
			if(!next.density && next.type != /turf/closed/dungeon_void)
				var/list/path = list()
				var/turf/walker = current
				while(walker != start)
					path += walker
					walker = came_from[walker]
				return path

			var/next_is_void = (next.type == /turf/closed/dungeon_void)
			var/next_is_wall = next.density && !next_is_void
			if(!next_is_void && !next_is_wall)
				continue // doors, structures etc. that aren't open or dense: avoid
			if(current_is_wall && next_is_void)
				continue // once we start breaching a wall we must come out the other side
			var/walls = walls_used[current] + (next_is_wall ? 1 : 0)
			if(walls > 2)
				continue

			var/new_cost = cost[current] + 1 + rand() * carve_wiggle
			if(step_dir != arrive_dir[current])
				new_cost += carve_turn_cost
			if(next_is_wall)
				new_cost += carve_wall_cost
			if(new_cost > carve_max_cost)
				continue
			if(!isnull(cost[next]) && cost[next] <= new_cost)
				continue

			cost[next] = new_cost
			came_from[next] = current
			arrive_dir[next] = step_dir
			walls_used[next] = walls
			open_set |= next
	return null

/datum/controller/subsystem/dungeon_generator/proc/carve_path(list/path, turf/start, dir)
	var/floor_type = start.type // match the hallway's own floor
	var/wall_type = sample_wall_type(start, dir)

	// Gather first: ChangeTurf invalidates the old turf refs
	var/list/to_wall = list()
	for(var/turf/T as anything in path)
		for(var/step_dir in GLOB.alldirs)
			var/turf/neighbor = get_step(T, step_dir)
			if(neighbor?.type == /turf/closed/dungeon_void && !(neighbor in path))
				to_wall |= neighbor

	for(var/turf/T as anything in path)
		T.ChangeTurf(floor_type)
	for(var/turf/T as anything in to_wall)
		T.ChangeTurf(wall_type)

/datum/controller/subsystem/dungeon_generator/proc/sample_wall_type(turf/start, dir)
	for(var/turn_angle in list(90, -90))
		var/turf/side = get_step(start, turn(dir, turn_angle))
		if(side?.density && side.type != /turf/closed/dungeon_void)
			return side.type
	return carve_wall_fallback

/datum/controller/subsystem/dungeon_generator/proc/try_pickedtype_first(picked_type, direction, turf/creator, obj/effect/dungeon_directional_helper/looking_for_love, room_depth = 1, depth_factor = 0, special_pick = FALSE)
	var/list/candidates = build_weighted_templates(room_depth, depth_factor, picked_type, TRUE, !special_pick)
	var/list/placed = place_from_candidates(candidates, direction, creator)
	if(!placed)
		return FALSE

	var/datum/map_template/dungeon/template = placed[1]
	var/turf/true_spawn = placed[2]

	register_placed_room(template, true_spawn, room_depth)

	return TRUE

/datum/controller/subsystem/dungeon_generator/proc/calculate_spawn_position(datum/map_template/dungeon/template, direction, turf/creator)
	var/turf/true_spawn
	switch(direction)
		if(WEST)
			if(!template.west_offset)
				return null
			if(creator.y - template.west_offset < 0)
				return null
			var/turf/turf = locate(creator.x, creator.y - template.west_offset, creator.z)
			if(turf?.type != /turf/closed/dungeon_void)
				return null
			var/turf/turf2 = locate(creator.x + template.width, creator.y - template.east_offset, creator.z)
			if(turf2?.type != /turf/closed/dungeon_void)
				return null
			true_spawn = get_offset_target_turf(creator, 0, -(template.west_offset))

		if(NORTH)
			if(!template.north_offset)
				return null
			if(creator.x - template.north_offset < 0)
				return null
			if(creator.y - template.height < 0)
				return null
			var/turf/turf = locate(creator.x - template.north_offset - 1, creator.y + template.height, creator.z)
			if(turf?.type != /turf/closed/dungeon_void)
				return null
			var/turf/turf2 = locate(creator.x -(template.north_offset - 1) + template.width, creator.y + template.height, creator.z)
			if(turf2?.type != /turf/closed/dungeon_void)
				return null
			true_spawn = get_offset_target_turf(creator, -(template.north_offset), -(template.height-1))

		if(SOUTH)
			if(!template.south_offset)
				return null
			if(creator.y - template.south_offset < 0)
				return null
			var/turf/turf = locate(creator.x, creator.y + template.height, creator.z)
			if(turf?.type != /turf/closed/dungeon_void)
				return null
			var/turf/turf2 = locate(creator.x + template.width - template.south_offset, creator.y + template.height, creator.z)
			if(turf2?.type != /turf/closed/dungeon_void)
				return null
			true_spawn = get_offset_target_turf(creator, -template.south_offset, 0)

		if(EAST)
			if(!template.east_offset)
				return null
			if(creator.y - template.east_offset < 0)
				return null
			if(creator.x - template.width < 0)
				return null
			var/turf/turf = locate(creator.x - (template.width-1), creator.y - template.east_offset, creator.z)
			if(turf?.type != /turf/closed/dungeon_void)
				return null
			var/turf/turf2 = locate(creator.x, creator.y - template.east_offset, creator.z)
			if(turf2?.type != /turf/closed/dungeon_void)
				return null
			true_spawn = get_offset_target_turf(creator, -(template.width-1), -template.east_offset)

	return true_spawn

/datum/controller/subsystem/dungeon_generator/proc/validate_spawn_area(datum/map_template/dungeon/template, turf/true_spawn)
	if(true_spawn.x + template.width > world.maxx)
		return FALSE
	if(true_spawn.y + template.height > world.maxy)
		return FALSE

	var/list/turfs = template.get_affected_turfs(true_spawn)
	for(var/turf/list_turf in turfs)
		if(list_turf.type != /turf/closed/dungeon_void)
			return FALSE
	return TRUE

/// Spreads loot_budget across the registered spawners. Spawners are never deleted, they just
/// stop accepting items once full, so this can be re-run after clear_loot().
/// Returns the total loot value placed this run.
/datum/controller/subsystem/dungeon_generator/proc/distribute_loot()
	loot_distributed = TRUE
	loot_remaining = loot_budget

	var/list/candidates = list()
	for(var/obj/effect/dungeon_loot_spawner/spawner as anything in loot_spawners)
		if(QDELETED(spawner) || !spawner.can_accept_loot())
			continue
		candidates[spawner] = spawner.spawn_weight * (1 + get_depth_factor(spawner.depth, spawner.z) * loot_depth_bias)

	while(loot_remaining > 0 && length(candidates))
		var/obj/effect/dungeon_loot_spawner/spawner = pick_weighted_key(candidates)
		if(!spawner)
			break
		// Item has to fit both the spawner's remaining capacity and what's left of the global budget.
		var/item_path = spawner.pick_loot(min(loot_remaining, spawner.get_remaining_value()))
		if(!item_path)
			candidates -= spawner
			continue
		loot_remaining -= spawner.spawn_loot(item_path)
		if(!spawner.can_accept_loot())
			candidates -= spawner
		CHECK_TICK

	var/spent = loot_budget - loot_remaining
	log_world("Dungeon loot distributed: [spent]/[loot_budget] value across [length(loot_spawners)] spawners.")
	return spent

///Reset every spawner's used value and hand out a fresh budget. Should probably only ever be used for debugging/events?
/datum/controller/subsystem/dungeon_generator/proc/regenerate_loot()
	for(var/obj/effect/dungeon_loot_spawner/spawner as anything in loot_spawners)
		if(QDELETED(spawner))
			loot_spawners -= spawner
			continue
		spawner.used_value = 0
		spawner.used_items = 0
	return distribute_loot()

/datum/controller/subsystem/dungeon_generator/proc/get_random_dungeon_waystone()
	var/list/weighted = list()
	for(var/obj/structure/waystone/dungeon/stone as anything in dungeon_waystones)
		if(QDELETED(stone))
			continue
		var/factor = get_depth_factor(stone.depth, stone.z)
		weighted[stone] = max(0.1, 1 - abs(factor - 0.5) * 2)
	return pick_weighted_key(weighted)

/// Respawns dead dungeon mobs. Returns how many were respawned.
/// amount          - flat number of mobs to respawn
/// percent         - optional, 0-100: percent of the dead pool to respawn (overrides amount if set)
/// player_range    - spawn points with a living player within this many tiles (same z) are skipped
/// depth_weighting - RESPAWN_WEIGHT_NONE / _SHALLOW / _DEEP, which records get picked first
/datum/controller/subsystem/dungeon_generator/proc/respawn_mobs(amount = 0, percent = null, player_range = 10, depth_weighting = RESPAWN_WEIGHT_NONE)
	var/pool = length(dead_records)
	if(!pool)
		return 0

	var/to_spawn = amount
	if(!isnull(percent))
		to_spawn = CEILING(pool * clamp(percent, 0, 100) / 100, 1)
	to_spawn = min(to_spawn, pool)
	if(to_spawn <= 0)
		return 0

	// Snapshot living players once instead of per record
	var/list/living_players = list()
	for(var/mob/living/player in GLOB.player_list)
		if(player.client && player.stat != DEAD)
			living_players += player

	// Build the eligible set with a weight per record
	var/list/candidates = list()
	for(var/datum/dungeon_mob_record/record as anything in dead_records)
		var/turf/spawn_turf = record.spawn_turf
		if(!spawn_turf || spawn_turf.density)
			continue
		if(player_near_turf(spawn_turf, player_range, living_players))
			continue
		candidates[record] = get_respawn_weight(record, depth_weighting)

	var/respawned = 0
	while(respawned < to_spawn && length(candidates))
		var/datum/dungeon_mob_record/record = pick_weighted_key(candidates)
		if(!record)
			break
		candidates -= record

		var/turf/spawn_turf = record.spawn_turf
		var/mob/living/new_mob = new record.mob_type(spawn_turf)
		dead_records -= record
		register_dungeon_mob(new_mob, record.depth, spawn_turf)

		qdel(record)
		respawned++
		CHECK_TICK
	return respawned

/datum/controller/subsystem/dungeon_generator/proc/player_near_turf(turf/target, range, list/players)
	for(var/mob/living/player as anything in players)
		if(player.z != target.z)
			continue
		if(get_dist(player, target) <= range)
			return TRUE
	return FALSE

/// Weight of a dead record for respawn picking. Uses the same depth factor as room/loot generation.
/// The 0.1 floor keeps the unfavored end possible.
/datum/controller/subsystem/dungeon_generator/proc/get_respawn_weight(datum/dungeon_mob_record/record, depth_weighting)
	switch(depth_weighting)
		if(RESPAWN_WEIGHT_SHALLOW)
			return 0.1 + (1 - get_depth_factor(record.depth, record.spawn_turf.z))
		if(RESPAWN_WEIGHT_DEEP)
			return 0.1 + get_depth_factor(record.depth, record.spawn_turf.z)
	return 1
