/obj/structure/closet/crate
	name = "crate"
	desc = ""
	icon = 'icons/obj/crates.dmi'
	icon_state = "crate"
	w_class = WEIGHT_CLASS_BULKY
	can_weld_shut = FALSE
	horizontal = TRUE
	allow_dense = FALSE
	dense_when_open = TRUE
	climbable = TRUE
	climb_time = 10 //real fast, because let's be honest stepping into or onto a crate is easy
	climb_stun = 0 //climbing onto crates isn't hard, guys
	open_sound = 'sound/blank.ogg'
	close_sound = 'sound/blank.ogg'
	open_sound_volume = 35
	close_sound_volume = 50
	drag_slowdown = 0

/obj/structure/closet/crate/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(!istype(mover, /obj/structure/closet))
		var/obj/structure/closet/crate/locatedcrate = locate(/obj/structure/closet/crate) in get_turf(mover)
		if(locatedcrate) //you can walk on it like tables, if you're not in an open crate trying to move to a closed crate
			if(opened) //if we're open, allow entering regardless of located crate openness
				return TRUE
			if(!locatedcrate.opened) //otherwise, if the located crate is closed, allow entering
				return TRUE

/obj/structure/closet/crate/attack_hand(mob/user)
	. = ..()
	if(.)
		return

/obj/structure/closet/crate/open(mob/living/user)
	. = ..()

/obj/structure/closet/crate/coffin
	name = "casket"
	desc = "Death basket."
	icon_state = "casket"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	icon = 'icons/roguetown/misc/structure.dmi'
	material_drop_amount = 5
	open_sound = 'sound/blank.ogg'
	close_sound = 'sound/blank.ogg'
	open_sound_volume = 25
	close_sound_volume = 50

/obj/structure/closet/crate/coffin/vampire
	name = "sleep casket"
	desc = "A fancy coffin."
	icon_state = "vcasket"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	icon = 'icons/roguetown/misc/structure.dmi'
	material_drop_amount = 5
	open_sound = 'sound/blank.ogg'
	close_sound = 'sound/blank.ogg'
	open_sound_volume = 25
	close_sound_volume = 50
