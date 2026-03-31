/obj/item/essence_connector
	name = "pestran connector"
	desc = "A oddly shaped object used to create connections between alchemical apparatus. Can sense nearby essence nodes. Something under the metal squirms..."
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "connector"
	w_class = WEIGHT_CLASS_SMALL
	var/obj/machinery/essence/source_device = null
	var/connecting = FALSE
	slot_flags = ITEM_SLOT_HIP
	COOLDOWN_DECLARE(next_scan)

/obj/item/essence_connector/afterattack(atom/target, mob/user, proximity_flag, list/modifiers)
	if(!proximity_flag)
		. = ..()
		return

	var/obj/machinery/essence/machine = target
	if(!istype(machine))
		to_chat(user, span_warning("[target] is not an essence device."))
		return

	if(connecting)
		complete_connection(machine, user)
	else
		start_connection(machine, user)

/obj/item/essence_connector/attack_self(mob/user, list/modifiers)
	if(connecting)
		cancel_connection(user)
	else
		if(!COOLDOWN_FINISHED(src, next_scan))
			return

		COOLDOWN_START(src, next_scan, 2 SECONDS)

		var/obj/structure/essence_node/closest
		var/closest_dist = INFINITY
		for(var/obj/structure/essence_node/node as anything in GLOB.essence_nodes)
			if(!isturf(node.loc))
				continue
			if(node.z != user.z)
				continue
			if(get_dist(user, node) > closest_dist)
				continue
			closest = node
			closest_dist = get_dist(user, node)

		if(!closest)
			return

		var/dir = get_dir(user, closest)
		var/arrow_color

		switch(closest_dist)
			if(1 to 5)
				arrow_color = COLOR_GREEN
			if(6 to 10)
				arrow_color = COLOR_YELLOW
			if(11 to 15)
				arrow_color = COLOR_ORANGE
			else
				arrow_color = COLOR_RED

		var/datum/hud/user_hud = user.hud_used
		if(!user_hud || !istype(user_hud, /datum/hud) || !islist(user_hud.infodisplay))
			return

		var/atom/movable/screen/multitool_arrow/arrow = new(null, user_hud)
		arrow.color = arrow_color
		arrow.screen_loc = "CENTER-1,CENTER-1"
		arrow.transform = matrix(dir2angle(dir), MATRIX_ROTATE)

		user_hud.infodisplay += arrow
		user_hud.show_hud(user_hud.hud_version)

		QDEL_IN(arrow, 1.5 SECONDS)

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

/obj/item/essence_connector/proc/start_connection(obj/machinery/essence/machine, mob/user)
	source_device = machine
	connecting = TRUE
	machine.add_overlay(get_connection_overlay("source"))
	to_chat(user, span_info("Connection started from [machine.name]. Click another device to link, or use in hand to cancel."))

/obj/item/essence_connector/proc/complete_connection(obj/machinery/essence/target, mob/user)
	if(target == source_device)
		to_chat(user, span_warning("Cannot connect a device to itself."))
		cancel_connection(user)
		return

	if(source_device.is_connected_to(target))
		to_chat(user, span_warning("[source_device.name] is already connected to [target.name]."))
		cancel_connection(user)
		return

	if(source_device.can_connect_to(target))
		source_device.create_connection(target, user)
		to_chat(user, span_info("Successfully connected [source_device.name] to [target.name]."))
	else
		to_chat(user, span_warning("Cannot establish connection between these devices."))

	cancel_connection(user)

/obj/item/essence_connector/proc/cancel_connection(mob/user)
	if(source_device)
		source_device.cut_overlay(get_connection_overlay("source"))
		source_device = null
	connecting = FALSE
	to_chat(user, span_info("Connection cancelled."))

/obj/item/essence_connector/proc/get_connection_overlay(state)
	var/mutable_appearance/overlay = mutable_appearance('icons/effects/effects.dmi', "connection_[state]")
	overlay.layer = ABOVE_MOB_LAYER
	return overlay

/obj/machinery/essence/splitter/can_connect_to(obj/machinery/essence/target)
	return istype(target, /obj/machinery/essence/combiner) || \
		   istype(target, /obj/machinery/essence/reservoir) || \
		   istype(target, /obj/machinery/essence/enchantment_altar) || \
		   istype(target, /obj/machinery/essence/test_tube) || \
		   istype(target, /obj/machinery/essence/infuser) || \
		   istype(target, /obj/machinery/essence/research_matrix)

/obj/machinery/essence/combiner/can_connect_to(obj/machinery/essence/target)
	return istype(target, /obj/machinery/essence/reservoir) || \
		   istype(target, /obj/machinery/essence/enchantment_altar) || \
		   istype(target, /obj/machinery/essence/test_tube) || \
		   istype(target, /obj/machinery/essence/infuser) || \
		   istype(target, /obj/machinery/essence/research_matrix)

/obj/machinery/essence/reservoir/can_connect_to(obj/machinery/essence/target)
	return istype(target, /obj/machinery/essence/combiner) || \
		   istype(target, /obj/machinery/essence/reservoir) || \
		   istype(target, /obj/machinery/essence/enchantment_altar) || \
		   istype(target, /obj/machinery/essence/test_tube) || \
		   istype(target, /obj/machinery/essence/infuser) || \
		   istype(target, /obj/machinery/essence/research_matrix)

/obj/machinery/essence/harvester/can_connect_to(obj/machinery/essence/target)
	return istype(target, /obj/machinery/essence/combiner) || \
		   istype(target, /obj/machinery/essence/reservoir) || \
		   istype(target, /obj/machinery/essence/enchantment_altar) || \
		   istype(target, /obj/machinery/essence/test_tube) || \
		   istype(target, /obj/machinery/essence/infuser) || \
		   istype(target, /obj/machinery/essence/research_matrix)

/datum/essence_connection
	var/obj/machinery/essence/source
	var/obj/machinery/essence/target
	var/transfer_rate = 10
	var/active = TRUE
	var/established_by

/datum/essence_connection/Destroy()
	source = null
	target = null
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
	var/obj/machinery/essence/destination
	var/travel_time = 2 SECONDS

/obj/effect/essence_orb/Initialize(mapload, obj/machinery/essence/dest_machine, essence_type, travel_duration = 2 SECONDS)
	. = ..()

	if(!dest_machine || QDELETED(dest_machine))
		return INITIALIZE_HINT_QDEL

	destination = dest_machine
	travel_time = travel_duration

	setup_appearance(essence_type)
	animate_to_destination()

/obj/effect/essence_orb/proc/setup_appearance(essence_type)
	if(essence_type)
		var/datum/thaumaturgical_essence/essence = new essence_type
		essence_color = essence.color
		qdel(essence)

	color = essence_color

/obj/effect/essence_orb/proc/animate_to_destination()
	if(!destination || QDELETED(destination))
		qdel(src)
		return

	var/turf/start_turf = get_turf(src)
	var/turf/end_turf = get_turf(destination)

	if(!start_turf || !end_turf)
		qdel(src)
		return

	var/pixel_dx = (end_turf.x - start_turf.x) * 32
	var/pixel_dy = (end_turf.y - start_turf.y) * 32

	// Arc movement
	var/arc_height = min(sqrt(pixel_dx*pixel_dx + pixel_dy*pixel_dy) * 0.3, 16)

	animate(src, pixel_x = pixel_dx/2, pixel_y = pixel_dy/2 + arc_height,
			time = travel_time/2, easing = SINE_EASING)
	animate(pixel_x = pixel_dx, pixel_y = pixel_dy,
			time = travel_time/2, easing = SINE_EASING)

	// Gentle pulsing
	animate(alpha = 180, time = travel_time/4, loop = 4, easing = SINE_EASING, flags = ANIMATION_PARALLEL)
	animate(alpha = 255, time = travel_time/4, easing = SINE_EASING)

	addtimer(CALLBACK(src, PROC_REF(arrive_at_destination)), travel_time)

/obj/effect/essence_orb/proc/arrive_at_destination()
	if(destination && !QDELETED(destination))
		var/turf/dest_turf = get_turf(destination)
		if(dest_turf)
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
