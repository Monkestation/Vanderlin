/obj/item/essence_connector
	name = "pestran connector"
	desc = "A oddly shaped object used to create connections between alchemical apparatus. Something under the metal squirms..."
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "connector"
	w_class = WEIGHT_CLASS_SMALL
	item_weight = 340 GRAMS
	slot_flags = ITEM_SLOT_HIP
	COOLDOWN_DECLARE(next_scan)

	var/obj/machinery/essence/source_device = null
	var/connecting = FALSE

/obj/item/essence_connector/proc/resolve_essence_machine(atom/target)
	if(istype(target, /obj/machinery/essence))
		return target
	if(istype(target, /obj/machinery/light/fueled/cauldron))
		var/obj/machinery/light/fueled/cauldron/C = target
		return C.essence_node
	return null

/obj/item/essence_connector/afterattack(atom/target, mob/user, proximity_flag, list/modifiers)
	if(!proximity_flag)
		return ..()
	if(user.get_active_held_item() != src)
		return ..()

	var/obj/machinery/essence/machine = resolve_essence_machine(target)
	if(!machine)
		if(connecting)
			to_chat(user, span_warning("[target] is not an essence device."))
		return

	if(connecting)
		complete_connection(machine, user)
		return
	start_connection(machine, user)

/obj/item/essence_connector/proc/complete_connection(obj/machinery/essence/target, mob/user)
	var/obj/machinery/essence/from = source_device
	// Clear state FIRST before any early returns so we're never left in a broken half-state
	source_device.cut_overlay(get_connection_overlay("source"))
	source_device = null
	connecting = FALSE

	if(target == from)
		to_chat(user, span_warning("Cannot connect a device to itself."))
		return

	for(var/datum/essence_link/existing in from.links)
		if(existing.source == from && existing.sink == target)
			to_chat(user, span_warning("These devices are already linked in that direction."))
			return

	var/datum/essence_link/link = essence_create_link(from, target)
	if(!link)
		to_chat(user, span_warning("Could not create link, check that both machines accept connections in that direction."))
		return

	to_chat(user, span_info("Linked [get_display_name(from)] → [get_display_name(target)]."))

/obj/item/essence_connector/proc/cancel_connection(mob/user)
	if(source_device)
		source_device.cut_overlay(get_connection_overlay("source"))
		source_device = null
	connecting = FALSE
	if(user)
		to_chat(user, span_info("Connection cancelled."))

/obj/item/essence_connector/attack_self(mob/user, list/modifiers)
	if(connecting)
		cancel_connection(user)
		return

	if(!COOLDOWN_FINISHED(src, next_scan))
		return
	COOLDOWN_START(src, next_scan, 2 SECONDS)

	// Scan for nearby essence nodes only (structures, not machines)
	var/obj/structure/essence_node/closest = null
	var/closest_dist = INFINITY

	for(var/obj/structure/essence_node/node in GLOB.essence_nodes)
		if(!isturf(node.loc))
			continue
		if(node.z != user.z)
			continue
		var/d = get_dist(user, node)
		if(d >= closest_dist)
			continue
		closest = node
		closest_dist = d

	if(!closest)
		to_chat(user, span_warning("No essence nodes detected nearby."))
		return

	var/dir = get_dir(user, closest)
	var/arrow_color
	switch(closest_dist)
		if(1 to 5)   arrow_color = COLOR_GREEN
		if(6 to 10)  arrow_color = COLOR_YELLOW
		if(11 to 15) arrow_color = COLOR_ORANGE
		else         arrow_color = COLOR_RED

	var/datum/hud/user_hud = user.hud_used
	if(!user_hud || !islist(user_hud.infodisplay))
		return

	var/atom/movable/screen/multitool_arrow/arrow = new(null, user_hud)
	arrow.color = arrow_color
	arrow.screen_loc = "CENTER-1,CENTER-1"
	arrow.transform = matrix(dir2angle(dir), MATRIX_ROTATE)
	user_hud.infodisplay += arrow
	user_hud.show_hud(user_hud.hud_version)
	QDEL_IN(arrow, 1.5 SECONDS)

/obj/item/essence_connector/proc/start_connection(obj/machinery/essence/machine, mob/user)
	source_device = machine
	connecting = TRUE
	machine.add_overlay(get_connection_overlay("source"))
	to_chat(user, span_info("Connection started from [get_display_name(machine)]. Click another device to complete the link, or use in hand to cancel."))

/obj/item/essence_connector/proc/get_display_name(obj/machinery/essence/machine)
	if(istype(machine, /obj/machinery/essence/cauldron_node))
		var/obj/machinery/essence/cauldron_node/node = machine
		return node.owner ? node.owner.name : machine.name
	return machine.name

/obj/item/essence_connector/proc/get_connection_overlay(state)
	var/mutable_appearance/overlay = mutable_appearance('icons/effects/effects.dmi', "connection_[state]")
	overlay.layer = ABOVE_MOB_LAYER
	return overlay

/atom/movable/screen/multitool_arrow
	icon = 'icons/effects/96x96.dmi'
	icon_state = "multitool_arrow"
	pixel_x = -32
	pixel_y = -32

/atom/movable/screen/multitool_arrow/Destroy()
	if(hud)
		hud.infodisplay -= src
		INVOKE_ASYNC(hud, TYPE_PROC_REF(/datum/hud, show_hud), hud.hud_version)
	return ..()

/obj/effect/essence_orb
	name = "essence orb"
	desc = "Alchemical essence in transit along a silver thread."
	icon = 'icons/effects/effects.dmi'
	icon_state = "phasein"
	density = FALSE
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	var/essence_color = "#4A90E2"
	var/travel_time = 2 SECONDS

/obj/effect/essence_orb/Initialize(mapload, turf/destination_turf, essence_type, travel_duration = 2 SECONDS)
	. = ..()
	if(!destination_turf)
		return INITIALIZE_HINT_QDEL
	travel_time = travel_duration
	if(essence_type)
		var/datum/thaumaturgical_essence/essence = new essence_type
		essence_color = essence.color
		qdel(essence)
	color = essence_color
	animate_to_destination(destination_turf)

/obj/effect/essence_orb/proc/animate_to_destination(turf/end_turf)
	var/turf/start_turf = get_turf(src)
	if(!start_turf || !end_turf)
		qdel(src)
		return

	var/pixel_dx = (end_turf.x - start_turf.x) * 32
	var/pixel_dy = (end_turf.y - start_turf.y) * 32
	var/arc_height = min(sqrt(pixel_dx**2 + pixel_dy**2) * 0.3, 16)

	animate(src, pixel_x = pixel_dx/2, pixel_y = pixel_dy/2 + arc_height,
		time = travel_time/2, easing = SINE_EASING)
	animate(pixel_x = pixel_dx, pixel_y = pixel_dy,
		time = travel_time/2, easing = SINE_EASING)
	animate(alpha = 180, time = travel_time/4, loop = 4, easing = SINE_EASING, flags = ANIMATION_PARALLEL)
	animate(alpha = 255, time = travel_time/4, easing = SINE_EASING)

	addtimer(CALLBACK(src, PROC_REF(arrive), end_turf), travel_time)

/obj/effect/essence_orb/proc/arrive(turf/dest_turf)
	new /obj/effect/temp_visual/essence_sparkle(dest_turf, essence_color)
	qdel(src)

/obj/effect/temp_visual/essence_sparkle
	icon = 'icons/effects/effects.dmi'
	icon_state = "sparkles"
	duration = 1 SECONDS
	layer = ABOVE_MOB_LAYER

/obj/effect/temp_visual/essence_sparkle/Initialize(mapload, spark_color = "#4A90E2")
	. = ..()
	color = spark_color
	set_light(1, 1, 1,  l_color = spark_color)
