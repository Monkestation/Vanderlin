GLOBAL_LIST_EMPTY(storage_objects)

/obj/structure/stockpile_storage
	name = "stockpile storage"
	desc = "A designated storage area for stockpiled goods."
	icon = 'icons/roguetown/misc/pipes.dmi'
	icon_state = "drain"
	density = FALSE
	anchored = TRUE
	var/storage_id = STOCK_GENERIC
	var/storage_range = 2
	var/list/datum/stock/linked_stocks = list()
	var/datum/proximity_monitor/advanced/stockpile_storage/proximity_monitor

/obj/structure/stockpile_storage/Initialize(mapload)
	. = ..()
	REGISTER_REQUIRED_MAP_ITEM(1, INFINITY)
	LAZYADD(GLOB.storage_objects, src)

	proximity_monitor = new(src, storage_range, FALSE)
	proximity_monitor.storage_obj = src
	// Link to existing stocks with matching ID
	for(var/datum/stock/S in SStreasury.stockpile_datums)
		if(S.stockpile_id == storage_id)
			link_stock(S)
	// Initial scan for existing items
	initial_scan()

/obj/structure/stockpile_storage/Destroy()
	QDEL_NULL(proximity_monitor)
	LAZYREMOVE(GLOB.storage_objects, src)
	// Unlink from all stocks
	for(var/datum/stock/S as anything in linked_stocks)
		S.linked_storages -= src
	linked_stocks = list()
	return ..()

/obj/structure/stockpile_storage/proc/link_stock(datum/stock/S)
	if(S in linked_stocks)
		S.process_pending_items()
		return
	linked_stocks += S
	S.linked_storages += src
	S.process_pending_items()

/obj/structure/stockpile_storage/proc/unlink_stock(datum/stock/S)
	linked_stocks -= S
	S.linked_storages -= src

/obj/structure/stockpile_storage/proc/initial_scan()
	for(var/turf/T in range(storage_range, src))
		for(var/obj/item/I in T)
			check_and_register_item(I)

/obj/structure/stockpile_storage/proc/check_and_register_item(obj/item/I)
	for(var/datum/stock/S as anything in linked_stocks)
		if(S.is_valid_stockpile_item(I))
			S.register_item(I)
			return TRUE
	return FALSE

/obj/structure/stockpile_storage/examine(mob/user)
	. = ..()
	. += span_notice("Storage ID: [storage_id]")
	. += span_notice("Storage Range: [storage_range] tiles")
	if(linked_stocks.len)
		. += span_notice("Linked to [linked_stocks.len] stock type(s).")
		for(var/datum/stock/S as anything in linked_stocks)
			var/count = S.get_held_count()
			. += span_notice("- [S.name]: [count] items")

/datum/proximity_monitor/advanced/stockpile_storage
	var/obj/structure/stockpile_storage/storage_obj

/datum/proximity_monitor/advanced/stockpile_storage/field_turf_crossed(atom/movable/movable, turf/old_location, turf/new_location)
	if(!storage_obj || !isitem(movable))
		return
	var/obj/item/I = movable
	// Check if this item should be tracked by any linked stocks
	storage_obj.check_and_register_item(I)

/datum/proximity_monitor/advanced/stockpile_storage/field_turf_uncrossed(atom/movable/movable, turf/old_location, turf/new_location)
	if(!storage_obj || !isitem(movable))
		return
	var/obj/item/I = movable
	// Item left the range, unregister from all linked stocks
	for(var/datum/stock/S as anything in storage_obj.linked_stocks)
		var/datum/weakref/item_ref = WEAKREF(I)
		if(item_ref in S.tracked_items)
			S.unregister_item(I)

/obj/structure/stockpile_storage/food
	storage_id = STOCK_FOOD

/obj/structure/stockpile_storage/metal
	storage_id = STOCK_METAL
