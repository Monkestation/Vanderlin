//todo: handle moving sunlight turfs - see various uses of get_turf in lighting_object


/*

Sunlight System

	Objects + Details
		Sunlight Objects (this file)
			- Grayscale version of lighting_object
			- Has 3 states
				- SKY_BLOCKED  (0)
					- Turfs that have an opaque turf above them. Has no light themselves but is affected by SKY_VISIBLE_BORDER
				- SKY_VISIBLE (1)
					- Turfs that with no opaque turfs above it (no roof, glass roof, etc), with no neighbouring SKY_BLOCKED tiles
					  Emits no light, but is fully white to display the overlay color
				- SKY_VISIBLE_BORDER  (2)
					- Turfs that with no opaque turfs above it (no roof, glass roof, etc), which neighbour at least one SKY_BLOCKED tile.
				     Emits light to SKY_BLOCKED tiles, and fully white to display the overlay color

*/

/obj/proc/weather_act_on(weather_trait, severity)
	return

/atom/movable/outdoor_effect
	name = "outdoor effect"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE
	appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
	plane = WEATHER_EFFECT_PLANE

	var/state = SKY_VISIBLE	// If we can see the see the sky, are blocked, or we have a blocked neighbour (SKY_BLOCKED/VISIBLE/VISIBLE_BORDER)
	var/weatherproof = FALSE // If we have a weather overlay

	var/turf/source_turf
	var/mutable_appearance/sunlight_overlay
	var/list/datum/lighting_corner/affecting_corners

/atom/movable/outdoor_effect/Initialize(mapload)
	. = ..()
	source_turf = loc
	if(source_turf.outdoor_effect)
		qdel(source_turf.outdoor_effect, force = TRUE)
	source_turf.outdoor_effect = src

/atom/movable/outdoor_effect/Destroy(force)
	if(!force)
		return QDEL_HINT_LETMELIVE

	//If we are a source of light - disable it, to fix out corner refs
	disable_sunlight()

	//Remove ourselves from our turf
	if(source_turf && source_turf.outdoor_effect == src)
		source_turf.outdoor_effect = null

	return ..()

/atom/movable/outdoor_effect/proc/disable_sunlight()
	for(var/datum/lighting_corner/C as anything in affecting_corners)
		C.sunFalloff -= affecting_corners[C]
		for(var/turf/turf in C.get_masters())
			SSoutdoor_effects.queue_turf_corners(turf)

	SSoutdoor_effects.queue_turf_corners(source_turf)

	//Empty our affecting_corners list
	affecting_corners = null

/atom/movable/outdoor_effect/proc/process_state()
	switch(state)
		if(SKY_BLOCKED)
			disable_sunlight() /* Do our indoor processing */
		if(SKY_VISIBLE_BORDER)
			calc_sunlight_spread()

#define GLOBAL_LIGHT_RANGE 2

#define HARD_SUN 0.5 /* our hyperboloidy modifyer funky times - I wrote this in like, 2020 and can't remember how it works - I think it makes a 3D cone shape with a flat top */
/* calculate the indoor corners we are affecting */
#define SUN_FALLOFF(C, T) (1 - CLAMP01(sqrt((C.x - T.x) ** 2 + (C.y - T.y) ** 2 - HARD_SUN) / GLOBAL_LIGHT_RANGE))

/atom/movable/outdoor_effect/proc/calc_sunlight_spread()
	var/list/datum/lighting_corner/corners = list()
	if(source_turf)
		var/oldlum = source_turf.luminosity
		source_turf.luminosity = GLOBAL_LIGHT_RANGE
		for(var/turf/T in view(GLOBAL_LIGHT_RANGE, source_turf))
			if(IS_OPAQUE_TURF(T))
				continue
			if(!T.lighting_corners_initialised)
				GENERATE_MISSING_CORNERS(T)

			corners[T.lighting_corner_NE] = 0
			corners[T.lighting_corner_SE] = 0
			corners[T.lighting_corner_SW] = 0
			corners[T.lighting_corner_NW] = 0

		source_turf.luminosity = oldlum

	var/list/datum/lighting_corner/new_corners = (corners - src.affecting_corners)
	LAZYINITLIST(src.affecting_corners)
	var/list/affecting_corners = src.affecting_corners
	for (var/datum/lighting_corner/corner as anything in new_corners)
		var/falloff = SUN_FALLOFF(corner, source_turf)
		if (falloff != 0)
			corner.sunFalloff += falloff
			affecting_corners[corner] = falloff
			for (var/turf/master in corner.get_masters())
				SSoutdoor_effects.queue_turf_corners(master)

	var/list/datum/lighting_corner/gone_corners = affecting_corners - corners
	for (var/datum/lighting_corner/corner as anything in gone_corners)
		corner.sunFalloff -= affecting_corners[corner]
		for (var/turf/master in corner.get_masters())
			SSoutdoor_effects.queue_turf_corners(master)

	affecting_corners -= gone_corners

#undef GLOBAL_LIGHT_RANGE
#undef HARD_SUN
#undef SUN_FALLOFF

/* Related object changes */
/* I moved this here to consolidate sunlight changes as much as possible, so its easily disabled */

/* area fuckery */
/area/var/turf/pseudo_roof

/* turf fuckery */
/turf/var/tmp/atom/movable/outdoor_effect/outdoor_effect /* a turf's sunlight overlay */
/turf/var/tmp/is_being_weathered = FALSE // if we're in the weathered_turfs list or not
/turf/var/turf/pseudo_roof /* our roof turf - may be a path for top z level, or a ref to the turf above*/

//non-weatherproof turfs
/turf/var/weatherproof = TRUE
/turf/open/openspace/weatherproof = FALSE

/datum/lighting_corner/var/sunFalloff = 0 /* smallest distance to sunlight turf, for sunlight falloff */

/turf/proc/reassess_stack()
	if(!SSlighting.initialized && !SSoutdoor_effects.initialized)
		return

	/* remove roof refs (not path for psuedo roof) so we can recalculate it */
	if(pseudo_roof && !ispath(pseudo_roof))
		pseudo_roof = null

	var/list/datum/lighting_corner/corners = list(
		lighting_corner_NE,
		lighting_corner_NW,
		lighting_corner_SE,
		lighting_corner_SW,
	)

	SSoutdoor_effects.queue_work |= src

	for(var/datum/lighting_corner/corner in corners)
		for(var/turf/turf in corner.get_masters())
			SSoutdoor_effects.queue_work |= turf

	var/turf/T = GET_TURF_BELOW(src)
	if(T)
		T.reassess_stack()

/* check ourselves and neighbours to see what outdoor effects we need */
/* turf won't initialize an outdoor_effect if sky_blocked*/
/turf/proc/update_sky_and_weather_states()
	var/TempState

	var/sky_visible = is_sky_visible()
	var/turf_weatherproof = is_weatherproof()
	if(!sky_visible)/* roofed, so turn off the lights */
		TempState = SKY_BLOCKED
	else
		TempState = SKY_VISIBLE
		for(var/turf/closed/closed_neighbor in orange(1, src)) // use byond's built-in type filtering for speed
			TempState = SKY_VISIBLE_BORDER
			break
		if(TempState != SKY_VISIBLE_BORDER)
			for(var/turf/open/open_neighbor in orange(1, src)) // once again, use orange instead of RANGE_TURFS for the built-in type filtering
				if(!open_neighbor.is_sky_visible()) /* if we have a single roofed/indoor neighbour, we are a border */
					TempState = SKY_VISIBLE_BORDER
					break

	/* if border or indoor, initialize. Set sunlight state if valid */
	if(!outdoor_effect && (TempState != SKY_BLOCKED || !turf_weatherproof))
		outdoor_effect = new /atom/movable/outdoor_effect(src)
	if(outdoor_effect)
		outdoor_effect.state = TempState
		outdoor_effect.weatherproof = turf_weatherproof
		if(turf_weatherproof) // we're weatherproof so make sure we're not being weathered
			if(turf_flags & TURF_BEING_WEATHERED) // only remove it from the list if we're sure it's already in it
				SSParticleWeather.weathered_turfs -= src
				turf_flags &= ~TURF_BEING_WEATHERED
		else if(SSoutdoor_effects.turf_weather_affectable_z_levels[z]) // not weatherproof, enable weathering if allowed
			turf_flags |= TURF_BEING_WEATHERED
			SSParticleWeather.weathered_turfs += src

/// Do this turf and all the turfs above it in the z-stack allow sunlight through?
/turf/proc/is_sky_visible()
	// rare for this to be true but it overrides everything else
	if (pseudo_roof)
		return FALSE
	var/turf/ceiling = _GET_TURF_ABOVE_UNSAFE(src)
	if(ceiling)
		return ceiling.is_sky_visible_through()
	else
		var/area/turf_area = loc
		if(!turf_area.outdoors)
			return FALSE
	return TRUE

/// Does this turf allow the turf below to see the sky?
/// Equivalent to is_sky_visible(recursionStarted = TRUE) in the old format.
/turf/proc/is_sky_visible_through()
	if(!istransparentturf(src))
		return FALSE
	for(var/obj/structure/thing in src)
		if(thing.weatherproof)
			return FALSE
	return is_sky_visible()

/// Does this turf, or ANY turf in the Z-stack above it, block weather effects?
/turf/proc/is_weatherproof()
	// rare for this to be true
	if (pseudo_roof)
		return TRUE
	var/turf/ceiling = _GET_TURF_ABOVE_UNSAFE(src)
	if(ceiling)
		return ceiling.is_weatherproof_ceiling()
	var/area/turf_area = loc
	return !turf_area.outdoors // if this runtimes because a turf isn't in an area i'll just die

/turf/closed/is_weatherproof() // skip checks for this. refactor if you ever allow closed turfs to let weather through ig
	return TRUE

/// Does this turf block the ones below it from receiving weather effects?
/// Equivalent to is_weatherproof(recursionStarted = TRUE) in the old format.
/turf/proc/is_weatherproof_ceiling()
	// due to the type overrides of this proc we can assume src is never a closed turf
	if(weatherproof) // turf weatherproof only applies for passing weather downwards
		return TRUE
	// not inherently weatherproof
	for(var/obj/structure/thing in src) // check for weather blockers (tent walls, etc)
		if(thing.weatherproof)
			return TRUE
	return is_weatherproof() // check our own roof

/turf/closed/is_weatherproof_ceiling() // ditto, skip checks for this.
	return TRUE
