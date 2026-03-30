GLOBAL_LIST_EMPTY(tram_signals)
GLOBAL_LIST_EMPTY(tram_signs)
GLOBAL_LIST_EMPTY(tram_doors)

/obj/machinery/tram_controls
	name = "tram controls"
	desc = "An interface for the tram that lets you tell the tram where to go and hopefully it makes it there. I'm here to describe the controls to you, not to inspire confidence."
	icon_state = "tram_controls"
	layer = SIGN_LAYER
	density = FALSE
	flags_1 = NODECONSTRUCT_1
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	light_color = COLOR_BLUE_LIGHT
	light_outer_range = 0 //we dont want to spam SSlighting with source updates every movement

	///Weakref to the tram piece we control
	var/datum/weakref/tram_ref

	var/specific_lift_id = TRAM_LIFT_ID

/obj/machinery/tram_controls/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/tram_controls/LateInitialize()
	. = ..()
	find_tram()

/**
 * Finds the tram from the console
 *
 * Locates tram parts in the lift global list after everything is done.
 */
/obj/machinery/tram_controls/proc/find_tram()
	for(var/datum/lift_master/lift as anything in GLOB.active_lifts_by_type[TRAM_LIFT_ID])
		if(lift.specific_lift_id == specific_lift_id)
			tram_ref = WEAKREF(lift)


/**
 * Finds the destinations for the tram console gui
 *
 * Pulls tram landmarks from the landmark gobal list
 * and uses those to show the proper icons and destination
 * names for the tram console gui.
 */
/obj/machinery/tram_controls/proc/get_destinations()
	. = list()
	for(var/obj/effect/landmark/tram/destination as anything in GLOB.tram_landmarks[specific_lift_id])
		var/list/this_destination = list()
		this_destination["name"] = destination.name
		this_destination["dest_icons"] = destination.tgui_icons
		this_destination["id"] = destination.platform_code
		. += list(this_destination)

/obj/machinery/tram_controls/ui_act(action, params)
	. = ..()
	if (.)
		return

	switch (action)
		if ("send")
			var/obj/effect/landmark/tram/destination_platform
			for (var/obj/effect/landmark/tram/destination as anything in GLOB.tram_landmarks[specific_lift_id])
				if(destination.platform_code == params["destination"])
					destination_platform = destination
					break

			if (!destination_platform)
				return FALSE

			return try_send_tram(destination_platform)

/// Attempts to sends the tram to the given destination
/obj/machinery/tram_controls/proc/try_send_tram(obj/effect/landmark/tram/destination_platform)
	var/datum/lift_master/tram/tram_part = tram_ref?.resolve()
	if(!tram_part)
		return FALSE
	if(tram_part.controls_locked || tram_part.travelling) // someone else started already
		return FALSE
	tram_part.tram_travel(destination_platform)
	return TRUE

/obj/machinery/tram_controls/proc/update_operating() // Pass the operating status from the controls to the lift_master
	var/datum/lift_master/tram/tram_part = tram_ref?.resolve()
	if(tram_part)
		tram_part.is_operational = TRUE
