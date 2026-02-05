/datum/component/particle_spewer/sparkle
	icon_file = 'icons/effects/particles/special_particles.dmi'
	particle_state = "sparkle"

	unusual_description = "shiny"
	duration = 0.7 SECONDS
	spawn_interval = 0.3 SECONDS
	burst_amount = 0
	offsets = FALSE
	var/shine_more = FALSE

/datum/component/particle_spewer/sparkle/Initialize(shine_more = FALSE)
	. = ..()
	src.shine_more = shine_more
	if(src.shine_more)
		duration = 1.1 SECONDS
		spawn_interval = 0.2 SECONDS
		burst_amount = 2

/datum/component/particle_spewer/sparkle/animate_particle(obj/effect/abstract/particle/spawned)
	var/matrix/first = matrix()
	spawned.pixel_x += rand(-12, 12) // can be anywhere in the tile bounds
	spawned.pixel_y += rand(-12, 12)
	first.Turn(rand(-90, 90))
	if(!shine_more)
		first.Scale(0.1, 0.1)
	else
		first.Scale(0.15, 0.15)
	spawned.transform = first

	first.Scale(10)
	if(!shine_more)
		animate(spawned, transform = first, time = 0.3 SECONDS, alpha = 220)
	else
		animate(spawned, transform = first, time = 0.3 SECONDS, alpha = 255)

	first.Scale(0.1 * 0.1)
	first.Turn(rand(-90, 90))
	animate(transform = first, time = 0.3 SECONDS)

	QDEL_IN(spawned, duration)

