/obj/item/storage/bag
	slot_flags = ITEM_SLOT_HIP

/obj/item/storage/bag/Initialize(mapload, ...)
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.allow_quick_gather = TRUE
	STR.allow_quick_empty = TRUE
	STR.display_numerical_stacking = TRUE
	STR.click_gather = TRUE
