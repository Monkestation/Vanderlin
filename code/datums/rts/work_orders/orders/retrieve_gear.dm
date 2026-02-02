/datum/work_order/retrieve_gear
	name = "Retrieve Gear"
	visible_message = "is retrieving equipment."
	work_time_left = 3 SECONDS
	stamina_cost = 5
	can_continue = TRUE
	var/datum/worker_gear/gear_to_retrieve
	var/obj/effect/building_node/source_storage

/datum/work_order/retrieve_gear/New(mob/living/worker, obj/effect/building_node/storage_node, datum/worker_gear/gear)
	. = ..()
	source_storage = storage_node
	gear_to_retrieve = gear
	work_target = storage_node

/datum/work_order/retrieve_gear/start_working(mob/living/worker_mob)
	if(!source_storage || !gear_to_retrieve)
		stop_work("missing source or gear")
		return

	if(!source_storage.Adjacent(worker_mob))
		set_movement_target(source_storage)
		return

	if(!(gear_to_retrieve in source_storage.stored_gear))
		stop_work("gear no longer available")
		return
	return ..()

/datum/work_order/retrieve_gear/finish_work()
	if(worker.controller_mind.has_gear_in_slot(gear_to_retrieve.slot))
		stop_work("slot already occupied")
		return

	if(!(gear_to_retrieve in source_storage.stored_gear))
		stop_work("gear no longer available")
		return

	source_storage.retrieve_gear(gear_to_retrieve)
	gear_to_retrieve.owner = worker.controller_mind
	worker.controller_mind.worker_gear[gear_to_retrieve.slot] = gear_to_retrieve
	gear_to_retrieve.item.forceMove(worker)

	SEND_SIGNAL(worker.controller_mind, COMSIG_WORKER_GEAR_CHANGED, gear_to_retrieve.slot, null, gear_to_retrieve)
	worker.controller_mind?.update_gear_overlay(gear_to_retrieve.slot)
	. = ..()
