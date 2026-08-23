//this really shouldn't be a component but I don't wanna add a var for it.
/datum/component/ai_path_renderer
	var/mob/mob
	var/list/turf_path = list()
	var/obj/abstract/visual_ui_element/scrollable/console_output/output

/datum/component/ai_path_renderer/Initialize(obj/abstract/visual_ui_element/scrollable/console_output/console, mob/target)
	. = ..()
	mob = target
	output = console

	RegisterSignal(mob, COMSIG_MOVABLE_MOVED, PROC_REF(check_turf_update))
	RegisterSignal(mob, COMSIG_AI_PATH_GENERATED, PROC_REF(regenerate_path))
	RegisterSignal(mob, COMSIG_AI_MOVEMENT_SET, PROC_REF(output_target_change))
	RegisterSignal(mob, COMSIG_AI_GENERAL_CHANGE, PROC_REF(output_information))
	RegisterSignal(mob, COMSIG_QDELETING, PROC_REF(clean))


/datum/component/ai_path_renderer/Destroy(force)
	UnregisterSignal(mob, list(COMSIG_MOVABLE_MOVED,COMSIG_AI_PATH_GENERATED,COMSIG_AI_MOVEMENT_SET,COMSIG_AI_GENERAL_CHANGE,COMSIG_QDELETING))
	cut_path()

	mob = null
	turf_path = null
	output = null

	. = ..()

/datum/component/ai_path_renderer/proc/cut_path()
	var/mob/parent_atom = parent
	parent_atom.client?.images -= turf_path
	turf_path = list()

/datum/component/ai_path_renderer/proc/regenerate_path(datum/source, list/draw_list)
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

/datum/component/ai_path_renderer/proc/render_turf(turf/draw, direction)
	var/image/arrow = image('icons/turf/debug.dmi', draw, "arrow", 6, direction)
	arrow.plane = ABOVE_LIGHTING_PLANE
	return arrow

/datum/component/ai_path_renderer/proc/check_turf_update(atom/movable/mover, atom/oldloc, direction)
	var/mob/parent_atom = parent
	for(var/image/image as anything in turf_path)
		if(image.loc != oldloc)
			continue
		parent_atom.client?.images -= image
		turf_path -= image

/datum/component/ai_path_renderer/proc/output_target_change(datum/source, old, change)
	output.add_line("  -[mob] movement target set to [change] from [old].")

/datum/component/ai_path_renderer/proc/output_information(datum/source, information)
	output.add_line("  -[mob]: [information].")

/datum/component/ai_path_renderer/proc/clean(datum/source, information)
	output.add_line("  -[mob]: Deleting.")
	qdel(src)

/datum/console_command/debug_ai
	command_key = "debug_ai"

/datum/console_command/echo/help_information(obj/abstract/visual_ui_element/scrollable/console_output/output)
	output.add_line("debug_ai - Displays path data to you, and logs when movement targets are set in console")

/datum/console_command/debug_ai/execute(obj/abstract/visual_ui_element/scrollable/console_output/output, list/arg_list)
	var/mob/current = output.parent.get_user()
	var/datum/component/ai_path_renderer/render = current.GetComponent(/datum/component/ai_path_renderer)
	if(render)
		output.add_line("Stopped tracking [render.mob]'s AI controller.")
		qdel(render)
		return

	var/atom/marked_datum = current.client.holder?.marked_datum
	if(!marked_datum)
		output.add_line("ERROR: No marked datum")
		return
	if(!marked_datum.ai_controller)
		output.add_line("ERROR: No AI controller")
		return

	current.AddComponent(/datum/component/ai_path_renderer, output, marked_datum)
	render = current.GetComponent(/datum/component/ai_path_renderer)
	output.add_line("Started tracking [render.mob]'s AI controller.")
