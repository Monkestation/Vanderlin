/datum/map_template/matthios_fragment
	name = "Matthios Fragment"
	id = "matthios_fragment"
	width = 15
	height = 15
	mappath = "_maps/templates/voyager_features/matthios_fragment.dmm"

/datum/cave_generator/matthios_fragment
	wall_turf = /turf/closed/dungeon_void
	var/datum/map_template/fragment_template_path
	feature_attempts = 0
	lava_river_count = 0

/datum/cave_generator/matthios_fragment/New(datum/cave_biome/selected_biome, sx = 100, sy = 100)
	..(selected_biome, sx, sy)

	fragment_template_path = new /datum/map_template/matthios_fragment()

/datum/cave_generator/matthios_fragment/generate_deferred(turf/bottom_left_corner, datum/controller/subsystem/terrain_generation/subsystem, datum/terrain_generation_job/job)
	set waitfor = FALSE

	if(!bottom_left_corner)
		return FALSE

	var/start_x = bottom_left_corner.x
	var/start_y = bottom_left_corner.y
	var/start_z = bottom_left_corner.z

	// Phase 1: Fill both levels with void
	var/tiles_processed = 0
	var/total_tiles = size_x * size_y * 2

	// Fill lower level
	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to size_y - 1)
			var/turf/T = locate(start_x + x, start_y + y, start_z)
			if(T)
				T.ChangeTurf(/turf/closed/dungeon_void)

			tiles_processed++
			if(tiles_processed % 200 == 0)
				if(job)
					job.progress = (tiles_processed / total_tiles) * 50 // 0-50% for filling
				CHECK_TICK

	// Fill upper level
	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to size_y - 1)
			var/turf/T = locate(start_x + x, start_y + y, start_z + 1)
			if(T)
				T.ChangeTurf(/turf/closed/dungeon_void)

			tiles_processed++
			if(tiles_processed % 200 == 0)
				if(job)
					job.progress = (tiles_processed / total_tiles) * 50 // 0-50% for filling
				CHECK_TICK

	// Phase 2: Place single template on lower level using Poisson sampling
	if(fragment_template_path)
		var/placed = FALSE
		var/template_width = fragment_template_path.width
		var/template_height = fragment_template_path.height

		var/max_x = size_x - template_width
		var/max_y = size_y - template_height

		if(max_x > 0 && max_y > 0)
			var/list/samples = cave_noise.poisson_disk_sampling(0, max_x, 0, max_y, 10) // min_radius of 10
			for(var/list/sample in samples)
				if(placed)
					break

				var/sx = round(sample[1])
				var/sy = round(sample[2])

				var/turf/spawn_loc = locate(start_x + sx, start_y + sy, start_z)
				if(spawn_loc && fragment_template_path.load(spawn_loc, centered = FALSE))
					placed = TRUE
					break

				CHECK_TICK

	if(job)
		job.progress = 100

	return TRUE

/datum/cave_generator/matthios_fragment/generate(turf/bottom_left_corner)
	if(!bottom_left_corner)
		return FALSE

	var/start_x = bottom_left_corner.x
	var/start_y = bottom_left_corner.y
	var/start_z = bottom_left_corner.z

	// Fill lower level with void
	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to size_y - 1)
			var/turf/T = locate(start_x + x, start_y + y, start_z)
			if(T)
				T.ChangeTurf(/turf/closed/dungeon_void)

	// Fill upper level with void
	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to size_y - 1)
			var/turf/T = locate(start_x + x, start_y + y, start_z + 1)
			if(T)
				T.ChangeTurf(/turf/closed/dungeon_void)

	if(fragment_template_path)
		var/placed = FALSE
		var/template_width = fragment_template_path.width
		var/template_height = fragment_template_path.height

		var/max_x = size_x - template_width
		var/max_y = size_y - template_height

		if(max_x > 0 && max_y > 0)
			var/list/samples = cave_noise.poisson_disk_sampling(0, max_x, 0, max_y, 10)

			// Try each sample point until we successfully place the template on lower level
			for(var/list/sample in samples)
				if(placed)
					break

				var/sx = round(sample[1])
				var/sy = round(sample[2])

				var/turf/spawn_loc = locate(start_x + sx, start_y + sy, start_z)
				if(spawn_loc && fragment_template_path.load(spawn_loc, centered = FALSE))
					placed = TRUE
					break

	return TRUE

GLOBAL_LIST_INIT(island_descents, list())
GLOBAL_LIST_INIT(island_ascents, list())

/obj/structure/island_descent
	name = "Descent into Darkness"
	desc = "A passage leading deeper into the fragment. The way down is treacherous."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "shitportal"
	density = TRUE
	anchored = TRUE
	appearance_flags = NONE
	obj_flags = INDESTRUCTIBLE

	var/obj/structure/island_ascent/linked_ascent
	var/island_id // Will be set based on z-level or island identifier
	var/can_descend = TRUE
	var/list/descent_requirements = list()
	var/requires_all = FALSE

/obj/structure/island_descent/Initialize()
	. = ..()
	var/datum/island_data/my_island = SSterrain_generation.get_island_at_location(get_turf(src))
	if(!my_island)
		return

	island_id = my_island.island_id

	GLOB.island_descents |= src
	if(LAZYACCESS(descent_requirements, "Time"))
		GLOB.TodUpdate += src
	return INITIALIZE_HINT_LATELOAD

/obj/structure/island_descent/LateInitialize()
	. = ..()
	// Find matching ascent on the same island
	for(var/obj/structure/island_ascent/ascent as anything in GLOB.island_ascents)
		if(ascent.island_id == island_id)
			linked_ascent = ascent
			ascent.linked_descent = src
			break

/obj/structure/island_descent/Destroy()
	GLOB.island_descents -= src
	if(linked_ascent)
		linked_ascent.linked_descent = null
		linked_ascent = null
	if(LAZYACCESS(descent_requirements, "Time"))
		GLOB.TodUpdate -= src
	return ..()

/obj/structure/island_descent/update_tod(todd)
	if(todd == descent_requirements["Time"])
		can_descend = TRUE
	else if(descent_requirements["Time"])
		can_descend = FALSE

/obj/structure/island_descent/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	use(user)

/obj/structure/island_descent/attackby(obj/item/W, mob/user, params)
	return use(user)

/obj/structure/island_descent/attack_ghost(mob/dead/observer/user)
	use(user, TRUE)
	return ..()

/obj/structure/island_descent/proc/use(mob/user, is_ghost = FALSE)
	if(!attempt_descent(user, is_ghost))
		return

	if(!linked_ascent)
		to_chat(user, span_warning("The passage leads nowhere..."))
		return

	if(!is_ghost)
		to_chat(user, span_notice("You descend into the depths..."))
		playsound(src, 'sound/foley/ladder.ogg', 100, FALSE)
		if(!do_after(user, 3 SECONDS, src))
			return

	movable_travel_z_level(user, get_turf(linked_ascent))

/obj/structure/island_descent/proc/attempt_descent(mob/user, is_ghost = FALSE)
	if(!is_ghost && !can_descend)
		to_chat(user, span_warning("The passage seems blocked."))
		return FALSE

	if(descent_requirements && !is_ghost)
		if(!has_requirements(user))
			return FALSE

	return TRUE

/obj/structure/island_descent/proc/has_requirements(mob/user)
	if(!length(descent_requirements))
		return TRUE

	var/requirements_met = 0
	var/time_req = LAZYACCESS(descent_requirements, "Time")
	if(time_req && GLOB.tod == time_req)
		requirements_met++

	if(!requires_all && requirements_met > 0)
		return TRUE

	if(requirements_met < length(descent_requirements))
		to_chat(user, span_warning("You cannot descend yet."))
		return FALSE

	return TRUE

/obj/structure/island_ascent
	name = "Ascent to Surface"
	desc = "A passage leading back up to the surface. Fresh air flows from above."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "shitportal"
	density = TRUE
	anchored = TRUE
	appearance_flags = NONE
	obj_flags = INDESTRUCTIBLE

	var/obj/structure/island_descent/linked_descent
	var/island_id // Will be set based on z-level or island identifier
	var/can_ascend = TRUE
	var/list/ascent_requirements = list()
	var/requires_all = FALSE

/obj/structure/island_ascent/Initialize()
	. = ..()
	var/datum/island_data/my_island = SSterrain_generation.get_island_at_location(get_turf(src))
	if(!my_island)
		return

	island_id = my_island.island_id

	GLOB.island_ascents |= src
	if(LAZYACCESS(ascent_requirements, "Time"))
		GLOB.TodUpdate += src
	return INITIALIZE_HINT_LATELOAD

/obj/structure/island_ascent/LateInitialize()
	. = ..()
	// Find matching descent on the same island
	for(var/obj/structure/island_descent/descent as anything in GLOB.island_descents)
		if(descent.island_id == island_id)
			linked_descent = descent
			descent.linked_ascent = src
			break

/obj/structure/island_ascent/Destroy()
	GLOB.island_ascents -= src
	if(linked_descent)
		linked_descent.linked_ascent = null
		linked_descent = null
	if(LAZYACCESS(ascent_requirements, "Time"))
		GLOB.TodUpdate -= src
	return ..()

/obj/structure/island_ascent/update_tod(todd)
	if(todd == ascent_requirements["Time"])
		can_ascend = TRUE
	else if(ascent_requirements["Time"])
		can_ascend = FALSE

/obj/structure/island_ascent/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	use(user)

/obj/structure/island_ascent/attackby(obj/item/W, mob/user, params)
	return use(user)

/obj/structure/island_ascent/attack_ghost(mob/dead/observer/user)
	use(user, TRUE)
	return ..()

/obj/structure/island_ascent/proc/use(mob/user, is_ghost = FALSE)
	if(!attempt_ascent(user, is_ghost))
		return

	if(!linked_descent)
		to_chat(user, span_warning("The passage leads nowhere..."))
		return

	if(!is_ghost)
		to_chat(user, span_notice("You ascend back to the surface..."))
		playsound(src, 'sound/foley/ladder.ogg', 100, FALSE)
		if(!do_after(user, 3 SECONDS, src))
			return

	movable_travel_z_level(user, get_turf(linked_descent))

/obj/structure/island_ascent/proc/attempt_ascent(mob/user, is_ghost = FALSE)
	if(!is_ghost && !can_ascend)
		to_chat(user, span_warning("The passage seems blocked."))
		return FALSE

	if(ascent_requirements && !is_ghost)
		if(!has_requirements(user))
			return FALSE

	return TRUE

/obj/structure/island_ascent/proc/has_requirements(mob/user)
	if(!length(ascent_requirements))
		return TRUE

	var/requirements_met = 0
	var/time_req = LAZYACCESS(ascent_requirements, "Time")
	if(time_req && GLOB.tod == time_req)
		requirements_met++

	if(!requires_all && requirements_met > 0)
		return TRUE

	if(requirements_met < length(ascent_requirements))
		to_chat(user, span_warning("You cannot ascend yet."))
		return FALSE

	return TRUE
