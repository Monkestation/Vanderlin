
/obj/structure/keyrack
	name = "key rack"
	desc = "A rack for holding up to 20 keys."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "keyrack"
	base_icon_state = "keyrack"
	SET_BASE_PIXEL(0, 32)

	anchored = TRUE
	density = FALSE

	var/opened = FALSE

/obj/structure/keyrack/Initialize()
	. = ..()
	create_storage(/datum/storage/keyrack)
	RegisterSignals(src, list(COMSIG_STORAGE_STORED_ITEM, COMSIG_STORAGE_REMOVED_ITEM), PROC_REF(inventory_changed))

/obj/structure/keyrack/proc/inventory_changed()
	SIGNAL_HANDLER

	if(opened)
		update_appearance(UPDATE_OVERLAYS)

/obj/structure/keyrack/attack_hand(mob/living/user)
	. = ..()
	opened = !opened
	update_appearance(UPDATE_ICON)

/obj/structure/keyrack/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][opened ? "open" : ""]"

/obj/structure/keyrack/update_overlays()
	. = ..()
	if(!opened)
		return

	var/index = 1
	for(var/obj/item/key/K in atom_storage.return_inv())
		var/mutable_appearance/key_overlay = mutable_appearance(K.icon, K.icon_state, alpha = K.alpha, color = K.color)

		key_overlay.transform *= 0.25
		// -4 is the x offset of the first hook
		key_overlay.pixel_x += -4 + 3 * floor((index - 1) / 2) // every other key, move the offset 3 pixels to the next hook
		// 2 is the y offset of the first hook
		key_overlay.pixel_y += index % 2 ? 1 : -5 // every other key, flip between using -2 offset and 4

		. += key_overlay

		index++

		if(index >= 8)
			break
