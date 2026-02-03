/obj/effect/landmark/tram/queued_path/cargo_exit
	platform_code = "cargo_exit"

/obj/effect/landmark/tram/queued_path/cargo_pre_enter
	platform_code = "cargo_pre_enter"



/obj/effect/landmark/tram/queued_path/cargo_storage_point
	platform_code = "cargo_storage_point"
	next_path_id = "cargo_map_enter"


/obj/effect/landmark/tram/queued_path/cargo_map_enter
	platform_code = "cargo_map_enter"
	next_path_id = "cargo_stop"
	var/datum/lift_master/tram/held_tram

/obj/effect/landmark/tram/queued_path/cargo_map_enter/Initialize(mapload)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_DISPATCH_CARGO, PROC_REF(dispatch_cargo))

/obj/effect/landmark/tram/queued_path/cargo_map_enter/tram_reached_travel_point(datum/source, datum/lift_master/tram/tram)
	tram.destination = null
	held_tram = tram
	SSmerchant.cargo_docked = TRUE

/obj/effect/landmark/tram/queued_path/cargo_map_enter/proc/dispatch_cargo(datum/source, datum/lift_master/tram/tram)
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

/obj/effect/landmark/tram/queued_path/cargo_map_exit
	platform_code = "cargo_map_exit"
	next_path_id = "cargo_storage_point"



/obj/effect/landmark/tram/queued_path/cargo_stop
	platform_code = "cargo_stop"

	next_path_id = "cargo_exit"

/obj/effect/landmark/tram/queued_path/cargo_stop/tram_reached_travel_point(datum/source, datum/lift_master/tram/tram)
	RegisterSignal(tram, COMSIG_TRAM_EMPTY, PROC_REF(send_cargo_boat))

/obj/effect/landmark/tram/queued_path/cargo_stop/proc/send_cargo_boat(datum/lift_master/tram/tram)
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


/obj/effect/landmark/tram/queued_path/cargo_map_exit/tram_reached_travel_point(datum/source, datum/lift_master/tram/tram)
	tram.try_sell_items()
	tram.try_process_order()
	tram.hide_tram()
	. = ..()
