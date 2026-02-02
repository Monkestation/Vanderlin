/datum/work_order
	var/name = "Generic Work Order"
	var/visible_message
	var/mob/living/worker
	var/atom/work_target
	var/stamina_cost
	var/work_time_left = 0
	var/can_continue = FALSE

/datum/work_order/New(mob/living/new_worker, datum/work_order/type, ...)
	. = ..()
	worker = new_worker

/datum/work_order/proc/start_working(mob/living/worker_mob)
	worker.controller_mind.set_paused_state(TRUE, "starting work")
	worker.controller_mind.update_stat_panel()
	work_time_left /= get_work_speed_modifier(worker_mob.controller_mind)
	var/world_start_time = world.time

	if(visible_message)
		worker.visible_message("[worker] [visible_message]")

	if(!do_after(worker, work_time_left, target = work_target, interaction_key = "work"))
		worker.controller_mind.set_paused_state(FALSE, "work interrupted")
		if(!can_continue)
			stop_work("interrupted")
			return FALSE
		work_time_left = world.time - world_start_time
		return FALSE
	finish_work()

/datum/work_order/proc/get_work_speed_modifier(datum/worker_mind/mind)
	var/modifier = 1
	for(var/slot as anything in mind.worker_gear)
		if(!mind.has_gear_in_slot(slot))
			continue
		var/datum/worker_gear/gear = mind.get_gear_in_slot(slot)
		modifier /= gear.get_work_speed_modifier()
		var/specifics = gear.get_task_bonus(src, TASK_KEY_SPEED)
		if(specifics)
			modifier *= specifics
	return modifier

/datum/work_order/proc/finish_work()
	SHOULD_CALL_PARENT(TRUE)
	var/true_stamina_cost = round(stamina_cost * get_stamina_cost_modifier(worker.controller_mind), 1)
	worker.controller_mind.finish_work(TRUE, true_stamina_cost)
	worker.controller_mind.update_stat_panel()

/datum/work_order/proc/get_stamina_cost_modifier(datum/worker_mind/mind)
	var/modifier = 1
	for(var/slot as anything in mind.worker_gear)
		if(!mind.has_gear_in_slot(slot))
			continue
		var/datum/worker_gear/gear = mind.get_gear_in_slot(slot)
		modifier *= gear.get_stamina_cost_modifier()
		var/specifics = gear.get_task_bonus(src, TASK_KEY_REDUCTION)
		if(specifics)
			modifier *= specifics
	return modifier

/datum/work_order/proc/set_movement_target(atom/target)
	if(!target)
		stop_work("no target")
	if(!length(get_path_to(worker, get_turf(target), TYPE_PROC_REF(/turf, Heuristic_cardinal_3d), 32 + 1, 250,1)))
		stop_work("unreachable target")
		return
	worker.controller_mind.set_movement_target(target)

/datum/work_order/proc/stop_work(reason = "unknown")
	SHOULD_CALL_PARENT(TRUE)
	if(worker.controller_mind.current_task == src)
		worker.stop_doing("work")
		SEND_SIGNAL(worker.controller_mind, COMSIG_WORKER_TASK_FAILED, src, reason)
		worker.controller_mind.stop_working()
		worker.controller_mind.update_stat_panel()
