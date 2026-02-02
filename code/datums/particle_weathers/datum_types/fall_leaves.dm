/particles/weather/fall_leaves
	icon 		= 'icons/effects/particles/particle.dmi'
	icon_state	= list("leaf1"=5, "leaf2"=6, "leaf3"=5)

	spin		= 6
	position 	= generator("box", list(-500,-256,0), list(400,500,0))
	gravity 	= list(0, -1, 0.1)
	friction 	= 0.5
	drift 		= generator("circle", 1)
	lifespan = generator("num", 35, 55)
	fade = generator("num", 2, 6)
	maxSpawning            = 40
	minSpawning            = 20
	wind = 2
	transform = null


/datum/particle_weather/fall_leaves
	name = "Fall Leaves"
	desc = "Gentle fall, la la description."
	particleEffectType = /particles/weather/fall_leaves

	weather_sounds = /datum/looping_sound/rain
	indoor_weather_sounds = /datum/looping_sound/indoor_rain

	minSeverity = 5
	maxSeverity = 100
	maxSeverityChange = 0
	severitySteps = 100
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 1
	target_trait = PARTICLEWEATHER_RAIN
