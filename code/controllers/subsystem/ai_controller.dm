#define AI_CONTROLLER_PROCESSING_TILE_RANGE 15

/// Handles the processing of SelectBehaviors aswell as able_to_plan() seperate from controller/process
/// handles only the subsystems within our planning bucket.
SUBSYSTEM_DEF(ai_controllers)
	name = "AI Controller Ticker"
	flags = SS_POST_FIRE_TIMING|SS_BACKGROUND
	priority = FIRE_PRIORITY_NPC
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	init_order = INIT_ORDER_AI_CONTROLLERS
	wait = 0.5 SECONDS
	///bucket we look into for planning. GLOB.ai_controllers_by_status[planning_status]
	var/planning_status = AI_STATUS_ON
	var/list/currentrun = list()
	///if TRUE, this subsystem only processes controllers near a client (or flagged always_process), same rules as SSmobs. If FALSE (default/base), everything in the status bucket processes every fire like before.
	var/uses_cell_processing = FALSE


/datum/controller/subsystem/ai_controllers/Initialize(timeofday)
	setup_subtrees()
	return ..()

///Called when the max Z level was changed, updating our coverage.
/datum/controller/subsystem/ai_controllers/proc/on_max_z_changed()
	if(!length(GLOB.ai_controllers_by_zlevel))
		GLOB.ai_controllers_by_zlevel = new /list(world.maxz,0)
	while (GLOB.ai_controllers_by_zlevel.len < world.maxz)
		GLOB.ai_controllers_by_zlevel.len++
		GLOB.ai_controllers_by_zlevel[GLOB.ai_controllers_by_zlevel.len] = list()

/datum/controller/subsystem/ai_controllers/proc/setup_subtrees()
	if(length(GLOB.ai_subtrees))
		return
	for(var/subtree_type in subtypesof(/datum/ai_planning_subtree))
		var/datum/ai_planning_subtree/subtree = new subtree_type
		GLOB.ai_subtrees[subtree_type] = subtree

/datum/controller/subsystem/ai_controllers/proc/build_currentrun()
	. = list()

	if(!uses_cell_processing)
		var/list/controller_list = GLOB.ai_controllers_by_status[planning_status]
		. = controller_list.Copy()
		return

	var/list/in_range_controllers = list()
	var/list/seen_cells = list()

	for(var/z_index in 1 to SSmobs.clients_by_zlevel.len)
		if(z_index in SSmobs.town_z)
			if(z_index <= GLOB.ai_controllers_by_zlevel.len)
				in_range_controllers |= GLOB.ai_controllers_by_zlevel[z_index]
			continue

		var/list/clients_here = SSmobs.clients_by_zlevel[z_index]
		if(!length(clients_here))
			continue

		for(var/mob/living/client_mob as anything in clients_here)
			var/turf/turf = get_turf(client_mob)
			if(!turf)
				continue
			for(var/datum/spatial_grid_cell/cell as anything in SSspatial_grid.get_cells_in_range(turf, AI_CONTROLLER_PROCESSING_TILE_RANGE))
				if(seen_cells[cell])
					continue
				seen_cells[cell] = TRUE
				for(var/atom/movable/hearable as anything in cell.hearing_contents)
					var/datum/ai_controller/found_controller = hearable.ai_controller
					if(found_controller)
						in_range_controllers[found_controller] = TRUE

	var/list/list =  GLOB.ai_controllers_by_status[planning_status]
	for(var/datum/ai_controller/ai_controller as anything in in_range_controllers)
		if(ai_controller in list)
			. += ai_controller

/datum/controller/subsystem/ai_controllers/fire(resumed)
	if(!resumed)
		src.currentrun = build_currentrun()

	var/list/currentrun = src.currentrun
	while(currentrun.len)
		var/datum/ai_controller/ai_controller = currentrun[currentrun.len]
		currentrun.len--
		if(!ai_controller || QDELETED(ai_controller))
			continue
		if(!COOLDOWN_FINISHED(ai_controller, failed_planning_cooldown))
			continue
		if(!ai_controller.able_to_plan())
			continue
		ai_controller.SelectBehaviors(wait * 0.1)
		if(!LAZYLEN(ai_controller.current_behaviors))
			COOLDOWN_START(ai_controller, failed_planning_cooldown, AI_FAILED_PLANNING_COOLDOWN)
		if(MC_TICK_CHECK)
			return

#undef AI_CONTROLLER_PROCESSING_TILE_RANGE
