/* Backpacks
 * Contains:
 *		Backpack
 *		Backpack Types
 *		Satchel Types
 */

/*
 * Backpack
 */

/obj/item/storage/backpack
	name = "backpack"
	desc = ""
	icon_state = "backpack"
	item_state = "backpack"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	resistance_flags = NONE
	max_integrity = 300

	sewrepair = TRUE
	fiber_salvage = TRUE
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured
	carry_multiplier = 0.75
