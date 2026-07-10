/obj/effect/mapping_helpers/virtual_z_link
	name = "virtual z-link helper"
	icon_state = "virtual_z_link"
	late = TRUE
	var/link_id = ""
	var/is_above = FALSE
	/// Width of the region to link. If 0, uses the area bounding box.
	var/link_width = 0
	/// Height of the region to link. If 0, uses the area bounding box.
	var/link_height = 0

GLOBAL_LIST_EMPTY(virtual_z_link_helpers)

/obj/effect/mapping_helpers/virtual_z_link/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/mapping_helpers/virtual_z_link/LateInitialize()
	if(!link_id)
		log_mapping("[src] at [AREACOORD(src)] has no link_id set!")
		qdel(src)
		return

	LAZYINITLIST(GLOB.virtual_z_link_helpers[link_id])
	GLOB.virtual_z_link_helpers[link_id] += src

	// Try to find our partner
	for(var/obj/effect/mapping_helpers/virtual_z_link/other in GLOB.virtual_z_link_helpers[link_id])
		if(other == src)
			continue
		if(other.is_above == is_above)
			log_mapping("[src] at [AREACOORD(src)] found duplicate [is_above ? "above" : "below"] helper with link_id '[link_id]' at [AREACOORD(other)]!")
			continue
		var/obj/effect/mapping_helpers/virtual_z_link/above = is_above ? src : other
		var/obj/effect/mapping_helpers/virtual_z_link/below = is_above ? other : src
		do_link(above, below)
		return

/obj/effect/mapping_helpers/virtual_z_link/proc/do_link(obj/effect/mapping_helpers/virtual_z_link/above, obj/effect/mapping_helpers/virtual_z_link/below)
	// Use the helper positions as origins directly if width/height are specified
	var/width = link_width || 0
	var/height = link_height || 0

	var/turf/above_origin
	var/turf/below_origin

	if(width && height)
		// Use the helpers' own turfs as the bottom-left origins
		above_origin = get_turf(above)
		below_origin = get_turf(below)
	else
		// Fall back to area bounding box
		var/area/above_area = get_area(above)
		var/area/below_area = get_area(below)

		if(!above_area || !below_area)
			log_mapping("[src] at [AREACOORD(src)] could not find areas for link_id '[link_id]'!")
			qdel(src)
			return

		var/above_min_x = INFINITY
		var/above_min_y = INFINITY
		var/below_min_x = INFINITY
		var/below_min_y = INFINITY
		var/below_max_x = -INFINITY
		var/below_max_y = -INFINITY

		for(var/turf/T as anything in above_area.get_turfs_by_zlevel(above.z))
			if(T.z != above.z)
				continue
			if(T.x < above_min_x) above_min_x = T.x
			if(T.y < above_min_y) above_min_y = T.y

		for(var/turf/T as anything in below_area.get_turfs_by_zlevel(below.z))
			if(T.z != below.z)
				continue
			if(T.x < below_min_x) below_min_x = T.x
			if(T.y < below_min_y) below_min_y = T.y
			if(T.x > below_max_x) below_max_x = T.x
			if(T.y > below_max_y) below_max_y = T.y

		width = below_max_x - below_min_x + 1
		height = below_max_y - below_min_y + 1
		above_origin = locate(above_min_x, above_min_y, above.z)
		below_origin = locate(below_min_x, below_min_y, below.z)

	if(!width || !height)
		log_mapping("[src] at [AREACOORD(src)] could not determine region size for link_id '[link_id]'!")
		qdel(src)
		return

	link_region(below_origin, above_origin, width, height)

	GLOB.virtual_z_link_helpers[link_id] -= above
	GLOB.virtual_z_link_helpers[link_id] -= below
	if(!length(GLOB.virtual_z_link_helpers[link_id]))
		GLOB.virtual_z_link_helpers -= link_id

	qdel(above)
	qdel(below)

/obj/effect/mapping_helpers/virtual_z_link/Destroy()
	if(link_id && (link_id in GLOB.virtual_z_link_helpers))
		GLOB.virtual_z_link_helpers[link_id] -= src
		if(!length(GLOB.virtual_z_link_helpers[link_id]))
			GLOB.virtual_z_link_helpers -= link_id
	return ..()
