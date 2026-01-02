///these are basically work orders we want repeating with the same variables so say you want a pawn farming grain we add this.
///different path then queued because queueds are meant to be one and done
///should really be singletons referenced by workers, and created by jobsites
/datum/persistant_workorder
	var/name
	var/ui_icon
	var/ui_icon_state

	var/obj/effect/building_node/created_node
	var/datum/work_order/work_type
	var/arg_1
	var/arg_2
	var/arg_3
	var/arg_4
	var/arg_5

/datum/persistant_workorder/New(obj/effect/building_node/source)
	. = ..()
	created_node = source

/datum/persistant_workorder/proc/apply_to_worker(mob/living/worker)
	if(!worker.controller_mind)
		return
	if(worker.controller_mind.current_task)
		return
	worker.controller_mind.set_current_task(work_type, arg_1, arg_2, arg_3, arg_4, arg_5)
