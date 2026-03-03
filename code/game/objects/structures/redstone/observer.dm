
/obj/structure/redstone/observer
	name = "redstone observer"
	desc = "Detects changes in the block it's observing and emits a redstone pulse."
	icon_state = "comparator"
	redstone_role = REDSTONE_ROLE_SOURCE
	var/turf/observing_turf
	var/last_observed_state
	var/pulse_length = 2
	var/pulsing = FALSE
	can_connect_wires = TRUE

/obj/structure/redstone/observer/Initialize()
	. = ..()
	update_observing_turf()
	register_observation_signals()
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/redstone/observer/Destroy()
	unregister_observation_signals()
	return ..()

/obj/structure/redstone/observer/get_source_power()
	return pulsing ? 15 : 0

/obj/structure/redstone/observer/get_output_directions()
	return list(REVERSE_DIR(dir))

/obj/structure/redstone/observer/can_connect_to(obj/structure/redstone/other, dir)
	return (dir == REVERSE_DIR(dir))

/obj/structure/redstone/observer/can_receive_from(obj/structure/redstone/source, direction)
	return FALSE

/obj/structure/redstone/observer/proc/update_observing_turf()
	unregister_observation_signals()
	observing_turf = get_step(src, dir)
	last_observed_state = get_turf_state(observing_turf)

/obj/structure/redstone/observer/proc/register_observation_signals()
	if(!observing_turf)
		return
	RegisterSignal(observing_turf, COMSIG_TURF_CHANGE, PROC_REF(on_observed_change))
	RegisterSignal(observing_turf, COMSIG_TURF_ENTERED, PROC_REF(on_observed_change))
	RegisterSignal(observing_turf, COMSIG_TURF_EXITED, PROC_REF(on_observed_change))

/obj/structure/redstone/observer/proc/unregister_observation_signals()
	if(!observing_turf)
		return
	UnregisterSignal(observing_turf, list(COMSIG_TURF_CHANGE, COMSIG_ATOM_ENTERED, COMSIG_TURF_EXITED))

/obj/structure/redstone/observer/proc/get_turf_state(turf/T)
	if(!T)
		return null
	var/list/state = list()
	state["turf_type"] = T.type
	state["objects"] = list()
	for(var/obj/O in T)
		state["objects"] += O.type
	return state

/obj/structure/redstone/observer/proc/on_observed_change()
	SIGNAL_HANDLER
	if(pulsing)
		return
	var/current_state = get_turf_state(observing_turf)
	if(!compare_states(last_observed_state, current_state))
		emit_pulse()
		last_observed_state = current_state

/obj/structure/redstone/observer/proc/compare_states(list/state1, list/state2)
	if(!state1 || !state2)
		return FALSE
	if(state1["turf_type"] != state2["turf_type"])
		return FALSE
	if(length(state1["objects"]) != length(state2["objects"]))
		return FALSE
	return TRUE

/obj/structure/redstone/observer/proc/emit_pulse()
	pulsing = TRUE
	power_level = 15
	schedule_network_update()
	update_appearance(UPDATE_ICON_STATE)

	spawn(pulse_length * 10)
		pulsing = FALSE
		power_level = 0
		schedule_network_update()
		update_appearance(UPDATE_ICON_STATE)

/obj/structure/redstone/observer/update_icon_state()
	. = ..()
	icon_state = pulsing ? "comparator_pulse" : "comparator"

/obj/structure/redstone/observer/AltClick(mob/user, list/modifiers)
	if(!Adjacent(user))
		return
	dir = turn(dir, 90)
	update_observing_turf()
	register_observation_signals()
	update_appearance(UPDATE_ICON_STATE)
	to_chat(user, "<span class='notice'>You rotate the [name].</span>")
