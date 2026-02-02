/turf/open/dungeon_trap
	name = "dark chasm"
	desc = "It's a long way down..."
	icon = 'icons/turf/floors.dmi'
	icon_state = "grey"
	color = "#3d3d3d"

	var/can_cover_up = TRUE
	var/can_build_on = TRUE
	dynamic_lighting = 1
	turf_flags = NONE
	path_weight = 500
	smoothing_flags = SMOOTH_EDGE
	smoothing_groups = SMOOTH_GROUP_FLOOR_OPEN_SPACE
	smoothing_list = SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_CLOSED_WALL
	neighborlay_self = "staticedge"


/turf/open/dungeon_trap/can_traverse_safely(atom/movable/traveler)
	//cheating this by checking if they can fall onto the same tile
	if(!traveler.can_zFall(src, 0, null, DOWN))
		return TRUE
	return FALSE

/turf/open/dungeon_trap/zPassIn(atom/movable/A, direction, turf/source)
	if(direction == DOWN)
		for(var/obj/O in contents)
			if(O.obj_flags & BLOCK_Z_IN_DOWN)
				return FALSE
		return TRUE
	if(direction == UP)
		return FALSE // this shouldn't really happen, one way trip buddy
	return FALSE

/turf/open/dungeon_trap/zPassOut(atom/movable/A, direction, turf/destination)
	if(A.anchored && !isprojectile(A))
		return FALSE
	if(direction == DOWN)
		for(var/obj/O in contents)
			if(O.obj_flags & BLOCK_Z_OUT_DOWN)
				return FALSE
		return TRUE
	return FALSE

/turf/open/dungeon_trap/can_zFall(atom/movable/A, levels = 1, turf/target)
	if(!length(GLOB.dungeon_entries) || !length(GLOB.dungeon_exits))
		return FALSE
	return zPassOut(A, DOWN, target) && target.zPassIn(A, DOWN, src)

/turf/open/dungeon_trap/zFall(atom/movable/A, levels = 1, force = FALSE)
	if(!isobj(A) && !ismob(A))
		return FALSE
	var/turf/target = get_dungeon_tile()
	if(!target)
		return FALSE
	levels += (SSdungeon_generator.dungeon_z + 2) - target.z //if you fall on the lower dungeon level, you're falling 3+ levels. If you're falling on the upper level, you're falling 2+.
	if(!force && (!can_zFall(A, levels, target) || !A.can_zFall(src, levels, target, DOWN)))
		return FALSE
	A.atom_flags |= Z_FALLING
	A.forceMove(target)
	A.atom_flags &= ~Z_FALLING
	target.zImpact(A, levels, src)
	return TRUE

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
