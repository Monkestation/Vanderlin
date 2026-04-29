GLOBAL_LIST_INIT(breakable_types, list(
	/obj/structure/flora,
))
// Creates a single atom rather than loading a map template.
/datum/building_datum/simple
	stockpile_needed = FALSE
	var/atom/created_atom

/datum/building_datum/simple/generate_preview()
	generated_MA = new
	generated_MA.icon = initial(created_atom.icon)
	generated_MA.icon_state = initial(created_atom.icon_state)
	generated_MA.plane = ABOVE_LIGHTING_PLANE

	generated_MA.alpha = 190
	generated_MA.color = COLOR_CYAN

/datum/building_datum/simple/try_place_building(mob/camera/strategy_controller/user, turf/placed_turf)
	if(!resource_check(user))
		return
	user.resource_stockpile?.remove_resources(resource_cost)

	var/list/turfs = list(placed_turf)

	var/list/failed_locations = list()
	for(var/turf/turf in turfs)
		if(istype(turf, /turf/closed/mineral/bedrock))
			failed_locations |= turf
			continue

		for(var/obj/structure/structure in turf.contents)
			if(!is_type_in_list(structure, GLOB.breakable_types))
				failed_locations |= turf
				continue
		for(var/obj/machinery/structure in turf.contents)
			failed_locations |= turf
			continue

	if(length(failed_locations))
		for(var/turf/turf in failed_locations)
			new /obj/effect/conflicting_area(turf)

		return FALSE

	center_turf = placed_turf
	for(var/turf/turf in turfs)
		for(var/obj/structure/structure in turf.contents)
			if(is_type_in_list(structure, GLOB.breakable_types))
				if(!turf.break_overlay)
					create_turf_break_overlay(turf)
					continue
		if(!isclosedturf(turf))
			continue
		needed_broken_turfs |= turf
		if(!turf.break_overlay)
			create_turf_break_overlay(turf)

	return TRUE

/datum/building_datum/simple/construct_building()
	if(building_right_now)
		return
	building_right_now = TRUE

	var/atom/atom = new created_atom(center_turf)

	after_construction(atom)
	master.building_requests -= src
