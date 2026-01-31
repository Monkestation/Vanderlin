/// Cached underlay list for storage grid sizes
GLOBAL_LIST_EMPTY(storage_underlay_cache)

/**
 * Datumized Storage
 * Eliminates the need for custom signals specifically for the storage component, and attaches a storage variable (atom_storage) to every atom.
 * If you're looking to create custom storage type behaviors, check ../subtypes
 */
/datum/storage
	/**
	 * A reference to the atom linked to this storage object
	 * If the parent goes, we go. Will never be null.
	 */
	VAR_FINAL/atom/parent
	/**
	 * A reference to the atom where the items are actually stored.
	 * By default this is parent. Should generally never be null.
	 * Sometimes it's not the parent, that's what is called "dissassociated storage".
	 *
	 * Do NOT set this directly, use set_real_location.
	 */
	VAR_FINAL/atom/real_location

	/// List of all the mobs currently viewing the contents of this storage.
	VAR_PRIVATE/list/mob/is_using

	/// List of our stored items and coordinates to said items
	VAR_PRIVATE/list/obj/item/item_coordinates

	/// storage display object
	VAR_PRIVATE/atom/movable/screen/storage/boxes
	/// close button object
	VAR_PRIVATE/atom/movable/screen/close/closer

	/// Typecache of items that can be inserted into this storage.
	/// By default, all item types can be inserted (assuming other conditions are met).
	/// Do not set directly, use set_holdable
	VAR_FINAL/list/obj/item/can_hold
	/// Typecache of items that cannot be inserted into this storage.
	/// By default, no item types are barred from insertion.
	/// Do not set directly, use set_holdable
	VAR_FINAL/list/obj/item/cant_hold
	/// Typecache of items that can always be inserted into this storage, regardless of size.
	/// Do not set directly, use set_holdable
	VAR_FINAL/list/obj/item/exception_hold
	/// For use with an exception typecache:
	/// The maximum amount of items of the exception type that can be inserted into this storage.
	var/exception_max = INFINITY

	/// Reference to action to change pick-up modes, only applicable to objs
	VAR_PRIVATE/datum/action/item_action/storage_gather_mode/modeswitch_action

	// null is used as these are legacy and aren't applicable to grids
	/// max items overall
	var/max_slots = null
	/// max combined weight classes the storage can hold
	var/max_total_storage = null

	/// max weight class for a single item being inserted
	var/max_specific_storage = WEIGHT_CLASS_NORMAL

	/// Locked storage can't be closed without being unlocked
	var/locked = FALSE
	/// whether or not we should open when clicked
	var/attack_hand_interact = TRUE
	/// whether or not we allow storage objects of the same size inside
	var/allow_big_nesting = FALSE
	/// Access flags for when we are equipped see [_DEFINES/storage.dm]
	/// As implied by "equipped" only applicable to /obj/item parents
	var/equipped_access_flags = NONE
	/// Flags for when we auto close see [_DEFINES/storage.dm]
	var/closure_flags = STORAGE_CLOSE_MOVEMENT

	/// If TRUE, we can click on items with the storage object to pick them up and insert them.
	var/allow_quick_gather = FALSE
	/// The mode for collection when allow_quick_gather is enabled. See [code/__DEFINES/storage.dm]
	var/collection_mode = COLLECT_EVERYTHING

	/// If TRUE, we can use-in-hand the storage object to dump all of its contents.
	var/allow_quick_empty = FALSE

	///do we insert items when clicked by them?
	var/insert_on_attack = TRUE

	/// shows what we can hold in examine text
	var/can_hold_description

	/// you put things *in* a bag, but *on* a plate
	var/insert_preposition = "in"

	/// Determines whether we play a rustle animation when inserting/removing items.
	var/animated = TRUE
	/// Determines whether we play a rustle sound when inserting/removing items.
	var/do_rustle = TRUE
	var/rustle_vary = TRUE
	/// Path for the item's rustle sound.
	var/rustle_sound = SFX_RUSTLE
	/// Path for the item's rustle sound when removing items.
	var/remove_rustle_sound = null
	/// The sound to play when we open/access the storage
	var/open_sound
	var/open_sound_vary = TRUE

	/// If TRUE, chat messages for inserting/removing items will not be shown.
	var/silent = FALSE
	/// Same as above but only for the user.
	/// Useful to cut on chat spam without removing feedback for other players.
	var/silent_for_user = FALSE

	/// alt click takes an item out instead of opening up storage
	var/quickdraw = FALSE

	/// instead of displaying multiple items of the same type, display them as numbered contents
	var/numerical_stacking = FALSE

	/// maximum amount of columns a storage object can have
	var/screen_max_columns = 3
	var/screen_max_rows = 8
	/// pixel location of the boxes and close button
	var/screen_pixel_x = 5
	var/screen_pixel_y = 0
	/// where storage starts being rendered, screen_loc wise
	var/screen_start_x = 1
	var/screen_start_y = 10

	/// No interface will be displayed, items can only be added and removed randomly or not at all
	var/no_interface = FALSE

	/// If TRUE, shows the contents of the storage in open_storage, observers bypass
	/// Don't set by default, change conditionally for grid storage
	var/display_contents = TRUE

/datum/storage/New(
	atom/parent,
	screen_max_rows = src.screen_max_rows,
	screen_max_columns = src.screen_max_columns,
	max_slots = src.max_slots,
	max_specific_storage = src.max_specific_storage,
	max_total_storage = src.max_total_storage,
)

	boxes = new(null, src)
	closer = new(null, src)

	if(!istype(parent))
		stack_trace("Storage datum ([type]) created without a [isnull(parent) ? "null parent" : "invalid parent ([parent.type])"]!")
		qdel(src)
		return

	set_parent(parent)
	set_real_location(parent)

	src.screen_max_rows = screen_max_rows
	src.screen_max_columns = screen_max_columns
	src.max_slots = max_slots
	src.max_specific_storage = max_specific_storage
	src.max_total_storage = max_total_storage

/datum/storage/Destroy(force)
	for(var/mob/person as anything in is_using)
		hide_contents(person)

	LAZYCLEARLIST(is_using)

	QDEL_NULL(boxes)
	QDEL_NULL(closer)

	parent = null
	real_location = null

	return ..()

/// Set the passed atom as the parent
/datum/storage/proc/set_parent(atom/new_parent)
	PROTECTED_PROC(TRUE)

	ASSERT(isnull(parent))

	parent = new_parent

	// a few of theses should probably be on the real_location rather than the parent
	RegisterSignal(parent, list(COMSIG_ATOM_ATTACK_PAW, COMSIG_ATOM_ATTACK_HAND), PROC_REF(on_attack))
	RegisterSignal(parent, COMSIG_MOUSEDROP_ONTO, PROC_REF(on_mousedrop_onto))
	RegisterSignal(parent, COMSIG_MOUSEDROPPED_ONTO, PROC_REF(on_mousedropped_onto))
	RegisterSignal(parent, COMSIG_ITEM_PRE_ATTACK, PROC_REF(on_preattack))
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF, PROC_REF(mass_empty))
	RegisterSignal(parent, list(COMSIG_ATOM_ATTACK_GHOST, COMSIG_ATOM_ATTACK_HAND_SECONDARY), PROC_REF(open_storage_on_signal))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(close_distance))
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(update_actions))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(handle_examination))
	RegisterSignal(parent, COMSIG_OBJ_DECONSTRUCT, PROC_REF(on_deconstruct))
	RegisterSignal(parent, COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON, PROC_REF(item_init))

/**
 * Sets where items are physically being stored in the case it shouldn't be on the parent.
 *
 * Does not handle moving any existing items, that must be done manually.
 *
 * Arguments
 * * atom/new_real_location - the new real location of the datum
 * * should_drop - if TRUE, all the items in the old real location will be dropped.
 */
/datum/storage/proc/set_real_location(atom/new_real_location, should_drop = FALSE)
	if(!isnull(real_location))
		UnregisterSignal(real_location, list(
			COMSIG_ATOM_ENTERED,
			COMSIG_ATOM_EXITED,
			COMSIG_PARENT_QDELETING,
		))
		real_location.flags_1 &= ~HAS_DISASSOCIATED_STORAGE_1
		if(should_drop)
			remove_all()

	if(isnull(new_real_location))
		return

	real_location = new_real_location
	if(real_location != parent)
		real_location.flags_1 |= HAS_DISASSOCIATED_STORAGE_1

	RegisterSignal(real_location, COMSIG_ATOM_ENTERED, PROC_REF(handle_enter))
	RegisterSignal(real_location, COMSIG_ATOM_EXITED, PROC_REF(handle_exit))
	RegisterSignal(real_location, COMSIG_PARENT_QDELETING, PROC_REF(real_location_deleted))

/// Signal handler for when the real location is deleted.
/datum/storage/proc/real_location_deleted(datum/deleting_real_location)
	SIGNAL_HANDLER

	set_real_location(null)

/datum/storage/proc/on_deconstruct()
	SIGNAL_HANDLER

	remove_all()

/// Ran on items instantiated inside the storage, basically a chopped down version of handle_enter
/datum/storage/proc/item_init(datum/source, obj/item/inited)
	SIGNAL_HANDLER

	if(!istype(inited))
		return

	// Grid storage can't expand more, so if there isn't space we need to handle it here
	if(!no_interface)
		var/coordinates = get_valid_coordinates(inited)
		if(!add_item_to_grid(inited, coordinates))
			var/atom/loc = real_location.drop_location()
			if(!loc)
				qdel(inited)
			else
				inited.forceMove(real_location.drop_location())
			return

	inited.item_flags |= IN_STORAGE
	RegisterSignal(inited, COMSIG_MOUSEDROPPED_ONTO, PROC_REF(mousedrop_receive))

/// Automatically ran on all object insertions: flag marking and view refreshing.
/datum/storage/proc/handle_enter(datum/source, obj/item/arrived)
	SIGNAL_HANDLER

	if(!istype(arrived))
		return

	arrived.item_flags |= IN_STORAGE

	refresh_views()
	arrived.on_enter_storage(src)
	RegisterSignal(arrived, COMSIG_MOUSEDROPPED_ONTO, PROC_REF(mousedrop_receive))
	SEND_SIGNAL(arrived, COMSIG_ITEM_STORED, src)
	parent.update_appearance()

/// Automatically ran on all object removals: flag marking and view refreshing.
/datum/storage/proc/handle_exit(datum/source, obj/item/gone)
	SIGNAL_HANDLER

	if(!istype(gone))
		return

	gone.item_flags &= ~IN_STORAGE

	remove_and_refresh(gone)
	gone.on_exit_storage(src)
	UnregisterSignal(gone, COMSIG_MOUSEDROPPED_ONTO)
	SEND_SIGNAL(gone, COMSIG_ITEM_UNSTORED, src)
	parent.update_appearance()

/datum/storage/proc/handle_examination(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	if(isnull(can_hold_description))
		return

	examine_list += span_notice("[source] can hold: [can_hold_description]")

/// Almost 100% of the time the lists passed into set_holdable are reused for each instance of the component
/// Just fucking cache it 4head
/// Yes I could generalize this, but I don't want anyone else using it. in fact, DO NOT COPY THIS
/// If you find yourself needing this pattern, you're likely better off using static typecaches
/// I'm not because I do not trust implementers of the storage datum to use them, BUT
/// IF I FIND YOU USING THIS PATTERN IN YOUR CODE I WILL BREAK YOU ACROSS MY KNEES
/// ~Lemon
GLOBAL_LIST_EMPTY(cached_storage_typecaches)

/datum/storage/proc/set_holdable(list/can_hold_list = null, list/cant_hold_list = null)
	if(!isnull(can_hold_list) && !islist(can_hold_list))
		can_hold_list = list(can_hold_list)
	if(!isnull(cant_hold_list) && !islist(cant_hold_list))
		cant_hold_list = list(cant_hold_list)

	if(!isnull(can_hold_list))
		if(isnull(can_hold_description))
			can_hold_description = generate_hold_desc(can_hold_list)

	if(can_hold_list)
		var/unique_key = can_hold_list.Join("-")
		if(!GLOB.cached_storage_typecaches[unique_key])
			GLOB.cached_storage_typecaches[unique_key] = typecacheof(can_hold_list)
		can_hold = GLOB.cached_storage_typecaches[unique_key]

	if(!isnull(cant_hold_list))
		var/unique_key = cant_hold_list.Join("-")
		if(!GLOB.cached_storage_typecaches[unique_key])
			GLOB.cached_storage_typecaches[unique_key] = typecacheof(cant_hold_list)
		cant_hold = GLOB.cached_storage_typecaches[unique_key]

/// Generates a description, primarily for clothing storage.
/datum/storage/proc/generate_hold_desc(can_hold_list)
	var/list/desc = list()

	for(var/obj/item/valid_item as anything in can_hold_list)
		desc += "\a [initial(valid_item.name)]"

	return "\n\t[span_notice("[desc.Join("\n\t")]")]"

/// Updates the action button for toggling collectmode.
/datum/storage/proc/update_actions(atom/source, mob/equipper, slot)
	SIGNAL_HANDLER

	if(!allow_quick_gather)
		QDEL_NULL(modeswitch_action)
		return
	if(!isnull(modeswitch_action))
		return
	if(!isitem(parent))
		return

	var/obj/item/item_parent = parent
	modeswitch_action = item_parent.add_item_action(/datum/action/item_action/storage_gather_mode)
	RegisterSignal(modeswitch_action, COMSIG_ACTION_TRIGGER, PROC_REF(action_trigger))
	RegisterSignal(modeswitch_action, COMSIG_PARENT_QDELETING, PROC_REF(action_deleted))

/datum/storage/proc/action_trigger(datum/source, datum/action/triggered)
	SIGNAL_HANDLER

	toggle_collection_mode(triggered.owner)

	return COMPONENT_ACTION_BLOCK_TRIGGER

/datum/storage/proc/action_deleted(datum/source)
	SIGNAL_HANDLER

	modeswitch_action = null

/// Refreshes and item to be put back into the real world, out of storage.
/datum/storage/proc/reset_item(obj/item/thing)
	thing.layer = initial(thing.layer)
	thing.plane = initial(thing.plane)
	thing.mouse_opacity = initial(thing.mouse_opacity)
	thing.screen_loc = null
	thing.underlays = null

	if(thing.maptext)
		thing.maptext = ""

/**
 * Checks if an item is capable of being inserted into the storage.
 *
 * Arguments
 * * obj/item/to_insert - the item we're checking
 * * messages - if TRUE, will print out a message if the item is not valid
 * * force - bypass locked storage up to a certain level. See [code/__DEFINES/storage.dm]
 * * params - solely to check for grid storage restrictions
 */
/datum/storage/proc/can_insert(obj/item/to_insert, mob/user, messages = TRUE, force = STORAGE_NOT_LOCKED, params)
	if(QDELETED(to_insert) || !istype(to_insert))
		return FALSE

	if(!isitem(to_insert))
		return FALSE

	if(to_insert.item_flags & ABSTRACT)
		return FALSE

	if((to_insert == parent) || (to_insert == real_location))
		return FALSE

	if(locked > force)
		if(messages && user)
			user.balloon_alert(user, "closed!")
		return FALSE

	if(HAS_TRAIT(to_insert, TRAIT_NODROP))
		if(messages && user)
			user.balloon_alert(user, "stuck on your hand!")
		return FALSE

	if(!no_interface && grid_full())
		if(messages && user && !silent_for_user)
			user.balloon_alert(user, "no space!")
		return FALSE

	if(max_slots && length(real_location.contents) >= max_slots)
		if(messages && user && !silent_for_user)
			user.balloon_alert(user, "no space!")
		return FALSE

	if(max_total_storage && (to_insert.w_class + get_total_weight() > max_total_storage))
		if(messages && user && !silent_for_user)
			user.balloon_alert(user, "too heavy!")
		return FALSE

	var/can_hold_it = isnull(can_hold) || is_type_in_typecache(to_insert, can_hold) || is_type_in_typecache(to_insert, exception_hold)
	var/cant_hold_it = is_type_in_typecache(to_insert, cant_hold)
	var/trait_says_no = HAS_TRAIT(to_insert, TRAIT_NO_STORAGE_INSERT)
	if(!can_hold_it || cant_hold_it || trait_says_no)
		if(messages && user)
			user.balloon_alert(user, "can't hold!")
		return FALSE

	// this is valid if the container our location is being held in is a storage item
	var/datum/storage/bigger_fish = parent.loc?.atom_storage
	if(bigger_fish && bigger_fish.max_specific_storage < max_specific_storage)
		if(messages && user)
			user.balloon_alert(user, "[LOWER_TEXT(parent.loc.name)] is in the way!")
		return FALSE

	if(isitem(parent))
		var/obj/item/item_parent = parent
		if(item_parent.item_flags & IN_INVENTORY)
			if(equipped_access_flags & STORAGE_ACCESS_NOT_WORN)
				if(messages)
					user.balloon_alert(user, "not while worn!")
				return FALSE
			else if(equipped_access_flags & STORAGE_ACCESS_INHANDS)
				if(!locate(parent) in user.held_items)
					if(messages)
						user.balloon_alert(user, "need to hold!")
				return FALSE
		var/datum/storage/smaller_fish = to_insert.atom_storage
		if(smaller_fish && !allow_big_nesting && to_insert.w_class >= item_parent.w_class)
			if(messages && user)
				user.balloon_alert(user, "too big!")
			return FALSE

	if(no_interface) // Don't care about grid
		return TRUE

	var/coordinates
	if(params)
		coordinates = screen_loc_to_grid_coordinates(LAZYACCESS(params2list(params), SCREEN_LOC))
	else
		coordinates = get_valid_coordinates(to_insert)

	if(!validate_grid_coordinates(coordinates, to_insert))
		if(messages && user)
			user.balloon_alert(user, "no room!")
		return FALSE

	return TRUE

/// Returns TRUE if the grid is full
/datum/storage/proc/grid_full()
	if(!length(item_coordinates))
		return FALSE

	// Item coordinates store the positions taken up by every item, if the total
	// equals the area of the grid, we're full
	var/total = 0
	for(var/obj/item/stored as anything in item_coordinates)
		total += length(item_coordinates[stored])

	return total == (screen_max_columns * screen_max_rows)

/// Returns a count of how many items held due to exception_hold we have
/datum/storage/proc/get_exception_count()
	var/count = 0
	for(var/obj/item/thing in real_location)
		if(thing.w_class > max_specific_storage && is_type_in_typecache(thing, exception_hold))
			count += 1
	return count

/// Returns a sum of all of our content's weight classes
/datum/storage/proc/get_total_weight()
	var/total_weight = 0
	for(var/obj/item/thing in real_location)
		total_weight += thing.w_class
	return total_weight

/// Returns first set of valid coordinates for grid storage or none
/datum/storage/proc/get_valid_coordinates(obj/item/to_insert)
	for(var/current_y in 1 to screen_max_rows)
		for(var/current_x in 1 to screen_max_columns)
			var/test_coordinates = "[current_x - 1],[current_y - 1]"

			if(validate_grid_coordinates(test_coordinates, to_insert))
				return test_coordinates

			// This may look strange but we try to flip and check the validity again
			if(!to_insert.flip_grid_storage_dimensions())
				continue

			if(validate_grid_coordinates(test_coordinates, to_insert))
				return test_coordinates

/**
 * Attempts to insert an item into the storage
 *
 * Arguments
 * * obj/item/to_insert - the item we're inserting
 * * mob/user - (optional) the user who is inserting the item.
 * * override - skip feedback, only do the animation
 * * force - bypass locked storage up to a certain level. See [code/__DEFINES/storage.dm]
 * * messages - if TRUE, we will create balloon alerts for the user.
 * * params - for grids, screenloc is used to position the item inside storage
 */
/datum/storage/proc/attempt_insert(obj/item/to_insert, mob/user, override = FALSE, force = STORAGE_NOT_LOCKED, messages = TRUE, params)
	SHOULD_NOT_SLEEP(TRUE)

	if(!can_insert(to_insert, user, messages = messages, force = force, params = params))
		return FALSE

	if(SEND_SIGNAL(parent, COMSIG_ATOM_PRE_STORED_ITEM, to_insert, user, force, messages) & BLOCK_STORAGE_INSERT)
		return FALSE

	SEND_SIGNAL(parent, COMSIG_ATOM_STORED_ITEM, to_insert, user, force)
	SEND_SIGNAL(src, COMSIG_STORAGE_STORED_ITEM, to_insert, user, force)

	if(get(real_location, /mob) != user)
		to_insert.do_pickup_animation(real_location, user)

	if(!no_interface)
		var/coordinates
		if(params)
			coordinates = screen_loc_to_grid_coordinates(LAZYACCESS(params2list(params), SCREEN_LOC))
		else
			coordinates = get_valid_coordinates(to_insert)
		add_item_to_grid(to_insert, coordinates)

	if(ismob(to_insert.loc))
		var/mob/item_carrier = to_insert.loc
		item_carrier.transferItemToLoc(to_insert, real_location) // This allows has_unequipped() to be properly called.
	else
		to_insert.forceMove(real_location)

	item_insertion_feedback(user, to_insert, override)
	parent.update_appearance()

	return TRUE

/// Since items inside storages ignore transparency for QOL reasons, we're tracking when things are dropped onto them instead of our UI elements
/datum/storage/proc/mousedrop_receive(atom/dropped_onto, atom/movable/target, mob/user, params)
	SIGNAL_HANDLER

	if(src != user.active_storage)
		return

	if(!user.can_perform_action(parent, FORBID_TELEKINESIS_REACH))
		return

	if(target.loc != real_location) // what even
		return

	if(numerical_stacking)
		return

	var/drop_index = real_location.contents.Find(dropped_onto)
	real_location.contents -= target

	// Use an empty list if we're dropping onto the last item
	var/list/to_move = length(real_location.contents) >= drop_index ? real_location.contents.Copy(drop_index) : list()
	real_location.contents -= to_move
	real_location.contents += target
	real_location.contents += to_move

	refresh_views()

/**
 * Inserts every item in a given list, with a progress bar
 *
 * Arguments
 * * mob/user - the user who is inserting the items
 * * list/things - the list of items to insert
 * * atom/thing_loc - the location of the items (used to make sure an item hasn't moved during pickup)
 * * list/rejections - a list used to make sure we only complain once about an invalid insertion
 * * datum/progressbar/progress - the progressbar used to show the progress of the insertion
 */
/datum/storage/proc/handle_mass_pickup(mob/user, list/things, atom/thing_loc, list/rejections, datum/progressbar/progress)
	for(var/obj/item/thing in things)
		things -= thing
		if(thing.loc != thing_loc)
			continue
		if(thing.type in rejections) // To limit bag spamming: any given type only complains once
			continue
		if(!attempt_insert(thing, user, override = TRUE)) // Note can_be_inserted still makes noise when the answer is no
			if(real_location.contents.len >= max_slots)
				break
			rejections += thing.type // therefore full bags are still a little spammy
			continue

		if (TICK_CHECK)
			progress.update(progress.goal - things.len)
			return TRUE

	progress.update(progress.goal - things.len)
	return FALSE

/**
 * Provides visual feedback in chat for an item insertion
 *
 * @param mob/user the user who is inserting the item
 * @param obj/item/thing the item we're inserting
 * @param override skip feedback, only do animation check
 */
/datum/storage/proc/item_insertion_feedback(mob/user, obj/item/thing, override = FALSE)
	if(animated)
		animate_parent()

	if(override)
		return

	if(silent)
		return

	if(do_rustle && rustle_sound)
		playsound(parent, rustle_sound, 50, rustle_vary, -5)

	if(user && !silent_for_user)
		to_chat(user, span_notice("I put [thing] [insert_preposition]to [parent]."))

	for(var/mob/viewing in oviewers(user))
		if(in_range(user, viewing) || (thing?.w_class >= WEIGHT_CLASS_NORMAL))
			viewing.show_message(span_notice("[user] puts [thing] [insert_preposition]to [parent]."), MSG_VISUAL)

/**
 * Attempts to remove an item from the storage
 * Ignores removal do_afters. Only use this if you're doing it as part of a dumping action
 *
 * Arguments
 * * obj/item/thing - the object we're removing
 * * atom/remove_to_loc - where we're placing the item
 * * silent - if TRUE, we won't play any exit sounds
 * * visual_updates - if TRUE we update storage views & animate parent appearance
 */
/datum/storage/proc/attempt_remove(obj/item/thing, atom/remove_to_loc, silent = FALSE, visual_updates = TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(istype(thing) && ismob(parent.loc))
		var/mob/mob_parent = parent.loc
		thing.dropped(mob_parent, /*silent = */TRUE)

	if(remove_to_loc)
		reset_item(thing)
		thing.forceMove(remove_to_loc)

		if(!silent && do_rustle)
			if(remove_rustle_sound)
				playsound(parent, remove_rustle_sound, 50, TRUE, -5)
			else if(rustle_sound)
				playsound(parent, rustle_sound, 50, TRUE, -5)
	else
		thing.moveToNullspace()

	if(visual_updates)
		if(animated)
			animate_parent()

		refresh_views()
		parent.update_appearance()

	SEND_SIGNAL(parent, COMSIG_ATOM_REMOVED_ITEM, thing, remove_to_loc, silent)
	SEND_SIGNAL(src, COMSIG_STORAGE_REMOVED_ITEM, thing, remove_to_loc, silent)
	return TRUE

/**
 * Removes everything inside of our storage
 *
 * Arguments
 * * atom/drop_loc - where we're placing the item
 * * update_storage - should we update the parent to show visual effects
 */
/datum/storage/proc/remove_all(atom/drop_loc = parent.drop_location(), update_storage = TRUE)
	for(var/obj/item/thing in real_location)
		if(!attempt_remove(thing, drop_loc, silent = TRUE))
			continue
		thing.pixel_x = thing.base_pixel_x + rand(-8, 8)
		thing.pixel_y = thing.base_pixel_y + rand(-8, 8)

/**
 * Allows a mob to attempt to remove a single item from the storage
 * Allows for hooks into things like removal delays
 *
 * Arguments
 * * mob/removing - the mob doing the removing
 * * obj/item/thing - the object we're removing
 * * atom/remove_to_loc - where we're placing the item
 * * silent - if TRUE, we won't play any exit sounds
 */
/datum/storage/proc/remove_single(mob/removing, obj/item/thing, atom/remove_to_loc, silent = FALSE)
	return attempt_remove(thing, remove_to_loc, silent)

/**
 * Removes only a specific type of item from our storage
 *
 * Arguments
 * * type - the type of item to remove
 * * amount - how many we should attempt to pick up at one time
 * * check_adjacent - if TRUE, we'll check adjacent locations for the item type
 * * force - if TRUE, we'll bypass the check_adjacent check all together
 * * mob/user - the user who is removing the items
 * * list/inserted - (optional) allows consumers to pass a list to be filled with all removed items.
 */
/datum/storage/proc/remove_type(type, atom/destination, amount = INFINITY, check_adjacent = FALSE, force = FALSE, mob/user, list/inserted)
	if(!force && check_adjacent)
		if(isnull(user) || !user.CanReach(destination) || !user.CanReach(parent))
			return FALSE

	var/list/taking = typecache_filter_list(real_location.contents, typecacheof(type))
	if(taking.len > amount)
		taking.len = amount

	if(inserted) //duplicated code for performance, don't bother checking retval/checking for list every item.
		for(var/i in taking)
			if(attempt_remove(i, destination))
				inserted |= i
	else
		for(var/i in taking)
			attempt_remove(i, destination)

	return TRUE

/// Signal handler for remove_all()
/datum/storage/proc/mass_empty(datum/source, atom/location, force)
	SIGNAL_HANDLER

	if(!allow_quick_empty && !force)
		return

	remove_all(get_turf(location))

/**
 * Recursive proc to get absolutely EVERYTHING inside a storage item, including the contents of inner items.
 *
 * Arguments
 * * recursive - whether or not we're checking inside of inner items
 */
/datum/storage/proc/return_inv(recursive = TRUE)
	var/list/ret = list()

	for(var/atom/found_thing as anything in real_location)
		ret |= found_thing
		if(recursive && found_thing.atom_storage)
			ret |= found_thing.atom_storage.return_inv(recursive = TRUE)

	return ret

/**
 * Resets an object, removes it from our screen, and refreshes the view.
 *
 * @param atom/movable/gone the object leaving our storage
 */
/datum/storage/proc/remove_and_refresh(atom/movable/gone)
	SIGNAL_HANDLER

	for(var/mob/user as anything in is_using)
		if(!user.client)
			continue
		var/client/cuser = user.client
		cuser.screen -= gone

	if(gone in item_coordinates)
		LAZYREMOVE(item_coordinates, gone)

	reset_item(gone)
	refresh_views()

/// Signal handler for preattack from an object.
/datum/storage/proc/on_preattack(datum/source, obj/item/thing, mob/user, list/modifiers)
	SIGNAL_HANDLER

	if(!istype(thing) || thing == parent.loc || !allow_quick_gather || thing.atom_storage)
		return

	if(collection_mode == COLLECT_ONE)
		if(thing.loc == user)
			user.dropItemToGround(thing, silent = TRUE) //this is nessassary to update any inventory slot it is attached to
		attempt_insert(thing, user)
		return COMPONENT_CANCEL_ATTACK_CHAIN

	if(!isturf(thing.loc))
		return COMPONENT_CANCEL_ATTACK_CHAIN

	INVOKE_ASYNC(src, PROC_REF(collect_on_turf), thing, user)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/**
 * Collects every item of a type on a turf.
 *
 * @param obj/item/thing the initial object to pick up
 * @param mob/user the user who is picking up the items
 */
/datum/storage/proc/collect_on_turf(obj/item/thing, mob/user)
	var/atom/holder = thing.loc
	var/list/pick_up = holder.contents.Copy()

	if(collection_mode == COLLECT_SAME)
		pick_up = typecache_filter_list(pick_up, typecacheof(thing.type))

	var/amount = length(pick_up)
	if(!amount)
		parent.balloon_alert(user, "nothing to pick up!")
		return

	var/datum/progressbar/progress = new(user, amount, thing.loc)
	var/list/rejections = list()

	while(do_after(user, 1 SECONDS, parent, NONE, FALSE, CALLBACK(src, PROC_REF(handle_mass_pickup), user, pick_up.Copy(), thing.loc, rejections, progress)))
		stoplag(1)

	progress.end_progress()
	// If nothing was actually removed, don't send the pickup message
	var/list/current_contents = holder.contents.Copy()
	if(length(pick_up | current_contents) == length(current_contents))
		return
	parent.balloon_alert(user, "picked up")

/// Signal handler for whenever we drag the storage somewhere.
/datum/storage/proc/on_mousedrop_onto(datum/source, atom/over_object, mob/user)
	SIGNAL_HANDLER

	if(user.incapacitated() || !user.canUseStorage())
		return

	if(istype(over_object, /atom/movable/screen/inventory/hand))
		if(parent.loc != user || !user.can_perform_action(parent, FORBID_TELEKINESIS_REACH | ALLOW_RESTING))
			return

		var/atom/movable/screen/inventory/hand/hand = over_object
		user.putItemFromInventoryInHandIfPossible(parent, hand.held_index)
		parent.add_fingerprint(user)
		return

	if(over_object == user)
		if(!user.can_perform_action(parent, FORBID_TELEKINESIS_REACH | ALLOW_RESTING))
			return

		if(isliving(parent) && user.pulling == parent)
			var/mob/living/as_living = parent
			if(as_living.can_be_held)
				return

		parent.add_fingerprint(user)
		INVOKE_ASYNC(src, PROC_REF(open_storage), user)
		return

	if(istype(over_object, /atom/movable/screen) || ismob(over_object))
		return NONE

	if(!user.can_perform_action(over_object, FORBID_TELEKINESIS_REACH))
		return NONE

	parent.add_fingerprint(user)

	var/atom/dump_loc = over_object.get_dumping_location()
	if(isnull(dump_loc))
		return

	/// Don't dump *onto* objects in the same storage as ourselves
	if(over_object.loc == parent.loc && !isnull(parent.loc.atom_storage) && isnull(over_object.atom_storage))
		return

	INVOKE_ASYNC(src, PROC_REF(dump_content_at), over_object, dump_loc, user)

/**
 * Dumps all of our contents at a specific location.
 *
 * @param atom/dest_object where to dump to
 * @param mob/user the user who is dumping the contents
 */
/datum/storage/proc/dump_content_at(atom/dest_object, dump_loc, mob/user)
	if(locked)
		user.balloon_alert(user, "closed!")
		return

	if(!user.CanReach(parent) || !user.CanReach(dest_object))
		return

	if(SEND_SIGNAL(dest_object, COMSIG_STORAGE_DUMP_CONTENT, src, user) & STORAGE_DUMP_HANDLED)
		return

	// Storage to storage transfer is instant
	if(dest_object.atom_storage)
		to_chat(user, span_notice("You dump the contents of [parent] into [dest_object]."))

		if(do_rustle && rustle_sound)
			playsound(parent, rustle_sound, 50, TRUE, -5)

		for(var/obj/item/to_dump in real_location)
			dest_object.atom_storage.attempt_insert(to_dump, user)
		parent.update_appearance()
		SEND_SIGNAL(src, COMSIG_STORAGE_DUMP_POST_TRANSFER, dest_object, user)
		return

	// Storage to loc transfer requires a do_after
	to_chat(user, span_notice("You start dumping out the contents of [parent] onto [dest_object]..."))
	if(!do_after(user, 2 SECONDS, target = dest_object))
		return

	remove_all(dump_loc)

/// Signal handler for whenever something gets mouse-dropped onto us.
/datum/storage/proc/on_mousedropped_onto(datum/source, obj/item/dropping, mob/user)
	SIGNAL_HANDLER

	if(!istype(dropping))
		return

	if(dropping != user.get_active_held_item())
		return

	if(!user.can_perform_action(source, FORBID_TELEKINESIS_REACH))
		return

	if(dropping.atom_storage) // If it has storage it should be trying to dump, not insert.
		return

	if(!iscarbon(user))
		return

	attempt_insert(dropping, user)

/// Called directly from the attack chain if [insert_on_attack] is TRUE.
/// Handles inserting an item into the storage when clicked.
/datum/storage/proc/item_interact_insert(mob/living/user, obj/item/thing)
	return attempt_insert(thing, user)

/// Signal handler for whenever we're attacked by a mob.
/datum/storage/proc/on_attack(datum/source, mob/user)
	SIGNAL_HANDLER

	if(!attack_hand_interact)
		return

	if(user.active_storage == src && parent.loc == user)
		user.active_storage.hide_contents(user)
		hide_contents(user)
		return COMPONENT_CANCEL_ATTACK_CHAIN

	if(parent.loc == user)
		INVOKE_ASYNC(src, PROC_REF(open_storage), user)
		return COMPONENT_CANCEL_ATTACK_CHAIN

/// Signal handler to open up the storage when we receive a signal.
/datum/storage/proc/open_storage_on_signal(datum/source, mob/to_show)
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, PROC_REF(open_storage), to_show)

	if(display_contents && !no_interface)
		return COMPONENT_NO_AFTERATTACK

/// Opens the storage to the mob, showing them the contents to their UI.
/datum/storage/proc/open_storage(mob/living/to_show)
	if(isobserver(to_show))
		show_contents(to_show)
		return FALSE

	if(!isliving(to_show) || !to_show.can_perform_action(parent, ALLOW_RESTING | FORBID_TELEKINESIS_REACH))
		return FALSE

	if(locked)
		if(!silent)
			parent.balloon_alert(to_show, "closed!")
		return FALSE

	if(locked)
		if(!silent)
			parent.balloon_alert(to_show, "closed!")
		return FALSE

	// If we're quickdrawing boys
	if(quickdraw && !to_show.get_active_held_item())
		var/obj/item/to_remove = locate() in real_location
		if(!to_remove)
			return TRUE

		if(remove_single(to_show, to_remove))
			INVOKE_ASYNC(src, PROC_REF(put_in_hands_async), to_show, to_remove)
			if(!silent)
				to_show.visible_message(
					span_warning("[to_show] draws [to_remove] from [parent]!"),
					span_notice("You draw [to_remove] from [parent]."),
				)
			return TRUE

	// If nothing else, then we want to open the thing, so do that
	if(!show_contents(to_show))
		return FALSE

	if(animated)
		animate_parent()

	if(do_rustle && !silent)
		playsound(parent, (open_sound ? open_sound : SFX_RUSTLE), 50, open_sound_vary, -5)

	return TRUE

/// Async version of putting something into a mobs hand.
/datum/storage/proc/put_in_hands_async(mob/to_show, obj/item/toremove)
	if(!to_show.put_in_hands(toremove))
		if(!silent)
			toremove.balloon_alert(to_show, "fumbled!")
		return TRUE

/// Signal handler for whenever a mob walks away with us, close if they can't reach us.
/datum/storage/proc/close_distance(datum/source)
	SIGNAL_HANDLER

	for(var/mob/user in can_see_contents())
		if (!user.CanReach(parent))
			hide_contents(user)

/// Close the storage UI for everyone viewing us.
/datum/storage/proc/close_all()
	for(var/mob/user in is_using)
		hide_contents(user)

/// Closes the storage UIs of this and everything inside the parent for everyone viewing them.
/datum/storage/proc/close_all_recursive()
	close_all()
	for(var/atom/movable/movable as anything in parent.get_all_contents())
		movable.atom_storage?.close_all()

/// Refresh the views of everyone currently viewing the storage.
/datum/storage/proc/refresh_views()
	for(var/mob/user in can_see_contents())
		show_contents(user)

/// Checks who is currently capable of viewing our storage (and is.)
/datum/storage/proc/can_see_contents()
	var/list/seeing = list()
	for (var/mob/user in is_using)
		if(user.active_storage == src && user.client)
			seeing += user
		else
			hide_contents(user)
	return seeing

/**
 * Show our storage to a mob.
 *
 * @param mob/to_show the mob to show the storage to
 */
/datum/storage/proc/show_contents(mob/to_show)
	if(no_interface)
		return FALSE

	if(!to_show.client)
		return FALSE

	// You can only inspect hidden contents if you're an observer
	if(!isobserver(to_show) && !display_contents)
		return FALSE

	if(to_show.active_storage != src && (to_show.stat == CONSCIOUS))
		for(var/obj/item/thing in real_location)
			if(thing.on_found(to_show))
				to_show.active_storage.hide_contents(to_show)

	if(to_show.active_storage)
		to_show.active_storage.hide_contents(to_show)

	to_show.active_storage = src

	if(ismovable(real_location))
		var/atom/movable/movable_loc = real_location
		movable_loc.become_active_storage(src)

	orient_to_hud()

	LAZYOR(is_using, to_show)

	to_show.client.screen |= boxes
	to_show.client.screen |= closer
	to_show.client.screen |= real_location.contents

/**
 * Hide our storage from a mob.
 *
 * @param mob/to_show the mob to hide the storage from
 */
/datum/storage/proc/hide_contents(mob/to_show)
	if(to_show.active_storage == src)
		to_show.active_storage = null

	if(!length(is_using) && ismovable(real_location))
		var/atom/movable/movable_loc = real_location
		movable_loc.lose_active_storage(src)

	LAZYREMOVE(is_using, to_show)

	SEND_SIGNAL(src, COMSIG_STORAGE_CLOSED, to_show)

	if(to_show.client)
		to_show.client.screen -= boxes
		to_show.client.screen -= closer
		to_show.client.screen -= real_location.contents

/**
 * Toggles the collectmode of our storage.
 *
 * @param mob/to_show the mob toggling us
 */
/datum/storage/proc/toggle_collection_mode(mob/user)
	collection_mode = (collection_mode + 1) % 3

	switch(collection_mode)
		if(COLLECT_SAME)
			to_chat(user, span_notice("[parent] now picks up all items of a single type at once."))
		if(COLLECT_EVERYTHING)
			to_chat(user, span_notice("[parent] now picks up all items in a tile at once."))
		if(COLLECT_ONE)
			to_chat(user, span_notice("[parent] now picks up one item at a time."))

/// Gives a spiffy animation to our parent to represent opening and closing.
/datum/storage/proc/animate_parent()
	var/matrix/old_matrix = parent.transform
	animate(parent, time = 1.5, loop = 0, transform = parent.transform.Scale(1.07, 0.9))
	animate(time = 2, transform = old_matrix)

///Assign a new value to the locked variable. If it's higher than NOT_LOCKED, close the UIs and update the appearance of the parent.
/datum/storage/proc/set_locked(new_locked)
	if(locked == new_locked)
		return

	locked = new_locked
	if(new_locked > STORAGE_NOT_LOCKED)
		close_all_recursive()

	parent.update_appearance()

/// Generates the numbers on an item in storage to show stacking.
/datum/storage/proc/process_numerical_display()
	var/list/toreturn = list()

	for(var/obj/item/thing in real_location)
		var/total_amnt = 1

		if(istype(thing, /obj/item/natural/bundle))
			var/obj/item/natural/bundle/things = thing
			total_amnt = things.amount

		if(!toreturn["[thing.type]-[thing.name]"])
			toreturn["[thing.type]-[thing.name]"] = new /datum/numbered_display(thing, total_amnt)
		else
			var/datum/numbered_display/numberdisplay = toreturn["[thing.type]-[thing.name]"]
			numberdisplay.number += total_amnt

	return toreturn

/// Updates the storage UI to fit all objects inside storage.
/datum/storage/proc/orient_to_hud()
	//Numbered contents display
	var/list/datum/numbered_display/numbered_contents
	if(numerical_stacking)
		numbered_contents = process_numerical_display()

	var/rows = screen_max_rows
	var/columns = screen_max_columns

	orient_item_boxes(rows, columns, numbered_contents)

/// Generates the actual UI objects, their location, and alignments whenever we open storage up.
/datum/storage/proc/orient_item_boxes(rows = 0, cols = 0, list/obj/item/numerical_display_contents)
	boxes.screen_loc = "[screen_start_x]:[src.screen_pixel_x],[screen_start_y]:[src.screen_pixel_y] to [screen_start_x+cols-1]:[src.screen_pixel_x],[screen_start_y-rows+1]:[src.screen_pixel_y]"

	var/mutable_appearance/bound_underlay
	var/screen_loc
	var/screen_x
	var/screen_y
	var/screen_pixel_x
	var/screen_pixel_y

	// This needs cleaning, there has to be a better way of mapping this out

	if(islist(numerical_display_contents))
		for(var/index in numerical_display_contents)
			var/datum/numbered_display/numbered_display = numerical_display_contents[index]
			var/obj/item/stored_item = numbered_display.sample_object

			var/enchanted = (stored_item.has_enchantment(/datum/enchantment/dimensional_shrink) || (stored_item.item_flags & SHRINK_ENCHANT))

			var/used_gridwidth = stored_item.grid_width
			if(enchanted)
				used_gridwidth = max(32, used_gridwidth - 32)

			var/used_gridheight = stored_item.grid_height
			if(enchanted)
				used_gridheight = max(32, used_gridheight - 32)

			stored_item.mouse_opacity = MOUSE_OPACITY_OPAQUE

			bound_underlay = get_bound_underlay(used_gridwidth, used_gridheight, enchanted)
			stored_item.underlays += bound_underlay

			var/list/grid_lock = LAZYACCESS(item_coordinates, stored_item)
			screen_loc = grid_coordinates_to_screen_loc(grid_lock[1])

			screen_x = copytext(screen_loc, 1, findtext(screen_loc, ","))
			screen_pixel_x = text2num(copytext(screen_x, findtext(screen_x, ":") + 1))
			screen_pixel_x += (world.icon_size / 2) * ((used_gridwidth / world.icon_size) - 1)
			screen_x = text2num(copytext(screen_x, 1, findtext(screen_x, ":")))

			screen_y = copytext(screen_loc, findtext(screen_loc, ",") + 1)
			screen_pixel_y = text2num(copytext(screen_y, findtext(screen_y, ":") + 1))
			screen_pixel_y += (world.icon_size / 2) * ((used_gridheight / world.icon_size) - 1)
			screen_y = text2num(copytext(screen_y, 1, findtext(screen_y, ":")))

			stored_item.screen_loc = "[screen_x]:[screen_pixel_x],[screen_y]:[screen_pixel_y]"
			stored_item.plane = ABOVE_HUD_PLANE
			stored_item.maptext = MAPTEXT("<font color='white'>[(numbered_display.number > 1)? "[numbered_display.number]" : ""]</font>")
	else
		for(var/obj/item/stored_item in real_location)
			if(QDELETED(stored_item))
				continue

			var/enchanted = (stored_item.has_enchantment(/datum/enchantment/dimensional_shrink) || (stored_item.item_flags & SHRINK_ENCHANT))

			var/used_gridwidth = stored_item.grid_width
			if(enchanted)
				used_gridwidth = max(32, used_gridwidth - 32)

			var/used_gridheight = stored_item.grid_height
			if(enchanted)
				used_gridheight = max(32, used_gridheight - 32)

			stored_item.mouse_opacity = MOUSE_OPACITY_OPAQUE

			bound_underlay = get_bound_underlay(used_gridwidth, used_gridheight, enchanted)
			stored_item.underlays += bound_underlay

			var/list/grid_lock = LAZYACCESS(item_coordinates, stored_item)
			screen_loc = grid_coordinates_to_screen_loc(grid_lock[1])

			screen_x = copytext(screen_loc, 1, findtext(screen_loc, ","))
			screen_pixel_x = text2num(copytext(screen_x, findtext(screen_x, ":") + 1))
			screen_pixel_x += (world.icon_size / 2) * ((used_gridwidth / world.icon_size) - 1)
			screen_x = text2num(copytext(screen_x, 1, findtext(screen_x, ":")))

			screen_y = copytext(screen_loc, findtext(screen_loc, ",") + 1)
			screen_pixel_y = text2num(copytext(screen_y, findtext(screen_y, ":") + 1))
			screen_pixel_y += (world.icon_size / 2) * ((used_gridheight / world.icon_size) - 1)
			screen_y = text2num(copytext(screen_y, 1, findtext(screen_y, ":")))

			stored_item.screen_loc = "[screen_x]:[screen_pixel_x],[screen_y]:[screen_pixel_y]"
			stored_item.plane = ABOVE_HUD_PLANE
			stored_item.maptext = ""

	update_closer(rows, cols)

/datum/storage/proc/update_closer(rows = 0, cols = 0)
	closer.cut_overlays()
	closer.icon_state = "close"

	var/half_rows = floor((rows - 1) * 0.5)

	var/half_row_ceil = CEILING((rows - 1) * 0.5, 1)

	var/extra = ISEVEN(rows)

	closer.screen_loc = "[screen_start_x+cols]:[screen_pixel_x],[screen_start_y - (half_rows + extra)]:[screen_pixel_y]"
	switch(rows)
		if(-INFINITY to 1)
			closer.icon_state = "close"
		if(2)
			closer.icon_state = "close_left"
		if(3 to INFINITY)
			closer.icon_state = "close_mid"

	var/image/offset_image
	for(var/overlayer in 1 to half_rows)
		var/state = (overlayer >= half_rows) ? "close_right" : "close_mid"
		offset_image = image(closer.icon, state)
		offset_image.transform = offset_image.transform.Translate(0, world.icon_size * -overlayer)
		closer.add_overlay(offset_image)

	for(var/overlayer in 1 to half_row_ceil)
		var/state = (overlayer >= half_row_ceil) ? "close_left" : "close_mid"
		offset_image = image(closer.icon, state)
		offset_image.transform = offset_image.transform.Translate(0, world.icon_size * overlayer)
		closer.add_overlay(offset_image)

	if(rows > 1)
		var/image/close_overlay = image(closer.icon, "close_overlay")
		close_overlay.transform = close_overlay.transform.Translate(0, world.icon_size * ((((rows - 1) * 0.5) + extra) - (half_row_ceil)))
		closer.add_overlay(close_overlay)

/datum/storage/proc/screen_loc_to_grid_coordinates(screen_loc = "")
	var/screen_x = copytext(screen_loc, 1, findtext(screen_loc, ","))
	var/screen_pixel_x = text2num(copytext(screen_x, findtext(screen_x, ":") + 1))
	screen_x = text2num(copytext(screen_x, 1, findtext(screen_x, ":")))

	var/screen_y = copytext(screen_loc, findtext(screen_loc, ",") + 1)
	var/screen_pixel_y = text2num(copytext(screen_y, findtext(screen_y, ":") + 1))
	screen_y = text2num(copytext(screen_y, 1, findtext(screen_y, ":")))

	var/screen_x_pixels = (screen_x * world.icon_size) + screen_pixel_x
	screen_x_pixels -= (screen_start_x * world.icon_size) + screen_pixel_x
	screen_x_pixels = floor(screen_x_pixels / world.icon_size)

	var/screen_y_pixels = (screen_y * world.icon_size) + screen_pixel_y
	screen_y_pixels -= ((screen_start_y - screen_max_rows + 1) * world.icon_size) + screen_pixel_y
	screen_y_pixels = floor(screen_y_pixels / world.icon_size)

	return "[screen_x_pixels],[screen_y_pixels]"

/datum/storage/proc/grid_coordinates_to_screen_loc(coordinates = "")
	var/coordinate_x = copytext(coordinates, 1, findtext(coordinates, ","))
	coordinate_x = text2num(copytext(coordinate_x, 1, findtext(coordinate_x, ":")))

	var/coordinate_y = copytext(coordinates, findtext(coordinates, ",") + 1)
	coordinate_y = text2num(copytext(coordinate_y, 1, findtext(coordinate_y, ":")))

	var/screen_x_pixels = coordinate_x * world.icon_size
	screen_x_pixels += (screen_start_x * world.icon_size) + src.screen_pixel_x

	var/screen_y_pixels = coordinate_y * world.icon_size
	screen_y_pixels += ((screen_start_y - screen_max_rows + 1) * world.icon_size) + src.screen_pixel_y

	var/screen_x = floor(screen_x_pixels / world.icon_size)
	var/screen_pixel_x = floor(screen_x_pixels - FLOOR(screen_x_pixels, world.icon_size))

	var/screen_y = floor(screen_y_pixels / world.icon_size)
	var/screen_pixel_y = floor(screen_y_pixels - FLOOR(screen_y_pixels, world.icon_size))

	return "[screen_x]:[screen_pixel_x],[screen_y]:[screen_pixel_y]"

/datum/storage/proc/validate_grid_coordinates(coordinates, obj/item/to_store)
	if(!coordinates)
		return FALSE

	if(grid_full())
		return FALSE

	// Validate starting location (bottom right)
	var/list/x_and_y = splittext(coordinates, ",")

	if(text2num(x_and_y[1]) >= screen_max_columns)
		return FALSE

	if(text2num(x_and_y[2]) >= screen_max_rows)
		return FALSE

	var/list/grid_coordinates = list(coordinates)

	var/enchanted = to_store.has_enchantment(/datum/enchantment/dimensional_shrink)

	/// Validate height is in bounds and add to coordinates covered
	var/used_grid_height = to_store.grid_height
	if(used_grid_height > 32)
		if(enchanted)
			used_grid_height = max(32, used_grid_height - 32)

		var/grid_length = used_grid_height / 32
		if(grid_length > 1)
			var/list/coords = splittext(coordinates, ",")
			for(var/i in 1 to grid_length - 1)
				var/grid_y = text2num(coords[2]) + i
				if(grid_y >= screen_max_rows)
					return FALSE
				grid_coordinates += "[coords[1]],[grid_y]"

	/// Validate width is in bounds and add to coordinates covered
	var/used_grid_width = to_store.grid_width
	if(used_grid_width > 32)
		if(enchanted)
			used_grid_width = max(32, used_grid_width - 32)

		var/grid_length = used_grid_width / 32
		if(grid_length > 1)
			var/list/coords = splittext(coordinates, ",")
			for(var/i in 1 to grid_length - 1)
				var/grid_x = text2num(coords[1]) + i
				if(grid_x >= screen_max_columns)
					return FALSE
				grid_coordinates += "[grid_x],[coords[2]]"

	/// Validate there are no existing items
	for(var/coord in grid_coordinates)
		if(grid_item_from_coordinates(coord))
			return FALSE

	return TRUE

/// Get bound overlay for given size, creates it if it doesn't exist
/datum/storage/proc/get_bound_underlay(grid_width = world.icon_size, grid_height = world.icon_size, enchanted)
	var/mutable_appearance/existing = GLOB.storage_underlay_cache["[grid_width]x[grid_height]_[enchanted]"]
	if(existing)
		return existing

	return generate_bound_underlay(grid_width, grid_height, enchanted)

/// Create bound overlay for a grid
/datum/storage/proc/generate_bound_underlay(grid_width = world.icon_size, grid_height = world.icon_size, enchanted = FALSE)
	var/icon/final_icon = icon('icons/hud/storage.dmi', "blank")
	final_icon.Scale(grid_width, grid_height)

	var/static/list/scale_both = list("block_under")
	var/static/list/scale_x_states = list("up", "down")
	var/static/list/scale_y_states = list("right", "left")

	var/width_offset = world.icon_size * ((grid_width / world.icon_size) - 1)
	var/height_offset = world.icon_size * ((grid_height / world.icon_size) - 1)

	var/icon/scaled_icon
	for(var/scaled_both in scale_both)
		scaled_icon = icon('icons/hud/storage.dmi', scaled_both)
		scaled_icon.Scale(grid_width, grid_height)
		final_icon.Blend(scaled_icon, ICON_OVERLAY)

	var/multiplier = 0
	for(var/scaled_x in scale_x_states)
		multiplier = !multiplier
		if(enchanted)
			scaled_icon = icon('icons/hud/storage.dmi', "[scaled_x]_fancy")
		else
			scaled_icon = icon('icons/hud/storage.dmi', scaled_x)
		scaled_icon.Scale(grid_width, world.icon_size)
		final_icon.Blend(scaled_icon, ICON_OVERLAY, 1, 1 + (height_offset * multiplier))

	multiplier = 0
	for(var/scaled_y in scale_y_states)
		multiplier = !multiplier
		if(enchanted)
			scaled_icon = icon('icons/hud/storage.dmi', "[scaled_y]_fancy")
		else
			scaled_icon = icon('icons/hud/storage.dmi', scaled_y)
		scaled_icon.Scale(world.icon_size, grid_height)
		final_icon.Blend(scaled_icon, ICON_OVERLAY, 1 + (width_offset * multiplier), 1)

	var/corner_pos_x = 1 + (grid_width - world.icon_size)
	var/corner_pos_y = 1 + (grid_height - world.icon_size)
	var/icon/corner_left_down = icon('icons/hud/storage.dmi', "corner_left_down")

	final_icon.Blend(corner_left_down, ICON_OVERLAY, 1, 1)
	var/icon/corner_right_down = icon('icons/hud/storage.dmi', "corner_right_down")

	final_icon.Blend(corner_right_down, ICON_OVERLAY, corner_pos_x, 1)
	var/icon/corner_left_up = icon('icons/hud/storage.dmi', "corner_left_up")

	final_icon.Blend(corner_left_up, ICON_OVERLAY, 1, corner_pos_y)
	var/icon/corner_right_up = icon('icons/hud/storage.dmi', "corner_right_up")

	final_icon.Blend(corner_right_up, ICON_OVERLAY, corner_pos_x, corner_pos_y)

	var/mutable_appearance/final_appearance = mutable_appearance(final_icon, appearance_flags = APPEARANCE_UI_IGNORE_ALPHA)
	final_appearance.transform = final_appearance.transform.Translate(-width_offset / 2, -height_offset  /2)

	GLOB.storage_underlay_cache["[grid_width]x[grid_height]_[enchanted]"] = final_appearance

	return final_appearance

/// Add an item to our tracked grid for grid storage
/datum/storage/proc/add_item_to_grid(obj/item/to_store, coordinates)
	if(!coordinates)
		stack_trace("Storage datum [src] ([parent.type]) tried to add to its grid without coordinates.")
		return FALSE

	var/list/grid_coordinates = list(coordinates)

	var/enchanted = to_store.has_enchantment(/datum/enchantment/dimensional_shrink)

	var/used_grid_height = to_store.grid_height
	if(used_grid_height > 32)
		if(enchanted)
			used_grid_height = max(32, used_grid_height - 32)

		var/grid_length = used_grid_height / 32
		if(grid_length > 1)
			var/list/x_and_y = splittext(coordinates, ",")
			for(var/i in 1 to grid_length - 1)
				grid_coordinates += "[x_and_y[1]],[text2num(x_and_y[2]) + i]"

	var/used_grid_width = to_store.grid_width
	if(used_grid_width > 32)
		if(enchanted)
			used_grid_width = max(32, used_grid_width - 32)

		var/grid_length = used_grid_width / 32
		if(grid_length > 1)
			var/list/x_and_y = splittext(coordinates, ",")
			for(var/i in 1 to grid_length - 1)
				grid_coordinates += "[text2num(x_and_y[1]) + i],[x_and_y[2]]"

	for(var/coord in grid_coordinates)
		LAZYADDASSOCLIST(item_coordinates, to_store, coord)

	return TRUE

/datum/storage/proc/grid_item_from_coordinates(coordinates)
	for(var/obj/item/thing in item_coordinates)
		var/list/existing = LAZYACCESS(item_coordinates, thing)
		if(coordinates in existing)
			return thing
