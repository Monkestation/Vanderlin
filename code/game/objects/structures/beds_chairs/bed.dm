/* Beds... get your mind out of the gutter, they're for sleeping!
 * Contains:
 * 		Beds
 *		Roller beds
 */

/*
 * Beds
 */
/obj/structure/bed
	name = "bed"
	desc = "A very nice bed. Perfect for sleeping, or lazying around."
	icon_state = "bed"
	icon = 'icons/roguetown/misc/structure.dmi'
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = 90
	resistance_flags = FLAMMABLE
	max_integrity = 100
	integrity_failure = 0.35
	buckleverb = "lay"
	sleepy = 3
	debris = list(/obj/item/natural/wood/plank = 1)
	metalizer_result = /obj/machinery/anvil/crafted

	var/buildstacktype
	var/buildstackamount = 2
	var/bolts = TRUE

	//For the bed and sheet buff
	var/sheet_tucked = FALSE
	var/sheet_on = FALSE

/obj/structure/bed/Initialize(mapload, ...)
	. = ..()
	var/obj/item/bedsheet/sheet = locate() in loc
	if(sheet)
		sheet_on = TRUE

/obj/structure/bed/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(buildstacktype)
			new buildstacktype(loc,buildstackamount)
	..()

/obj/structure/bed/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/bed/examine(mob/user)
	. = ..()
	desc = initial(desc)
	if(sheet_tucked && sheet_on)
		desc += "\nThe sheet is neatly tucked in and the bed looks ready for a good rest."
	else if(!sheet_tucked && sheet_on)
		desc += "\nSomeone has already slept in this bed, the sheet is all messy."
	else
		desc += "\nThis bed has no sheet, at least it's still a bed."

/obj/structure/bed/attackby(obj/item/W, mob/user, list/modifiers)
	if(W.tool_behaviour == TOOL_WRENCH && !(flags_1 & NODECONSTRUCT_1))
		W.play_tool_sound(src)
		deconstruct(TRUE)
	else
		return ..()

/obj/structure/bed/post_buckle_mob(mob/living/M)
	. = ..()
	M.update_cone_show()

/obj/structure/bed/post_unbuckle_mob(mob/living/M)
	. = ..()
	M.update_cone_show()
