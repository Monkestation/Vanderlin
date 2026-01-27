/obj/structure/meatvine/intestine_wormhole
	name = "pulsating intestinal passage"
	desc = "A grotesque tunnel of writhing intestinal tissue. You could probably enter it..."
	icon_state = "intestine_wormhole"
	density = FALSE
	max_integrity = 200
	layer = LOW_SIGIL_LAYER
	var/wormhole_id // Unique ID for this wormhole network

/obj/structure/meatvine/intestine_wormhole/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	if(!locate(/obj/structure/meatvine/floor) in T)
		return INITIALIZE_HINT_QDEL

	RegisterSignal(T, COMSIG_PARENT_QDELETING, PROC_REF(on_floor_destroyed))

/obj/structure/meatvine/intestine_wormhole/proc/on_floor_destroyed()
	visible_message("<span class='warning'>[src] collapses as its foundation is destroyed!</span>")
	qdel(src)

/obj/structure/meatvine/intestine_wormhole/proc/try_use(mob/living/user)
	var/list/network_wormholes = list()
	if(master)
		for(var/obj/structure/meatvine/intestine_wormhole/wormhole in master.vines)
			if(wormhole.wormhole_id == wormhole_id) // Include ALL wormholes with same ID
				network_wormholes += wormhole

	if(network_wormholes.len <= 1) // Need at least 2 wormholes to travel
		to_chat(user, "<span class='warning'>This passage leads nowhere...</span>")
		return

	enter_wormhole(user, network_wormholes)

/obj/structure/meatvine/intestine_wormhole/proc/enter_wormhole(mob/living/user, list/destinations)
	if(!user.client)
		return

	user.alpha = 0

	to_chat(user, "<span class='notice'>You squeeze into the pulsating passage. You feel other exits nearby...</span>")

	var/datum/wormhole_travel_ui/ui = new(user, src, destinations)
	ui.show()

/datum/wormhole_travel_ui
	var/mob/living/traveler
	var/obj/structure/meatvine/intestine_wormhole/origin
	var/list/destinations = list()
	var/current_index = 1
	var/obj/screen/wormhole_navigate/left_button
	var/obj/screen/wormhole_navigate/right_button

/datum/wormhole_travel_ui/New(mob/living/user, obj/structure/meatvine/intestine_wormhole/entry_point, list/destination_list)
	traveler = user
	origin = entry_point
	destinations = destination_list.Copy()

	// Start at the origin wormhole
	current_index = destinations.Find(entry_point)
	if(!current_index)
		current_index = 1

	// Register signal to cleanup when mob moves
	RegisterSignal(traveler, COMSIG_MOVABLE_MOVED, PROC_REF(on_traveler_moved))

/datum/wormhole_travel_ui/proc/on_traveler_moved(mob/source, atom/old_loc, movement_dir, forced, list/old_locs)
	// Only cleanup if they moved away from a wormhole location
	var/turf/current_turf = get_turf(traveler)
	var/on_wormhole = FALSE

	for(var/obj/structure/meatvine/intestine_wormhole/wormhole in destinations)
		if(get_turf(wormhole) == current_turf)
			on_wormhole = TRUE
			break

	if(!on_wormhole)
		exit_wormhole()

/datum/wormhole_travel_ui/proc/show()
	if(!traveler?.client)
		cleanup()
		return

	var/client/C = traveler.client

	left_button = new()
	left_button.ui = src
	left_button.direction = -1
	left_button.screen_loc = "7,7" // More centered
	left_button.update_appearance()
	C.screen += left_button

	right_button = new()
	right_button.ui = src
	right_button.direction = 1
	right_button.screen_loc = "9,7" // More centered
	right_button.update_appearance()
	C.screen += right_button

	move_to_destination()
	update_display()

/datum/wormhole_travel_ui/proc/update_display()
	if(!traveler || current_index > destinations.len)
		return

	var/obj/structure/meatvine/intestine_wormhole/current_dest = destinations[current_index]
	var/area/dest_area = get_area(current_dest)

	to_chat(traveler, "<span class='notice'>Destination [current_index]/[destinations.len]: [dest_area.name]</span>")

/datum/wormhole_travel_ui/proc/navigate(direction)
	current_index += direction

	if(current_index < 1)
		current_index = destinations.len
	else if(current_index > destinations.len)
		current_index = 1

	move_to_destination()
	update_display()

/datum/wormhole_travel_ui/proc/move_to_destination()
	if(!traveler || current_index > destinations.len)
		return

	var/obj/structure/meatvine/intestine_wormhole/destination = destinations[current_index]
	var/turf/dest_turf = get_turf(destination)

	traveler.forceMove(dest_turf)

/datum/wormhole_travel_ui/proc/exit_wormhole()
	if(!traveler)
		return

	cleanup()

	to_chat(traveler, "<span class='notice'>You squeeze out of the passage!</span>")

	animate(traveler, alpha = 255, time = 0.5 SECONDS)

	addtimer(CALLBACK(traveler, TYPE_PROC_REF(/mob/living, Knockdown), 2 SECONDS), 0.5 SECONDS)

/datum/wormhole_travel_ui/proc/cleanup()
	if(traveler)
		UnregisterSignal(traveler, COMSIG_MOVABLE_MOVED)

	if(traveler?.client)
		var/client/C = traveler.client

		if(left_button)
			C.screen -= left_button
			qdel(left_button)

		if(right_button)
			C.screen -= right_button
			qdel(right_button)

	if(traveler && traveler.alpha == 0)
		traveler.alpha = 255

	qdel(src)

/obj/screen/wormhole_navigate
	name = "Navigate"
	icon = 'icons/obj/cellular/putrid_abilities.dmi'
	icon_state = "button_bg"
	plane = HUD_PLANE

	var/datum/wormhole_travel_ui/ui
	var/direction = 0  // -1 for left, 1 for right

/obj/screen/wormhole_navigate/update_icon_state()
	. = ..()
	if(direction < 0)
		icon_state = "button_bg"
		name = "Previous Exit"
	else
		icon_state = "button_bg"
		name = "Next Exit"

/obj/screen/wormhole_navigate/Click()
	if(!ui)
		return

	ui.navigate(direction)

/obj/screen/wormhole_navigate/MouseEntered(location, control, params)
	. = ..()
	transform = matrix() * 1.2

/obj/screen/wormhole_navigate/MouseExited()
	. = ..()
	transform = matrix()
