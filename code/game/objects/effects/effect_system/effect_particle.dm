
/atom/movable/proc/ModParticles(target, min, max, type = "circle", random = 1)
	if(particles)
		particles.ModParticles(target, min, max, type = "circle", random = 1)

/particles
	var/name = "particles"

/particles/Destroy(force)
	if(force)
		return ..()

	. = QDEL_HINT_LETMELIVE
	CRASH("Something tried to qdel a [type], which shouldn't happen!")

/particles/proc/ModParticles(target, min, max, type = "circle", random = 1)
	if (!(type in list("vector", "box", "circle", "sphere", "square", "cube"))) // Valid types for generator(), sans color
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
