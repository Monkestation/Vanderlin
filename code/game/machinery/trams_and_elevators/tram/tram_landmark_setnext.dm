/obj/effect/landmark/tram/queued_path
	name = "tram destination continue pathing"

	var/next_path_id

/obj/effect/landmark/tram/queued_path/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_TRAM_REACHED_PLATFORM, PROC_REF(tram_reached_travel_point))

/obj/effect/landmark/tram/queued_path/Destroy()
	. = ..()
	UnregisterSignal(src, COMSIG_TRAM_REACHED_PLATFORM)

/obj/effect/landmark/tram/queued_path/proc/tram_reached_travel_point(datum/source, datum/lift_master/tram/tram)
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
	tram.set_travelling(FALSE)
	tram.tram_travel(destination_platform)
	tram.callback_platform = destination_platform

	return TRUE

/obj/effect/landmark/tram/queued_path/debug_1
	specific_lift_id = DEBUG_LIFT_ID
	platform_code = "debug_1"
	next_path_id = "debug_2"

/obj/effect/landmark/tram/queued_path/debug_2
	specific_lift_id = DEBUG_LIFT_ID
	platform_code = "debug_2"
	next_path_id = "debug_1"
