/turf/open/floor/carpet
	name = "carpet"
	icon = 'icons/turf/floors.dmi'
	icon_state = "carpet"
	flags_1 = NONE
	landsound = 'sound/foley/jumpland/carpetland.ogg'
	footstep = FOOTSTEP_CARPET
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	clawfootstep = FOOTSTEP_CARPET_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

	smoothing_groups = SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_FLOOR_CARPET

	spread_chance = 1.8

/turf/open/floor/carpet/Initialize()
	. = ..()
	update_appearance(UPDATE_ICON)

/turf/open/floor/carpet/update_icon()
	if(!..())
		return FALSE
	if(smoothing_flags & SMOOTH_BITMASK)
		QUEUE_SMOOTH(src)

/turf/open/floor/carpet/purple
	icon = 'icons/turf/smooth/floors/carpet_purple.dmi'
	icon_state = MAP_SWITCH("carpet", "carpet-0")
	smoothing_flags = SMOOTH_BITMASK

/turf/open/floor/carpet/stellar
	icon = 'icons/turf/smooth/floors/carpet_stellar.dmi'
	icon_state = MAP_SWITCH("carpet", "carpet-0")
	smoothing_flags = SMOOTH_BITMASK

/turf/open/floor/carpet/red
	icon = 'icons/turf/smooth/floors/carpet_red.dmi'
	icon_state = MAP_SWITCH("carpet", "carpet-0")
	smoothing_flags = SMOOTH_BITMASK

/turf/open/floor/carpet/royalblack
	icon = 'icons/turf/smooth/floors/carpet_royalblack.dmi'
	icon_state = MAP_SWITCH("carpet", "carpet-0")
	smoothing_flags = SMOOTH_BITMASK

/turf/open/floor/carpet/break_tile()
	broken = TRUE
	update_appearance(UPDATE_ICON)

/turf/open/floor/carpet/burn_tile()
	burnt = TRUE
	update_appearance(UPDATE_ICON)

/turf/open/floor/carpet/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	return FALSE
