SUBSYSTEM_DEF(liquids)
	name = "Abyssor's Domain"
	wait = 0.5 SECONDS
	flags = SS_KEEP_TIMING | SS_NO_INIT | SS_BACKGROUND
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	var/list/active_groups = list()

	var/list/evaporation_queue = list()
	var/evaporation_counter = 0 //Only process evaporation on intervals

	var/run_type = SSLIQUIDS_RUN_TYPE_GROUPS

	///debug variable to toggle evaporation from running
	var/debug_evaporation = FALSE

	var/list/burning_turfs = list()
	var/fire_counter = 0

	var/member_counter = 0

	var/list/arrayed_groups = list()

	///list of groups to work on for cached edges
	var/list/cached_edge_work_queue = list()
	///list of groups we are going to work on in group process
	var/list/group_process_work_queue = list()
	///list of all work queue for turf processing
	var/list/active_turf_group_queue = list()
	///list of cached exposures we are working with
	var/list/cached_exposures = list()


/datum/controller/subsystem/liquids/stat_entry(msg)
	msg += "AG:[length(active_groups)]|BT:[length(burning_turfs)]|EQ:[length(evaporation_queue)]]"
	return ..()

/datum/controller/subsystem/liquids/fire(resumed)
	if(!length(active_groups) && !length(evaporation_queue) && !length(burning_turfs))
		return

	list_clear_nulls(active_groups)

	if(length(arrayed_groups))
		list_clear_nulls(arrayed_groups)
		for(var/datum/liquid_group/liquid_group as anything in arrayed_groups)
			if(QDELETED(liquid_group))
				arrayed_groups -= liquid_group
				continue
			while(!MC_TICK_CHECK && length(liquid_group?.splitting_array)) // three at a time until we either finish or over-run, this should be done before anything else
				liquid_group.work_on_split_queue()
				liquid_group.cleanse_members()

	if(run_type == SSLIQUIDS_RUN_TYPE_GROUPS)
		if(!length(group_process_work_queue))
			group_process_work_queue |= active_groups
		list_clear_nulls(group_process_work_queue)
		if(length(group_process_work_queue))
			var/populate_evaporation = FALSE
			if(!length(evaporation_queue))
				populate_evaporation = TRUE
			for(var/datum/liquid_group/liquid_group as anything in group_process_work_queue)
				if(MC_TICK_CHECK)
					return
				if(QDELETED(liquid_group))
					group_process_work_queue -= liquid_group
					continue
				liquid_group.process_group(TRUE)
				if(populate_evaporation && (liquid_group.always_evaporates || liquid_group.expected_turf_height < LIQUID_STATE_ANKLES) && liquid_group.evaporates)
					for(var/turf/listed_turf as anything in liquid_group.members)
						if(QDELETED(listed_turf))
							continue
						evaporation_queue |= listed_turf
				group_process_work_queue -= liquid_group


		run_type = SSLIQUIDS_RUN_TYPE_EVAPORATION

	if(run_type == SSLIQUIDS_RUN_TYPE_EVAPORATION && !debug_evaporation)
		list_clear_nulls(evaporation_queue)
		evaporation_counter++
		if(evaporation_counter >= REQUIRED_EVAPORATION_PROCESSES)
			evaporation_counter = 0
			for(var/datum/liquid_group/liquid_group as anything in active_groups)
				if(MC_TICK_CHECK)
					return
				if(QDELETED(liquid_group))
					active_groups -= liquid_group
					continue
				liquid_group.check_dead()
				if(!length(liquid_group?.splitting_array))
					liquid_group.process_turf_disperse()
			for(var/turf/liquid_turf as anything in evaporation_queue)
				if(MC_TICK_CHECK)
					return
				if(!prob(EVAPORATION_CHANCE) || QDELETED(liquid_turf))
					evaporation_queue -= liquid_turf
					continue
				liquid_turf?.liquids?.process_evaporation()
		run_type = SSLIQUIDS_RUN_TYPE_FIRE

	if(run_type == SSLIQUIDS_RUN_TYPE_FIRE)
		fire_counter++
		for(var/datum/liquid_group/liquid_group as anything in active_groups)
			if(MC_TICK_CHECK)
				return
			if(length(liquid_group?.burning_members))
				for(var/turf/burning_turf as anything in liquid_group.burning_members)
					if(MC_TICK_CHECK)
						return
					if(!istype(burning_turf) || QDELING(burning_turf))
						liquid_group.burning_members -= burning_turf
						continue
					liquid_group.process_spread(burning_turf)

		if(fire_counter > REQUIRED_FIRE_PROCESSES)
			for(var/datum/liquid_group/liquid_group as anything in active_groups)
				if(MC_TICK_CHECK)
					return
				if(QDELETED(liquid_group))
					active_groups -= liquid_group
					continue
				if(length(liquid_group.burning_members))
					liquid_group.process_fire()
			fire_counter = 0
		run_type = SSLIQUIDS_RUN_TYPE_TURFS

	if(run_type == SSLIQUIDS_RUN_TYPE_TURFS)
		member_counter++
		if(!length(active_turf_group_queue))
			active_turf_group_queue += active_groups
		list_clear_nulls(active_turf_group_queue)

		if(member_counter > REQUIRED_MEMBER_PROCESSES)
			list_clear_nulls(cached_exposures)
			if(!length(cached_exposures))
				for(var/datum/liquid_group/liquid_group as anything in active_turf_group_queue)
					if(MC_TICK_CHECK)
						return
					if(QDELETED(liquid_group))
						active_turf_group_queue -= liquid_group
						continue
					liquid_group.build_turf_reagent()
					active_turf_group_queue -= liquid_group
					if(!liquid_group.exposure)
						continue
					cached_exposures |= liquid_group.members

			var/process_count = 0
			var/list/groups_we_rebuilt = list()
			while((process_count <= 500) && length(cached_exposures))
				process_count++
				var/turf/member = pick_n_take(cached_exposures)
				if(QDELETED(member) || QDELETED(member.liquids) || QDELETED(member.liquids.liquid_group))
					continue
				var/datum/liquid_group/liquid_group = member.liquids.liquid_group
				if(!(liquid_group in groups_we_rebuilt))
					groups_we_rebuilt |= liquid_group
					liquid_group.build_turf_reagent()

				if(!istype(member) || QDELING(member))
					liquid_group.members -= member
					continue
				liquid_group.process_member(member)
				if(MC_TICK_CHECK)
					return
			member_counter = 0
		run_type = SSLIQUIDS_RUN_TYPE_CACHED_EDGES

	if(run_type == SSLIQUIDS_RUN_TYPE_CACHED_EDGES)
		if(!length(cached_edge_work_queue))
			cached_edge_work_queue |= active_groups
		list_clear_nulls(cached_edge_work_queue)

		if(length(cached_edge_work_queue))
			for(var/datum/liquid_group/liquid_group as anything in cached_edge_work_queue)
				if(MC_TICK_CHECK)
					return
				if(QDELETED(liquid_group))
					cached_edge_work_queue -= liquid_group
					continue

				liquid_group.build_turf_reagent()
				if(liquid_group.reagents_per_turf > LIQUID_HEIGHT_DIVISOR)
					liquid_group.process_cached_edges()
				cached_edge_work_queue -= liquid_group


		run_type = SSLIQUIDS_RUN_TYPE_GROUPS


/client/proc/toggle_liquid_debug()
	set category = "Debug"
	set name = "Liquid Groups Color Debug"
	set desc = "Liquid Groups Color Debug."
	if(!holder)
		return
	GLOB.liquid_debug_colors = !GLOB.liquid_debug_colors
