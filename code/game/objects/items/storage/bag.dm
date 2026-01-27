/obj/item/storage/bag
	slot_flags = ITEM_SLOT_HIP

/obj/item/storage/bag/Initialize(mapload, ...)
	. = ..()
	atom_storage.allow_quick_gather = TRUE
	atom_storage.allow_quick_empty = TRUE
	atom_storage.numerical_stacking = TRUE
