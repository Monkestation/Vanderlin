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

	var/multilevel_dungeons = FALSE  // Toggle for multi-level generation
	var/max_delve_levels = 2        // Maximum dungeon depth
	var/list/dungeon_levels = list() // Track z-levels for each delve level
	var/list/delve_entries = list()  // Pre-generated entry points for each level
	var/list/delve_descent = list()  // Pre-generated entry points for each level

	var/list/descent_objects = list() // Track descent objects by level
	var/list/level_entries = list()   // Track all entries by delve level

	var/created_since = 0
	var/descent_since = 0
	var/unlinked_dungeon_length = 0

/datum/controller/subsystem/dungeon_generator/Initialize(start_timeofday)
	unlinked_dungeon_length = length(GLOB.unlinked_dungeon_entries)

	if(multilevel_dungeons)
		setup_multilevel_dungeons()

	while(length(markers))
		for(var/obj/effect/dungeon_directional_helper/helper as anything in markers)
			if(!get_turf(helper))
				continue
			if(dungeon_z == -1)
				dungeon_z = helper.z // this shouldn't ever fail i think
			find_soulmate(helper.dir, get_turf(helper), helper)
			markers -= helper
	return ..()

/datum/controller/subsystem/dungeon_generator/proc/setup_multilevel_dungeons()
	for(var/level = 1; level <= max_delve_levels; level++)
		delve_entries["[level]"] = rand(2, 4)
		delve_descent["[level]"] = rand(2, 4)
		dungeon_levels["[level]"] = list()

/datum/controller/subsystem/dungeon_generator/fire(resumed)
	var/current_run = 0
	if(length(markers))
		for(var/obj/effect/dungeon_directional_helper/helper as anything in markers)
			if(current_run >= 4)
				return
			if(!get_turf(helper))
				continue
			find_soulmate(helper.dir, get_turf(helper), helper)
			markers -= helper
			if(TICK_CHECK_LOW)
				return
			current_run++

/datum/controller/subsystem/dungeon_generator/proc/find_soulmate(direction, turf/creator, obj/effect/dungeon_directional_helper/looking_for_love)
	creator = get_step(creator, direction)
	if(!creator)
		return
	if(creator.type != /turf/closed/dungeon_void)
		return

	// Determine current delve level
	var/current_delve_level = get_delve_level(creator.z)

	switch(direction)
		if(NORTH)
			direction = SOUTH
		if(SOUTH)
			direction = NORTH
		if(EAST)
			direction = WEST
		if(WEST)
			direction = EAST

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

	var/picked_type = pickweight(parent_types)
	var/picking = TRUE

	// Handle multi-level dungeon logic
	if(multilevel_dungeons && current_delve_level > 0)
		// Check if we should spawn a descent
		if(descent_since > 30)
			if(should_spawn_descent(current_delve_level))
				picked_type = /datum/map_template/dungeon/descent
		// Modify entry spawn chance based on remaining entries for this level
		else if(unlinked_dungeon_length > 0 && delve_entries["[current_delve_level]"] > 0)
			if(created_since > 30)
				if(prob(10 + created_since))
					picked_type = /datum/map_template/dungeon/entry
	else if(unlinked_dungeon_length > 0)
		if(created_since > 30)
			if(prob(10 + created_since))
				picked_type = /datum/map_template/dungeon/entry

	if(!try_pickedtype_first(picked_type, direction, creator, looking_for_love, current_delve_level))
		var/list/true_list = created_types.Copy()
		// inlining pickweight here to make it faster
		// since we want to avoid re-totaling it
		var/true_total = 0
		for(var/datum/map_template/dungeon/template in true_list)
			if(istype(template, picked_type) || istype(template, /datum/map_template/dungeon/entry))
				true_list -= template
				continue
			if(!true_list[template])
				true_list[template] = 1
			true_total += true_list[template]
		while(picking)
			if(!GET_TURF_ABOVE(creator))
				message_admins("[ADMIN_JMP(creator)] A dungeon piece was set to spawn on a top level z. This is not intended, there is a bad template.")
				return
			if(!length(true_list))
				return
			var/chosen = rand(1, true_total)
			var/datum/map_template/dungeon/template
			for(template in true_list)
				chosen -= true_list[template]
				if(chosen <= 0)
					break // go with template
			true_total -= true_list[template]
			true_list -= template

			var/turf/true_spawn = calculate_spawn_position(template, direction, creator)
			if(!true_spawn || !validate_spawn_area(template, true_spawn))
				continue

			if(!template.load(true_spawn))
				continue

			picking = FALSE
			placed_types |= template.type
			placed_types[template.type]++
			created_since++
			descent_since++

			// Apply delve modifiers if multi-level dungeons are enabled
			if(multilevel_dungeons && current_delve_level > 0)
				enhance_dungeon_area(template, true_spawn, current_delve_level)

/datum/controller/subsystem/dungeon_generator/proc/try_pickedtype_first(picked_type, direction, turf/creator, obj/effect/dungeon_directional_helper/looking_for_love, delve_level = 0)
	var/picking = TRUE
	var/list/true_list = created_types.Copy()

	// inlining pickweight here to make it faster
	// since we want to avoid re-totaling it
	var/true_total = 0
	for(var/datum/map_template/dungeon/template in true_list)
		if(!istype(template, picked_type))
			true_list -= template
			continue
		if(!true_list[template])
			true_list[template] = 1
		true_total += true_list[template]
	while(picking)
		if(!length(true_list))
			return FALSE
		var/chosen = rand(1, true_total)
		var/datum/map_template/dungeon/template
		for(template in true_list)
			chosen -= true_list[template]
			if(chosen <= 0)
				break // go with template
		true_total -= true_list[template]
		true_list -= template

		var/turf/true_spawn = calculate_spawn_position(template, direction, creator)
		if(!true_spawn || !validate_spawn_area(template, true_spawn))
			continue

		if(!template.load(true_spawn))
			continue

		picking = FALSE
		created_since++
		placed_types |= template.type
		placed_types[template.type]++

		// Handle special cases for multi-level dungeons
		if(multilevel_dungeons)
			if(picked_type == /datum/map_template/dungeon/entry && delve_level > 0)
				delve_entries["[delve_level]"]--

		if(picked_type == /datum/map_template/dungeon/entry)
			created_since = 0
			unlinked_dungeon_length--

		if(picked_type == /datum/map_template/dungeon/descent)
			descent_since = 0
			delve_descent["[delve_level]"]--

		// Apply delve modifiers if multi-level dungeons are enabled
		if(multilevel_dungeons && delve_level > 0)
			enhance_dungeon_area(template, true_spawn, delve_level)

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

/datum/controller/subsystem/dungeon_generator/proc/get_delve_level(z_level)
	// Each delve level spans 2 z-levels
	// Returns 0 for surface/non-dungeon levels
	if(!multilevel_dungeons)
		return

	return SSmapping.get_delve(z_level)

/datum/controller/subsystem/dungeon_generator/proc/should_spawn_descent(current_level)
	if(!multilevel_dungeons)
		return FALSE
	if(current_level >= max_delve_levels) // No descents on the last level
		return FALSE
	if(delve_descent["[current_level]"] <= 0) // No more entries needed for next level
		return FALSE

	// Chance to spawn a descent - higher chance later in generation
	return prob(15 + (descent_since * 2))

/datum/controller/subsystem/dungeon_generator/proc/enhance_dungeon_area(datum/map_template/dungeon/template, turf/spawn_location, delve_level)
	if(!multilevel_dungeons || delve_level <= 0)
		return

	var/list/affected_turfs = template.get_affected_turfs(spawn_location)

	// Find and enhance all mobs in the area
	for(var/turf/T in affected_turfs)
		for(var/mob/M in T.contents)
			if(isliving(M))
				SSmobs.enhance_mob(M, delve_level)


/datum/map_template/dungeon/entry/load(turf/T, centered)
	. = ..()
	if(!.)
		return FALSE

	// Find and configure any exit objects in the loaded template
	var/list/turfs = get_affected_turfs(T, centered)
	for(var/turf/turf in turfs)
		for(var/obj/structure/dungeon_exit/descent in turf.contents)
			var/delve_level = SSdungeon_generator.get_delve_level(turf.z)
			if(delve_level > 0)
				descent.delve_level = delve_level

				// Register this exit
				if(!SSdungeon_generator.level_entries[delve_level])
					SSdungeon_generator.level_entries[delve_level] = list()
				SSdungeon_generator.level_entries[delve_level] += descent

			break // Only handle the first descent found
	return TRUE
