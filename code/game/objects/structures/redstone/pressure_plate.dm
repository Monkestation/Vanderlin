
/obj/structure/redstone/pressure_plate
	name = "redstone pressure plate"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "pressureplate"
	redstone_role = REDSTONE_ROLE_SOURCE
	var/active = FALSE
	var/list/current_occupants = list()
	var/activation_weight = 1

/obj/structure/redstone/pressure_plate/Initialize()
	. = ..()
	RegisterSignal(loc, COMSIG_ATOM_ENTERED, PROC_REF(on_entered))
	RegisterSignal(loc, COMSIG_TURF_EXITED, PROC_REF(on_exited))
	check_activation()

/obj/structure/redstone/pressure_plate/Destroy()
	UnregisterSignal(loc, list(COMSIG_ATOM_ENTERED, COMSIG_TURF_EXITED))
	return ..()

/obj/structure/redstone/pressure_plate/get_source_power()
	return active ? 15 : 0

/obj/structure/redstone/pressure_plate/can_receive_from(obj/structure/redstone/source, direction)
	return FALSE // Sources don't receive power

/obj/structure/redstone/pressure_plate/proc/on_entered(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER
	if(should_count_object(arrived))
		current_occupants[arrived] = TRUE
		check_activation()

/obj/structure/redstone/pressure_plate/proc/on_exited(datum/source, atom/movable/gone, direction)
	SIGNAL_HANDLER
	if(gone in current_occupants)
		current_occupants -= gone
		check_activation()

/obj/structure/redstone/pressure_plate/proc/should_count_object(atom/movable/AM)
	if(ismob(AM))
		var/mob/M = AM
		return M.stat != DEAD
	if(isitem(AM))
		var/obj/item/I = AM
		return I.w_class >= WEIGHT_CLASS_NORMAL
	return FALSE

/obj/structure/redstone/pressure_plate/proc/check_activation()
	var/list/valid_occupants = list()
	for(var/atom/movable/AM in current_occupants)
		if(should_count_object(AM) && AM.loc == loc)
			valid_occupants[AM] = TRUE
	current_occupants = valid_occupants

	var/should_activate = (length(current_occupants) >= activation_weight)
	if(should_activate != active)
		active = should_activate
		if(active)
			playsound(src, 'sound/misc/pressurepad_down.ogg', 65, extrarange = 2)
		else
			playsound(src, 'sound/misc/pressurepad_up.ogg', 65, extrarange = 2)
		schedule_network_update()

/obj/structure/redstone/pressure_plate/examine(mob/user)
	. = ..()
	. += "The pressure plate is currently [active ? "pressed down" : "ready"]."
