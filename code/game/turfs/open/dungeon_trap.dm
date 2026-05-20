/turf/open/dungeon_trap
	name = "dark chasm"
	desc = "It's a long way down..."
	baseturfs = /turf/open/dungeon_trap
	icon = 'icons/turf/floors/chasms.dmi'
	icon_state = "chasms-255"
	base_icon_state = "chasms"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	smoothing_groups = SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_TURF_CHASM
	smoothing_list = SMOOTH_GROUP_TURF_CHASM
	bullet_bounce_sound = null //abandon all hope ye who enter
	path_weight = 500
	dynamic_lighting = 1

/turf/open/dungeon_trap/can_cross_safely(atom/movable/traveler)
	return HAS_TRAIT(traveler, TRAIT_MOVE_FLYING) || !traveler.can_z_move(DOWN, src, z_move_flags = ZMOVE_FALL_FLAGS)

/turf/open/dungeon_trap/zImpact(atom/movable/falling, levels, turf/prev_turf, flags)
	if(!isobj(falling) && !ismob(falling))
		return ..()
	if(!length(GLOB.dungeon_entries) || !length(GLOB.dungeon_exits))
		return ..()
	. = handle_falling_movement(falling, levels) // I hate this
	if(!.)
		return ..()

/turf/open/dungeon_trap/proc/handle_falling_movement(atom/movable/falling, levels)
	var/turf/target = get_dungeon_tile()
	if(!target)
		return FALSE
	levels += (SSdungeon_generator.dungeon_z + 2) - target.z //if you fall on the lower dungeon level, you're falling 3+ levels. If you're falling on the upper level, you're falling 2+.
	falling.forceMove(target) // we're just going to fake the zmovement
	return target.zImpact(falling, levels, src)

/proc/get_dungeon_tile()
	//this z is pulled from the first made dungeon marker which should be on the bottom floor. if it's not, this'll need to be reworked
	if(SSdungeon_generator.dungeon_z == -1)
		return
	var/list/dungeon_turfs = Z_TURFS(SSdungeon_generator.dungeon_z + 1)
	var/turf/open/chosen_turf
	while(!chosen_turf && length(dungeon_turfs))
		var/turf/T = pick_n_take(dungeon_turfs)
		if(isopenturf(T))
			chosen_turf = T
		// no chosen_turf this step so don't bother with the parts after this
		if(isclosedturf(chosen_turf) || isopenspace(chosen_turf)) // don't put us in walls or falls
			continue
		// check if our chosen_turf actually works
		for(var/obj/structure/struct in chosen_turf)
			if(struct.density && !struct.climbable) // keeps you from landing inside bars or something
				chosen_turf = null // ineligible
				break
	return chosen_turf

/// tiles that zip you to the top z level of vanderlin
/turf/open/dungeon_trap/australia
	name = "deep abyss"
	desc = "It's a long way up..."
	icon_state = "undervoid2"
	color = null
	smoothing_flags = NONE
	smoothing_groups = NONE
	smoothing_list = null
	neighborlay_self = null
	dynamic_lighting = FALSE

/turf/open/dungeon_trap/australia/handle_falling_movement(atom/movable/falling, levels)
	var/turf/target = get_australia_tile()
	if(!target)
		return FALSE
	levels += 1
	falling.forceMove(target) // we're just going to fake the zmovement
	return target.zImpact(falling, levels, src)

/proc/get_australia_tile()
	var/list/levels = SSmapping.levels_by_trait(ZTRAIT_TOWN)
	if(!length(levels))
		return
	var/list/australia_turfs = Z_TURFS(levels[length(levels)])
	var/turf/open/chosen_turf
	while(!chosen_turf && length(australia_turfs))
		var/turf/T = pick_n_take(australia_turfs)
		if(isopenturf(T))
			chosen_turf = T
		// no chosen_turf this step so don't bother with the parts after this
		if(isclosedturf(chosen_turf) || isopenspace(chosen_turf)) // don't put us in walls or falls
			continue
		// check if our chosen_turf actually works
		for(var/obj/structure/struct in chosen_turf)
			if(struct.density && !struct.climbable) // keeps you from landing inside bars or something
				chosen_turf = null // ineligible
				break
	return chosen_turf
