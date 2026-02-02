/datum/component/worker_mind_renderer
	var/datum/worker_mind/mind
	var/list/turf_path = list()
	var/obj/abstract/visual_ui_element/scrollable/console_output/output
	var/last_task_type
	var/last_stamina
	var/last_movement_target
	var/last_paused_state

/datum/component/worker_mind_renderer/Initialize(obj/abstract/visual_ui_element/scrollable/console_output/console, datum/worker_mind/target_mind)
	. = ..()
	mind = target_mind
	output = console

	// Store initial states
	last_task_type = mind.current_task?.type
	last_stamina = mind.current_stamina
	last_movement_target = mind.movement_target
	last_paused_state = mind.paused

	// Register signals for various worker mind events
	RegisterSignal(mind, COMSIG_WORKER_TASK_STARTED, PROC_REF(output_task_started))
	RegisterSignal(mind, COMSIG_WORKER_TASK_FINISHED, PROC_REF(output_task_finished))
	RegisterSignal(mind, COMSIG_WORKER_TASK_FAILED, PROC_REF(output_task_failed))
	RegisterSignal(mind, COMSIG_WORKER_STAMINA_CHANGED, PROC_REF(output_stamina_change))
	RegisterSignal(mind, COMSIG_WORKER_MOVEMENT_SET, PROC_REF(output_movement_change))
	RegisterSignal(mind, COMSIG_WORKER_PAUSED_CHANGED, PROC_REF(output_pause_change))
	RegisterSignal(mind, COMSIG_WORKER_GEAR_CHANGED, PROC_REF(output_gear_change))
	RegisterSignal(mind, COMSIG_WORKER_IDLE_START, PROC_REF(output_idle_start))
	RegisterSignal(mind, COMSIG_WORKER_ATTACK_START, PROC_REF(output_attack_start))
	RegisterSignal(mind, COMSIG_WORKER_ATTACK_END, PROC_REF(output_attack_end))
	RegisterSignal(mind.worker, COMSIG_PARENT_QDELETING, PROC_REF(clean))
	RegisterSignal(mind, COMSIG_AI_PATH_GENERATED, PROC_REF(regenerate_path))
	RegisterSignal(mind.worker, COMSIG_MOVABLE_MOVED, PROC_REF(check_turf_update))

	// Start monitoring loop
	START_PROCESSING(SSstrategy_master, src)

/datum/component/worker_mind_renderer/Destroy(force)
	UnregisterSignal(mind, list(
		COMSIG_WORKER_TASK_STARTED,
		COMSIG_WORKER_TASK_FINISHED,
		COMSIG_WORKER_TASK_FAILED,
		COMSIG_WORKER_STAMINA_CHANGED,
		COMSIG_WORKER_MOVEMENT_SET,
		COMSIG_WORKER_PAUSED_CHANGED,
		COMSIG_WORKER_GEAR_CHANGED,
		COMSIG_WORKER_IDLE_START,
		COMSIG_WORKER_ATTACK_START,
		COMSIG_WORKER_ATTACK_END,
		COMSIG_AI_PATH_GENERATED,
	))
	cut_path()

	UnregisterSignal(mind.worker, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED))
	STOP_PROCESSING(SSstrategy_master, src)
	mind = null
	output = null
	. = ..()

/datum/component/worker_mind_renderer/proc/cut_path()
	var/mob/parent_atom = parent
	parent_atom.client?.images -= turf_path
	turf_path = list()

/datum/component/worker_mind_renderer/process()
	if(!mind || !output)
		return

	// Check for state changes that don't have signals
	check_task_change()
	check_stamina_change()
	check_movement_change()
	check_pause_change()

/datum/component/worker_mind_renderer/proc/regenerate_path(datum/source, list/draw_list)
	var/mob/parent_atom = parent
	cut_path()

	var/list/image/turf_images = list()
	// Render everything but the first and last
	for(var/i in 1 to (length(draw_list) - 1))
		var/turf/problem_child = draw_list[i]
		var/turf/next = draw_list[i + 1]
		turf_images += render_turf(problem_child, get_dir(problem_child, next))

	turf_path = turf_images
	parent_atom.client?.images += turf_path

/datum/component/worker_mind_renderer/proc/render_turf(turf/draw, direction)
	var/image/arrow = image('icons/turf/debug.dmi', draw, "arrow", 6, direction)
	arrow.plane = ABOVE_LIGHTING_PLANE
	return arrow

/datum/component/worker_mind_renderer/proc/check_turf_update(atom/movable/mover, atom/oldloc, direction)
	var/mob/parent_atom = parent
	for(var/image/image as anything in turf_path)
		if(image.loc != oldloc)
			continue
		parent_atom.client?.images -= image
		turf_path -= image

/datum/component/worker_mind_renderer/proc/check_task_change()
	var/current_task_type = mind.current_task?.type
	if(current_task_type != last_task_type)
		if(current_task_type)
			output.add_line("  -[mind.worker_name]: Task changed to [current_task_type]")
		else
			output.add_line("  -[mind.worker_name]: Task cleared")
		last_task_type = current_task_type

/datum/component/worker_mind_renderer/proc/check_stamina_change()
	if(mind.current_stamina != last_stamina)
		var/change = mind.current_stamina - last_stamina
		var/change_text = change > 0 ? "+[change]" : "[change]"
		output.add_line("  -[mind.worker_name]: Stamina [change_text] ([last_stamina] → [mind.current_stamina]/[mind.maximum_stamina])")
		last_stamina = mind.current_stamina

/datum/component/worker_mind_renderer/proc/check_movement_change()
	if(mind.movement_target != last_movement_target)
		output.add_line("  -[mind.worker_name]: Movement target set to [mind.movement_target] from [last_movement_target]")
		last_movement_target = mind.movement_target

/datum/component/worker_mind_renderer/proc/check_pause_change()
	if(mind.paused != last_paused_state)
		output.add_line("  -[mind.worker_name]: [mind.paused ? "Paused" : "Unpaused"]")
		last_paused_state = mind.paused

/datum/component/worker_mind_renderer/proc/output_task_started(datum/source, datum/work_order/task)
	output.add_line("  -[mind.worker_name]: Started task '[task.name]' (Stamina cost: [task.stamina_cost])")

/datum/component/worker_mind_renderer/proc/output_task_finished(datum/source, datum/work_order/task, success, stamina_used)
	var/result = success ? "SUCCESS" : "FAILED"
	var/task_time = task.work_time_left / task.get_work_speed_modifier(mind)
	output.add_line("  -[mind.worker_name]: Finished task '[task.name]' - [result] (Work Time: [task_time * 0.1] Seconds)")

/datum/component/worker_mind_renderer/proc/output_task_failed(datum/source, datum/work_order/task, reason)
	output.add_line("  -[mind.worker_name]: Task '[task.name]' FAILED - [reason]")

/datum/component/worker_mind_renderer/proc/output_stamina_change(datum/source, old_stamina, new_stamina, change_reason)
	var/change = new_stamina - old_stamina
	var/change_text = change > 0 ? "+[change]" : "[change]"
	output.add_line("  -[mind.worker_name]: Stamina [change_text] ([old_stamina] → [new_stamina]/[mind.maximum_stamina]) - [change_reason]")

/datum/component/worker_mind_renderer/proc/output_movement_change(datum/source, atom/old_target, atom/new_target)
	output.add_line("  -[mind.worker_name]: Movement target changed from [old_target] to [new_target]")

/datum/component/worker_mind_renderer/proc/output_pause_change(datum/source, old_state, new_state, reason)
	var/state_text = new_state ? "PAUSED" : "UNPAUSED"
	output.add_line("  -[mind.worker_name]: [state_text] - [reason]")

/datum/component/worker_mind_renderer/proc/output_gear_change(datum/source, slot, datum/worker_gear/old_gear, datum/worker_gear/new_gear)
	if(new_gear)
		output.add_line("  -[mind.worker_name]: Equipped [new_gear.item] in [slot]")
	else
		output.add_line("  -[mind.worker_name]: Removed gear from [slot]")

/datum/component/worker_mind_renderer/proc/output_idle_start(datum/source, datum/idle_tendancies/idle_type)
	output.add_line("  -[mind.worker_name]: Started idle behavior: [idle_type.type]")

/datum/component/worker_mind_renderer/proc/output_attack_start(datum/source, atom/target)
	output.add_line("  -[mind.worker_name]: Started attacking [target]")

/datum/component/worker_mind_renderer/proc/output_attack_end(datum/source, atom/target, result)
	output.add_line("  -[mind.worker_name]: Stopped attacking [target] - [result]")

/datum/component/worker_mind_renderer/proc/clean(datum/source)
	output.add_line("  -[mind.worker_name]: Worker deleted.")
	qdel(src)

/datum/console_command/debug_worker
	command_key = "debug_worker"

/datum/console_command/debug_worker/help_information(obj/abstract/visual_ui_element/scrollable/console_output/output)
	output.add_line("debug_worker - Displays worker mind debug data and logs worker activities in console")

/datum/console_command/debug_worker/execute(obj/abstract/visual_ui_element/scrollable/console_output/output, list/arg_list)
	var/mob/current = output.parent.get_user()
	var/datum/component/worker_mind_renderer/render = current.GetComponent(/datum/component/worker_mind_renderer)

	if(render)
		output.add_line("Stopped tracking [render.mind.worker_name]'s worker mind.")
		qdel(render)
		return

	var/atom/marked_datum = current.client.holder?.marked_datum
	if(!marked_datum)
		output.add_line("ERROR: No marked datum")
		return

	var/datum/worker_mind/target_mind

	// Check if marked datum is a worker mob with controller_mind
	if(ismob(marked_datum))
		var/mob/living/marked_mob = marked_datum
		if(marked_mob.controller_mind)
			target_mind = marked_mob.controller_mind

	// Check if marked datum is a worker_mind directly
	else if(istype(marked_datum, /datum/worker_mind))
		target_mind = marked_datum

	if(!target_mind)
		output.add_line("ERROR: Marked datum has no worker mind")
		return

	current.AddComponent(/datum/component/worker_mind_renderer, output, target_mind)
	render = current.GetComponent(/datum/component/worker_mind_renderer)
	output.add_line("Started tracking [render.mind.worker_name]'s worker mind.")
