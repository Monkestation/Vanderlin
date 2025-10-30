/atom/movable
	var/list/particle_emitters

/atom/movable/Destroy(force)
	for(var/emitter as anything in particle_emitters)
		qdel(emitter)
	UNSETEMPTY(particle_emitters)
	return ..()

/atom/movable/proc/AddParticles(type, create_new = FALSE)
	if(!ispath(type))
		if (GLOB.all_particles[type])
			particles = GLOB.all_particles[type]
		return
	if(create_new)
		particles = new type()
		GLOB.all_particles[src.name] = particles
	else
		var/particles/P = type
		var/index = initial(P.name)
		particles = GLOB.all_particles[index]

/atom/movable/proc/MakeParticleEmitter(type, create_new = FALSE, time = -1)
	var/obj/particle_emitter/pe
	pe = new /obj/particle_emitter(loc, time)
	pe.host = src
	pe.AddParticles(type, create_new)
	LAZYOR(particle_emitters, pe)
	return pe

/atom/movable/proc/RemoveEmitter(obj/particle_emitter/emitter)
	LAZYREMOVE(particle_emitters, emitter)
	qdel(emitter)

/atom/movable/proc/RemoveParticles(delete = FALSE)
	if (delete)
		QDEL_NULL(particles)
	particles = null
	if (/obj/particle_emitter in vis_contents)
		vis_contents -= /obj/particle_emitter

/atom/movable/proc/ModParticles(target, min, max, type = "circle", random = 1)
	if (particles)
		particles.ModParticles(target, min, max, type = "circle", random = 1)

/particles
	var/name = "particles"

/particles/proc/ModParticles(target, min, max, type = "circle", random = 1)
	if (!(type in list("vector", "box", "circle", "sphere", "square", "cube")))											// Valid types for generator(), sans color
		return

	if (target in list("width", "height", "count", "spawning", "bound1", "bound2", "gravity", "gradient", "transform"))	// These vars cannot be generators, per reference doc, and changing some breaks things anyways
		return

	if (target in vars)
		vars[target] = MakeGenerator(type, min, max, random)

/particles/proc/SetGradient(...)
	var/counter = 0
	var/list/new_gradient = list()
	for (var/i in args)
		new_gradient += counter
		counter += 1/length(args)
		new_gradient += i
	gradient = new_gradient

/obj/particle_emitter
	name = ""
	anchored = TRUE
	mouse_opacity = 0
	appearance_flags = PIXEL_SCALE
	var/particle_type = null
	var/timer
	var/atom/movable/host

/obj/particle_emitter/Initialize(mapload, time, _color)
	. = ..()
	if(particle_type)
		particles = GLOB.all_particles[particle_type]

	if(time > 0)
		timer = QDEL_IN_STOPPABLE(src, time)
	color = _color

/obj/particle_emitter/Destroy(force)
	if(timer)
		deltimer(timer)
	if(host)
		LAZYREMOVE(host.particle_emitters, src)
		host = null
	RemoveParticles()
	return ..()

/obj/particle_emitter/smoke
	layer = FIRE_LAYER
	particle_type = "smoke"
