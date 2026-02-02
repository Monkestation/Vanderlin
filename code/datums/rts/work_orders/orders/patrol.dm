/datum/work_order/patrol
	name = "Patrolling to point"
	stamina_cost = 2
	work_time_left = 3 SECONDS
	visible_message = "patrols the area."
	var/datum/persistant_workorder/patrol/patrol_order

/datum/work_order/patrol/New(mob/living/new_worker, datum/work_order/type, turf/target_point, datum/persistant_workorder/patrol/source_patrol)
	. = ..()
	patrol_order = source_patrol
	set_movement_target(target_point)

/datum/work_order/patrol/finish_work()
	if(patrol_order)
		patrol_order.advance_to_next_point()
		// Will automatically get reassigned on next process cycle
	return ..()
