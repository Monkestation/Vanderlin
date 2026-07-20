
/obj/structure/waterwheel
	name = "waterwheel"

	icon = 'icons/roguetown/misc/waterwheel.dmi'
	icon_state = "1"

	layer = 5
	stress_generator = TRUE
	rotation_structure = TRUE
	initialize_dirs = CONN_DIR_FORWARD | CONN_DIR_FLIP

/obj/structure/waterwheel/find_rotation_network()
	. = ..()
	setup_rotation(get_turf(src))

/obj/structure/waterwheel/proc/setup_rotation(turf/open/water/river/water)
	if(!water)
		water = get_turf(src)
	if(!istype(water))
		return
	if(water.volume_status == WATER_VOLUME_DRY)
		return
	var/wheel_rotation_dir = water.dir
	if(!(wheel_rotation_dir & ALL_CARDINALS))
		return
	if(dir == wheel_rotation_dir || dir == REVERSE_DIR(wheel_rotation_dir)) //incorrect orientation
		return

	if(EWCOMPONENT(wheel_rotation_dir))
		wheel_rotation_dir = EWDIRFLIP(wheel_rotation_dir)
	else // northern water is EAST rotation, southern water is WEST rotation
		wheel_rotation_dir = turn(wheel_rotation_dir, -90)
	last_stress_generation = 0
	set_stress_generation(1024)
	set_rotational_direction_and_speed(wheel_rotation_dir, 8)
	return TRUE

/obj/structure/waterwheel/update_animation_effect()
	if(!rotation_network || rotation_network?.overstressed || !rotations_per_minute || !rotation_network?.total_stress)
		animate(src, icon_state = "1", time = 1)
		return
	var/frame_stage = 1 / ((rotations_per_minute / 60) * 4)
	if(rotation_direction == WEST)
		animate(src, icon_state = "1", time = frame_stage, loop=-1)
		animate(icon_state = "2", time = frame_stage)
		animate(icon_state = "3", time = frame_stage)
		animate(icon_state = "4", time = frame_stage)
	else
		animate(src, icon_state = "4", time = frame_stage, loop=-1)
		animate(icon_state = "3", time = frame_stage)
		animate(icon_state = "2", time = frame_stage)
		animate(icon_state = "1", time = frame_stage)
