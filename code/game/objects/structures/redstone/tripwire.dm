
/obj/structure/redstone/tripwire_hook
	name = "tripwire hook"
	desc = "Creates an invisible tripwire that detects movement."
	icon_state = "tripwire_hook"
	redstone_role = REDSTONE_ROLE_SOURCE
	var/obj/structure/redstone/tripwire_hook/connected_hook
	var/list/tripwire_turfs = list()
	var/max_distance = 10
	var/triggered = FALSE
	can_connect_wires = TRUE

/obj/structure/redstone/tripwire_hook/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/redstone/tripwire_hook/LateInitialize()
	. = ..()
	find_connection()

/obj/structure/redstone/tripwire_hook/Destroy()
	if(connected_hook)
		connected_hook.connected_hook = null
		connected_hook.clear_tripwire()
	clear_tripwire()
	return ..()

/obj/structure/redstone/tripwire_hook/get_source_power()
	return triggered ? 15 : 0

/obj/structure/redstone/tripwire_hook/can_receive_from(obj/structure/redstone/source, direction)
	return FALSE

/obj/structure/redstone/tripwire_hook/proc/find_connection()
	var/turf/current = get_turf(src)
	for(var/i = 1 to max_distance)
		current = get_step(current, dir)
		if(!current)
			break
		for(var/obj/structure/redstone/tripwire_hook/hook in current)
			if(hook != src && !hook.connected_hook && hook.dir == REVERSE_DIR(dir))
				establish_connection(hook)
				return
		tripwire_turfs += current

/obj/structure/redstone/tripwire_hook/proc/establish_connection(obj/structure/redstone/tripwire_hook/other)
	connected_hook = other
	other.connected_hook = src
	other.tripwire_turfs = tripwire_turfs.Copy()

	for(var/turf/T in tripwire_turfs)
		RegisterSignal(T, COMSIG_ATOM_ENTERED, PROC_REF(on_tripwire_crossed))

/obj/structure/redstone/tripwire_hook/proc/clear_tripwire()
	for(var/turf/T in tripwire_turfs)
		UnregisterSignal(T, COMSIG_ATOM_ENTERED)
	tripwire_turfs.Cut()

/obj/structure/redstone/tripwire_hook/proc/on_tripwire_crossed(datum/source, atom/movable/crossed)
	SIGNAL_HANDLER
	if(!isliving(crossed))
		return
	trigger_hook()
	if(connected_hook)
		connected_hook.trigger_hook()

/obj/structure/redstone/tripwire_hook/proc/trigger_hook()
	if(triggered)
		return
	triggered = TRUE
	power_level = 15
	schedule_network_update()
	spawn(5)
		triggered = FALSE
		power_level = 0
		schedule_network_update()
