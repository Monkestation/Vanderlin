/turf/var/turf/virtual_above
/turf/var/turf/virtual_below

GLOBAL_LIST_EMPTY(virtual_z_links)

GLOBAL_LIST_EMPTY(virtual_region_index)

/// Returns the turf above, checking virtual links before real Z.
/turf/proc/get_virtual_above()
	if(virtual_above)
		return virtual_above
	if(!length(SSmapping.multiz_levels) || !SSmapping.multiz_levels[z][Z_LEVEL_UP])
		return null
	return get_step(src, UP)

/// Returns the turf below, checking virtual links before real Z.
/turf/proc/get_virtual_below()
	if(virtual_below)
		return virtual_below
	if(!length(SSmapping.multiz_levels) || !SSmapping.multiz_levels[z][Z_LEVEL_DOWN])
		return null
	return get_step(src, DOWN)

/**
 * Links this turf to treat [new_below] as its Z-below neighbour.
 * Sets the reciprocal link on new_below automatically.
 * Pass null to clear the link.
 */
/turf/proc/link_below(turf/new_below, skip_reciprocal = FALSE)
	if(virtual_below)
		var/turf/old_below = virtual_below
		virtual_below = null
		var/list/linter_list = GLOB.virtual_z_links[src]
		linter_list?.Remove("below")
		if(old_below.virtual_above == src)
			old_below.link_above(null, skip_reciprocal = TRUE)

	if(!new_below)
		on_virtual_link_changed()
		return

	virtual_below = new_below
	LAZYINITLIST(GLOB.virtual_z_links[src])
	GLOB.virtual_z_links[src]["below"] = new_below

	if(!skip_reciprocal)
		new_below.link_above(src, skip_reciprocal = TRUE)

	on_virtual_link_changed()

/**
 * Links this turf to treat [new_above] as its Z-above neighbour.
 * Sets the reciprocal link on new_above automatically.
 * Pass null to clear the link.
 */
/turf/proc/link_above(turf/new_above, skip_reciprocal = FALSE)
	if(virtual_above)
		var/turf/old_above = virtual_above
		virtual_above = null
		var/list/linter_list = GLOB.virtual_z_links[src]
		linter_list?.Remove("above")
		if(old_above.virtual_below == src)
			old_above.link_below(null, skip_reciprocal = TRUE)

	if(!new_above)
		on_virtual_link_changed()
		return

	virtual_above = new_above
	LAZYINITLIST(GLOB.virtual_z_links[src])
	GLOB.virtual_z_links[src]["above"] = new_above

	if(!skip_reciprocal)
		new_above.link_below(src, skip_reciprocal = TRUE)

	on_virtual_link_changed()

/**
 * Called after any virtual link change on this turf.
 * Fires the same signals and reassessment that real Z changes would.
 */
/turf/proc/on_virtual_link_changed()
	reassess_stack()
	SEND_SIGNAL(src, COMSIG_TURF_MULTIZ_NEW, src, DOWN)
	SEND_SIGNAL(src, COMSIG_TURF_MULTIZ_NEW, src, UP)

/// Removes all virtual links from this turf in both directions.
/turf/proc/unlink_virtual_z()
	link_below(null)
	link_above(null)
	GLOB.virtual_z_links -= src

/turf/Destroy()
	if(GLOB.virtual_z_links[src])
		unlink_virtual_z()
	return ..()

/**
 * Links two rectangular regions vertically.
 * Each turf in the above region treats the corresponding turf
 * in the below region as its Z-below neighbour.
 */
/proc/link_region(turf/below_bottom_left, turf/above_bottom_left, width, height)
	if(!below_bottom_left || !above_bottom_left)
		CRASH("link_region: null corner turf passed")

	var/datum/virtual_region_link/L = new(
		below_bottom_left.z, above_bottom_left.z,
		below_bottom_left.x, below_bottom_left.y,
		below_bottom_left.x + width - 1, below_bottom_left.y + height - 1,
		above_bottom_left.x, above_bottom_left.y
	)
	if(!("[below_bottom_left.z]" in GLOB.virtual_region_index))
		GLOB.virtual_region_index["[below_bottom_left.z]"] = list()
	if(!("[above_bottom_left.z]" in GLOB.virtual_region_index))
		GLOB.virtual_region_index["[above_bottom_left.z]"] = list()

	LAZYOR(GLOB.virtual_region_index["[below_bottom_left.z]"], L)
	LAZYOR(GLOB.virtual_region_index["[above_bottom_left.z]"], L)

	for(var/x in 0 to width - 1)
		for(var/y in 0 to height - 1)
			var/turf/below = locate(below_bottom_left.x + x, below_bottom_left.y + y, below_bottom_left.z)
			var/turf/above = locate(above_bottom_left.x + x, above_bottom_left.y + y, above_bottom_left.z)
			if(!below || !above)
				continue
			above.link_below(below)

/// Removes all virtual Z links from a rectangular region.
/proc/unlink_region(turf/bottom_left, width, height)
	for(var/x in 0 to width - 1)
		for(var/y in 0 to height - 1)
			var/turf/T = locate(bottom_left.x + x, bottom_left.y + y, bottom_left.z)
			if(T)
				T.unlink_virtual_z()

/datum/virtual_region_link
	var/z_below
	var/z_above
	var/x1
	var/y1
	var/x2
	var/y2
	var/offset_x
	var/offset_y

/datum/virtual_region_link/New(z_below, z_above, x1, y1, x2, y2, above_x1, above_y1)
	. = ..()
	src.z_below = z_below
	src.z_above = z_above
	src.x1 = x1
	src.y1 = y1
	src.x2 = x2
	src.y2 = y2
	offset_x = above_x1 - x1
	offset_y = above_y1 - y1

/datum/virtual_region_link/proc/contains_below(px, py)
	return px >= x1 && px <= x2 && py >= y1 && py <= y2

/datum/virtual_region_link/proc/contains_above(px, py)
	var/ax1 = x1 + offset_x
	var/ay1 = y1 + offset_y
	var/ax2 = x2 + offset_x
	var/ay2 = y2 + offset_y
	return px >= ax1 && px <= ax2 && py >= ay1 && py <= ay2
