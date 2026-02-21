//Fluff structures serve no purpose and exist only for enriching the environment. They can be destroyed with a wrench.

/obj/structure/well
	name = "well"
	desc = "A well of stone. Has a hook which a bucket can be attached to, to draw water from beneath."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "welly"
	anchored = TRUE
	density = TRUE
	opacity = 0
	climb_time = 40
	climbable = TRUE
	layer = 2.91
	damage_deflection = 30
	var/well_climb = FALSE

/obj/structure/well/climb_down
	desc = "A well of stone. Has a hook which a bucket can be attached to, to draw water from beneath. It seems you can climb down this one"
	well_climb = "DOWN"

/obj/structure/well/climb_up
	name = "bucket rope"
	desc = "A rope at the bottom of a well, you can climb up it if you want."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "rope"
	well_climb = "UP"
	density = FALSE
	layer = 4

/obj/structure/well/fountain
	name = "water fountain"
	desc = "An elegant fountain fit for royalty. Not suitable for drinking from."
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "fountain"
	layer = BELOW_MOB_LAYER
	layer = -0.1

/obj/structure/well/fountain/onbite(mob/living/user)
	. = ..()
	if(.)
		return
	playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
	user.visible_message(span_info("[user] starts to drink from [src]."))
	if(do_after(user, 2.5 SECONDS, src))
		drink_from(user)
	return TRUE

/obj/structure/well/fountain/proc/drink_from(mob/living/user)
	var/datum/reagents/reagents = new()
	reagents.add_reagent(/datum/reagent/water/gross, 2)
	reagents.trans_to(user, reagents.total_volume, transfered_by = user, method = INGEST)
	playsound(user,pick('sound/items/drink_gen (1).ogg','sound/items/drink_gen (2).ogg','sound/items/drink_gen (3).ogg'), 100, TRUE)

/obj/structure/well/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/reagent_containers/glass/bucket))
		var/obj/item/reagent_containers/glass/bucket/W = I
		if(W.reagents.holder_full())
			to_chat(user, "<span class='warning'>[W] is full.</span>")
			return
		if(do_after(user, 6 SECONDS, src))
			var/list/waterl = list(/datum/reagent/water = 100)
			W.reagents.add_reagent_list(waterl)
			to_chat(user, "<span class='notice'>I fill [W] from [src].</span>")
			playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 80, FALSE)
			return
	else ..()

/obj/structure/well/MouseDrop_T(obj/O, mob/user)
	. = ..()
	// this is mostly a copy paste of the ladder code-ish
	if(well_climb == FALSE)
		return
	if(!in_range(src, user))
		return
	playsound(src, 'sound/foley/ladder.ogg', 100, FALSE)
	if(!do_after(user, 3 SECONDS, src))
		return
	user.visible_message("<span class='notice'>[user] climbs down [src].</span>", "<span class='notice'>I climb down [src].</span>")
	src.add_fingerprint(user)
	var/turf/well = get_turf(src)
	var/turf/destination = locate(well.x, well.y, well.z)
	if(well_climb == "DOWN")
		destination = locate(well.x, well.y, well.z - 1)
	else
		destination = locate(well.x, well.y, well.z + 1)
	if(isliving(user))
		movable_travel_z_level(user, destination)
