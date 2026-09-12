/obj/effect/landmark/tram/queued_path/fence_exit
	platform_code = "fence_exit"
	specific_lift_id = "fence"

/obj/effect/landmark/tram/queued_path/fence_pre_enter
	platform_code = "fence_pre_enter"
	specific_lift_id = "fence"


/obj/effect/landmark/tram/queued_path/fence_storage_point
	platform_code = "fence_storage_point"
	next_path_id = "fence_map_enter"
	specific_lift_id = "fence"

/obj/effect/landmark/tram/queued_path/fence_map_enter
	platform_code = "fence_map_enter"
	next_path_id = "fence_stop"
	specific_lift_id = "fence"
	var/datum/lift_master/tram/held_tram

/obj/effect/landmark/tram/queued_path/fence_map_enter/Initialize(mapload)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_DISPATCH_CARGO, PROC_REF(dispatch_cargo))

/obj/effect/landmark/tram/queued_path/fence_map_enter/tram_reached_travel_point(datum/source, datum/lift_master/tram/tram)
	held_tram = tram
	SSmerchant.fence_docked = TRUE
	tram.set_travelling(FALSE)

/obj/effect/landmark/tram/queued_path/fence_map_enter/proc/dispatch_cargo(datum/source, datum/lift_master/tram/tram)
	if(!held_tram)
		held_tram = tram

	if(!SSticker.HasRoundStarted())
		return
	if(!next_path_id)
		return
	var/obj/effect/landmark/tram/destination_platform
	for (var/obj/effect/landmark/tram/destination as anything in GLOB.tram_landmarks[specific_lift_id])
		if(destination.platform_code == next_path_id)
			destination_platform = destination
			break

	if (!destination_platform)
		return FALSE

	held_tram.tram_travel(destination_platform, rapid = FALSE)
	held_tram.callback_platform = destination_platform
	held_tram = null

	return TRUE

/obj/effect/landmark/tram/queued_path/fence_map_exit
	platform_code = "fence_map_exit"
	next_path_id = "fence_storage_point"
	specific_lift_id = "fence"

/obj/effect/landmark/tram/queued_path/fence_stop
	platform_code = "fence_stop"

	next_path_id = "fence_exit"
	specific_lift_id = "fence"

/obj/effect/landmark/tram/queued_path/fence_stop/tram_reached_travel_point(datum/source, datum/lift_master/tram/tram)
	RegisterSignal(tram, COMSIG_TRAM_EMPTY, PROC_REF(send_fence_boat))
	tram.set_travelling(FALSE)

/obj/effect/landmark/tram/queued_path/fence_stop/proc/send_fence_boat(datum/lift_master/tram/tram)
	UnregisterSignal(tram, COMSIG_TRAM_EMPTY)
	if(!SSticker.HasRoundStarted())
		return
	if(!next_path_id)
		return
	var/obj/effect/landmark/tram/destination_platform
	for (var/obj/effect/landmark/tram/destination as anything in GLOB.tram_landmarks[specific_lift_id])
		if(destination.platform_code == next_path_id)
			destination_platform = destination
			break

	if (!destination_platform)
		return FALSE

	tram.tram_travel(destination_platform, rapid = FALSE)
	tram.callback_platform = destination_platform


/obj/effect/landmark/tram/queued_path/fence_map_exit/tram_reached_travel_point(datum/source, datum/lift_master/tram/tram)
	tram.try_sell_items()
	tram.try_process_order()
	tram.hide_tram()
	tram.set_travelling(FALSE)
	. = ..()
