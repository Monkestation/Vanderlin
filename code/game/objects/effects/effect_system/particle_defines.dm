/particles/mist
	name = "mist"
	icon = 'icons/effects/particles/smoke.dmi'
	icon_state = list("steam_1" = 1, "steam_2" = 1, "steam_3" = 1)
	count = 500
	spawning = 4
	lifespan = 5 SECONDS
	fade = 1 SECONDS
	fadein = 1 SECONDS
	velocity = generator("box", list(-0.5, -0.25, 0), list(0.5, 0.25, 0), NORMAL_RAND)
	position = generator("box", list(-20, -16), list(20, -2), UNIFORM_RAND)
	friction = 0.2
	grow = 0.0015

/particles/mist/waterfall
	count = 75
	lifespan =  generator("num", 2 SECONDS, 3 SECONDS)
	position = generator("box", list(-20, 4), list(20, 10), UNIFORM_RAND)

// All the smoke variant particles.
/particles/smoke
	name = "smoke"
	icon = 'icons/effects/particles/smoke.dmi'
	icon_state = list("smoke_1" = 1, "smoke_2" = 1, "smoke_3" = 2)
	width = 100
	height = 100
	count = 1000
	spawning = 4
	lifespan = 1.5 SECONDS
	fade = 1 SECONDS
	velocity = list(0, 0.4, 0)
	position = list(6, 0, 0)
	drift = generator(GEN_SPHERE, 0, 2, NORMAL_RAND)
	friction = 0.2
	gravity = list(0, 0.95)
	grow = 0.05

/particles/smoke/burning
	name = "burning"
	position = list(0, 0, 0)

/particles/smoke/burning/small
	name = "burning_small"
	spawning = 1
	scale = list(0.8, 0.8)
	velocity = list(0, 0.4, 0)

/particles/smoke/steam
	name = "steam"
	icon_state = list("steam_1" = 1, "steam_2" = 1, "steam_3" = 2)
	fade = 1.5 SECONDS

/particles/smoke/steam/mild
	name = "steam_mild"
	spawning = 1
	velocity = list(0, 0.3, 0)
	friction = 0.25

/particles/smoke/steam/bad
	name = "steam_bad"
	icon_state = list("steam_1" = 1, "smoke_1" = 1, "smoke_2" = 1, "smoke_3" = 1)
	spawning = 2
	velocity = list(0, 0.25, 0)

/particles/smoke/steam/water_vent
	name = "water_pipe"
	icon_state = list("steam_1" = 1, "smoke_1" = 1, "smoke_2" = 1, "smoke_3" = 1)
	spawning = 2
	velocity = list(0, 0.25, 0)
	position = generator(GEN_VECTOR, list(-3, -5, 0), list(3, -6.5, 0), NORMAL_RAND)

/particles/smoke/cig
	name = "cig"
	icon_state = list("steam_1" = 2, "steam_2" = 1, "steam_3" = 1)
	count = 1
	spawning = 0.05 // used to pace it out roughly in time with breath ticks
	position = list(-6, -2, 0)
	gravity = list(0, 0.75, 0)
	lifespan = 0.75 SECONDS
	fade = 0.75 SECONDS
	velocity = list(0, 0.2, 0)
	scale = 0.5
	grow = 0.01
	friction = 0.5
	color = "#d0d0d09d"

/particles/smoke/cig/big
	name = "cig_big"
	icon_state = list("steam_1" = 1, "steam_2" = 2, "steam_3" = 2)
	gravity = list(0, 0.5, 0)
	velocity = list(0, 0.1, 0)
	lifespan = generator(GEN_NUM, 1 SECONDS, 3.5 SECONDS)
	fade = 1 SECONDS
	grow = 0.1
	scale = 0.75
	spawning = 1
	friction = 0.75

/particles/smoke/cig/big/steam
	name = "cig_big"
	icon_state = list("steam_1" = 1, "steam_2" = 2, "steam_3" = 2)
	gravity = list(0, 0.5, 0)
	velocity = list(0, 0.1, 0)
	lifespan = generator(GEN_NUM, 1 SECONDS, 3.5 SECONDS)
	fade = 1 SECONDS
	grow = 0.1
	scale = 0.75
	spawning = 1
	friction = 0.75
	position = generator(GEN_VECTOR, list(-6, -6, 0), list(6, 6, 0), NORMAL_RAND)

/particles/smoke/ash
	name = "cig_ash"
	icon_state = list("ash_1" = 2, "ash_2" = 2, "ash_3" = 1, "smoke_1" = 3, "smoke_2" = 2)
	count = 500
	spawning = 1
	lifespan = 1 SECONDS
	fade = 0.2 SECONDS
	fadein = 0.7 SECONDS
	position = generator(GEN_VECTOR, list(-3, 5, 0), list(3, 6.5, 0), NORMAL_RAND)
	velocity = generator(GEN_VECTOR, list(-0.1, 0.4, 0), list(0.1, 0.5, 0), NORMAL_RAND)

/particles/sparks
	name = "sparks"
	width = 124
	height = 124
	count = 16
	spawning = 16
	lifespan = 1.5 SECONDS
	fade = 0.25 SECONDS
	position = generator("circle", -12, 12, NORMAL_RAND)
	gravity = list(0, -1)
	velocity = generator("box", list(-12, 2, 0), list(12, 12, 5), NORMAL_RAND)
	friction = 0.25
	gradient = list(0, COLOR_WHITE, 1, COLOR_ORANGE)
	color_change = 0.125
	color = 0
	transform = list(1,0,0,0, 0,1,0,0, 0,0,1,1/5, 0,0,0,1)

/particles/water_spray
	name = "water_spray"
	width = 124
	height = 124
	count = 32
	spawning = 4
	lifespan = 0.7 SECONDS
	fade = 0.1 SECONDS
	position = generator("box", list(-10, -10), list(10, 10), NORMAL_RAND)
	velocity = generator("num", -4, -8)
	friction = 0.225
	gravity = list(1, 1)
	color = COLOR_WHITE
	transform = list(1,0,0,0, 0,1,0,0, 0,0,1,1/5, 0,0,0,1)

// PARTICLE PORTED FROM LC13, BY TaculoTaculo
/particles/particle_song
	name = "song"
	icon = 'icons/effects/particles/song.dmi'
	icon_state = list("song_small" = 1,"song_medium" = 1,"song_large" = 1)
	width = 128
	height = 128
	count = 30
	spawning = 2
	lifespan = 12
	fadein = 6
	fade = 6
	velocity = generator(GEN_CIRCLE, -5, 5, NORMAL_RAND)
	rotation = generator(GEN_NUM, -120, 120)
	spin = generator(GEN_NUM, -20, 20)
	grow = list(0.2, 0.2)
	friction = 0.6
