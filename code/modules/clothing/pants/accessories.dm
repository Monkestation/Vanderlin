/obj/item/clothing/accessory //Ties moved to neck slot items, but as there are still things like medals and armbands, this accessory system is being kept as-is
	name = "Accessory"
	desc = ""
	icon = 'icons/obj/clothing/accessories.dmi'
	icon_state = "plasma"
	item_state = ""	//no inhands
	slot_flags = 0
	w_class = WEIGHT_CLASS_SMALL
	var/above_suit = FALSE
	var/minimize_when_attached = TRUE // TRUE if shown as a small icon in corner, FALSE if overlayed
	var/datum/component/storage/detached_pockets
	var/attachment_slot = CHEST

/obj/item/clothing/accessory/proc/can_attach_accessory(obj/item/clothing/U, mob/user)
	if(!attachment_slot || (U && U.body_parts_covered & attachment_slot))
		return TRUE
	if(user)
		to_chat(user, "<span class='warning'>There doesn't seem to be anywhere to put [src]...</span>")

/obj/item/clothing/accessory/proc/attach(obj/item/clothing/pants/U, user)
	var/datum/component/storage/storage = GetComponent(/datum/component/storage)
	if(storage)
		if(SEND_SIGNAL(U, COMSIG_CONTAINS_STORAGE))
			return FALSE
		U.TakeComponent(storage)
		detached_pockets = storage
	U.attached_accessory = src
	forceMove(U)
	plane = FLOAT_PLANE
	if(minimize_when_attached)
		transform *= 0.5	//halve the size so it doesn't overpower the under
		pixel_x += 8
		pixel_y -= 8
	U.add_overlay(src)

	if (islist(U.armor) || isnull(U.armor)) 										// This proc can run before /obj/Initialize has run for U and src,
		U.armor = getArmor(arglist(U.armor))	// we have to check that the armor list has been transformed into a datum before we try to call a proc on it
																					// This is safe to do as /obj/Initialize only handles setting up the datum if actually needed.
	if (islist(armor) || isnull(armor))
		armor = getArmor(arglist(armor))

	U.armor = U.armor.attachArmor(armor)

	if(isliving(user))
		on_uniform_equip(U, user)

	return TRUE

/obj/item/clothing/accessory/proc/detach(obj/item/clothing/pants/U, user)
	if(detached_pockets && detached_pockets.parent == U)
		TakeComponent(detached_pockets)

	U.armor = U.armor.detachArmor(armor)

	if(isliving(user))
		on_uniform_dropped(U, user)

	if(minimize_when_attached)
		transform *= 2
		pixel_x -= 8
		pixel_y += 8
	layer = initial(layer)
	plane = initial(plane)
	U.cut_overlays()
	U.attached_accessory = null
	U.accessory_overlay = null

/obj/item/clothing/accessory/proc/on_uniform_equip(obj/item/clothing/pants/U, user)
	return

/obj/item/clothing/accessory/proc/on_uniform_dropped(obj/item/clothing/pants/U, user)
	return

/obj/item/clothing/accessory/AltClick(mob/user, list/modifiers)
	if(istype(user) && user.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH))
		if(initial(above_suit))
			above_suit = !above_suit
			to_chat(user, "[src] will be worn [above_suit ? "above" : "below"] my suit.")

/obj/item/clothing/accessory/examine(mob/user)
	. = ..()
	. += "<span class='notice'>\The [src] can be attached to a uniform. Alt-click to remove it once attached.</span>"
	if(initial(above_suit))
		. += "<span class='notice'>\The [src] can be worn above or below my suit. Alt-click to toggle.</span>"
