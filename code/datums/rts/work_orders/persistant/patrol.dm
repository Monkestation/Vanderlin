/datum/persistant_workorder/patrol
	name = "Patrolling"
	ui_icon = 'icons/roguetown/misc/structure.dmi'
	ui_icon_state = "sign"
	work_type = /datum/work_order/patrol

	var/mob/living/patrolling_mob
	var/current_point_index = 1

/datum/persistant_workorder/patrol/New(obj/effect/building_node/source, mob/living/mob, list/turf/points)
	. = ..()
	patrolling_mob = mob
	current_point_index = 1

/datum/persistant_workorder/patrol/apply_to_worker(mob/living/worker)
	if(!worker.controller_mind)
		return
	if(worker.controller_mind.current_task)
		return

	// Set current target point from the mob's own patrol points
	if(!length(worker.controller_mind.patrol_points))
		return

	if(current_point_index > length(worker.controller_mind.patrol_points))
		current_point_index = 1

	arg_1 = worker.controller_mind.patrol_points[current_point_index]
	worker.controller_mind.set_current_task(work_type, arg_1, src)

/datum/persistant_workorder/patrol/proc/advance_to_next_point()
	current_point_index++
	if(current_point_index > length(patrolling_mob.controller_mind.patrol_points))
		current_point_index = 1
