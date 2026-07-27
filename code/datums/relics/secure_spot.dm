/obj/structure/secure_spot
	name = "relic holder"
	icon = 'icons/roguetown/items/gadgets.dmi'
	icon_state = "folding_table_deployed"

	var/secure_id = SECURE_SPOT_CHURCH
	var/obj/item/stored_item

/obj/structure/secure_spot/Destroy()
	if(stored_item)
		// Unregister signals from the item before clearing it
		UnregisterSignal(stored_item, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING))
		stored_item = null
	return ..()

/obj/structure/secure_spot/attackby(obj/item/I, mob/user, params)
	if(stored_item)
		to_chat(user, span_warning("\The [src] is already holding something!"))
		return ..()

	if(user.transferItemToLoc(I, src))
		to_chat(user, span_notice("You place \the [I] into \the [src]."))

		stored_item = I

		// 1. Listen to the item's movements/lifecycle to prevent ghost items
		RegisterSignal(stored_item, COMSIG_MOVABLE_MOVED, PROC_REF(handle_item_left))
		RegisterSignal(stored_item, COMSIG_QDELETING, PROC_REF(handle_item_left))

		// 2. Update visuals
		update_appearance()

		// 3. Wake up the trigger
		SEND_SIGNAL(stored_item, COMSIG_SECURE_SPOT_ACTIVATED)
		return TRUE

	return ..()

/**
 * Triggered if the item is forced out (jaunts, teleports, drags) or deleted.
 */
/obj/structure/secure_spot/proc/handle_item_left(obj/item/source)
	SIGNAL_HANDLER

	// Clean up the item signals so we don't leak memory
	UnregisterSignal(source, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING))

	// Tell the relic trigger to go back to sleep
	SEND_SIGNAL(stored_item, COMSIG_SECURE_SPOT_DEACTIVATED)

	stored_item = null
	update_appearance()


/obj/structure/secure_spot/attack_hand(mob/living/user)
	if(!istype(user))
		return ..()
	if(!stored_item)
		return ..()
	empty_spot(user)
	return TRUE

/obj/structure/secure_spot/proc/empty_spot(mob/living/user)
	if(!stored_item)
		return

	var/obj/item/dropping = stored_item

	// If a user is manually pulling it out, try to put it directly into their hands
	if(user)
		// This safely breaks any internal signal tracking on the item before moving it
		UnregisterSignal(dropping, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING))

		// Attempt to give it to the player. If their hands are full, put_in_hands returns FALSE
		if(user.put_in_hands(dropping))
			to_chat(user, span_notice("You remove \the [dropping] from \the [src]."))
		else
			// Hands are full! Force drop it at the user's feet instead
			dropping.forceMove(user.drop_location())
			to_chat(user, span_warning("Your hands are full, so \the [dropping] tumbles onto the floor!"))
	else
		// If called without a user (e.g. blown up, or triggered by a machine), just eject it
		UnregisterSignal(dropping, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING))
		dropping.forceMove(drop_location())

	// Null out, update visuals, and put the relic trigger back to sleep
	SEND_SIGNAL(stored_item, COMSIG_SECURE_SPOT_DEACTIVATED)
	stored_item = null
	update_appearance()

/obj/structure/secure_spot/update_overlays()
	. = ..()
	if(!stored_item)
		return

	// Create a visual copy of the item to overlay onto the spot
	//!TODO When we have a real sprite offset this
	var/mutable_appearance/item_overlay = stored_item.appearance
	. += item_overlay
