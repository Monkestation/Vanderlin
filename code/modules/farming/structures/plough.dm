/obj/structure/plough
	name = "plough"
	desc = "A wooden plough with iron blades to till the earth for crops."
	icon = 'icons/roguetown/misc/plough.dmi'
	icon_state = "plough"
	density = TRUE
	max_integrity = 600
	anchored = FALSE
	climbable = FALSE
	facepull = FALSE
	drag_slowdown = 6
	SET_BASE_PIXEL(-12, 0)

/obj/structure/plough/Moved(atom/old_loc, movement_dir, forced, list/old_locs)
	. = ..()
	if((dir == WEST) || (dir == EAST))
		if(pulledby)
			user_tries_tilling(pulledby, get_turf(src))

/obj/structure/plough/proc/user_tries_tilling(mob/living/user, turf/location)
	if(istype(location, /turf/open/floor/grass))
		playsound(location,'sound/items/dig_shovel.ogg', 100, TRUE)
		location.ChangeTurf(/turf/open/floor/dirt, flags = CHANGETURF_INHERIT_AIR)
		if(user.buckled)
			apply_farming_fatigue(user, 5)
		else
			apply_farming_fatigue(user, 10)
		return
	if(istype(location, /turf/open/floor/dirt))
		playsound(location,'sound/items/dig_shovel.ogg', 100, TRUE)
		var/obj/structure/soil/soil = get_soil_on_turf(location)
		if(soil)
			soil.user_till_soil(user)
		else
			var/obj/structure/irrigation_channel/located = locate(/obj/structure/irrigation_channel) in location
			if(located)
				to_chat(user, span_notice("[located] is in the way!"))
				return
			new /obj/structure/soil(location)
			if(user.buckled)
				apply_farming_fatigue(user, 5)
			else
				apply_farming_fatigue(user, 10)

		return
