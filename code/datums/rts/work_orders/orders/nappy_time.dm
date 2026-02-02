/datum/work_order/nappy_time
	name = "Napping"
	stamina_cost = 0
	work_time_left = 30 SECONDS
	var/starting_working_number = 0
	var/stamina_to_restore = 50

/datum/work_order/nappy_time/New(mob/living/new_worker, datum/work_order/type, turf/sleeping_spot)
	. = ..()
	work_time_left = rand(30 SECONDS, 45 SECONDS)
	starting_working_number = work_time_left
	set_movement_target(sleeping_spot)

/datum/work_order/nappy_time/start_working(mob/living/worker_mob)
	worker.controller_mind.paused = TRUE
	worker.controller_mind.update_stat_panel()
	var/world_start_time = world.time
	if(!do_after(worker, work_time_left, target = work_target))
		worker.controller_mind.paused = FALSE
		if(!can_continue)
			work_time_left = world.time - world_start_time
			restore_stamina(work_time_left / starting_working_number)
			stop_work("interrupted")
			return FALSE
		work_time_left = world.time - world_start_time
		return FALSE

	finish_work()

/datum/work_order/nappy_time/finish_work()
	restore_stamina(1)
	. = ..()

/datum/work_order/nappy_time/proc/restore_stamina(completed)
	worker.controller_mind.current_stamina = min(worker.controller_mind.maximum_stamina, worker.controller_mind.current_stamina + (stamina_to_restore * completed))
