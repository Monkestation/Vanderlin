/datum/component/violent_death
	// Adjust these to change how the explosion scales by default
	var/explosion_power = 25
	var/explosion_falloff = 4
	var/explosion_shape = EXPLOSION_FALLOFF_SHAPE_LINEAR
	var/death_time = 10 SECONDS
	var/burns = FALSE

/datum/component/violent_death/Initialize(power, falloff, shape, burn, explode_time = 10 SECONDS)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	if(power)
		explosion_power = power
	if(falloff)
		explosion_falloff = falloff
	if(shape)
		explosion_shape = shape
	if(explode_time)
		death_time = explode_time
	if(burn)
		burns = burn

	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(handle_death))

/datum/component/violent_death/proc/handle_death(mob/living/L, gibbed)
	SIGNAL_HANDLER

	if(HAS_TRAIT(L, TRAIT_EXPLOSION_PREVENTER))
		return

	ADD_TRAIT(L, TRAIT_EXPLOSION_PREVENTER, REF(src))

	UnregisterSignal(L, COMSIG_LIVING_DEATH)

	addtimer(CALLBACK(src, PROC_REF(kaboom), L, gibbed), 0.5 SECONDS)

/datum/component/violent_death/proc/kaboom(mob/living/L, gibbed)
	var/old_color = L.color
	var/matrix/M = matrix(L.transform)
	M.Scale(2, 2)

	animate(L, transform = M, color = "#ff3333", time = death_time, loop = 0)

	addtimer(CALLBACK(src, PROC_REF(detonate), L, gibbed, old_color), death_time)

/datum/component/violent_death/proc/detonate(mob/living/L, gibbed, old_color)
	if(QDELETED(L))
		return

	var/turf/T = get_turf(L)
	if(!T)
		return

	cell_explosion(
		epicenter = T, \
		power = explosion_power, \
		falloff = explosion_falloff, \
		falloff_shape = explosion_shape, \
		explosion_source = "[L.name] (Violent Death Component)", \
		burns = burns \
	)

	var/matrix/M = matrix(L.transform)
	M.Scale(1, 1)
	animate(L, transform = M, color = old_color, time = 1)

	if(!gibbed)
		L.gib()
	qdel(src)
