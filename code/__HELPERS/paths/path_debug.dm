#define CHEBYSHEV "Chebyshev - get_dist"
#define EUCLIDEAN "Euclidean - get_dist_euclidean"
#define MANHATTAN "Manhattan - get_dist_manhattan"
#define OCTILE "Octile - get_dist_octile - Experimental"

/obj/item/pathfinding_stick
	name = "Pathfinder stick"
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "stick1"

	var/static/list/callbacks = list(
		CHEBYSHEV = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(_get_dist)),
		EUCLIDEAN = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(get_dist_euclidean)),
		MANHATTAN = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(get_dist_manhattan)),
		OCTILE = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(get_dist_octile)),
	)
	var/selected = CHEBYSHEV
	var/diagonals = TRUE

/obj/item/pathfinding_stick/examine(mob/user)
	. = ..()
	. += "It's set to [selected]."
	. += "It's [diagonals ? "" : "not"] using diagonals."

/obj/item/pathfinding_stick/attack_self(mob/user, list/modifiers)
	. = ..()

	var/heuristic = tgui_input_list(user, "Select heuristic", "Pathfinder", callbacks)
	if(!heuristic)
		return

	selected = heuristic

/obj/item/pathfinding_stick/attack_self_secondary(mob/user, list/modifiers)
	. = ..()
	diagonals = !diagonals

	balloon_alert(user, "[diagonals ? "" : "not"] using diagonals.")

/obj/item/pathfinding_stick/afterattack(atom/target, mob/living/user, proximity_flag, list/modifiers)
	. = ..()

	if(proximity_flag || !target)
		return

	start_pathing(user, target)

/obj/item/pathfinding_stick/proc/start_pathing(mob/living/user, atom/target)
	var/datum/callback/path_heuristic = callbacks[selected]

	var/time = world.timeofday

	var/list/path = SSpathfinder.astar_pathfind_now(user, target, 100, 0, null, null, FALSE, diagonals, path_heuristic)

	if(!length(path))
		to_chat(user, span_alert("Pathfinding could not be completed."))
		return

	to_chat(user, span_info("Path length [length(path)] took [DS2MS(world.timeofday - time)] ms to complete."))

	var/static/list/images

	LAZYINITLIST(images)
	if(length(images))
		for(var/image/I as anything in images)
			user.client.images -= I

	for(var/index in 1 to length(path))
		var/turf/current_turf = path[index]
		var/image/path_display
		if(index == 1)
			path_display = image('icons/turf/floors.dmi', current_turf, "pure_white")
			path_display.plane = ABOVE_LIGHTING_PLANE
			path_display.alpha = 200
			path_display.color = "#FF0000"
			path_display.layer = 2 // Render above whiteness, but below maptext.

		else if(index == length(path))
			path_display = image('icons/turf/floors.dmi', current_turf, "pure_white")
			path_display.plane = ABOVE_LIGHTING_PLANE
			path_display.alpha = 200
			path_display.color = "#00FF00"
			path_display.layer = 2 // Render above whiteness, but below maptext.

		else
			path_display = image('icons/effects/navigation.dmi', current_turf)
			path_display.plane = ABOVE_LIGHTING_PLANE
			path_display.color = COLOR_BLUE //So it stands out better against the white.
			path_display.alpha = 200

			var/turf/turf_ahead = path[index+1]
			var/turf/turf_behind = path[index-1]
			var/dir_1 = 0
			var/dir_2 = 0

			dir_1 = turn(angle2dir(get_angle(turf_ahead, current_turf)), 180)
			dir_2 = turn(angle2dir(get_angle(turf_behind, current_turf)), 180)
			if(dir_1 > dir_2)
				dir_1 = dir_2
				dir_2 = turn(angle2dir(get_angle(turf_ahead, current_turf)), 180)

			path_display.icon_state = "[dir_1]-[dir_2]"
#ifndef DEBUG_PATHFINDING //Disables this for hygiene.
			path_display.maptext = MAPTEXT("[index]---[get_dist_euclidean(current_turf, target)]")
#else
			path_display.alpha = 255 //Make it solid if we're doing debug rendering.
			path_display.layer = 2 // Render above whiteness, but below maptext.
#endif


		images += path_display
		user.client.images += path_display

/obj/item/pathfinding_stick/proc/generate_path(mob/living/user, atom/target, datum/callback/path_heuristic, include_diagonals)

