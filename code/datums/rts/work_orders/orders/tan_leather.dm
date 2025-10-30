/datum/work_order/tan_leather
	name = "Tanning Leather"
	work_time_left = 40 SECONDS
	stamina_cost = 8
	var/obj/effect/building_node/tannery/tannery
	var/obj/effect/workspot/workspot

/datum/work_order/tan_leather/New(mob/living/new_worker, datum/work_order/type, obj/effect/workspot/work_spot, obj/effect/building_node/tannery/tannery_node)
	. = ..()
	tannery = tannery_node
	workspot = work_spot
	set_movement_target(work_spot)

/datum/work_order/tan_leather/start_working(mob/living/worker_mob)
	if(!tannery.use_work_materials(list(MAT_HIDE = 1)))
		worker.controller_mind.pause_task_for(30 SECONDS, workspot)
		tannery.add_material_request(src, list(MAT_HIDE = 1), 3)
		return
	. = ..()

/datum/work_order/tan_leather/finish_work()
	tannery.materials_to_store |= MAT_LEATHER
	tannery.materials_to_store[MAT_LEATHER] += 1
	. = ..()
