/obj/structure/meatvine/tracking_beacon
	icon = 'icons/obj/cellular/meat.dmi'
	icon_state = "tracking_beacon"
	name = "probing mass"
	desc = "A pulsating organic sensor that marks intruders for the putrid's attention."
	density = FALSE
	opacity = FALSE
	pass_flags = LETPASSTHROW
	max_integrity = 25
	resistance_flags = CAN_BE_HIT
	layer = LOW_SIGIL_LAYER

	var/obj/structure/meatvine/floor/floor_vine = null
	var/datum/proximity_monitor/advanced/beacon_monitor/monitor = null
	var/tracking_range = 4
	var/mark_duration = 12 SECONDS

	var/pulse_color = "#ff3333"

/obj/structure/meatvine/tracking_beacon/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	floor_vine = locate(/obj/structure/meatvine/floor) in T
	if(!floor_vine)
		qdel(src)
		return INITIALIZE_HINT_QDEL

	RegisterSignal(floor_vine, COMSIG_PARENT_QDELETING, PROC_REF(on_floor_destroyed))

	monitor = new(src, tracking_range, FALSE)
	monitor.beacon = src
	monitor.recalculate_field(full_recalc = TRUE)

	set_light(2, 1, 1, l_color = pulse_color)
	start_pulse_animation()

	return .

/obj/structure/meatvine/tracking_beacon/Destroy()
	if(floor_vine)
		UnregisterSignal(floor_vine, COMSIG_PARENT_QDELETING)
	floor_vine = null

	QDEL_NULL(monitor)

	return ..()

/obj/structure/meatvine/tracking_beacon/proc/on_floor_destroyed(datum/source)
	SIGNAL_HANDLER
	floor_vine = null
	qdel(src)

/obj/structure/meatvine/tracking_beacon/proc/start_pulse_animation()
	animate(src, alpha = 180, time = 1 SECONDS, loop = -1)
	animate(alpha = 255, time = 1 SECONDS)

/obj/structure/meatvine/tracking_beacon/proc/mark_target(atom/movable/target)
	if(!isliving(target))
		return FALSE

	var/mob/living/L = target

	if(istype(L, /mob/living/simple_animal/hostile/retaliate/meatvine))
		return FALSE

	if(L.has_status_effect(/datum/status_effect/meatvine_tracked))
		return FALSE

	L.apply_status_effect(/datum/status_effect/meatvine_tracked, mark_duration)

	new /obj/effect/temp_visual/meatvine_mark(get_turf(L))

	if(master)
		master.add_hive_tracker(L, mark_duration)

	to_chat(L, span_danger("You feel a creeping sensation as something marks your presence!"))

	return TRUE

/obj/structure/meatvine/tracking_beacon/grow()
	if(!master)
		return
	if(master.isdying)
		return
	if(!floor_vine || QDELETED(floor_vine))
		qdel(src)
		return
	return

/datum/proximity_monitor/advanced/beacon_monitor
	edge_is_a_field = TRUE
	var/obj/structure/meatvine/tracking_beacon/beacon = null

	var/list/marked_entities = list()

/datum/proximity_monitor/advanced/beacon_monitor/Destroy()
	beacon = null
	marked_entities.Cut()
	return ..()

/datum/proximity_monitor/advanced/beacon_monitor/field_turf_crossed(atom/movable/movable, turf/old_location, turf/new_location)
	. = ..()

	if(!beacon || QDELETED(beacon))
		return

	if(!isliving(movable))
		return

	var/mob/living/L = movable

	if(L in marked_entities)
		return

	if(beacon.mark_target(L))
		marked_entities += L
		addtimer(CALLBACK(src, PROC_REF(cleanup_tracked_entity), L), beacon.mark_duration)

/datum/proximity_monitor/advanced/beacon_monitor/proc/cleanup_tracked_entity(mob/living/entity)
	if(entity in marked_entities)
		marked_entities -= entity

/datum/status_effect/meatvine_tracked
	id = "meatvine_tracked"
	alert_type = /atom/movable/screen/alert/status_effect/meatvine_tracked
	duration = 12 SECONDS

	var/particle_effect = null

/datum/status_effect/meatvine_tracked/on_apply()
	. = ..()
	if(!.)
		return
	to_chat(owner, span_danger("You've been marked by the meatvine!"))
	return TRUE

/atom/movable/screen/alert/status_effect/meatvine_tracked
	name = "Tracked"
	desc = "The meatvine knows where you are!"
	icon_state = "tracked"

/obj/effect/temp_visual/meatvine_mark
	icon = 'icons/effects/effects.dmi'
	icon_state = "electricity"
	duration = 1 SECONDS
	randomdir = FALSE
	layer = ABOVE_MOB_LAYER

/obj/effect/temp_visual/meatvine_mark/Initialize(mapload)
	. = ..()
	color = "#ff3333"
	animate(src, alpha = 0, time = duration)
