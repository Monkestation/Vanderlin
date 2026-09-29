/obj/effect/abstract/path_point
	icon = 'icons/effects/fov/fov_effects.dmi'
	icon_state = "empty_image"
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = RESET_COLOR | RESET_TRANSFORM
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER

/obj/structure/fluff/signage/waypoint
	name = "waypost"
	desc = "A weathered signpost, carved with directions."
	layer = BELOW_MOB_LAYER

	/// List of waypoint_ids seperate so you can map edit better I think?
	var/list/destination_ids = list()
	/// name shown in the radial = atom/turf it points to
	var/list/destinations = list()
	///sub list of the image used for each destination to avoid recreation radial = image
	var/list/destination_images = list()

/obj/structure/fluff/signage/waypoint/default
	destination_ids = list(
		"inn",
		"tailor",
		"apothecary",
		"clinic",
		"smithy",
		"merchant",
		"mage"
	)
/obj/structure/fluff/signage/waypoint/Initialize(mapload)
	. = ..()
	if(length(destination_ids))
		build_destinations()

/obj/structure/fluff/signage/waypoint/Destroy()
	. = ..()
	QDEL_LIST(destinations)
	QDEL_LIST(destination_images)

/obj/structure/fluff/signage/waypoint/proc/build_destinations()
	for(var/id in destination_ids)
		var/obj/effect/landmark/waypoint_target/target = GLOB.waypoint_targets[id]
		if(!target)
			continue
		var/label = target.name
		destinations[label] = target
		destination_images[label] = icon(target.icon, target.icon_state)

/obj/structure/fluff/signage/waypoint/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return

	if(!user.is_literate())
		user.adjust_experience(/datum/attribute/skill/misc/reading, 2, FALSE)
		to_chat(user, span_warning("You can't make sense of what's carved into [src]."))
		return

	if(!length(destinations))
		to_chat(user, span_notice("[src] doesn't seem to point anywhere."))
		return

	var/list/choices = list()
	for(var/dest_name in destinations)
		choices[dest_name] = destination_images[dest_name]

	var/choice = show_radial_menu(user, src, choices, radius = 48, require_near = TRUE, tooltips = TRUE, radial_slice_icon = "radial_thaum")
	if(!choice)
		return

	var/atom/target = destinations[choice]
	if(!target)
		return

	SSwaypoints.set_waypoint(user, target)
	to_chat(user, span_notice("You get your bearings from [src]."))


/datum/waypoint_guide
	var/mob/living/owner
	var/atom/target
	var/list/image/display_images = list()
	/// hosts the real /datum/proximity_monitor for the current target
	var/obj/effect/abstract/waypoint_marker/marker

/datum/waypoint_guide/New(mob/living/owner, atom/target)
	. = ..()
	src.owner = owner
	RegisterSignal(owner, COMSIG_QDELETING, PROC_REF(on_owner_deleted))
	RegisterSignal(owner, COMSIG_MOB_LOGOUT, PROC_REF(on_owner_logout))
	set_target(target)

/datum/waypoint_guide/Destroy(force)
	clear_visuals()
	clear_proximity()
	if(owner)
		UnregisterSignal(owner, list(COMSIG_QDELETING, COMSIG_MOB_LOGOUT))
	owner = null
	target = null
	return ..()

/datum/waypoint_guide/proc/on_owner_deleted(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/waypoint_guide/proc/on_owner_logout(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/waypoint_guide/proc/set_target(atom/new_target)
	target = new_target
	INVOKE_ASYNC(src, PROC_REF(build_path))

/datum/waypoint_guide/proc/build_path()
	if(!owner || !target)
		return

	var/list/turf/path = get_path_to_closest_approach(
		owner,
		get_turf(target),
		TYPE_PROC_REF(/turf, Heuristic_cardinal_3d),
		100,
		100,
		1,
	)

	render_footsteps(path)
	watch_proximity()

/datum/waypoint_guide/proc/render_footsteps(list/turf/path)
	clear_visuals()
	if(!length(path))
		return

	for(var/i in 1 to length(path))
		var/turf/step = path[i]
		var/facing = (i < length(path)) ? get_dir(step, path[i + 1]) : SOUTH
		var/image/footstep = image('icons/effects/fov/fov_effects.dmi', step, "path_step", ABOVE_MOB_LAYER, facing)
		footstep.plane = GAME_PLANE_UPPER
		footstep.appearance_flags = RESET_COLOR | RESET_TRANSFORM
		footstep.alpha = 175
		footstep.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		display_images += footstep

	owner.client?.images += display_images

/datum/waypoint_guide/proc/clear_visuals()
	owner?.client?.images -= display_images
	display_images = list()

/datum/waypoint_guide/proc/watch_proximity()
	clear_proximity()
	if(!target)
		return

	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return

	marker = new /obj/effect/abstract/waypoint_marker(target_turf, src, 3)

/datum/waypoint_guide/proc/clear_proximity()
	QDEL_NULL(marker)

/datum/waypoint_guide/proc/on_reached()
	qdel(src)

/obj/effect/abstract/waypoint_marker
	name = ""
	invisibility = INVISIBILITY_ABSTRACT
	anchored = TRUE
	var/datum/waypoint_guide/guide
	var/datum/proximity_monitor/proximity_monitor

/obj/effect/abstract/waypoint_marker/Initialize(mapload, datum/waypoint_guide/guide, range = 1)
	. = ..()
	src.guide = guide
	proximity_monitor = new(src, range)

/obj/effect/abstract/waypoint_marker/Destroy(force)
	QDEL_NULL(proximity_monitor)
	guide = null
	return ..()

/obj/effect/abstract/waypoint_marker/HasProximity(mob/nearby)
	if(!istype(nearby) || !guide)
		return
	if(nearby != guide.owner)
		return
	guide.on_reached()
