/obj/structure/clutch
	name = "clutch"
	desc = "A mechanical clutch. While powered by redstone, it disengages, splitting the shaft as though it had been physically removed."
	icon = 'icons/obj/rotation_machines.dmi'
	icon_state = "gearbox"
	rotation_structure = TRUE
	initialize_dirs = CONN_DIR_FORWARD | CONN_DIR_FLIP
	anchored = TRUE
	redstone_structure = TRUE
	/// Whether the clutch is currently transmitting rotation. Unpowered = engaged.
	var/engaged = TRUE
	/// Last power level we acted on, so we only react on change.
	var/last_checked_power = 0

/obj/structure/clutch/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/clutch/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/clutch/redstone_triggered(mob/user)
	. = ..()
	set_engaged(!engaged)

/obj/structure/clutch/proc/set_engaged(new_engaged)
	if(engaged == new_engaged)
		return
	engaged = new_engaged
	update_appearance(UPDATE_ICON)

	if(engaged)
		find_rotation_network()
	else
		if(rotation_network)
			var/datum/rotation_network/old_network = rotation_network
			rotation_network.remove_connection(src)
			old_network.reassess_group(src)
		rotation_network = null
		set_rotations_per_minute(0)
		rotation_direction = null
