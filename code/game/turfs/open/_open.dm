/turf/open
	plane = FLOOR_PLANE
	hover_color = "#6b3f3f"
	var/slowdown = 0 //negative for faster, positive for slower
	var/postdig_icon_change = FALSE
	var/postdig_icon
	var/wet

	var/footstep = null
	var/barefootstep = null
	var/clawfootstep = null
	var/heavyfootstep = null
	var/force_footstep_sound = FALSE

	baseturfs = /turf/open/openspace

	smoothing_groups = SMOOTH_GROUP_TURF_OPEN

	var/obj/effect/hotspot/active_hotspot

	no_over_text = TRUE

	appearance_flags = LONG_GLIDE | TILE_BOUND
	/// Pollution of this turf
	var/datum/pollution/pollution

/turf/open/Initialize(mapload)
	. = ..()
	if(wet)
		AddComponent(/datum/component/wet_floor, wet, INFINITY, 0, INFINITY, TRUE)

/turf/proc/get_slowdown(mob/user)
	return 0

/turf/open/get_slowdown(mob/user)
	var/total_slowdown = slowdown
	for(var/obj/obj in contents)
		if(obj.obj_flags & BLOCK_Z_OUT_DOWN)
			return obj.object_slowdown
		total_slowdown += obj.object_slowdown
	return total_slowdown

/turf
	var/landsound = null

//direction is direction of travel of A
/turf/open/zPassIn(direction)
	if(direction != DOWN)
		return FALSE
	for(var/obj/on_us in contents)
		if(on_us.obj_flags & BLOCK_Z_IN_DOWN)
			return FALSE
	return TRUE

//direction is direction of travel of an atom
/turf/open/zPassOut(direction)
	if(direction != UP)
		return FALSE
	for(var/obj/on_us in contents)
		if(on_us.obj_flags & BLOCK_Z_OUT_UP)
			return FALSE
	return TRUE

//direction is direction of travel of air
/turf/open/zAirIn(direction, turf/source)
	return (direction == DOWN)

//direction is direction of travel of air
/turf/open/zAirOut(direction, turf/source)
	return (direction == UP)

/turf/open/proc/freon_gas_act()
	for(var/obj/I in contents)
		if(I.resistance_flags & FREEZE_PROOF)
			continue
		if(!(I.obj_flags & FROZEN))
			I.make_frozen_visual()
	for(var/mob/living/L in contents)
		if(L.bodytemperature <= 50)
			L.apply_status_effect(/datum/status_effect/freon)
	MakeSlippery(TURF_WET_PERMAFROST, 50)
	return TRUE

/turf/open/proc/water_vapor_gas_act()
	MakeSlippery(TURF_WET_WATER, min_wet_time = 100, wet_time_to_add = 50)

	SEND_SIGNAL(src, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_WASH)
	return TRUE

/turf/open/handle_slip(mob/living/slipper, knockdown_amount, obj/slippable, lube, paralyze_amount, force_drop)
	if(slipper.movement_type & MOVETYPES_NOT_TOUCHING_GROUND)
		return FALSE

	var/slide_distance = 4
	if(lube & SLIDE_ICE)
		// Ice slides only go 1 tile, this is so you will slip across ice until you reach a non-slip tile
		slide_distance = 1

	var/obj/buckled_obj
	if(slipper.buckled)
		if(!(lube & GALOSHES_DONT_HELP)) //can't slip while buckled unless it's lube.
			return FALSE
		buckled_obj = slipper.buckled
	else
		if(!(lube & SLIP_WHEN_CRAWLING) && (slipper.body_position == LYING_DOWN || !(slipper.status_flags & CANKNOCKDOWN))) // can't slip unbuckled mob if they're lying or can't fall.
			return FALSE
		if(slipper.m_intent == MOVE_INTENT_WALK && (lube & NO_SLIP_WHEN_WALKING))
			return FALSE

	if(!(lube & SLIDE_ICE))
		// Ice slides are intended to be combo'd so don't give the feedback
		to_chat(slipper, span_notice("You slipped[ slippable ? " on \the [slippable]" : ""]!"))
		playsound(slipper.loc, 'sound/misc/slip.ogg', 50, TRUE, -3)

	slipper.add_stress(/datum/stress_event/slipped)

	if(force_drop && iscarbon(slipper)) //carbon specific behavior that living doesn't have
		var/mob/living/carbon/carbon = slipper
		for(var/obj/item/item in slipper.held_items)
			carbon.accident(item)

	var/olddir = slipper.dir
	slipper.moving_diagonally = 0 //If this was part of diagonal move slipping will stop it.
	if(lube & SLIDE_ICE)
		// They need to be kept upright to maintain the combo effect (So don't knockdown)
		slipper.Immobilize(1 SECONDS)
		slipper.Stun(1 SECONDS)
	else
		slipper.Paralyze(paralyze_amount)
		slipper.Knockdown(knockdown_amount)
	slipper.stop_pulling()

	if(!isnull(buckled_obj) && !ismob(buckled_obj))
		buckled_obj.unbuckle_mob(slipper)
		// This is added onto the end so they slip "out of their chair" (one tile)
		lube |= SLIDE_ICE
		slide_distance = 1

	if(slide_distance)
		var/turf/target = get_ranged_target_turf(slipper, olddir, slide_distance)
		if(lube & SLIDE)
			slipper.AddComponent(/datum/component/force_move, target, TRUE)
		else if(lube & SLIDE_ICE)
			slipper.AddComponent(/datum/component/force_move, target, FALSE)//spinning would be bad for ice, fucks up the next dir

	return TRUE

/turf/open/proc/MakeSlippery(wet_setting = TURF_WET_WATER, min_wet_time = 0, wet_time_to_add = 0, max_wet_time = MAXIMUM_WET_TIME, permanent)
	AddComponent(/datum/component/wet_floor, wet_setting, min_wet_time, wet_time_to_add, max_wet_time, permanent)

/turf/open/proc/MakeDry(wet_setting = TURF_WET_WATER, immediate = FALSE, amount = INFINITY)
	SEND_SIGNAL(src, COMSIG_TURF_MAKE_DRY, wet_setting, immediate, amount)

/turf/proc/OnDry()
	return

/turf/open/get_dumping_location()
	return src

/turf/open/proc/ClearWet()//Nuclear option of immediately removing slipperyness from the tile instead of the natural drying over time
	qdel(GetComponent(/datum/component/wet_floor))

/turf/open/attacked_by(obj/item/I, mob/living/user)
	if(!(flags_1 & CAN_BE_ATTACKED_1) || !user.cmode)
		return FALSE
	. = ..()

/turf/open/OnCrafted(dirin, mob/user)
	. = ..()
	flags_1 |= CAN_BE_ATTACKED_1

///this will always use the highest value given depending on if set for negative
/turf/proc/add_turf_temperature(key, value, weight = 1)
	LAZYSET(temperature_sources, key, list(value, weight))
	rebuild_turf_temperature()


/turf/proc/remove_turf_temperature(key)
	LAZYREMOVE(temperature_sources, key)
	rebuild_turf_temperature()

/turf/proc/rebuild_turf_temperature()
	var/total = 0
	var/total_weight = 0

	for(var/source in temperature_sources)
		var/data = temperature_sources[source]
		var/value = data[1]
		var/weight = data[2]

		total += value * weight
		total_weight += weight

	var/delta = total_weight ? (total / total_weight) : 0
	temperature_modification = delta

/turf/proc/return_temperature()
	var/ambient_temperature = SSParticleWeather.selected_forecast.current_ambient_temperature
	if(SSParticleWeather.runningWeather)
		ambient_temperature += SSParticleWeather.runningWeather?.temperature_modification
	if(ambient_temperature < 15 && (outdoor_effect?.weatherproof || !outdoor_effect))
		if(ambient_temperature < 0)
			ambient_temperature = 0
		ambient_temperature += 10
	if(!("[z]" in GLOB.cellar_z))
		if(SSmapping.level_trait(z, ZTRAIT_CELLAR_LIKE))
			GLOB.cellar_z |= "[z]"
	if("[z]" in GLOB.cellar_z)
		ambient_temperature = 11 + CEILING(ambient_temperature * 0.1, 1)
	return temperature_modification + ambient_temperature
