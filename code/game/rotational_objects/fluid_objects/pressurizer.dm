/obj/structure/pressurizer
	name = "pressurizer"
	desc = "A pressurizer, connects to a shaft to add extra pressure to a network."
	icon = 'icons/roguetown/misc/pipes.dmi'
	icon_state = "pressurizer"
	density = FALSE
	layer = ABOVE_OBJ_LAYER
	plane = GAME_PLANE
	damage_deflection = 3
	rotation_structure = TRUE
	blade_dulling = DULLING_BASHCHOP
	attacked_sound = list('sound/combat/hits/onmetal/grille (1).ogg', 'sound/combat/hits/onmetal/grille (2).ogg', 'sound/combat/hits/onmetal/grille (3).ogg')
	smeltresult = /obj/item/ingot/bronze
	obj_flags = CAN_BE_HIT
	initialize_dirs = CONN_DIR_FORWARD
	var/obj/structure/water_pipe/connected_pipe
	var/last_pressure_added = 0
	var/list/suppliers = list()

/obj/structure/pressurizer/LateInitialize()
	. = ..()
	find_connected_pipe()
	START_PROCESSING(SSobj, src)

/obj/structure/pressurizer/Destroy()
	// Remove pressure from connected pipe before destruction
	STOP_PROCESSING(SSobj, src)
	if(connected_pipe && last_pressure_added)
		remove_pressure_from_pipe()
	UnregisterSignal(connected_pipe, COMSIG_QDELETING)
	connected_pipe = null
	return ..()

/obj/structure/pressurizer/process()
	if(!connected_pipe)
		return
	if(last_pressure_added == 0 && rotations_per_minute != 0)
		update_pressure()

/obj/structure/pressurizer/proc/clear_pipe()
	if(connected_pipe && last_pressure_added)
		remove_pressure_from_pipe()
	UnregisterSignal(connected_pipe, COMSIG_QDELETING)
	connected_pipe = null

/obj/structure/pressurizer/proc/find_connected_pipe()
	// Look for water pipe in the same turf
	for(var/obj/structure/water_pipe/pipe in get_turf(src))
		connected_pipe = pipe
		update_pressure()
		RegisterSignal(connected_pipe, COMSIG_QDELETING, PROC_REF(clear_pipe))
		break

/obj/structure/pressurizer/find_rotation_network()
	// Only look for shaft connections in the direction we're facing
	var/turf/step_forward = get_step_multiz(src, dir)
	for(var/obj/structure/structure in step_forward?.contents)
		if(!structure.rotation_network || !structure.dpdir)
			continue
		if(!(REVERSE_DIR(dir) & structure.dpdir))
			continue
		if(rotation_network)
			if(!structure.try_network_merge(src))
				rotation_break()
		else
			if(!structure.try_connect(src))
				rotation_break()

	if(!rotation_network)
		rotation_network = new
		rotation_network.add_connection(src)
		last_stress_added = 0
		set_stress_use(stress_use)

/obj/structure/pressurizer/proc/update_pressure()
	if(!connected_pipe)
		return

	// Remove old pressure contribution
	if(last_pressure_added > 0)
		remove_pressure_from_pipe()

	// Add new pressure based on current RPM
	if(rotations_per_minute > 0)
		add_pressure_to_pipe(rotations_per_minute)

/obj/structure/pressurizer/proc/add_pressure_to_pipe(pressure_amount)
	if(!connected_pipe || pressure_amount <= 0)
		return

	last_pressure_added = pressure_amount

	// Add pressure to the pipe
	for(var/obj/structure/water_pipe/pipe in connected_pipe.providers)
		if(pipe.taking_from in suppliers)
			continue
		pipe.taking_from.bonus_pressure += pressure_amount
		suppliers[pipe.taking_from] = pressure_amount

	if(!length(suppliers))
		last_pressure_added = 0
		return

	// Update stress usage to match RPM
	if(rotation_network)
		set_stress_use(rotations_per_minute)

/obj/structure/pressurizer/proc/remove_pressure_from_pipe()
	if(!connected_pipe || last_pressure_added <= 0)
		return

	for(var/obj/structure/water_pipe/pipe in connected_pipe.providers)
		if(!(pipe.taking_from in suppliers))
			continue
		pipe.taking_from.bonus_pressure -= suppliers[pipe.taking_from]
		suppliers -= pipe.taking_from
	last_pressure_added = 0

	// Reset stress usage
	if(rotation_network)
		set_stress_use(0)

/obj/structure/pressurizer/set_rotations_per_minute(speed)
	. = ..()
	if(. && connected_pipe) // Only update if speed was successfully set
		update_pressure()

/obj/structure/pressurizer/valid_water_connection(direction, obj/structure/water_pipe/pipe)
	return FALSE

/obj/structure/pressurizer/return_rotation_chat()
	if(!rotation_network)
		return
	return "RPM:[rotations_per_minute ? rotations_per_minute : "0"]\n\
			[rotation_network.total_stress ? "[rotation_network.overstressed ? "OVER:" : "STRESS:"][round(((rotation_network?.used_stress / max(1, rotation_network?.total_stress)) * 100), 1)]%" : "Stress: [rotation_network.used_stress]"]\n\
			DIR:[rotation_direction == 4 ? "CW" : rotation_direction == 8 ? "CCW" : ""]\n\
			PRESSURE OUT:[last_pressure_added]"
