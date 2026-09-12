
/obj/structure/pneumatic_gearbox
	name = "pneumatic gearbox"
	desc = "Converts mechanical rotation into speed for the pneumatic tube beneath it."
	icon = 'icons/obj/rotation_machines.dmi'
	icon_state = "gearbox"
	rotation_structure = TRUE
	initialize_dirs = CONN_DIR_FORWARD | CONN_DIR_FLIP
	anchored = TRUE
	var/obj/structure/pneumatic_tube/linked_pipe
	var/last_pushed_rpm = -1

/obj/structure/pneumatic_gearbox/Initialize(mapload)
	. = ..()
	relink()
	START_PROCESSING(SSobj, src)

/obj/structure/pneumatic_gearbox/Destroy()
	STOP_PROCESSING(SSobj, src)
	linked_pipe = null
	return ..()

/obj/structure/pneumatic_gearbox/proc/relink()
	linked_pipe = null
	for(var/obj/structure/pneumatic_tube/pipe in loc)
		if(color && pipe.color != color)
			continue
		linked_pipe = pipe
		break

/obj/structure/pneumatic_gearbox/process()
	if(!linked_pipe)
		relink()
		if(!linked_pipe)
			return
	if(rotations_per_minute == last_pushed_rpm)
		return
	last_pushed_rpm = rotations_per_minute
	if(!linked_pipe.pneumatic_network)
		linked_pipe.pneumatic_network = new /datum/pneumatic_network()
		linked_pipe.pneumatic_network.add_member(linked_pipe)
	linked_pipe.pneumatic_network.set_rpm(rotations_per_minute)
