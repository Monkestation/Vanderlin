/obj/structure/water_vent
	name = "fluid vent"
	desc = "Shoots out liquids and fluids."
	icon = 'icons/obj/structures/rotation_devices/water_vent.dmi'
	icon_state = "pipevent"

	accepts_water_input = TRUE

	var/obj/particle_emitter/emitter

/obj/structure/water_vent/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/water_vent/valid_water_connection(direction, obj/structure/water_pipe/pipe)
	if(direction == dir)
		input = pipe
		return TRUE

/obj/structure/water_vent/process()
	if(length(input?.providers))
		spew_water()

/obj/structure/water_vent/proc/spew_water()
	emitter = locate(/obj/particle_emitter) in particle_emitters
	if(!emitter)
		emitter = MakeParticleEmitter(/particles/smoke/steam/water_pipe)
	var/datum/reagent/reagent = input.carrying_reagent
	emitter.color = initial(reagent.color)

	var/matrix/matrix = matrix()
	switch(dir)
		if(SOUTH)
			matrix.Turn(180)
		if(EAST)
			matrix.Turn(90)
		if(WEST)
			matrix.Turn(270)
	emitter.transform = matrix

	var/range = max(1, FLOOR(input.water_pressure * 0.1, 1))
	range = min(3, range)

	var/list/emitter_velocity = list(0, 0.25 * range, 0)
	emitter.particles.velocity = emitter_velocity
	if(reagent)
		var/datum/reagent/faux_reagent = new reagent
		faux_reagent.on_aeration(input.water_pressure, get_turf(src))

	var/datum/reagents/splash_holder
	for(var/i = 1 to range)
		var/taking_pressure = input.water_pressure
		var/fallen = FALSE
		var/turf/pipe_turf
		if(!pipe_turf)
			pipe_turf = get_turf(src)
		else
			pipe_turf = get_step(src, dir)

		if(isclosedturf(pipe_turf))
			break
		if(isopenspace(pipe_turf))
			fallen = TRUE
			while(isopenspace(pipe_turf))
				for(var/mob/living/mob in pipe_turf.contents)
					if(!splash_holder)
						splash_holder = new/datum/reagents(FLOOR(input.water_pressure * 0.5, 1))
						splash_holder.my_atom = src
						splash_holder.add_reagent(reagent, FLOOR(input.water_pressure * 0.5, 1))
					splash_holder.reaction(mob, TOUCH, 1)
				pipe_turf = GET_TURF_BELOW(pipe_turf)
		if(istype(pipe_turf, /turf/open/water))
			var/turf/open/water/water = pipe_turf
			if(water.mapped)
				return
			water.water_volume = min(water.water_volume + taking_pressure, water.water_maximum)

		for(var/mob/living/mob in pipe_turf.contents)
			if(!splash_holder)
				splash_holder = new/datum/reagents(FLOOR(input.water_pressure * 0.5, 1))
				splash_holder.my_atom = src
				splash_holder.add_reagent(reagent, FLOOR(input.water_pressure * 0.5, 1))
			splash_holder.reaction(mob, TOUCH, 1)
			if(!fallen && range == 3 && i < 2)
				mob.safe_throw_at(get_edge_target_turf(src, dir), 2, 3, spin = FALSE)
		var/obj/structure/water_pipe/picked_provider = pick(input.providers)
		picked_provider?.taking_from?.use_water_pressure(taking_pressure)
		if(!istype(pipe_turf, /turf/open/water) && !ispath(reagent, /datum/reagent/water))
			var/datum/reagent/add_reagent = reagent
			var/send_pressure = taking_pressure
			if(ispath(reagent, /datum/reagent/steam))
				add_reagent = /datum/reagent/water
				send_pressure *= 0.25
				send_pressure = round(send_pressure, 1)
			pipe_turf.add_liquid(add_reagent, send_pressure)



/obj/structure/water_vent/return_rotation_chat()
	var/datum/reagent/reagent = input.carrying_reagent
	return "Input Pressure: [input ? input.water_pressure : "0"]\n\
			Fluid: [reagent ? initial(reagent.name) : "Nothing"]"
