/datum/work_order/move_structure
	name = "Moving "
	stamina_cost = 8
	work_time_left = 15 SECONDS
	visible_message = "starts to move a structure."
	var/obj/structure/target_structure
	var/turf/destination_turf
	var/moving_to_structure = TRUE

	var/obj/effect/spell_rune/rune

/datum/work_order/move_structure/New(mob/living/new_worker, datum/work_order/type, obj/structure/structure_to_move, turf/dest_turf)
	. = ..()
	if(!structure_to_move || !dest_turf)
		qdel(src)
		return

	target_structure = structure_to_move
	destination_turf = dest_turf
	name += target_structure.name

	set_movement_target(get_turf(structure_to_move))
	RegisterSignal(structure_to_move, COMSIG_PARENT_QDELETING, PROC_REF(stop_work))

/datum/work_order/move_structure/Destroy(force, ...)
	. = ..()
	if(target_structure)
		UnregisterSignal(target_structure, COMSIG_PARENT_QDELETING)

/datum/work_order/move_structure/start_working(mob/living/worker_mob)
	worker.controller_mind.paused = TRUE
	worker.controller_mind.update_stat_panel()
	var/world_start_time = world.time
	if(visible_message)
		worker.visible_message("[worker] [visible_message]")

	if(moving_to_structure)
		if(!do_after(worker, work_time_left, target = work_target))
			worker.controller_mind.paused = FALSE
			if(!can_continue)
				stop_work("interrupted")
				return FALSE
			work_time_left = world.time - world_start_time
			return FALSE

		moving_to_structure = FALSE
		rune = new(get_turf(work_target), null, "#800080")
		set_movement_target(destination_turf)
		worker.controller_mind.paused = FALSE
		return
	else
		if(!do_after(worker, work_time_left, target = work_target))
			worker.controller_mind.paused = FALSE
			if(!can_continue)
				stop_work("interrupted")
				return FALSE
			work_time_left = world.time - world_start_time
			return FALSE
		finish_work()
		return

/datum/work_order/move_structure/finish_work()
	if(!target_structure || !destination_turf)
		return ..()

	qdel(rune)
	var/atom/wave = new /obj/effect/temp_visual/wave_up(get_turf(target_structure))
	wave.color = "#800080"

	target_structure.forceMove(destination_turf)
	target_structure.visible_message(span_notice("[target_structure] has been moved to a new location."))

	return ..()
