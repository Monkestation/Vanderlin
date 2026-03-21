
//Doesn't actually function as a closet for contents,
/obj/structure/closet/keyrack
	name = "key rack"
	desc = "A rack for holding up to 20 keys."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "keyrack"
	base_icon_state = "keyrack"
	SET_BASE_PIXEL(0, 32)

	anchored = TRUE
	density = FALSE
	storage_capacity = 0
	mob_storage_capacity = 0

/obj/structure/closet/keyrack/Initialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/keyrack)
	RegisterSignals(src, list(COMSIG_STORAGE_ADDED, COMSIG_STORAGE_REMOVED), PROC_REF(inventory_changed))
	SEND_SIGNAL(src, COMSIG_TRY_STORAGE_SET_LOCKSTATE, !opened)

/obj/structure/closet/keyrack/proc/inventory_changed()
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/closet/keyrack/update_overlays()
	. = ..()
	if(!opened)
		return
	var/list/inventory = list()
	if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_RETURN_INVENTORY, inventory) || !length(inventory))
		return
	var/list/types_on_the_rack = list()
	for(var/obj/item/key/K in inventory)
		if(K.type in types_on_the_rack)
			continue
		types_on_the_rack |= K.type
		var/i = types_on_the_rack.len

		var/mutable_appearance/key_overlay = mutable_appearance(K.icon, K.icon_state, alpha = K.alpha, color = K.color)
		key_overlay.transform *= 0.25
		// -4 is the x offset of the first hook
		key_overlay.pixel_x += -4 + 3 * floor((i-1) / 2) // every other key, move the offset 3 pixels to the next hook
		// 2 is the y offset of the first hook
		key_overlay.pixel_y += i % 2 ? 1 : -5 // every other key, flip between using -2 offset and 4
		. += key_overlay
		if(i >= 8)
			break


/obj/structure/closet/keyrack/toggle(mob/living/user)
	. = ..()
	if(.)
		update_appearance(UPDATE_OVERLAYS)
		SEND_SIGNAL(src, COMSIG_TRY_STORAGE_SET_LOCKSTATE, !opened)



//clear these out so it stops acting like a proper closet
/obj/structure/closet/keyrack/insertion_allowed(atom/movable/AM)
	if(!is_type_in_list(AM, list(/obj/item/key, /obj/item/storage/keyring, /obj/item/lockpick, /obj/item/lockpickring)))
		return FALSE
	return ..()

/obj/structure/closet/keyrack/insert(atom/movable/inserted, mapload = FALSE)
	if(!mapload)
		return -1
	if(!insertion_allowed(inserted))
		return FALSE
	return SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, inserted, null, TRUE, TRUE)

/obj/structure/closet/keyrack/dump_contents()
	return
/obj/structure/closet/keyrack/tool_interact(obj/item/I, mob/user)
	return FALSE

