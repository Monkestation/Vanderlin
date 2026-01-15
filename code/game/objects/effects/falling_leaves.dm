/particles/leaf
	icon = 'icons/effects/particles/particle.dmi'
	icon_state = list("leaf1"=5, "leaf2"=6, "leaf3"=5)
	spin = 6
	position = generator("box", list(0,32,0), list(32,48,0))
	gravity = list(0, -1, 0.1)
	friction = 0.5
	drift = generator("circle", 1)
	lifespan = generator("num", 35, 55)
	fade = generator("num", 2, 6)
	spawning = 1
	count = 3
	width = 800
	height = 800

/obj/effect/falling_leaves/Initialize(mapload, ...)
	. = ..()
	particles = new /particles/leaf

/particles/sakura
	icon = 'icons/effects/particles/particle.dmi'
	icon_state	= "petals1"
	spin = 6
	position = generator("box", list(0,32,0), list(32,48,0))
	gravity = list(0, -1, 0.1)
	friction = 0.5
	drift = generator("circle", 1)
	lifespan = generator("num", 35, 55)
	fade = generator("num", 2, 6)
	spawning = 1
	count = 3
	width = 800
	height = 800

/obj/effect/falling_sakura
	var/obj/effect/abstract/particle_holder/cached/particle_effect

/obj/effect/falling_sakura/Initialize(mapload, ...)
	. = ..()
	particle_effect = new(src, /particles/sakura, 6)
	//render the steam over mobs and objects on the game plane
	particle_effect.vis_flags &= ~VIS_INHERIT_PLANE
