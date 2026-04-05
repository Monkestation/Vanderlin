/////////////////////////////////////////////
//SPARK SYSTEM (like steam system)
// The attach(atom/atom) proc is optional, and can be called to attach the effect
// to something, like the RCD, so then you can just call start() and the sparks
// will always spawn at the items location.
/////////////////////////////////////////////

/atom/proc/spark_act()
	return

/proc/do_sparks(number, cardinal_only, datum/source)
	var/datum/effect_system/spark_spread/sparks = new
	sparks.set_up(number, cardinal_only, source)
	sparks.autocleanup = TRUE
	sparks.start()

/obj/effect/particle_effect/sparks
	name = "sparks"
	icon = 'icons/effects/64x64.dmi'
	icon_state = "sparks"
	anchored = TRUE
	light_power = 1.3
	light_outer_range =  MINIMUM_USEFUL_LIGHT_RANGE
	light_color = LIGHT_COLOR_FIRE
	SET_BASE_PIXEL(-16, -16)
	plane = ABOVE_LIGHTING_PLANE

	var/silent = TRUE

/obj/effect/particle_effect/sparks/Initialize()
	..()
	dir = pick(GLOB.cardinals)
	return INITIALIZE_HINT_LATELOAD

/obj/effect/particle_effect/sparks/LateInitialize()
	flick(icon_state, src) // replay the animation
	if(!silent)
		playsound(src, SFX_SPARKS, 100, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	var/turf/T = loc
	if(isturf(T))
		T.hotspot_expose(1000,100)
		for(var/atom/AT as anything in T)
			if(!QDELETED(AT) && AT != src)
				AT.spark_act()
	QDEL_IN(src, 20)

/obj/effect/particle_effect/sparks/Destroy()
	var/turf/T = loc
	if(isturf(T))
		T.hotspot_expose(1000,100)
		for(var/atom/AT as anything in T)
			if(!QDELETED(AT) && AT != src)
				AT.spark_act()
	return ..()

/obj/effect/particle_effect/sparks/Move()
	..()
	var/turf/T = loc
	if(isturf(T))
		T.hotspot_expose(1000,100)
		for(var/atom/AT as anything in T)
			if(!QDELETED(AT) && AT != src)
				AT.spark_act()

/obj/effect/particle_effect/sparks/noisy
	silent = FALSE

/datum/effect_system/spark_spread
	effect_type = /obj/effect/particle_effect/sparks

/datum/effect_system/spark_spread/quantum
	effect_type = /obj/effect/particle_effect/sparks/quantum

/datum/effect_system/spark_spread/noisy
	effect_type = /obj/effect/particle_effect/sparks/noisy

//electricity

/obj/effect/particle_effect/sparks/electricity
	name = "lightning"
	icon_state = "electricity"

/obj/effect/particle_effect/sparks/quantum
	name = "quantum sparks"
	icon_state = "quantum_sparks"

/datum/effect_system/lightning_spread
	effect_type = /obj/effect/particle_effect/sparks/electricity
