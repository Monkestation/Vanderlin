/obj/effect/waterfall
	name = "waterfall"
	icon = 'icons/effects/waterfall.dmi'
	icon_state = "waterfall_temp"
	plane = GAME_PLANE_UPPER
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	SET_BASE_PIXEL(0, 32)
	var/datum/reagent/water_reagent = /datum/reagent/water

/obj/effect/waterfall/Initialize()
	. = ..()
	var/turf/open = get_turf(src)
	if(isopenspace(open))
		return
	color = initial(water_reagent.color)
	var/obj/effect/abstract/shared_particle_holder/waterfall_mist = add_shared_particles(/particles/mist/waterfall, "waterfall_mist")
	waterfall_mist.layer = 5
	waterfall_mist.alpha = 175

/obj/effect/waterfall/acid
	water_reagent = /datum/reagent/rogueacid
