// External storage-related logic:
// /mob/proc/ClickOn() in /_onclick/click.dm - clicking items in storages
// /mob/living/Move() in /modules/mob/living/living.dm - hiding storage boxes on mob movement

/datum/component/storage
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/datum/component/storage/concrete/master		//If not null, all actions act on master and this is just an access point.

	var/list/can_hold								//if this is set, only items, and their children, will fit
	var/list/cant_hold								//if this is set, items, and their children, won't fit
	var/list/exception_hold           //if set, these items will be the exception to the max size of object that can fit.

	var/dump_time = 10

	var/can_hold_description

	/// If true shows the contents of the storage in open_storage
	var/allow_look_inside = TRUE

	var/list/mob/is_using							//lazy list of mobs looking at the contents of this storage.

	var/locked = FALSE								//when locked nothing can see inside or use it.

	var/max_w_class = WEIGHT_CLASS_SMALL			//max size of objects that will fit.
	var/max_combined_w_class = 1000					//max combined sizes of objects that will fit.
	var/max_items = 1000								//max number of objects that will fit.

	var/emp_shielded = FALSE

	var/silent = FALSE								//whether this makes a message when things are put in.
	var/click_gather = FALSE						//whether this can be clicked on items to pick it up rather than the other way around.
	var/rustle_sound = "rustle"							//play rustle sound on interact. empty string or null to silence
	var/allow_quick_empty = FALSE					//allow empty verb which allows dumping on the floor of everything inside quickly.
	var/allow_quick_gather = FALSE					//allow toggle mob verb which toggles collecting all items from a tile.

	var/allow_dump_out = FALSE						//allow dumping out contents via LMB click-dragging

	var/collection_mode = COLLECT_EVERYTHING

	var/insert_verb = "tuck"						//you "tuck" things into a bag
	var/insert_preposition = "in"					//you put things "in" a bag, but "on" a tray.

	var/display_numerical_stacking = FALSE			//stack things of the same type and show as a single object with a number.

	var/atom/movable/screen/storage/boxes					//storage display object
	var/atom/movable/screen/close/closer						//close button object

	var/allow_big_nesting = FALSE					//allow storage objects of the same or greater size.

	var/attack_hand_interact = TRUE					//interact on attack hand.
	/// alt click takes an item out instead of opening up storage
	var/quickdraw = FALSE

	//Screen variables: Do not mess with these vars unless you know what you're doing. They're not defines so storage that isn't in the same location can be supported in the future.
	var/screen_max_columns = INFINITY							//These two determine maximum screen sizes.
	var/screen_max_rows = 9
	var/screen_pixel_x = 16								//These two are pixel values for screen loc of boxes and closer
	var/screen_pixel_y = 16
	var/screen_start_x = 1								//These two are where the storage starts being rendered, screen_loc wise.
	var/screen_start_y = 2
	//End

	/// prevents storage interactions while it is equipped. Think backpacks.
	var/not_while_equipped = FALSE

/datum/component/storage/Initialize(datum/component/storage/concrete/master)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	if(master)
		change_master(master)
	boxes = new(null, null, src)
	closer = new(null, null, src)
	orient2hud()

	RegisterSignal(parent, COMSIG_CONTAINS_STORAGE, PROC_REF(on_check))
	RegisterSignal(parent, COMSIG_IS_STORAGE_LOCKED, PROC_REF(check_locked))
	RegisterSignal(parent, COMSIG_TRY_STORAGE_SHOW, PROC_REF(signal_show_attempt))
	RegisterSignal(parent, COMSIG_TRY_STORAGE_INSERT, PROC_REF(signal_insertion_attempt))
	RegisterSignal(parent, COMSIG_TRY_STORAGE_CAN_INSERT, PROC_REF(signal_can_insert))
	RegisterSignal(parent, COMSIG_TRY_STORAGE_TAKE_TYPE, PROC_REF(signal_take_type))
	RegisterSignal(parent, COMSIG_TRY_STORAGE_FILL_TYPE, PROC_REF(signal_fill_type))
	RegisterSignal(parent, COMSIG_TRY_STORAGE_SET_LOCKSTATE, PROC_REF(set_locked))
	RegisterSignal(parent, COMSIG_TRY_STORAGE_TAKE, PROC_REF(signal_take_obj))
	RegisterSignal(parent, COMSIG_TRY_STORAGE_QUICK_EMPTY, PROC_REF(signal_quick_empty))
	RegisterSignal(parent, COMSIG_TRY_STORAGE_HIDE_FROM, PROC_REF(signal_hide_attempt))
	RegisterSignal(parent, COMSIG_TRY_STORAGE_HIDE_ALL, PROC_REF(close_all))
	RegisterSignal(parent, COMSIG_TRY_STORAGE_RETURN_INVENTORY, PROC_REF(signal_return_inv))

	RegisterSignal(parent, COMSIG_TOPIC, PROC_REF(topic_handle))

	RegisterSignal(parent, COMSIG_ATOM_ATTACKBY, PROC_REF(attackby))
	RegisterSignal(parent, COMSIG_ATOM_ATTACKBY_SECONDARY, PROC_REF(attackby_secondary))

	RegisterSignals(parent, list(COMSIG_ATOM_ATTACK_PAW, COMSIG_ATOM_ATTACK_HAND), PROC_REF(on_attack_hand))
	RegisterSignals(parent, list(COMSIG_CLICK_ALT, COMSIG_ATOM_ATTACK_GHOST, COMSIG_ATOM_ATTACK_HAND_SECONDARY), PROC_REF(open_storage_on_signal))

	RegisterSignal(parent, COMSIG_ATOM_ENTERED, PROC_REF(refresh_mob_views))
	RegisterSignal(parent, COMSIG_ATOM_EXITED, PROC_REF(_remove_and_refresh))
	RegisterSignal(parent, COMSIG_ATOM_CANREACH, PROC_REF(canreach_react))

	RegisterSignal(parent, COMSIG_ITEM_PRE_ATTACK, PROC_REF(preattack_intercept))
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF, PROC_REF(attack_self))
	RegisterSignal(parent, COMSIG_ITEM_PICKUP, PROC_REF(signal_on_pickup))

	RegisterSignal(parent, COMSIG_MOVABLE_POST_THROW, PROC_REF(close_all))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))

	RegisterSignal(parent, COMSIG_MOUSEDROP_ONTO, PROC_REF(mousedrop_onto))
	RegisterSignal(parent, COMSIG_MOUSEDROPPED_ONTO, PROC_REF(mousedrop_receive))

/datum/component/storage/Destroy()
	close_all()
	QDEL_NULL(boxes)
	QDEL_NULL(closer)
	LAZYCLEARLIST(is_using)
	change_master(null)
	item_to_grid_coordinates = null
	grid_coordinates_to_item = null
	first_coordinates_item = null
	return ..()


/datum/component/storage/proc/set_holdable(can_hold_list, cant_hold_list)
	can_hold_description = generate_hold_desc(can_hold_list)

	if (can_hold_list != null)
		can_hold = typecacheof(can_hold_list)

	if (cant_hold_list != null)
		cant_hold = typecacheof(cant_hold_list)

/datum/component/storage/proc/generate_hold_desc(can_hold_list)
	var/list/desc = list()

	for(var/obj/item/valid_item as anything in can_hold_list)
		desc += "\a [initial(valid_item.name)]"

	return "\n\t<span class='notice'>[desc.Join("\n\t")]</span>"

/datum/component/storage/proc/change_master(datum/component/storage/concrete/new_master)
	if(new_master == src || (!isnull(new_master) && !istype(new_master)))
		return FALSE
	if(master)
		master.on_slave_unlink(src)
	master = new_master
	if(master)
		master.on_slave_link(src)
	return TRUE

/datum/component/storage/proc/master()
	if(master == src)
		return			//infinite loops yo.
	return master

/datum/component/storage/proc/real_location()
	var/datum/component/storage/concrete/master = master()
	return master? master.real_location() : null

/datum/component/storage/proc/canreach_react(datum/source, list/next)
	var/datum/component/storage/concrete/master = master()
	if(!master)
		return
	. = COMPONENT_BLOCK_REACH
	next += master.parent
	for(var/datum/component/storage/slave as anything in master.slaves)
		next += slave.parent

/datum/component/storage/proc/on_move()
	var/atom/A = parent
	for(var/mob/living/L in can_see_contents())
		if(!L.CanReach(A))
			hide_from(L)
	for(var/obj/item/reagent_containers/I in A.contents)
		if(I.reagents && I.spillable)
			I.reagents.remove_all(3)

/datum/component/storage/proc/attack_self(datum/source, mob/M)
	if(locked)
		return FALSE
	if((M.get_active_held_item() == parent) && allow_quick_empty)
		quick_empty(M)

/datum/component/storage/proc/preattack_intercept(datum/source, obj/O, mob/M, list/modifiers)
	if(!isitem(O) || !click_gather || SEND_SIGNAL(O, COMSIG_CONTAINS_STORAGE))
		return FALSE
	. = COMPONENT_NO_ATTACK
	if(locked)
		return FALSE
	var/obj/item/I = O
	if(collection_mode == COLLECT_ONE)
		if(can_be_inserted(I, null, M))
			handle_item_insertion(I, null, M)
		return
	if(!isturf(I.loc))
		return
	var/list/things = I.loc.contents.Copy()
	if(collection_mode == COLLECT_SAME)
		things = typecache_filter_list(things, typecacheof(I.type))
	var/len = length(things)
	if(!len)
		to_chat(M, span_warning("I failed to pick up anything with [parent]!"))
		return
//	var/datum/progressbar/progress = new(M, len, I.loc)
//	var/list/rejections = list()
//	while(do_after(M, 0, TRUE, parent, FALSE, CALLBACK(src, PROC_REF(handle_mass_pickup), things, I.loc, rejections, progress)))
//		stoplag(1)
	if(ismob(M))
		var/mob/user = M
		for(var/obj/item/A in things)
			things -= A
//			if(A.loc != source_real_location)
//				continue
//			if(user.active_storage != src_object)
			if(A.on_found(user))
				break
			if(can_be_inserted(A,FALSE,user))
				handle_item_insertion(A, TRUE, user)
//			if (TICK_CHECK)
//				progress.update(progress.goal - things.len)
//				return TRUE
//	progress.end_progress()
//	to_chat(M, span_notice("I put everything I could [insert_preposition] [parent]."))

/datum/component/storage/proc/handle_mass_item_insertion(list/things, datum/component/storage/src_object, mob/user, datum/progressbar/progress)
	var/atom/source_real_location = src_object.real_location()
	for(var/obj/item/I in things)
		things -= I
		if(I.loc != source_real_location)
			continue
		if(user.active_storage != src_object)
			if(I.on_found(user))
				break
		if(can_be_inserted(I,FALSE,user))
			handle_item_insertion(I, TRUE, user)
		if (TICK_CHECK)
			progress.update(progress.goal - things.len)
			return TRUE

	progress.update(progress.goal - things.len)
	return FALSE

/datum/component/storage/proc/handle_mass_pickup(list/things, atom/thing_loc, list/rejections, datum/progressbar/progress)
	var/atom/real_location = real_location()
	for(var/obj/item/I in things)
		things -= I
		if(I.loc != thing_loc)
			continue
		if(I.type in rejections) // To limit bag spamming: any given type only complains once
			continue
		if(!can_be_inserted(I, stop_messages = TRUE))	// Note can_be_inserted still makes noise when the answer is no
			if(real_location.contents.len >= max_items)
				break
			rejections += I.type	// therefore full bags are still a little spammy
			continue

		handle_item_insertion(I, TRUE)	//The TRUE stops the "You put the [parent] into [S]" insertion message from being displayed.
		if (TICK_CHECK)
			progress.update(progress.goal - things.len)
			return TRUE

	progress.update(progress.goal - things.len)
	return FALSE

/datum/component/storage/proc/quick_empty(mob/user) // Evidently this handles emptying sacks in Roguetown...
	var/atom/A = parent
	if(!user.canUseStorage() || !A.Adjacent(user) || user.incapacitated(IGNORE_GRAB)) // Some sanity checks
		return
	if(locked)
//		to_chat(M, span_warning("[parent] seems to be locked!"))
		return FALSE
	A.add_fingerprint(user)
//	to_chat(M, span_notice("I start dumping out [parent]."))
//	var/turf/T = get_turf(A)
	var/list/things = contents()
	if(rustle_sound)
		playsound(A, rustle_sound, 50, FALSE, -5)
//	var/datum/progressbar/progress = new(M, length(things), T)
//	while (do_after(M, dump_time, TRUE, T, FALSE, CALLBACK(src, PROC_REF(mass_remove_from_storage), T, things, progress)))
//		stoplag(1)
//	progress.end_progress()
	var/turf/T = get_step(user, user.dir)
	if(istype(T, /turf/closed)) // Is there an impassible turf in the way? Try to drop on user turf instead
		T = get_turf(user)
		if(istype(T, /turf/closed))
			to_chat(user, span_warning("Something in the way."))
			return
	for(var/obj/structure/S in T) // Is there a structure in the way that isn't a chest, table, rack, or handcart? Can't dump the sack out on that
		if(S.density && !istype(S, /obj/structure/table) && !istype(S, /obj/structure/closet/crate) && !istype(S, /obj/structure/rack) && !istype(S, /obj/structure/bars) && !istype(S, /obj/structure/handcart))
			to_chat(user, span_warning("Something in the way."))
			return
	for(var/obj/item/I in things) // If the above aren't true, dump the sack onto the tile in front of us
		things -= I
//		if(I.loc != real_location)
//			continue
		remove_from_storage(I, T)
		I.pixel_x = I.base_pixel_x + rand(-10,10)
		I.pixel_y = I.base_pixel_y + rand(-10,10)
//		if(trigger_on_found && I.on_found())
//			return FALSE

/datum/component/storage/proc/mass_remove_from_storage(atom/target, list/things, datum/progressbar/progress, trigger_on_found = TRUE)
	var/atom/real_location = real_location()
	for(var/obj/item/I in things)
		things -= I
		if(I.loc != real_location)
			continue
		remove_from_storage(I, target)
		I.pixel_x = I.base_pixel_x + rand(-10,10)
		I.pixel_y = I.base_pixel_y + rand(-10,10)
		if(trigger_on_found && I.on_found())
			return FALSE
		if(TICK_CHECK)
			progress.update(progress.goal - length(things))
			return TRUE
	progress.update(progress.goal - length(things))
	return FALSE

/datum/component/storage/proc/do_quick_empty(atom/_target)
	if(!_target)
		_target = get_turf(parent)
	if(usr)
		hide_from(usr)
	var/list/contents = contents()
	var/atom/real_location = real_location()
	for(var/obj/item/I in contents)
		if(I.loc != real_location)
			continue
		remove_from_storage(I, _target)
	return TRUE

/datum/component/storage/proc/set_locked(datum/source, new_state)
	locked = new_state
	if(locked)
		close_all()

/datum/component/storage/proc/_process_numerical_display()
	. = list()
	var/atom/real_location = real_location()
	for(var/obj/item/I in real_location.contents)
		if(QDELETED(I))
			continue
		if(!.["[I.type]-[I.name]"])
			.["[I.type]-[I.name]"] = new /datum/numbered_display(I, 1)
		else
			var/datum/numbered_display/ND = .["[I.type]-[I.name]"]
			ND.number++

//This proc determines the size of the inventory to be displayed. Please touch it only if you know what you're doing.
/datum/component/storage/proc/orient2hud()
	var/atom/real_location = real_location()
	var/adjusted_contents = real_location.contents.len

	//Numbered contents display
	var/list/datum/numbered_display/numbered_contents
	if(display_numerical_stacking)
		numbered_contents = _process_numerical_display()
		adjusted_contents = numbered_contents.len

	var/rows = CLAMP(max_items, 1, screen_max_rows)
	var/columns = CLAMP(CEILING(adjusted_contents / rows, 1), 1, screen_max_columns)
	standard_orient_objs(rows, columns, numbered_contents)

//This proc draws out the inventory and places the items on it. It uses the standard position.
/datum/component/storage/proc/standard_orient_objs(rows, cols, list/obj/item/numerical_display_contents)
	boxes.screen_loc = "[screen_start_x]:[screen_pixel_x],[screen_start_y]:[screen_pixel_y] to [screen_start_x+cols-1]:[screen_pixel_x],[screen_start_y+rows-1]:[screen_pixel_y]"
	var/cx = screen_start_x
	var/cy = screen_start_y
	if(islist(numerical_display_contents))
		for(var/type in numerical_display_contents)
			var/datum/numbered_display/ND = numerical_display_contents[type]
			ND.sample_object.mouse_opacity = MOUSE_OPACITY_OPAQUE
			ND.sample_object.screen_loc = "[cx]:[screen_pixel_x],[cy]:[screen_pixel_y]"
			ND.sample_object.maptext = MAPTEXT("<font color='white'>[(ND.number > 1)? "[ND.number]" : ""]</font>")
			ND.sample_object.plane = ABOVE_HUD_PLANE
			cx++
			if(cx - screen_start_x >= cols)
				cx = screen_start_x
				cy++
				if(cy - screen_start_y >= rows)
					break
	else
		var/atom/real_location = real_location()
		for(var/obj/O in real_location)
			if(QDELETED(O))
				continue
			O.mouse_opacity = MOUSE_OPACITY_OPAQUE //This is here so storage items that spawn with contents correctly have the "click around item to equip"
			O.screen_loc = "[cx]:[screen_pixel_x],[cy]:[screen_pixel_y]"
			O.maptext = ""
			O.plane = ABOVE_HUD_PLANE
			cx++
			if(cx - screen_start_x >= cols)
				cx = screen_start_x
				cy++
				if(cy - screen_start_y >= rows)
					break
	closer.screen_loc = "[screen_start_x]:[screen_pixel_x],[screen_start_y+rows]:[screen_pixel_y]"

/// Signal handler for when we get attacked with secondary click by an item.
/datum/component/storage/proc/attackby_secondary(datum/source, atom/weapon, mob/user, list/modifiers)
	SIGNAL_HANDLER

	open_storage_on_signal(source, user)
	return COMPONENT_SECONDARY_CANCEL_ATTACK_CHAIN

/// Signal handler to open up the storage when we receive a signal.
/datum/component/storage/proc/open_storage_on_signal(datum/source, mob/to_show)
	SIGNAL_HANDLER

	var/atom/A = parent
	. = COMPONENT_CANCEL_ATTACK_CHAIN
	if(to_show.active_storage == src) //if you're already looking inside the storage item
		to_show.active_storage.close(to_show)
		close(to_show)
		return

	if(ishuman(to_show))
		var/mob/living/carbon/human/H = to_show
		if(not_while_equipped && !H.get_active_held_item())
			if(H.backl == A)
				H.putItemFromInventoryInHandIfPossible(A, H.active_hand_index)
				return
			if(H.backr == A)
				H.putItemFromInventoryInHandIfPossible(A, H.active_hand_index)
				return
			if(H.beltl == A)
				H.putItemFromInventoryInHandIfPossible(A, H.active_hand_index)
				return
			if(H.beltr == A)
				H.putItemFromInventoryInHandIfPossible(A, H.active_hand_index)
				return
			if(H.wear_neck == A)
				H.putItemFromInventoryInHandIfPossible(A, H.active_hand_index)
				return

	INVOKE_ASYNC(src, PROC_REF(open_storage), to_show)
	return

/// Opens the storage to the mob, showing them the contents to their UI.
/datum/component/storage/proc/open_storage(mob/to_show)
	if(!parent)
		return FALSE

	if(isobserver(to_show))
		show_to(to_show)
		return FALSE

	if(!to_show.CanReach(parent))
		return FALSE

	if(!isliving(to_show) || to_show.incapacitated())
		return FALSE

	if(locked)
		if(!silent)
			to_chat(to_show, span_warning("[parent] seems to be locked!"))
		return FALSE

	// If we're quickdrawing boys
	if(quickdraw && !to_show.get_active_held_item())
		if(!to_show.can_perform_action(parent, NEED_DEXTERITY))
			return
		var/obj/item/to_remove = locate() in real_location()
		if(!to_remove)
			return
		to_remove.add_fingerprint(to_show)
		remove_from_storage(to_remove, get_turf(to_show))
		INVOKE_ASYNC(src, PROC_REF(put_in_hands_async), to_show, to_remove)
		if(!silent)
			to_show.visible_message(
				span_warning("[to_show] draws [to_remove] from [parent]!"),
				span_smallnotice("You draw [to_remove] from [parent]."),
			)
		if(rustle_sound)
			playsound(parent, rustle_sound, 50, TRUE, -5)
		return TRUE

	// If nothing else, then we want to open the thing, so do that
	if(!show_to(to_show))
		return FALSE

	if(rustle_sound)
		playsound(parent, rustle_sound, 50, TRUE, -5)

	return TRUE

/**
 * Show our storage to a mob.
 *
 * @param mob/toshow the mob to show the storage to
 *
 * @returns FALSE if the show failed, TRUE otherwise
 */
/datum/component/storage/proc/show_to(mob/M)
	if(!M.client)
		return FALSE

	// You can only inspect hidden contents if you're an observer
	if(!isobserver(M) && !allow_look_inside)
		return FALSE

	var/atom/real_location = real_location()
	if(M.active_storage != src && (M.stat == CONSCIOUS))
		for(var/obj/item/I in real_location)
			if(I.on_found(M))
				return FALSE
	if(M.active_storage)
		M.active_storage.hide_from(M)
	orient2hud()
	M.client.screen |= boxes
	M.client.screen |= closer
	M.client.screen |= real_location.contents
	M.active_storage = src
	LAZYOR(is_using, M)
	return TRUE

/**
 * Hide our storage from a mob.
 *
 * @param mob/M the mob to hide the storage from
 */
/datum/component/storage/proc/hide_from(mob/M)
	if(!M.client)
		return TRUE
	var/atom/real_location = real_location()
	M.client.screen -= boxes
	M.client.screen -= closer
	M.client.screen -= real_location.contents
	if(M.active_storage == src)
		M.active_storage = null
	LAZYREMOVE(is_using, M)
	return TRUE

/datum/component/storage/proc/close(mob/M)
	hide_from(M)
	SEND_SIGNAL(parent, COMSIG_STORAGE_CLOSED, M)

/datum/component/storage/proc/close_all()
	. = FALSE
	for(var/mob/M in can_see_contents())
		close(M)
		. = TRUE //returns TRUE if any mobs actually got a close(M) call

/// Async version of putting something into a mobs hand.
/datum/component/storage/proc/put_in_hands_async(mob/toshow, obj/item/toremove)
	if(!toshow.put_in_hands(toremove))
		if(!silent)
			to_chat(toshow, span_danger("I fumble for [toremove] and it falls on the floor!"))
		return TRUE

//This proc draws out the inventory and places the items on it. tx and ty are the upper left tile and mx, my are the bottm right.
//The numbers are calculated from the bottom-left The bottom-left slot being 1,1.
/datum/component/storage/proc/orient_objs(tx, ty, mx, my)
	var/atom/real_location = real_location()
	var/cx = tx
	var/cy = ty
	boxes.screen_loc = "[tx]:,[ty] to [mx],[my]"
	for(var/obj/O in real_location)
		if(QDELETED(O))
			continue
		O.screen_loc = "[cx],[cy]"
		O.plane = ABOVE_HUD_PLANE
		cx++
		if(cx > mx)
			cx = tx
			cy--
	closer.screen_loc = "[mx+1],[my]"

//Resets something that is being removed from storage.
/datum/component/storage/proc/_removal_reset(atom/movable/thing)
	if(!istype(thing))
		return FALSE
	var/datum/component/storage/concrete/master = master()
	if(!istype(master))
		return FALSE
	return master._removal_reset(thing)

/datum/component/storage/proc/_remove_and_refresh(datum/source, atom/movable/thing)
	_removal_reset(thing)
	refresh_mob_views()

//Call this proc to handle the removal of an item from the storage item. The item will be moved to the new_location target, if that is null it's being deleted
/datum/component/storage/proc/remove_from_storage(atom/movable/AM, atom/new_location)
	if(!istype(AM))
		return FALSE
	var/datum/component/storage/concrete/master = master()
	if(!istype(master))
		return FALSE
	return master.remove_from_storage(AM, new_location)

/datum/component/storage/proc/refresh_mob_views()
	var/list/seeing = can_see_contents()
	for(var/i in seeing)
		show_to(i)
	return TRUE

/datum/component/storage/proc/can_see_contents()
	var/list/cansee = list()
	for(var/mob/M in is_using)
		if(M.active_storage == src && M.client)
			cansee |= M
		else
			LAZYREMOVE(is_using, M)
	return cansee

//Tries to dump content
/datum/component/storage/proc/dump_content_at(atom/dest_object, mob/M)
	var/atom/A = parent
	var/atom/dump_destination = dest_object.get_dumping_location()
	if(A.Adjacent(M) && dump_destination && M.Adjacent(dump_destination))
		if(locked)
//			to_chat(M, span_warning("[parent] seems to be locked!"))
			return FALSE
		if(dump_destination.storage_contents_dump_act(src, M))
			if(rustle_sound)
				playsound(A, rustle_sound, 50, TRUE, -5)
			return TRUE
	update_icon()
	return FALSE

//This proc is called when you want to place an item into the storage item
/datum/component/storage/proc/attackby(datum/source, obj/item/attacking_item, mob/user, modifiers, storage_click = FALSE)
	. = TRUE //no afterattack
	if(!can_be_inserted(attacking_item, FALSE, user, modifiers = modifiers, storage_click = storage_click))
		var/atom/real_location = real_location()
		if(LAZYLEN(real_location.contents) >= max_items) //don't use items on the backpack if they don't fit
			return TRUE
		return FALSE
	return handle_item_insertion(attacking_item, FALSE, user, modifiers = modifiers, storage_click = storage_click)

/datum/component/storage/proc/return_inv(recursive)
	var/list/ret = list()
	ret |= contents()
	if(recursive)
		for(var/atom/A as anything in ret.Copy())
			SEND_SIGNAL(A, COMSIG_TRY_STORAGE_RETURN_INVENTORY, ret, TRUE)
	return ret

/datum/component/storage/proc/contents()			//ONLY USE IF YOU NEED TO COPY CONTENTS OF REAL LOCATION, COPYING IS NOT AS FAST AS DIRECT ACCESS!
	var/atom/real_location = real_location()
	return real_location.contents.Copy()

//Abuses the fact that lists are just references, or something like that.
/datum/component/storage/proc/signal_return_inv(datum/source, list/interface, recursive = TRUE)
	if(!islist(interface))
		return FALSE
	interface |= return_inv(recursive)
	return TRUE

/datum/component/storage/proc/topic_handle(datum/source, user, href_list)
	if(href_list["show_valid_pocket_items"])
		handle_show_valid_items(source, user)

/datum/component/storage/proc/handle_show_valid_items(datum/source, user)
	to_chat(user, span_notice("[source] can hold: [can_hold_description]"))

/datum/component/storage/proc/mousedrop_onto(datum/source, atom/over_object, mob/M)
	set waitfor = FALSE
	. = COMPONENT_NO_MOUSEDROP
	if(!ismob(M))
		return
	if(!over_object)
		return
	if(M.incapacitated(IGNORE_GRAB) || !M.canUseStorage())
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/atom/A = parent
		if(not_while_equipped)
			if(H.backl == A)
				if(!H.get_active_held_item())
					H.putItemFromInventoryInHandIfPossible(A, H.active_hand_index)
				return
			if(H.backr == A)
				if(!H.get_active_held_item())
					H.putItemFromInventoryInHandIfPossible(A, H.active_hand_index)
				return
			if(H.beltl == A)
				if(!H.get_active_held_item())
					H.putItemFromInventoryInHandIfPossible(A, H.active_hand_index)
				return
			if(H.beltr == A)
				if(!H.get_active_held_item())
					H.putItemFromInventoryInHandIfPossible(A, H.active_hand_index)
				return
			if(H.wear_neck == A)
				if(!H.get_active_held_item())
					H.putItemFromInventoryInHandIfPossible(A, H.active_hand_index)
				return

	var/atom/A = parent
	A.add_fingerprint(M)
	// this must come before the screen objects only block, dunno why it wasn't before
	if(over_object == M)
		user_show_to_mob(M)
	if(!istype(over_object, /atom/movable/screen))
		if(allow_dump_out)
			dump_content_at(over_object, M)
			return
	if(A.loc != M)
		return
//	playsound(A, "rustle", 50, TRUE, -5)
	if(istype(over_object, /atom/movable/screen/inventory/hand))
		var/atom/movable/screen/inventory/hand/H = over_object
		M.putItemFromInventoryInHandIfPossible(A, H.held_index)
		return

/datum/component/storage/proc/user_show_to_mob(mob/M, force = FALSE)
	var/atom/A = parent
	if(!istype(M))
		return FALSE
	A.add_fingerprint(M)
	if((locked || !allow_look_inside) && !force)
//		to_chat(M, span_warning("[parent] seems to be locked!"))
		return FALSE
	if(force || M.CanReach(parent, view_only = TRUE))
		show_to(M)

/datum/component/storage/proc/mousedrop_receive(datum/source, atom/movable/O, mob/M)
	if(isitem(O))
		var/obj/item/I = O
		if(iscarbon(M))
			var/mob/living/L = M
			if(!L.incapacitated(IGNORE_GRAB) && I == L.get_active_held_item())
				if(!SEND_SIGNAL(I, COMSIG_CONTAINS_STORAGE) && can_be_inserted(I, FALSE))	//If it has storage it should be trying to dump, not insert.
					handle_item_insertion(I, FALSE, L)

/obj/item/proc/StorageBlock(obj/item/I, mob/user)
	return FALSE

//This proc return 1 if the item can be picked up and 0 if it can't.
//Set the stop_messages to stop it from printing messages
/datum/component/storage/proc/can_be_inserted(obj/item/I, stop_messages = FALSE, mob/M)
	if(!istype(I) || (I.item_flags & ABSTRACT))
		return FALSE //Not an item
	if(I == parent)
		return FALSE	//no paradoxes for you
	var/atom/real_location = real_location()
	var/atom/host = parent
	stop_messages = TRUE
	if(real_location == I.loc)
		return FALSE //Means the item is already in the storage item
	if(!ismob(host.loc) && !isturf(host.loc))
		return FALSE
	if(locked)
		if(M && !stop_messages)
			host.add_fingerprint(M)
//			to_chat(M, span_warning("[host] seems to be locked!"))
		return FALSE
	if(real_location.contents.len >= max_items)
		if(!stop_messages)
			to_chat(M, span_warning("[host] is full, make some space!"))
		return FALSE //Storage item is full
	if(length(can_hold))
		if(!is_type_in_typecache(I, can_hold))
			if(!stop_messages)
				to_chat(M, span_warning("[host] cannot hold [I]!"))
			return FALSE
	if(is_type_in_typecache(I, cant_hold)) //Check for specific items which this container can't hold.
		if(!stop_messages)
			to_chat(M, span_warning("[host] cannot hold [I]!"))
		return FALSE
	if(I.w_class > max_w_class && !is_type_in_typecache(I, exception_hold))
		if(!stop_messages)
			to_chat(M, span_warning("[I] is too big for [host]!"))
		return FALSE
	var/datum/component/storage/biggerfish = real_location.loc.GetComponent(/datum/component/storage)
	if(biggerfish && biggerfish.max_w_class < max_w_class)//return false if we are inside of another container, and that container has a smaller max_w_class than us (like if we're a bag in a box)
		if(!stop_messages)
			to_chat(M, span_warning("[I] can't fit in [host] while [real_location.loc] is in the way!"))
		return FALSE
	var/sum_w_class = I.w_class
	for(var/obj/item/_I in real_location)
		sum_w_class += _I.w_class //Adds up the combined w_classes which will be in the storage item if the item is added to it.
	if(sum_w_class > max_combined_w_class)
		if(!stop_messages)
			to_chat(M, span_warning("[I] won't fit in [host], make some space!"))
		return FALSE
	if(isitem(host))
		var/obj/item/IP = host
		var/datum/component/storage/STR_I = I.GetComponent(/datum/component/storage)
		if((I.w_class >= IP.w_class) && STR_I && !allow_big_nesting)
			if(!stop_messages)
				to_chat(M, span_warning("[IP] cannot hold [I] as it's a storage item of the same size!"))
			return FALSE //To prevent the stacking of same sized storage items.
		if(IP.StorageBlock(I, M))
			return FALSE
	if(HAS_TRAIT(I, TRAIT_NODROP)) //SHOULD be handled in unEquip, but better safe than sorry.
		if(!stop_messages)
			to_chat(M, span_warning("\the [I] is stuck to your hand, you can't put it in \the [host]!"))
		return FALSE
	var/datum/component/storage/concrete/master = master()
	if(!istype(master))
		return FALSE
	return master.slave_can_insert_object(src, I, stop_messages, M)

/datum/component/storage/proc/_insert_physical_item(obj/item/I, override = FALSE)
	return FALSE

//This proc handles items being inserted. It does not perform any checks of whether an item can or can't be inserted. That's done by can_be_inserted()
//The prevent_warning parameter will stop the insertion message from being displayed. It is intended for cases where you are inserting multiple items at once,
//such as when picking up all the items on a tile with one click.
/datum/component/storage/proc/handle_item_insertion(obj/item/I, prevent_warning = FALSE, mob/M, datum/component/storage/remote)
	var/atom/parent = src.parent
	var/datum/component/storage/concrete/master = master()
	if(!istype(master))
		return FALSE
	if(silent)
		prevent_warning = TRUE
	if(M)
		parent.add_fingerprint(M)
	. = master.handle_item_insertion_from_slave(src, I, prevent_warning, M)

/datum/component/storage/proc/mob_item_insertion_feedback(mob/user, mob/M, obj/item/I, override = FALSE)
	if(!length(is_using))
		SEND_SIGNAL(parent, COMSIG_STORAGE_CLOSED, M)
	if(silent && !override)
		return
	if(rustle_sound)
		playsound(parent, rustle_sound, 50, TRUE, -5)
	for(var/mob/viewing in viewers(user, null))
		if(M == viewing)
			to_chat(usr, span_smallnotice("I [insert_verb] [I] [insert_preposition]to [parent]."))
		else if(in_range(M, viewing)) //If someone is standing close enough, they can tell what it is...
			viewing.show_message(span_smallnotice("[M] [insert_verb]s [I] [insert_preposition]to [parent]."), MSG_VISUAL)
		else
			viewing.show_message(span_smallnotice("[M] [insert_verb]s something [insert_preposition]to [parent]."), MSG_VISUAL)

/datum/component/storage/proc/update_icon()
	if(isobj(parent))
		var/obj/O = parent
		O.update_appearance()

/datum/component/storage/proc/signal_insertion_attempt(datum/source, obj/item/I, mob/M, silent = FALSE, force = FALSE)
	if((!force && !can_be_inserted(I, TRUE, M)) || (I == parent))
		return FALSE
	return handle_item_insertion(I, silent, M)

/datum/component/storage/proc/signal_can_insert(datum/source, obj/item/I, mob/M, silent = FALSE)
	return can_be_inserted(I, silent, M)

/datum/component/storage/proc/signal_show_attempt(datum/source, mob/showto, force = FALSE)
	return user_show_to_mob(showto, force)

/datum/component/storage/proc/on_check()
	return TRUE

/datum/component/storage/proc/check_locked()
	return locked

/datum/component/storage/proc/signal_take_type(datum/source, type, atom/destination, amount = INFINITY, check_adjacent = FALSE, force = FALSE, mob/user, list/inserted)
	if(!force)
		if(check_adjacent)
			if(!user || !user.CanReach(destination) || !user.CanReach(parent))
				return FALSE
	var/list/taking = typecache_filter_list(contents(), typecacheof(type))
	if(taking.len > amount)
		taking.len = amount
	if(inserted)			//duplicated code for performance, don't bother checking retval/checking for list every item.
		for(var/i in taking)
			if(remove_from_storage(i, destination))
				inserted |= i
	else
		for(var/i in taking)
			remove_from_storage(i, destination)
	return TRUE

/datum/component/storage/proc/remaining_space_items()
	var/atom/real_location = real_location()
	return max(0, max_items - real_location.contents.len)

/datum/component/storage/proc/signal_fill_type(datum/source, type, amount = 20, force = FALSE)
	var/atom/real_location = real_location()
	if(!force)
		amount = min(remaining_space_items(), amount)
	for(var/i in 1 to amount)
		if(!handle_item_insertion(new type(real_location), TRUE))
			return i > 1 //return TRUE only if at least one insertion has been successful.
		if(CHECK_TICK)
			if(QDELETED(src))
				return TRUE
	return TRUE

/datum/component/storage/proc/on_attack_hand(datum/source, mob/user)
	var/atom/A = parent
	if(!attack_hand_interact)
		return
	if(user.active_storage == src && A.loc == user) //if you're already looking inside the storage item
		user.active_storage.close(user)
		close(user)
		return COMPONENT_CANCEL_ATTACK_CHAIN

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(not_while_equipped && !H.get_active_held_item())
			if(H.backl == A)
				H.putItemFromInventoryInHandIfPossible(A, H.active_hand_index)
				return
			if(H.backr == A)
				H.putItemFromInventoryInHandIfPossible(A, H.active_hand_index)
				return
			if(H.beltl == A)
				H.putItemFromInventoryInHandIfPossible(A, H.active_hand_index)
				return
			if(H.beltr == A)
				H.putItemFromInventoryInHandIfPossible(A, H.active_hand_index)
				return
			if(H.wear_neck == A)
				H.putItemFromInventoryInHandIfPossible(A, H.active_hand_index)
				return

	if(A.loc == user)
		open_storage(user)
		return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/component/storage/proc/signal_on_pickup(datum/source, mob/user)
	var/atom/A = parent
	for(var/mob/M in range(1, A))
		if(M.active_storage == src)
			close(M)

/datum/component/storage/proc/signal_take_obj(datum/source, atom/movable/AM, new_loc, force = FALSE)
	if(!(AM in real_location()))
		return FALSE
	return remove_from_storage(AM, new_loc)

/datum/component/storage/proc/signal_quick_empty(datum/source, atom/loctarget)
	return do_quick_empty(loctarget)

/datum/component/storage/proc/signal_hide_attempt(datum/source, mob/target)
	return hide_from(target)

/datum/component/storage/proc/action_trigger(datum/signal_source, datum/action/source)
	gather_mode_switch(source.owner)
	return COMPONENT_ACTION_BLOCK_TRIGGER

/datum/component/storage/proc/gather_mode_switch(mob/user)
	collection_mode = (collection_mode+1)%3
	switch(collection_mode)
		if(COLLECT_SAME)
			to_chat(user, span_notice("[parent] now picks up all items of a single type at once."))
		if(COLLECT_EVERYTHING)
			to_chat(user, span_notice("[parent] now picks up all items in a tile at once."))
		if(COLLECT_ONE)
			to_chat(user, span_notice("[parent] now picks up one item at a time."))
