/datum/work_order/construct_building
	name = "Constructing "
	stamina_cost = 15
	work_time_left = 15 SECONDS

	var/datum/building_datum/building

/datum/work_order/construct_building/New(mob/living/new_worker, datum/work_order/type, datum/building_datum/building_source, turf/center_turf)
	. = ..()
	set_movement_target(center_turf)
	name += building_source.name
	building = building_source


/datum/work_order/construct_building/stop_work(reason = "unknown")
	. = ..()
	building?.current_workers--
	building = null

/datum/work_order/construct_building/finish_work()
	building.construct_building()
	. = ..()
