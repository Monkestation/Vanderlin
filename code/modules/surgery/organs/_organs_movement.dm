// There are two kinds of organ movement: mob movement and limb movement
// If you pull someones brain out, you remove it from the mob and the limb
// If you take someones head off, you remove it from the mob but not the limb
// If you remove the brain from an already decapitated head, you remove it from the limb but not the mob

// Keep the seperation of limb removal and mob removal absolute

/*
 * Insert the organ into the select mob.
 *
 * receiver - the mob who will get our organ
 * special - "quick swapping" an organ out - when TRUE, the mob will be unaffected by not having that organ for the moment
 * movement_flags - Flags for how we behave in movement. See DEFINES/organ_movement for flags
 * new_zone - Organ zone we are placing the organ to
 */
/obj/item/organ/proc/Insert(mob/living/carbon/receiver, special = FALSE, movement_flags = NONE, new_zone = null)
	SHOULD_CALL_PARENT(TRUE)

	if(!mob_insert(receiver, special, movement_flags))
		return FALSE

	if(bodypart_owner && loc == bodypart_owner && receiver == bodypart_owner.owner)
		// ok this is a bit confusing but essentially, thanks to some EXTREME shenanigans
		// (tl;dr mob_insert -> set_species -> replace_limb -> bodypart_insert)
		// mob_insert can result in bodypart_insert being handled already
		// to avoid double insertion, and potential bugs, we'll stop here
		return TRUE

	bodypart_insert(limb_owner = receiver, movement_flags = movement_flags)

	return TRUE

/*
 * Remove the organ from the select mob.
 *
 * * organ_owner - the mob who owns our organ, that we're removing the organ from. Can be null
 * * special - "quick swapping" an organ out - when TRUE, the mob will be unaffected by not having that organ for the moment
 */
/obj/item/organ/proc/Remove(mob/living/carbon/organ_owner, special = FALSE, movement_flags = NONE)
	SHOULD_CALL_PARENT(TRUE)

	mob_remove(organ_owner, special, movement_flags)
	bodypart_remove(null, organ_owner, movement_flags)

/*
 * Insert the organ into the select mob.
 *
 * receiver - the mob who will get our organ
 * special - "quick swapping" an organ out - when TRUE, the mob will be unaffected by not having that organ for the moment
 * movement_flags - Flags for how we behave in movement. See DEFINES/organ_movement for flags
 */
/obj/item/organ/proc/mob_insert(mob/living/carbon/receiver, special, movement_flags, new_zone)
	SHOULD_CALL_PARENT(TRUE)

	if(!iscarbon(receiver))
		stack_trace("Tried to insert organ into non-carbon: [receiver.type]")
		return FALSE

	if(owner == receiver)
		stack_trace("Organ receiver is already organ owner")
		return FALSE

	current_zone = new_zone || zone

	if(unique_slot)
		var/obj/item/organ/replaced = receiver.getorganslot(slot)
		if(replaced)
			replaced.Remove(receiver, special = TRUE)
			if(movement_flags & DELETE_IF_REPLACED)
				qdel(replaced)
			else
				replaced.forceMove(get_turf(receiver))

	receiver.internal_organs |= src

	for(var/slot in organ_efficiency)
		LAZYADD(receiver.internal_organs_slot[slot], src)
		update_organ_efficiency(slot)

	var/checked_zone = check_zone(current_zone)
	LAZYADD(receiver.organs_by_zone[checked_zone], src)
	owner = receiver

	on_mob_insert(receiver, special, movement_flags)

	return TRUE

/// Called after the organ is inserted into a mob.
/// Adds Traits, Actions, and Status Effects on the mob in which the organ is impanted.
/// Override this proc to create unique side-effects for inserting your organ. Must be called by overrides.
/obj/item/organ/proc/on_mob_insert(mob/living/carbon/organ_owner, special = FALSE, movement_flags)
	SHOULD_CALL_PARENT(TRUE)


	for(var/datum/action/action as anything in actions)
		action.Grant(organ_owner)

	RegisterSignal(owner, COMSIG_ATOM_EXAMINE, PROC_REF(on_owner_examine))
	SEND_SIGNAL(src, COMSIG_ORGAN_INSERTED, organ_owner)

	update_accessory_colors()
	update_appearance()

	if(visible_organ && !(organ_owner.status_flags & BUILDING_ORGANS))
		organ_owner.update_body_parts(TRUE)

	organ_owner.update_organ_requirements()

/// Insert an organ into a limb, assume the limb as always detached and include no owner operations here (except the get_bodypart helper here I guess)
/// Give EITHER a limb OR a limb owner
/obj/item/organ/proc/bodypart_insert(obj/item/bodypart/bodypart, mob/living/carbon/limb_owner, movement_flags)
	SHOULD_CALL_PARENT(TRUE)

	if(limb_owner)
		bodypart = limb_owner.get_bodypart(deprecise_zone(zone))

	if(bodypart_owner == bodypart)
		stack_trace("Organ bodypart_insert called when organ is already owned by that bodypart")
	else if(!isnull(bodypart_owner))
		stack_trace("Organ bodypart_insert called when organ is already owned by a different bodypart")

	// In the event that we're already in the bodypart, DO NOT MOVE IT! otherwise it triggers forced_removal
	if(loc != bodypart)
		forceMove(bodypart) // The true movement

	// Don't re-register if we are already owned
	if(bodypart_owner != bodypart)
		bodypart_owner = bodypart
		RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(forced_removal))
		// Apply unique side-effects. Return value does not matter.
		on_bodypart_insert(bodypart, movement_flags)

	return TRUE

/// Add any limb specific effects you might want here
/obj/item/organ/proc/on_bodypart_insert(obj/item/bodypart/limb, movement_flags)
	SHOULD_CALL_PARENT(TRUE)

	item_flags |= ABSTRACT
	ADD_TRAIT(src, TRAIT_NODROP, ORGAN_INSIDE_BODY_TRAIT)

	if(organ_flags & ORGAN_LIMB_SUPPORTER)
		limb.update_limb_efficiency()

	STOP_PROCESSING(SSobj, src)

/*
 * Remove the organ from the select mob.
 *
 * * organ_owner - the mob who owns our organ, that we're removing the organ from. Can be null
 * * special - "quick swapping" an organ out - when TRUE, the mob will be unaffected by not having that organ for the moment
 */
/obj/item/organ/proc/mob_remove(mob/living/carbon/organ_owner, special = FALSE, movement_flags)
	SHOULD_CALL_PARENT(TRUE)

	var/initial_zone = current_zone
	current_zone = zone

	if(organ_owner)
		for(var/slot in organ_efficiency)
			LAZYREMOVE(organ_owner.internal_organs_slot[slot], src)

		var/checked_initial_zone = check_zone(initial_zone)
		LAZYREMOVE(organ_owner.organs_by_zone[checked_initial_zone], src)

		organ_owner.internal_organs -= src

	owner = null

	on_mob_remove(organ_owner, special, movement_flags)

	return TRUE

/// Called after the organ is removed from a mob.
/// Removes Traits, Actions, and Status Effects on the mob in which the organ was impanted.
/// Override this proc to create unique side-effects for removing your organ. Must be called by overrides.
/obj/item/organ/proc/on_mob_remove(mob/living/carbon/organ_owner, special = FALSE, movement_flags)
	SHOULD_CALL_PARENT(TRUE)

	if(!iscarbon(organ_owner))
		stack_trace("Organ removal should not be happening on non carbon mobs: [organ_owner]")

	for(var/datum/action/action as anything in actions)
		action.Remove(organ_owner)

	UnregisterSignal(organ_owner, COMSIG_ATOM_EXAMINE)
	SEND_SIGNAL(src, COMSIG_ORGAN_REMOVED, organ_owner)

	update_accessory_colors()
	update_appearance()

	if(visible_organ)
		organ_owner.update_body_parts(TRUE)

	if((organ_flags & ORGAN_VITAL) && !special && !HAS_TRAIT(organ_owner, TRAIT_GODMODE))
		if(organ_owner.stat != DEAD)
			organ_owner.investigate_log("has been killed by losing a vital organ ([src]).", INVESTIGATE_DEATHS)
		organ_owner.death()

	organ_owner.update_organ_requirements()

	// In cases where it's removed by non-surgical means
	organ_flags |= ORGAN_CUT_AWAY

	START_PROCESSING(SSobj, src)

/// Called to remove an organ from a limb. Do not put any mob operations here (except the bodypart_getter at the start)
/// Give EITHER a limb OR a limb_owner
/obj/item/organ/proc/bodypart_remove(obj/item/bodypart/limb, mob/living/carbon/limb_owner, movement_flags)
	SHOULD_CALL_PARENT(TRUE)

	if(!isnull(limb_owner))
		limb = limb_owner.get_bodypart(deprecise_zone(zone))

	UnregisterSignal(src, COMSIG_MOVABLE_MOVED) //DONT MOVE THIS!!!! we move the organ right after, so we unregister before we move them physically

	// The true movement is here
	moveToNullspace()
	bodypart_owner = null

	if(!isnull(limb))
		on_bodypart_remove(limb)

	return TRUE

/// Called on limb removal to remove limb specific limb effects or statusses
/obj/item/organ/proc/on_bodypart_remove(obj/item/bodypart/limb, movement_flags)
	SHOULD_CALL_PARENT(TRUE)

	item_flags &= ~ABSTRACT
	REMOVE_TRAIT(src, TRAIT_NODROP, ORGAN_INSIDE_BODY_TRAIT)

	if(organ_flags & ORGAN_LIMB_SUPPORTER)
		limb.update_limb_efficiency()

/// In space station videogame, nothing is sacred. If somehow an organ is removed unexpectedly, handle it properly
/obj/item/organ/proc/forced_removal()
	SIGNAL_HANDLER

	if(owner)
		Remove(owner)
	else if(bodypart_owner)
		bodypart_remove(limb_owner = owner)
	else
		stack_trace("Force removed an already removed organ!")
