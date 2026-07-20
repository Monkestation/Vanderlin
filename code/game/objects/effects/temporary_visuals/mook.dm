/obj/effect/temp_visual/mook_dust
	name = "dust"
	desc = "It's just a dust cloud!"
	icon = 'icons/effects/mook.dmi'
	icon_state = "mook_leap_cloud"
	layer = BELOW_MOB_LAYER
	plane = GAME_PLANE
	pixel_x = -16
	pixel_z = -16
	// base_pixel_z = -16
	base_pixel_x = -16
	duration = 1 SECONDS

/obj/effect/temp_visual/mook_dust/small

/obj/effect/temp_visual/mook_dust/small/Initialize(mapload)
	. = ..()
	transform = transform.Scale(0.5)
