/mob/camera/strategy_controller
	name = "Strategy Controller"
	real_name = "Strategy Controller"
	desc = "The overmind. It controls the kobolds."
	icon = 'icons/mob/cameramob.dmi'
	icon_state = "yalp_elor"
	mouse_opacity = MOUSE_OPACITY_ICON
	invisibility = INVISIBILITY_OBSERVER
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	sight = (SEE_TURFS|SEE_MOBS|SEE_OBJS)
	see_invisible = SEE_INVISIBLE_LIVING
	uses_intents = FALSE
	lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
	pass_flags = PASSCLOSEDTURF | PASSMOB | PASSTABLE
	next_move_modifier = 0
	var/datum/antagonist/overlord/linked_overlord

	var/list/worker_mobs = list()
	var/list/dead_workers = list()

	var/datum/stockpile/resource_stockpile
	var/datum/stockpile_requests/requests

	var/list/possible_job_actions = list()

	var/list/in_progress_workorders = list()
	var/list/building_requests = list()

	var/list/constructed_building_nodes = list()

	var/atom/movable/screen/controller_ui/controller_ui/displayed_mob_ui
	var/atom/movable/screen/strategy_ui/controller_ui/displayed_base_ui

	var/atom/movable/screen/gear_menu_backdrop/gear_ui
	var/atom/movable/screen/worker_inventory_backdrop/inventory_ui
	var/atom/movable/screen/building_backdrop/building_icon

	var/datum/building_datum/held_build

	var/worker_type = /mob/living/simple_animal/hostile/retaliate/fae/sprite

	var/break_turf_mode = FALSE
	var/turf/break_start_turf = null
	var/move_structure_mode = FALSE
	var/obj/structure/selected_structure = null
	var/list/mob/mobs_with_patrol_visuals = list()

/mob/camera/strategy_controller/Initialize()
	. = ..()
	displayed_base_ui = new(null, hud_used)
	building_icon = new(null, hud_used)
	START_PROCESSING(SSstrategy_master, src)

/mob/camera/strategy_controller/proc/open_gear_ui(obj/effect/building_node/node)
	if(!gear_ui)
		gear_ui = new(null, hud_used)
	gear_ui.open_ui(src, node)

/mob/camera/strategy_controller/proc/close_gear_ui()
	if(gear_ui)
		gear_ui.close_uis(src)

/mob/camera/strategy_controller/proc/open_inventory_ui(datum/worker_mind/worker)
	if(!inventory_ui)
		inventory_ui = new(null, hud_used)
	inventory_ui.open_ui(src, worker)
	RegisterSignal(displayed_mob_ui.worker_mind, COMSIG_WORKER_GEAR_CHANGED, PROC_REF(update_inventory))

/mob/camera/strategy_controller/proc/update_inventory()
	close_inventory_ui()
	open_inventory_ui(displayed_mob_ui.worker_mind)

/mob/camera/strategy_controller/proc/close_inventory_ui()
	if(inventory_ui)
		inventory_ui.close_uis(src)
		UnregisterSignal(displayed_mob_ui.worker_mind, COMSIG_WORKER_GEAR_CHANGED)

/mob/camera/strategy_controller/proc/close_building_ui()
	building_icon.close_uis(src)

/mob/camera/strategy_controller/proc/add_assignments(list/assignments)
	possible_job_actions |= assignments

/mob/camera/strategy_controller/proc/add_new_worker(mob/living/worker)
	worker_mobs |= worker

/mob/camera/strategy_controller/proc/create_new_worker_mob(atom/spawn_loc)
	var/turf/turf = get_turf(spawn_loc)
	var/mob/living/new_mob = new worker_type(turf)
	new_mob.controller_mind = new(new_mob, src)
	new_mob.faction |= "overlord"

/mob/camera/strategy_controller/proc/try_setup_build(datum/building_datum/building)
	if(held_build)
		held_build.clean_up(success = FALSE)

	var/datum/building_datum/build = new building(src)
	build.setup_building_ghost()

/mob/camera/strategy_controller/proc/queue_building_build(datum/building_datum/building, turf/source_turf)
	new building(src, source_turf)

/mob/camera/strategy_controller/ClickOn(atom/A, params)
	var/list/modifiers = params2list(params)

	var/mob/living/patrol_mob = find_active_patrol_setup_mob()
	if(patrol_mob)
		handle_patrol_setup_click(A, modifiers, patrol_mob)
		return

	if(break_turf_mode)
		handle_break_turf_click(A, modifiers)
		return

	if(move_structure_mode)
		handle_move_structure_click(A, modifiers)
		return

	if(LAZYACCESS(modifiers, LEFT_CLICK) && get_turf(A))
		if(held_build)
			if(held_build.try_place_building(src, get_turf(A)))
				var/datum/building_datum/last_type = held_build.type
				held_build.clean_up(success = TRUE)
				if(LAZYACCESS(modifiers, SHIFT_CLICKED))
					try_setup_build(last_type)
			else
				building_requests -= held_build
				held_build.clean_up()
			return

	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		if (istype(A, /obj/effect/building_node) && displayed_mob_ui)
			var/mob/living/worker_mob = displayed_mob_ui.worker_mob
			if(!A:override_click(src))
				var/datum/persistant_workorder/old_workorder = worker_mob.controller_mind.assigned_work
				var/datum/persistant_workorder/chosen_workorder = A:select_workorder(src)
				if(chosen_workorder)
					worker_mob.controller_mind.assigned_work = chosen_workorder
					if(worker_mob.controller_mind.current_task && (old_workorder != chosen_workorder))
						worker_mob.controller_mind.current_task.stop_work()
					worker_mob.controller_mind.assigned_work.apply_to_worker(worker_mob)

		else if(isliving(A))
			var/mob/living/living = A
			if(living.controller_mind)
				displayed_base_ui.remove_ui(client)
				if(displayed_mob_ui)
					displayed_mob_ui.remove_ui(client)
					close_inventory_ui()
				displayed_mob_ui = living.controller_mind.stats
				open_inventory_ui(living.controller_mind)
			displayed_mob_ui.add_ui(client)

	return ..()

/mob/camera/strategy_controller/proc/find_active_patrol_setup_mob()
	if(displayed_mob_ui?.worker_mob?.controller_mind.patrol_setup_active)
		return displayed_mob_ui.worker_mob
	return null

/mob/camera/strategy_controller/proc/handle_patrol_setup_click(atom/A, list/modifiers, mob/living/target_mob)
	var/turf/T = get_turf(A)
	if(!T)
		return

	var/right_click = LAZYACCESS(modifiers, RIGHT_CLICK)

	if(right_click)
		if(length(target_mob.controller_mind.patrol_points) >= 2)
			create_patrol_order(target_mob, target_mob.controller_mind.patrol_points.Copy())
			to_chat(src, span_notice("Patrol created with [length(target_mob.controller_mind.patrol_points)] points for [target_mob.name]."))
		else
			to_chat(src, span_warning("Need at least 2 patrol points to create a patrol."))

		target_mob.controller_mind.patrol_setup_active = FALSE

		if(displayed_mob_ui && displayed_mob_ui.worker_mob == target_mob && displayed_mob_ui.patrol_button)
			displayed_mob_ui.patrol_button.patrol_mode = FALSE
			displayed_mob_ui.patrol_button.color = null

		update_mob_patrol_visuals(target_mob)
		return

	if(!(T in target_mob.controller_mind.patrol_points))
		target_mob.controller_mind.patrol_points += T
		to_chat(src, span_notice("Added patrol point [length(target_mob.controller_mind.patrol_points)] for [target_mob.name] at [T.x], [T.y]. Right click to finish patrol setup."))
		update_mob_patrol_visuals(target_mob)

/mob/camera/strategy_controller/proc/create_patrol_order(mob/living/worker, list/turf/points)
	if(!worker.controller_mind)
		return

	if(worker.controller_mind.assigned_work && istype(worker.controller_mind.assigned_work, /datum/persistant_workorder/patrol))
		worker.controller_mind.assigned_work = null

	var/datum/persistant_workorder/patrol/new_patrol = new(null, worker, worker.controller_mind.patrol_points.Copy())
	worker.controller_mind.assigned_work = new_patrol
	new_patrol.apply_to_worker(worker)

/mob/camera/strategy_controller/proc/update_mob_patrol_visuals(mob/living/target_mob)
	clear_mob_patrol_visuals(target_mob)

	if(!target_mob.controller_mind.patrol_setup_active && !length(target_mob.controller_mind.patrol_points))
		return

	for(var/i in 1 to length(target_mob.controller_mind.patrol_points))
		var/turf/point = target_mob.controller_mind.patrol_points[i]
		var/image/point_img = image('icons/turf/debug.dmi', point, "patrol_point", ABOVE_LIGHTING_PLANE)
		point_img.plane = ABOVE_LIGHTING_PLANE
		point_img.color = target_mob.controller_mind.patrol_setup_active ? "#FFA500" : "#4CAF50" // Orange during setup, green when active
		target_mob.controller_mind.patrol_visual_images += point_img

		var/image/number_img = image('icons/turf/debug.dmi', point, "number_[i]", ABOVE_LIGHTING_PLANE + 0.1)
		number_img.plane = ABOVE_LIGHTING_PLANE + 0.1
		target_mob.controller_mind.patrol_visual_images += number_img

	if(length(target_mob.controller_mind.patrol_points) >= 2)
		var/obj/pathfind_guy/temp_pathfinder = new()

		for(var/i in 1 to length(target_mob.controller_mind.patrol_points))
			var/turf/current_point = target_mob.controller_mind.patrol_points[i]
			var/turf/next_point = target_mob.controller_mind.patrol_points[(i % length(target_mob.controller_mind.patrol_points)) + 1] // Loop back to start

			temp_pathfinder.forceMove(current_point)
			var/list/turf/path = get_path_to(temp_pathfinder, next_point, TYPE_PROC_REF(/turf, Heuristic_cardinal_3d), 250, 250, 1)
			if(length(path))
				target_mob.controller_mind.patrol_visual_images += render_patrol_path(path, target_mob.controller_mind.patrol_setup_active ? "#FFA500" : "#4CAF50")

		// Clean up the temporary pathfinder
		temp_pathfinder.moveToNullspace()
		qdel(temp_pathfinder)

	// Add to client view
	client.images += target_mob.controller_mind.patrol_visual_images

	// Track that this mob has visuals shown
	if(!(target_mob in mobs_with_patrol_visuals))
		mobs_with_patrol_visuals += target_mob

/mob/camera/strategy_controller/proc/clear_mob_patrol_visuals(mob/living/target_mob)
	if(!target_mob)
		return

	client.images -= target_mob.controller_mind.patrol_visual_images
	target_mob.controller_mind.patrol_visual_images = list()
	mobs_with_patrol_visuals -= target_mob

/mob/camera/strategy_controller/proc/render_patrol_path(list/turf/draw_list, color = "#4CAF50")
	if(!length(draw_list))
		return list()

	var/list/image/turf_images = list()
	// Render everything but the first and last
	for(var/i in 1 to (length(draw_list) - 1))
		var/turf/current_turf = draw_list[i]
		var/turf/next = draw_list[i + 1]
		turf_images += render_patrol_turf(current_turf, get_dir(current_turf, next), color)

	return turf_images

/mob/camera/strategy_controller/proc/render_patrol_turf(turf/draw, direction, color = "#4CAF50")
	var/image/arrow = image('icons/turf/debug.dmi', draw, "patrol_arrow", ABOVE_LIGHTING_PLANE, direction)
	arrow.plane = ABOVE_LIGHTING_PLANE
	arrow.color = color
	return arrow

/mob/camera/strategy_controller/proc/handle_break_turf_click(atom/A, list/modifiers)
	if(!isturf(A))
		A = get_turf(A)

	var/turf/T = A
	if(!T)
		return

	var/shift_held = LAZYACCESS(modifiers, SHIFT_CLICKED)
	var/right_click = LAZYACCESS(modifiers, RIGHT_CLICK)

	if(right_click)
		// Cancel break orders
		if(shift_held)
			cancel_break_orders_area(T)
		else
			cancel_break_order_single(T)
		return

	if(shift_held)
		// Area selection mode
		if(!break_start_turf)
			break_start_turf = T
			to_chat(src, span_notice("First corner selected at [T.x], [T.y]. Click another turf to complete the area."))
		else
			create_break_orders_area(break_start_turf, T)
			break_start_turf = null
	else
		// Single turf mode
		create_break_order_single(T)

/mob/camera/strategy_controller/proc/handle_move_structure_click(atom/A, list/modifiers)
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		// Cancel selection
		if(selected_structure)
			selected_structure.color = null
		selected_structure = null
		to_chat(src, span_notice("Structure selection cancelled."))
		return

	if(selected_structure)
		// Second click - set destination
		var/turf/dest_turf = get_turf(A)
		if(!dest_turf)
			return

		if(is_valid_move_destination(selected_structure, dest_turf))
			create_move_order(selected_structure, dest_turf)
			selected_structure.color = null
			selected_structure = null
		else
			to_chat(src, span_warning("Cannot move structure to that location."))
		return

	// First click - select structure
	if(isobj(A) && isstructure(A))
		var/obj/structure/S = A
		if(is_structure_moveable(S))
			selected_structure = S
			S.color = "#ffff00"  // Yellow highlight
			to_chat(src, span_notice("Selected [S.name]. Click a destination turf to move it there."))
		else
			to_chat(src, span_warning("[S.name] cannot be moved."))

/mob/camera/strategy_controller/proc/create_break_order_single(turf/T)
	if(!can_break_turf(T))
		to_chat(src, span_warning("Cannot break [T.name]."))
		return

	// Check if there's already a break order for this turf
	for(var/datum/queued_workorder/existing_order in in_progress_workorders)
		if(existing_order.work_path == /datum/work_order/break_turf && existing_order.arg_1 == T)
			to_chat(src, span_warning("Break order already exists for this turf."))
			return

	var/datum/queued_workorder/new_queued = new /datum/queued_workorder(/datum/work_order/break_turf, src, T)
	in_progress_workorders += new_queued

/mob/camera/strategy_controller/proc/create_break_orders_area(turf/start_turf, turf/end_turf)
	var/min_x = min(start_turf.x, end_turf.x)
	var/max_x = max(start_turf.x, end_turf.x)
	var/min_y = min(start_turf.y, end_turf.y)
	var/max_y = max(start_turf.y, end_turf.y)

	var/orders_created = 0

	for(var/x in min_x to max_x)
		for(var/y in min_y to max_y)
			var/turf/T = locate(x, y, start_turf.z)
			if(!T || !can_break_turf(T))
				continue

			// Check if there's already a break order for this turf
			var/already_exists = FALSE
			for(var/datum/queued_workorder/existing_order in in_progress_workorders)
				if(existing_order.work_path == /datum/work_order/break_turf && existing_order.arg_1 == T)
					already_exists = TRUE
					break

			if(!already_exists)
				var/datum/queued_workorder/new_queued = new /datum/queued_workorder(/datum/work_order/break_turf, src, T)
				in_progress_workorders += new_queued
				orders_created++

	to_chat(src, span_notice("Created [orders_created] break orders in the selected area."))

/mob/camera/strategy_controller/proc/cancel_break_order_single(turf/T)
	for(var/datum/queued_workorder/order in in_progress_workorders)
		if(order.work_path == /datum/work_order/break_turf && order.arg_1 == T)
			SEND_SIGNAL(T, COMSIG_CANCEL_TURF_BREAK)
			return
	to_chat(src, span_warning("No break order found for this turf."))

/mob/camera/strategy_controller/proc/cancel_break_orders_area(turf/center_turf)
	var/orders_cancelled = 0
	var/list/orders_to_remove = list()

	// Find all break orders in a reasonable area around the clicked turf
	for(var/datum/queued_workorder/order in in_progress_workorders)
		if(order.work_path == /datum/work_order/break_turf)
			var/turf/order_turf = order.arg_1
			if(get_dist(order_turf, center_turf) <= 10) // Adjust range as needed
				orders_to_remove += order
				orders_cancelled++

	for(var/datum/queued_workorder/order in orders_to_remove)
		var/turf/turf = order.arg_1
		SEND_SIGNAL(turf, COMSIG_CANCEL_TURF_BREAK)

	if(orders_cancelled > 0)
		to_chat(src, span_notice("Cancelled [orders_cancelled] break orders in the area."))
	else
		to_chat(src, span_warning("No break orders found in the area."))

/mob/camera/strategy_controller/proc/can_break_turf(turf/T)
	if(isclosedturf(T) && !istype(T, /turf/closed/mineral/bedrock))
		return TRUE

	// Check for breakable structures on the turf
	for(var/obj/structure/structure in T.contents)
		if(is_type_in_list(structure, GLOB.breakable_types))
			return TRUE

	return FALSE

/mob/camera/strategy_controller/proc/is_structure_moveable(obj/structure/S)
	// Define blacklist of unmoveable structures
	var/static/list/unmoveable_types = list(
	)

	if(is_type_in_list(S, unmoveable_types))
		return FALSE

	return TRUE

/mob/camera/strategy_controller/proc/is_valid_move_destination(obj/structure/S, turf/dest_turf)
	// Check if the destination turf can accommodate the structure
	if(dest_turf.density)
		return FALSE

	// Check for blocking objects
	for(var/obj/O in dest_turf.contents)
		if(O.density && O != S)
			return FALSE

	return TRUE

/mob/camera/strategy_controller/proc/create_move_order(obj/structure/S, turf/dest_turf)
	// Check for existing move orders for the same structure and remove them
	var/list/orders_to_remove = list()
	for(var/datum/queued_workorder/existing_order in in_progress_workorders)
		if(existing_order.work_path == /datum/work_order/move_structure && existing_order.arg_1 == S)
			orders_to_remove += existing_order

	for(var/datum/queued_workorder/old_order in orders_to_remove)
		in_progress_workorders -= old_order
		qdel(old_order)
		to_chat(src, span_notice("Cancelled previous move order for [S.name]."))

	var/datum/queued_workorder/new_queued = new /datum/queued_workorder(/datum/work_order/move_structure, src, S, dest_turf)
	in_progress_workorders += new_queued
	to_chat(src, span_notice("Move order created: [S.name] will be moved to [dest_turf.x], [dest_turf.y]."))


/mob/camera/strategy_controller/process()
	building_icon?.update(src)

	if(length(building_requests))
		for(var/mob/living/mob in worker_mobs)
			if(mob.stat >= DEAD)
				return
			if(!length(building_requests))
				return
			if(mob.controller_mind.current_task)
				continue
			if(mob.controller_mind.check_paused_state())
				continue

			for(var/datum/building_datum/building in building_requests)
				if(building.try_work_on(mob))
					return

	if(length(constructed_building_nodes))
		if(resource_stockpile)
			for(var/obj/effect/building_node/node in constructed_building_nodes)
				if(length(node.materials_to_store))
					for(var/mob/living/mob in worker_mobs)
						if(mob.stat >= DEAD)
							return
						if(mob.controller_mind.current_task)
							continue
						if(mob.controller_mind.check_paused_state())
							continue
						mob.controller_mind.set_current_task(/datum/work_order/store_materials, node, src)

				if(length(node.material_requests))
					var/passed = TRUE
					for(var/request in node.material_requests)
						if(!resource_stockpile.has_any_resources(node.material_requests[request]))
							passed = FALSE
					if(!passed)
						continue

					for(var/mob/living/mob in worker_mobs)
						if(mob.stat >= DEAD)
							return
						if(mob.controller_mind.current_task)
							continue
						if(mob.controller_mind.check_paused_state())
							continue
						mob.controller_mind.set_current_task(/datum/work_order/haul_materials, node, src)

	if(length(in_progress_workorders))
		for(var/mob/living/mob in worker_mobs)
			if(mob.stat >= DEAD)
				return
			if(!length(in_progress_workorders))
				return
			if(mob.controller_mind.current_task)
				continue
			if(mob.controller_mind.check_paused_state())
				continue

			for(var/datum/queued_workorder/workorder in in_progress_workorders)
				if(workorder.arg_1)
					if(!length(get_path_to(mob, workorder.arg_1, TYPE_PROC_REF(/turf, Heuristic_cardinal_3d), 32 + 1, 250,1)))
						continue
				mob.controller_mind.set_current_task(workorder.work_path, workorder.arg_1, workorder.arg_2, workorder.arg_3, workorder.arg_4)
				in_progress_workorders -= workorder
				qdel(workorder)
				return

/mob/camera/strategy_controller/proc/should_stop_idle(datum/worker_mind/mind)
	if(length(in_progress_workorders))
		return TRUE
	if(length(building_requests))
		return TRUE
	if(length(constructed_building_nodes))
		if(resource_stockpile)
			for(var/obj/effect/building_node/node in constructed_building_nodes)
				if(length(node.materials_to_store))
					return TRUE
				if(length(node.material_requests))
					return TRUE

	return FALSE


/mob/camera/strategy_controller/Login()
	. = ..()
	displayed_base_ui.add_ui(client)
	displayed_base_ui.add_ui_buttons(client)

	var/turf/T = get_turf(src)
	if (isturf(T))
		update_z(T.z)

/mob/camera/auto_deadmin_on_login()
	return

/mob/camera/Logout()
	update_z(null)
	return ..()

/mob/camera/onTransitZ(old_z,new_z)
	..()
	update_z(new_z)

/mob/camera/proc/update_z(new_z) // 1+ to register, null to unregister
	if (registered_z != new_z)
		if (registered_z)
			SSmobs.camera_players_by_zlevel[registered_z] -= src
		if (client)
			if (new_z)
				SSmobs.camera_players_by_zlevel[new_z] += src
			registered_z = new_z
		else
			registered_z = null
