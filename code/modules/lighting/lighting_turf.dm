// Causes any affecting light sources to be queued for a visibility update, for example a door got opened.
/turf/proc/reconsider_lights()
	for (var/datum/light_source/L as anything in affecting_lights)
		L.vis_update()

/turf/proc/lighting_clear_overlay()
	if (lighting_object)
		qdel(lighting_object, TRUE)

	var/datum/lighting_corner/C
	var/thing
	for (thing in corners)
		if(!thing)
			continue
		C = thing
		C.update_active()

// Builds a lighting object for us, but only if our area is dynamic.
/turf/proc/lighting_build_overlay()
	if(lighting_object)
		qdel(lighting_object, force=TRUE) //Shitty fix for lighting objects persisting after death

	var/area/A = loc
	if (!IS_DYNAMIC_LIGHTING(A) && !light_sources)
		return

	if (!lighting_corners_initialised)
		generate_missing_corners()

	new/atom/movable/lighting_object(src)

	for(var/datum/lighting_corner/C as anything in corners)
		if(!C)
			continue
		if(!C.active) // We would activate the corner, calculate the lighting for it.
			for(var/datum/light_source/S in C.affecting)
				S.recalc_corner(C)
			C.active = TRUE

// Used to get a scaled lumcount.
/turf/proc/get_lumcount(minlum = 0, maxlum = 1)
	if (!lighting_object)
		return 1

	var/totallums = 0
	var/thing
	var/datum/lighting_corner/L
	var/totalSunFalloff
	for (thing in corners)
		if(!thing)
			continue
		L = thing
		totallums += L.lum_r + L.lum_b + L.lum_g
		totalSunFalloff += L.sunFalloff

	if(outdoor_effect && outdoor_effect.state)
		totalSunFalloff = 4

	totallums += totalSunFalloff / 4

	totallums /= 12 // 4 corners, each with 3 channels, get the average.

	totallums = (totallums - minlum) / (maxlum - minlum)
	totallums += dynamic_lumcount

	return CLAMP01(totallums)

// Returns a boolean whether the turf is on soft lighting.
// Soft lighting being the threshold at which point the overlay considers
// itself as too dark to allow sight and see_in_dark becomes useful.
// So basically if this returns true the tile is unlit black.
/turf/proc/is_softly_lit()
	if (!lighting_object)
		return FALSE

	return !lighting_object.luminosity

///Proc to add movable sources of opacity on the turf and let it handle lighting code.
/turf/proc/add_opacity_source(atom/movable/new_source)
	LAZYADD(opacity_sources, new_source)
	if(opacity)
		return
	recalculate_directional_opacity()

///Proc to remove movable sources of opacity on the turf and let it handle lighting code.
/turf/proc/remove_opacity_source(atom/movable/old_source)
	LAZYREMOVE(opacity_sources, old_source)
	if(opacity) //Still opaque, no need to worry on updating.
		return
	recalculate_directional_opacity()

///Calculate on which directions this turfs block view.
/turf/proc/recalculate_directional_opacity()
	. = directional_opacity
	if(opacity)
		directional_opacity = ALL_CARDINALS
		if(. != directional_opacity)
			reconsider_lights()
		return

	directional_opacity = NONE

	if(opacity_sources)
		for(var/atom/movable/opacity_source as anything in opacity_sources)
			if(opacity_source.flags_1 & ON_BORDER_1)
				directional_opacity |= opacity_source.dir
			else //If fulltile and opaque, then the whole tile blocks view, no need to continue checking.
				directional_opacity = ALL_CARDINALS
				break
	else
		for(var/atom/movable/content as anything in contents)
			SEND_SIGNAL(content, COMSIG_TURF_NO_LONGER_BLOCK_LIGHT)

	if(. != directional_opacity && (. == ALL_CARDINALS || directional_opacity == ALL_CARDINALS))
		reconsider_lights() //The lighting system only cares whether the tile is fully concealed from all directions or not.

/turf/proc/change_area(area/old_area, area/new_area)
	GLOB.SUNLIGHT_QUEUE_WORK += src
	if(outdoor_effect)
		GLOB.SUNLIGHT_QUEUE_UPDATE += outdoor_effect
	if(SSlighting.initialized)
		if (new_area.dynamic_lighting != old_area.dynamic_lighting)
			if (new_area.dynamic_lighting)
				lighting_build_overlay()
			else
				lighting_clear_overlay()

	//move the turf
	LISTASSERTLEN(old_area.turfs_to_uncontain_by_zlevel, z, list())
	LISTASSERTLEN(new_area.turfs_by_zlevel, z, list())
	old_area.turfs_to_uncontain_by_zlevel[z] += src
	new_area.turfs_by_zlevel[z] += src
	new_area.contents += src

/turf/proc/get_corners()
	if (!IS_DYNAMIC_LIGHTING(src) && !light_sources)
		return null
	if (!lighting_corners_initialised)
		generate_missing_corners()
	if (IS_OPAQUE_TURF(src))
		return null // Since this proc gets used in a for loop, null won't be looped though.

	return corners

/turf/proc/generate_missing_corners()
	if (!IS_DYNAMIC_LIGHTING(src) && !light_sources)
		return
	lighting_corners_initialised = TRUE
	if (!corners)
		corners = list(null, null, null, null)

	for (var/i = 1 to 4)
		if (corners[i]) // Already have a corner on this direction.
			continue

		corners[i] = new/datum/lighting_corner(src, GLOB.LIGHTING_CORNER_DIAGONAL[i])


