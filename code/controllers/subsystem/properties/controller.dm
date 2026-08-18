/datum/property_controller
	var/obj/effect/landmark/house_spot/linked_property
	var/list/allowed_list = list()

	var/property_bounds_minx
	var/property_bounds_miny
	var/property_bounds_minz
	var/property_bounds_maxx
	var/property_bounds_maxy
	var/property_bounds_maxz

/datum/property_controller/New(obj/effect/landmark/house_spot/property)
	linked_property = property
	if(!property)
		return

	var/turf/start_turf = get_turf(property)
	if(!start_turf)
		return

	property_bounds_minx = start_turf.x
	property_bounds_miny = start_turf.y
	property_bounds_minz = start_turf.z
	property_bounds_maxx = start_turf.x + property.template_x - 1
	property_bounds_maxy = start_turf.y + property.template_y - 1
	property_bounds_maxz = start_turf.z + property.template_z - 1

/datum/property_controller/proc/check_access(mob/user)
	if(!linked_property || !user || !user.client)
		return FALSE

	// Owner has access
	if(user.ckey == linked_property.owner_ckey)
		return TRUE

	// Check allow list
	if(user.ckey in allowed_list)
		return TRUE

	return FALSE

/datum/property_controller/proc/is_in_property_bounds(atom/A)
	if(!linked_property)
		return FALSE

	var/turf/T = get_turf(A)
	if(!T)
		return FALSE

	return (T.x >= property_bounds_minx && T.x <= property_bounds_maxx && \
	        T.y >= property_bounds_miny && T.y <= property_bounds_maxy && \
	        T.z >= property_bounds_minz && T.z <= property_bounds_maxz)

/datum/property_controller/proc/add_access(ckey)
	if(!(ckey in allowed_list))
		allowed_list += ckey

/datum/property_controller/proc/remove_access(ckey)
	allowed_list -= ckey
