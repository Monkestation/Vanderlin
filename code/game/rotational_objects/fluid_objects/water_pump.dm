/obj/structure/water_pump
	name = "fluid pump"
	rotation_structure = TRUE
	initialize_dirs = CONN_DIR_NONE
	icon_state = "p1"
	icon = 'icons/obj/rotation_machines.dmi'
	layer = 5
	accepts_water_input = TRUE


	var/turf/open/water/pumping_from
	var/last_provided_pressure = 0
	var/mutable_appearance/water_spray
	var/datum/reagent/last_provided

/obj/structure/water_pump/find_rotation_network()

	for(var/direction in GLOB.cardinals)
		if(direction == dir || direction == REVERSE_DIR(dir))
			continue
		var/turf/step_back = get_step(src, direction)
		for(var/obj/structure/structure in step_back.contents)
			if(!structure.rotation_network || !structure.dpdir)
				continue
			if(!istype(structure, /obj/structure/rotation_piece/cog))
				continue
			if(structure.dir != dir && structure.dir != REVERSE_DIR(dir)) // cogs not oriented in same direction
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

/obj/structure/water_pump/return_surrounding_rotation(datum/rotation_network/network)
	var/list/surrounding = list()

	for(var/direction in GLOB.cardinals)
		if(!(direction & dpdir))
			continue
		var/turf/step_back = get_step(src, direction)
		for(var/obj/structure/structure in step_back.contents)
			if(!istype(structure, /obj/structure/rotation_piece/cog))
				continue
			if(structure.dir != dir && structure.dir != REVERSE_DIR(dir))
				continue
			if(!(structure in network.connected))
				continue
			surrounding |= structure
	return surrounding

/obj/structure/water_pump/Destroy()
	STOP_PROCESSING(SSobj, src)
	var/turf/open/pipe_turf = get_step(src, dir)
	var/obj/structure/water_pipe/pipe  = locate(/obj/structure/water_pipe) in pipe_turf
	if(pipe && last_provided)
		pipe.remove_provider(last_provided, 0)
	. = ..()

/obj/structure/water_pump/set_rotations_per_minute(speed)
	. = ..()
	if(!.)
		return
	set_stress_use(64 * (speed / 8))
	if(speed > 0)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)
		var/turf/open/pipe_turf = get_step(src, dir)
		var/obj/structure/water_pipe/pipe  = locate(/obj/structure/water_pipe) in pipe_turf
		if(pipe && last_provided)
			pipe.remove_provider(last_provided, 0)
		pumping_from = null
		last_provided_pressure = 0
		stop_spray()

/obj/structure/water_pump/return_rotation_chat()
	if(!rotation_network)
		return

	return "Pressure: [last_provided_pressure]\n\
			Fluid: [pumping_from ? initial(pumping_from.water_reagent.name) : "Nothing"]\n\
			RPM: [rotations_per_minute ? rotations_per_minute : "0"]\n\
			[rotation_network.total_stress ? "[rotation_network.overstressed ? "OVER:" : "STRESS:"][round(((rotation_network?.used_stress / max(1, rotation_network?.total_stress)) * 100), 1)]%" : "Stress: [rotation_network.used_stress]"]\n\
			DIR: [rotation_direction == 4 ? "CW" : rotation_direction == 8 ? "CCW" : ""]"

/obj/structure/water_pump/can_connect(obj/structure/connector)
	if(connector.rotation_direction && rotation_direction && (connector.rotation_direction != rotation_direction))
		if(!istype(connector, /obj/structure/rotation_piece/cog) && !istype(connector, /obj/structure/water_pump))
			if(connector.rotations_per_minute && rotations_per_minute)
				return FALSE
	return TRUE

/obj/structure/water_pump/update_animation_effect()
	if(!rotation_network || rotation_network?.overstressed || !rotations_per_minute || !rotation_network?.total_stress)
		animate(src, icon_state = "p1", time = 1)
		return
	var/frame_stage = 1 / ((rotations_per_minute / 60) * 4)
	if(rotation_direction == WEST)
		animate(src, icon_state = "p1", time = frame_stage, loop=-1)
		animate(icon_state = "p2", time = frame_stage)
		animate(icon_state = "p3", time = frame_stage)
		animate(icon_state = "p4", time = frame_stage)
	else
		animate(src, icon_state = "p4", time = frame_stage, loop=-1)
		animate(icon_state = "p3", time = frame_stage)
		animate(icon_state = "p2", time = frame_stage)
		animate(icon_state = "p1", time = frame_stage)

/obj/structure/water_pump/process()
	if(!rotations_per_minute)
		return
	if(!pumping_from)
		var/turf/open/water/water = get_step(src, REVERSE_DIR(dir))
		if(!istype(water))
			return
		pumping_from = water

	var/turf/open/pipe_turf = get_step(src, dir)
	last_provided = pumping_from.water_reagent
	if(!locate(/obj/structure/water_pipe) in pipe_turf)
		spray_water(pipe_turf)
		return

	stop_spray()
	var/obj/structure/water_pipe/pipe  = locate(/obj/structure/water_pipe) in pipe_turf


	var/new_pressure = rotations_per_minute + bonus_pressure
	// if(last_provided_pressure != new_pressure)
	pipe.make_provider(pumping_from.water_reagent, new_pressure, src)
	last_provided_pressure = new_pressure

/obj/structure/water_pump/use_water_pressure(pressure)
	pumping_from.adjust_originate_watervolume(pressure)

/obj/structure/water_pump/proc/spray_water(turf/pipe_turf)
	if(!water_spray)
		water_spray = mutable_appearance(icon, "water_spray")
		water_spray.pixel_y = 32
		water_spray.layer = 5
	cut_overlay(water_spray)
	water_spray.color = initial(pumping_from.water_reagent.color)
	add_overlay(water_spray)
	if(isopenspace(pipe_turf))
		while(isopenspace(pipe_turf))
			pipe_turf = GET_TURF_BELOW(pipe_turf)

	var/datum/reagent/faux_reagent = new pumping_from.water_reagent
	faux_reagent.on_aeration(rotations_per_minute, get_turf(src))

	if(istype(pipe_turf, /turf/open/water))
		var/turf/open/water/water = pipe_turf
		if(water.mapped)
			return
		use_water_pressure(rotations_per_minute)
		water.water_volume = min(water.water_volume + rotations_per_minute, water.water_maximum)

/obj/structure/water_pump/proc/stop_spray()
	cut_overlay(water_spray)
