/*
CONTAINS:
BEDSHEETS
LINEN BINS
*/

/obj/item/bedsheet
	name = "bedsheet"
	desc = ""
	icon = 'icons/obj/bedsheets.dmi'
	lefthand_file = 'icons/mob/inhands/misc/bedsheet_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/bedsheet_righthand.dmi'
	icon_state = "sheetwhite"
	item_state = "sheetwhite"
	layer = MOB_LAYER
	throwforce = 0
	throw_speed = 1
	throw_range = 2
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	dying_key = DYE_REGISTRY_BEDSHEET

	var/list/dream_messages = list("white")
	var/datum/weakref/signal_sleeper //this is our goldylocks
	var/bed_tucked = FALSE

/obj/item/bedsheet/Initialize()
	. = ..()
	AddElement(/datum/element/bed_tuckable, 0, 0, 0)

/obj/item/bedsheet/attack_self(mob/living/user, list/modifiers)
	if(!user.CanReach(src))		//No telekenetic grabbing.
		return
	if(!user.resting)
		return
	if(!user.dropItemToGround(src))
		return
	coverup(user)
	add_fingerprint(user)

/obj/item/bedsheet/proc/coverup(mob/living/sleeper)
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	pixel_x = base_pixel_x
	pixel_y = base_pixel_y
	to_chat(sleeper, "<span class='notice'>I cover myself with [src].</span>")
	var/angle = sleeper.lying_prev
	dir = angle2dir(angle + 180) // 180 flips it to be the same direction as the mob

	signal_sleeper = WEAKREF(sleeper)
	RegisterSignal(src, COMSIG_ITEM_PICKUP, PROC_REF(on_pickup))
	RegisterSignal(sleeper, COMSIG_MOVABLE_MOVED, PROC_REF(smooth_sheets))
	RegisterSignal(sleeper, COMSIG_LIVING_SET_RESTING, PROC_REF(smooth_sheets))
	RegisterSignal(sleeper, COMSIG_PARENT_QDELETING, PROC_REF(smooth_sheets))

/obj/item/bedsheet/proc/smooth_sheets(mob/living/sleeper)
	SIGNAL_HANDLER

	UnregisterSignal(src, COMSIG_ITEM_PICKUP)
	UnregisterSignal(sleeper, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(sleeper, COMSIG_LIVING_SET_RESTING)
	UnregisterSignal(sleeper, COMSIG_PARENT_QDELETING)
	to_chat(sleeper, "<span class='notice'>I smooth [src] out beneath you.</span>")
	layer = initial(layer)
	plane = initial(plane)
	signal_sleeper = null

// We need to do this in case someone picks up a bedsheet while a mob is covered up
// otherwise the bedsheet will disappear while in our hands if the sleeper signals get activated by moving
/obj/item/bedsheet/proc/on_pickup(datum/source, mob/grabber)
	SIGNAL_HANDLER

	var/mob/living/sleeper = signal_sleeper?.resolve()

	UnregisterSignal(src, COMSIG_ITEM_PICKUP)
	UnregisterSignal(sleeper, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(sleeper, COMSIG_LIVING_SET_RESTING)
	UnregisterSignal(sleeper, COMSIG_PARENT_QDELETING)
	signal_sleeper = null

/obj/item/bedsheet/attack_hand(mob/user, params)
	if(!bed_tucked)
		return ..()
	if(do_after(user, 2 SECONDS, src))
		var/obj/structure/bed/bed = locate() in loc
		if(bed)
			to_chat(user, span_notice("You start to remove \the [src] from \the [bed]."))
			bed.sheet_tucked = FALSE
			bed.sheet_on = FALSE
			bed_tucked = FALSE
		return ..()
/obj/item/bedsheet/cloth
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "cloth_bedsheet"
	item_state = "cloth_bedsheet"

/obj/item/bedsheet/pelt
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "pelt_bedsheet"
	item_state = "pelt_bedsheet"

/obj/item/bedsheet/wool
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "wool_bedsheet"
	item_state = "wool_bedsheet"

/obj/item/bedsheet/double_pelt
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "double_pelt_bedsheet"
	item_state = "double_pelt_bedsheet"

/obj/item/bedsheet/fabric
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "fabric_bedsheet"
	item_state = "fabric_bedsheet"

/obj/item/bedsheet/fabric_double
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "double_fabric_bedsheet"
	item_state = "double_fabric_bedsheet"

/obj/item/bedsheet/random
	icon_state = "random_bedsheet"
	name = "random bedsheet"
	desc = ""
