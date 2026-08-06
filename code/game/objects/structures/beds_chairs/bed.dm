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
	/// Directions in which the bed has its headrest on the left side.
	var/left_headrest_dirs = NORTHEAST
	//For the bed and sheet buff
	var/sheet_tucked = FALSE

/obj/structure/bed/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/soft_landing)
	update_buckle_vars(dir)

/obj/structure/bed/examine(mob/user)
	. = ..()
	if(sheet_tucked)
		. += span_info("A sheet is neatly tucked in, and [src] looks ready for a good rest.")

/obj/structure/bed/buckle_feedback(mob/living/being_buckled, mob/buckler)
	if(HAS_TRAIT(being_buckled, TRAIT_RESTRAINED))
		return ..()

	if(being_buckled == buckler)
		being_buckled.visible_message(
			span_notice("[buckler] lays down on [src]."),
			span_notice("You lay down on [src]."),
			// visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		)
	else
		being_buckled.visible_message(
			span_notice("[buckler] lays [being_buckled] down on [src]."),
			span_notice("[buckler] lays you down on [src]."),
			// visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		)

/obj/structure/bed/unbuckle_feedback(mob/living/being_unbuckled, mob/unbuckler)
	if(HAS_TRAIT(being_unbuckled, TRAIT_RESTRAINED))
		return ..()

	if(being_unbuckled == unbuckler)
		being_unbuckled.visible_message(
			span_notice("[unbuckler] gets up from [src]."),
			span_notice("You get up from [src]."),
			// visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		)
	else
		being_unbuckled.visible_message(
			span_notice("[unbuckler] pulls [being_unbuckled] up from [src]."),
			span_notice("[unbuckler] pulls you up from [src]."),
			// visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		)

/obj/structure/bed/setDir(newdir)
	. = ..()
	update_buckle_vars(newdir)

/obj/structure/bed/proc/update_buckle_vars(newdir)
	buckle_lying = newdir & left_headrest_dirs ? 270 : 90

/obj/structure/bed/atom_deconstruct(disassembled)
	. = ..()
	if(buildstacktype)
		new buildstacktype(loc, buildstackamount)

/obj/structure/bed/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/bed/post_buckle_mob(mob/living/M)
	. = ..()
	M.update_cone_show()

/obj/structure/bed/post_unbuckle_mob(mob/living/M)
	. = ..()
	M.update_cone_show()
