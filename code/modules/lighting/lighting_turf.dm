// Causes any affecting light sources to be queued for a visibility update, for example a door got opened.
/turf/proc/reconsider_lights()
	lighting_corner_NE?.vis_update()
	lighting_corner_SE?.vis_update()
	lighting_corner_SW?.vis_update()
	lighting_corner_NW?.vis_update()

/turf/proc/lighting_clear_overlay()
	if(lighting_object)
		qdel(lighting_object, force = TRUE)

// Builds a lighting object for us, but only if our area is dynamic.
/turf/proc/lighting_build_overlay()
	if(lighting_object)
		qdel(lighting_object, force = TRUE) //Shitty fix for lighting objects persisting after death

	var/area/our_area  = loc
	if(!IS_DYNAMIC_LIGHTING(our_area) && !light_sources)
		return

	new /atom/movable/lighting_object(src)

// Used to get a scaled lumcount.
/turf/proc/get_lumcount(minlum = 0, maxlum = 1)
	if (!lighting_object)
		return 1

	var/totallums = 0
	var/totalSunFalloff = 0

	var/datum/lighting_corner/L
	L = lighting_corner_NE
	if (L)
		totallums += L.lum_r + L.lum_b + L.lum_g
		totalSunFalloff += L.sunFalloff
	L = lighting_corner_SE
	if (L)
		totallums += L.lum_r + L.lum_b + L.lum_g
		totalSunFalloff += L.sunFalloff
	L = lighting_corner_SW
	if (L)
		totallums += L.lum_r + L.lum_b + L.lum_g
		totalSunFalloff += L.sunFalloff
	L = lighting_corner_NW
	if (L)
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

	return !(lighting_object.luminosity || dynamic_lumcount)

// Can't think of a good name, this proc will recalculate the has_opaque_atom variable.
/turf/proc/recalc_atom_opacity()
	has_opaque_atom = opacity
	if (!has_opaque_atom)
		for (var/atom/A as anything in src) // Loop through every movable atom on our tile PLUS ourselves (we matter too...)
			if (A.opacity)
				has_opaque_atom = TRUE
				break

/turf/Exited(atom/movable/Obj, atom/newloc)
	. = ..()

	if (Obj && Obj.opacity)
		recalc_atom_opacity() // Make sure to do this before reconsider_lights(), incase we're on instant updates.
		reconsider_lights()

/turf/proc/change_area(area/old_area, area/new_area)
	SSoutdoor_effects.queue_work |= src
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
