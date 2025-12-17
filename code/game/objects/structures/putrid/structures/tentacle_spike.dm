/obj/structure/meatvine/tentacle_spike
	icon = 'icons/obj/cellular/meat.dmi'
	icon_state = "spike"
	name = "tentacle spike"
	desc = "A sharp, twisted spike of corrupted flesh."
	density = FALSE
	opacity = FALSE
	pass_flags = LETPASSTHROW
	max_integrity = 20
	resistance_flags = CAN_BE_HIT
	layer = LOW_SIGIL_LAYER
	borders = FALSE
	var/spike_count = 1
	var/max_spikes = 5
	var/obj/structure/meatvine/floor/floor_vine = null
	var/list/obj/effect/spike_visual/spike_visuals = list()

/obj/structure/meatvine/tentacle_spike/Initialize()
	. = ..()
	icon_state = null
	var/turf/T = get_turf(src)
	floor_vine = locate(/obj/structure/meatvine/floor) in T

	if(!floor_vine)
		// No floor vine, we die
		qdel(src)
		return INITIALIZE_HINT_QDEL

	RegisterSignal(floor_vine, COMSIG_PARENT_QDELETING, PROC_REF(on_floor_destroyed))

	update_spike_visuals()
	return .

/obj/structure/meatvine/tentacle_spike/Destroy()
	if(floor_vine)
		UnregisterSignal(floor_vine, COMSIG_PARENT_QDELETING)
	floor_vine = null

	QDEL_LIST(spike_visuals)

	return ..()

/obj/structure/meatvine/tentacle_spike/proc/on_floor_destroyed(datum/source)
	SIGNAL_HANDLER
	floor_vine = null
	qdel(src)

/obj/structure/meatvine/tentacle_spike/proc/can_add_spike()
	return spike_count < max_spikes

/obj/structure/meatvine/tentacle_spike/proc/add_spike()
	if(!can_add_spike())
		return FALSE

	spike_count++
	update_spike_visuals()
	max_integrity = initial(max_integrity) * spike_count
	atom_integrity = max_integrity
	return TRUE

/obj/structure/meatvine/tentacle_spike/proc/update_spike_visuals()
	QDEL_LIST(spike_visuals)

	for(var/i in 1 to spike_count)
		var/obj/effect/spike_visual/spike = new(src)
		spike.pixel_x = rand(-12, 12)
		spike.pixel_y = rand(-12, 12)
		spike_visuals += spike
		vis_contents += spike

/obj/structure/meatvine/tentacle_spike/Crossed(atom/movable/AM)
	. = ..()
	if(isliving(AM))
		var/mob/living/L = AM
		if(("meat" in L.faction))
			return
		var/damage = 5 * spike_count
		L.adjustBruteLoss(damage)
		to_chat(L, "<span class='userdanger'>You are impaled by [src]!</span>")

		for(var/obj/effect/spike_visual/spike in spike_visuals)
			flick("spike_trigger", spike)

/obj/structure/meatvine/tentacle_spike/grow()
	if(!master)
		return
	if(master.isdying)
		return
	if(!floor_vine || QDELETED(floor_vine))
		qdel(src)
		return
	// Spikes don't grow on their own, they're built
	return

/obj/effect/spike_visual
	icon = 'icons/obj/cellular/meat.dmi'
	icon_state = "spike"
	layer = ABOVE_OBJ_LAYER
	plane = GAME_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
