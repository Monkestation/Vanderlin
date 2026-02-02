/obj/item/broom
	name = "broom"
	desc = "A broom, made from a bundle of twigs."
	icon = 'icons/roguetown/weapons/tools.dmi'
	icon_state = "broom"
	possible_item_intents = list(/datum/intent/use)
	gripped_intents = list(/datum/intent/use, /datum/intent/mace/strike/wood)
	force = 2
	throwforce = 1
	firefuel = 10 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_BACK
	smeltresult = /obj/item/fertilizer/ash

/obj/item/broom/apply_components()
	AddElement(/datum/element/walking_stick)
	AddComponent(/datum/component/two_handed, force_unwielded=2, force_wielded=4, wield_callback = CALLBACK(src, PROC_REF(on_wield)), unwield_callback = CALLBACK(src, PROC_REF(on_unwield)))

/obj/item/broom/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = -1,"nx" = 8,"ny" = 0,"wx" = -4,"wy" = 0,"ex" = 2,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/**
 * Handles registering the sweep proc when the broom is wielded
 *
 * Arguments:
 * * source - The source of the on_wield proc call
 * * user - The user which is wielding the broom
 */
/obj/item/broom/on_wield(obj/item/source, mob/user)
	. = ..()
	to_chat(user, span_notice("You brace the [src] against the ground in a firm sweeping stance."))
	RegisterSignal(user, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(sweep))

/**
 * Handles unregistering the sweep proc when the broom is unwielded
 *
 * Arguments:
 * * source - The source of the on_unwield proc call
 * * user - The user which is unwielding the broom
 */
/obj/item/broom/on_unwield(obj/item/source, mob/user)
	. = ..()
	UnregisterSignal(user, COMSIG_MOVABLE_PRE_MOVE)

/obj/item/broom/afterattack(atom/A, mob/user, proximity, list/modifiers)
	. = ..()
	if(!proximity)
		return
	sweep(user, A, show_message = TRUE)
	return
	// return . | AFTERATTACK_PROCESSED_ITEM

/**
 *
 * Arguments:
 * * user - The user of the pushbroom
 * * A - The atom which is located at the location to push atoms from
 */
/obj/item/broom/proc/sweep(mob/user, atom/A, show_message)
	SIGNAL_HANDLER

	var/turf/current_item_loc = isturf(A) ? A : A.loc
	if (!isturf(current_item_loc))
		return

	var/found_dirt = FALSE
	for(var/obj/effect/decal/cleanable/dirt/C in current_item_loc)
		if(show_message)
			user.visible_message(span_notice("[user] sweeps \the [C] away."), span_notice("I sweep \the [C] away."))
		qdel(C)
		found_dirt = TRUE

	if(found_dirt)
		playsound(user, "clothwipe", 100, TRUE)
		user.nobles_seen_servant_work()

	for(var/obj/effect/decal/cleanable/blood/O in current_item_loc)
		add_blood_DNA(GET_ATOM_BLOOD_DNA(O))
