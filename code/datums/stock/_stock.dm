// Global reachability cache system
GLOBAL_LIST_EMPTY(reachable_turfs_cache) // Cache keyed by storage REF
GLOBAL_LIST_EMPTY(cache_timestamps) // Timestamps for each cache entry

/datum/stock
	var/name = ""
	var/desc = ""
	var/item_type = null
	var/held_items = 0
	var/payout_price = 1
	var/withdraw_price = 1
	var/withdraw_disabled = FALSE
	var/demand = 100
	var/transport_item = FALSE
	var/export_price = 1
	var/importexport_amt = 10
	var/import_only = FALSE
	var/stable_price = FALSE
	var/percent_bounty = FALSE

	var/stockpile_id = STOCK_GENERIC // ID to match with stockpile objects
	var/list/tracked_items = list() // Weakref list of tracked items
	var/list/obj/structure/stockpile_storage/linked_storages = list() // All storage objects with this ID
	var/list/obj/item/pending_items = list() // Items waiting to be placed when storage is available
	var/reachability_cache_interval = 2 MINUTES

/datum/stock/New()
	. = ..()
	if(!stable_price)
		demand = rand(60,140)
	// Spawn starting items
	spawn_starting_items()
	// Link to existing storage objects
	link_to_storages()
	return

/datum/stock/Destroy()
	cleanup_all_tracked_items()
	cleanup_pending_items()
	// Unlink from storage objects
	for(var/obj/structure/stockpile_storage/storage as anything in linked_storages)
		storage.unlink_stock(src)
	linked_storages = list()
	return ..()

/datum/stock/proc/get_held_count()
	// Calculate current held items from tracked_items
	var/count = 0
	for(var/datum/weakref/item_ref as anything in tracked_items)
		var/obj/item/I = item_ref.resolve()
		if(!I)
			tracked_items -= item_ref
			continue
		if(istype(I, /obj/item/natural/bundle))
			var/obj/item/natural/bundle/B = I
			count += B.amount
		else
			count += 1
	return count

/datum/stock/proc/spawn_starting_items()
	if(held_items <= 0 || !item_type)
		return

	for(var/i in 1 to held_items)
		var/obj/item/new_item = new item_type()
		if(!add_item_to_stockpile(new_item))
			pending_items += new_item

/datum/stock/proc/cleanup_pending_items()
	for(var/obj/item/I as anything in pending_items)
		qdel(I)
	pending_items = list()

/datum/stock/proc/process_pending_items()
	// Called when new storage is linked
	if(!length(pending_items))
		return

	var/list/items_to_process = pending_items.Copy()
	for(var/obj/item/I as anything in items_to_process)
		if(add_item_to_stockpile(I))
			pending_items -= I

/datum/stock/proc/get_payout_price(obj/item/I) //treasures modify this based on the price of the treasure
	return payout_price

/datum/stock/proc/link_to_storages()
	if(!stockpile_id)
		return

	for(var/obj/structure/stockpile_storage/storage in GLOB.storage_objects)
		if(storage.storage_id == stockpile_id)
			storage.link_stock(src)
			// Process any pending items when new storage is linked
			process_pending_items()

	// Calculate initial reachable turfs for new storages
	update_reachable_turfs_for_storages()

/datum/stock/proc/check_item(obj/item/I) //for checking monster heads if they belong to monsters and other stuff
	if(import_only) //so you can't submit crackers to stockpile
		return FALSE
	return TRUE

/datum/stock/proc/is_valid_stockpile_item(obj/item/I)
	if(istype(I, /obj/item/natural/bundle))
		var/obj/item/natural/bundle/B = I
		return B.stacktype == item_type
	else
		return I.type == item_type && check_item(I)

/datum/stock/proc/register_item(obj/item/I)
	if(!is_valid_stockpile_item(I))
		return FALSE

	var/datum/weakref/item_ref = WEAKREF(I)
	if(item_ref in tracked_items)
		return FALSE // Already tracking

	tracked_items += item_ref

	// Register signals for movement and deletion
	RegisterSignal(I, COMSIG_MOVABLE_MOVED, PROC_REF(on_item_moved))
	RegisterSignal(I, COMSIG_PARENT_QDELETING, PROC_REF(on_item_deleted))
	RegisterSignal(I, COMSIG_ITEM_PICKUP, PROC_REF(on_item_picked_up))

	return TRUE

/datum/stock/proc/unregister_item(obj/item/I)
	var/datum/weakref/item_ref = WEAKREF(I)
	if(!(item_ref in tracked_items))
		return FALSE

	tracked_items -= item_ref

	// Unregister signals
	UnregisterSignal(I, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING, COMSIG_ITEM_PICKUP))

	return TRUE

/datum/stock/proc/cleanup_all_tracked_items()
	for(var/datum/weakref/item_ref as anything in tracked_items)
		var/obj/item/I = item_ref.resolve()
		if(I)
			UnregisterSignal(I, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING, COMSIG_ITEM_PICKUP))
	tracked_items = list()

/datum/stock/proc/on_item_moved(obj/item/source, atom/old_loc, direction, forced, list/old_locs, momentum_change)
	SIGNAL_HANDLER

	var/still_in_range = FALSE

	// Check if item is still within range of any linked storage
	for(var/obj/structure/stockpile_storage/storage as anything in linked_storages)
		if(!isturf(source.loc))
			break
		if(get_dist(source, storage) <= storage.storage_range)
			still_in_range = TRUE
			break

	if(!still_in_range)
		unregister_item(source)

/datum/stock/proc/on_item_deleted(obj/item/source)
	SIGNAL_HANDLER
	unregister_item(source)

/datum/stock/proc/on_item_picked_up(obj/item/source, mob/user)
	SIGNAL_HANDLER
	if(QDELETED(source))
		return
	unregister_item(source)

/datum/stock/proc/add_item_to_stockpile(obj/item/I)
	if(!is_valid_stockpile_item(I))
		return FALSE

	// Find the closest storage object
	var/obj/structure/stockpile_storage/closest_storage
	var/closest_dist = INFINITY

	for(var/obj/structure/stockpile_storage/storage as anything in linked_storages)
		if(!I.loc)
			closest_storage = storage
			break
		var/dist = get_dist_3d(I, storage)
		if((dist < closest_dist))
			closest_dist = dist
			closest_storage = storage

	if(!closest_storage)
		return FALSE

	// Get cached reachable turfs for this storage
	var/list/valid_turfs = get_cached_reachable_turfs(closest_storage)

	if(!valid_turfs || !valid_turfs.len)
		return FALSE

	var/turf/target_turf = pick(valid_turfs)
	I.forceMove(target_turf)

	// Registration will happen automatically via proximity monitor
	return TRUE

/datum/stock/proc/get_cached_reachable_turfs(obj/structure/stockpile_storage/storage)
	var/storage_key = "[REF(storage)]"
	var/current_time = world.time

	// Check if cache exists and is still valid
	if(LAZYACCESS(GLOB.reachable_turfs_cache, storage_key) && LAZYACCESS(GLOB.cache_timestamps, storage_key))
		var/cache_time = GLOB.cache_timestamps[storage_key]
		if(current_time - cache_time < reachability_cache_interval)
			return GLOB.reachable_turfs_cache[storage_key]

	// Cache is invalid or doesn't exist, recalculate
	var/list/reachable_turfs = calculate_reachable_turfs(storage)

	// Update global cache
	GLOB.reachable_turfs_cache[storage_key] = reachable_turfs
	GLOB.cache_timestamps[storage_key] = current_time

	return reachable_turfs

/datum/stock/proc/update_reachable_turfs_for_storages()
	// Force update cache for all linked storages
	for(var/obj/structure/stockpile_storage/storage as anything in linked_storages)
		var/storage_key = "[REF(storage)]"
		var/list/reachable_turfs = calculate_reachable_turfs(storage)

		GLOB.reachable_turfs_cache[storage_key] = reachable_turfs
		GLOB.cache_timestamps[storage_key] = world.time

/datum/stock/proc/calculate_reachable_turfs(obj/structure/stockpile_storage/storage)
	var/list/reachable_turfs = list()
	var/turf/storage_turf = get_turf(storage)

	if(!storage_turf)
		return reachable_turfs

	// Get all turfs within range and test reachability
	for(var/turf/T in range(storage.storage_range, storage))
		if(is_turf_reachable(storage_turf, T))
			reachable_turfs += T

	return reachable_turfs

/datum/stock/proc/is_turf_reachable(turf/start, turf/target)
	// Quick check: if it's the same turf, it's reachable
	if(start == target)
		return TRUE

	// Check if target turf itself is blocked
	if(is_turf_blocked(target))
		return FALSE

	// Create a temporary mob to test pathfinding
	var/obj/temp_mob = new /obj/item(start)

	// Try to step towards the target
	var/steps_taken = 0
	var/max_steps = get_dist(start, target) + 5 // Allow some extra steps for pathfinding around obstacles

	while(temp_mob.loc != target && steps_taken < max_steps)
		var/turf/old_loc = temp_mob.loc
		step_towards(temp_mob, target)
		steps_taken++

		// If we didn't move, we're blocked
		if(temp_mob.loc == old_loc)
			qdel(temp_mob)
			return FALSE

	var/success = (temp_mob.loc == target)
	qdel(temp_mob)
	return success

/datum/stock/proc/is_turf_blocked(turf/T)
	// Check if the turf itself is closed
	if(istype(T, /turf/closed))
		return TRUE

	// Check for blocking structures on the turf
	for(var/obj/structure/S in T)
		if(istype(S, /obj/structure/door) || istype(S, /obj/structure/window) || istype(S, /obj/structure/bars))
			return TRUE

	return FALSE

/datum/stock/proc/force_reachability_update()
	// Public method to force an immediate update for all linked storages
	update_reachable_turfs_for_storages()

/datum/stock/proc/clear_storage_cache(obj/structure/stockpile_storage/storage)
	// Remove specific storage from global cache (useful when storage is deleted)
	var/storage_key = "[REF(storage)]"
	LAZYREMOVE(GLOB.reachable_turfs_cache, storage_key)
	LAZYREMOVE(GLOB.cache_timestamps, storage_key)

/datum/stock/proc/withdraw_item()
	var/current_count = get_held_count()
	if(current_count <= 0)
		return null

	// Get a random tracked item
	if(!tracked_items.len)
		return null

	var/datum/weakref/item_ref = pick(tracked_items)
	var/obj/item/I = item_ref.resolve()

	if(!I)
		tracked_items -= item_ref
		return withdraw_item() // Try again

	// For bundles, we might need to split them
	if(istype(I, /obj/item/natural/bundle))
		var/obj/item/natural/bundle/B = I
		if(B.amount > 1)
			// Create a single item from the bundle
			var/obj/item/new_item = new item_type(B.loc)
			B.amount--
			return new_item
		else
			// Bundle has only one item, remove it entirely
			unregister_item(I)
			return I
	else
		unregister_item(I)
		return I

/datum/stock/proc/get_export_price()
	var/taxed_amount = round((export_price*importexport_amt) * (demand/100))
	taxed_amount = taxed_amount - round(SStreasury.queens_tax*taxed_amount)
	return max(taxed_amount, 0)

/datum/stock/proc/get_import_price()
	var/taxed_amount = round((export_price*importexport_amt) * (demand/100))
	taxed_amount = taxed_amount + round(SStreasury.queens_tax*taxed_amount)
	return max(taxed_amount, 5)

/datum/stock/proc/lower_demand()
	if(stable_price)
		return
	demand = max(demand-3,10)

/datum/stock/proc/raise_demand()
	if(stable_price)
		return
	demand = min(demand+1,200)

/datum/stock/proc/demand2word()
	switch(demand)
		if(160 to 200)
			return "Scarce"
		if(130 to 160)
			return "High"
		if(110 to 130)
			return "Growing"
		if(90 to 110)
			return "Normal"
		if(70 to 90)
			return "Falling"
		if(40 to 70)
			return "Low"
		if(1 to 40)
			return "Excess"
