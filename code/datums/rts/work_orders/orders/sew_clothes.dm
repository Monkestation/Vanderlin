/datum/work_order/sew_clothes
	name = "Sewing Cloth"
	work_time_left = 35 SECONDS
	stamina_cost = 5
	var/obj/effect/building_node/tailorshop/tailorshop
	var/obj/effect/workspot/workspot

/datum/work_order/sew_clothes/New(mob/living/new_worker, datum/work_order/type, obj/effect/workspot/work_spot, obj/effect/building_node/tailorshop/shop)
	. = ..()
	tailorshop = shop
	workspot = work_spot
	set_movement_target(work_spot)

/datum/work_order/sew_clothes/start_working(mob/living/worker_mob)
	if(!tailorshop.use_work_materials(list(MAT_SILK = 1)))
		worker.controller_mind.pause_task_for(30 SECONDS, workspot)
		tailorshop.add_material_request(src, list(MAT_SILK = 1), 3)
		return
	. = ..()


/datum/work_order/sew_clothes/finish_work()
	tailorshop.materials_to_store |= MAT_CLOTH
	tailorshop.materials_to_store[MAT_CLOTH] += 1
	. = ..()
