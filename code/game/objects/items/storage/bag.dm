/obj/item/storage/bag
	slot_flags = ITEM_SLOT_HIP

/obj/item/storage/bag/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.allow_quick_gather = TRUE
	STR.allow_quick_empty = TRUE
	STR.display_numerical_stacking = TRUE
	STR.click_gather = TRUE

/*
 * Trays - Agouri
 *///wip
/obj/item/storage/bag/tray
	name = "tray"
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "tray"
	desc = ""
	force = 5
	throwforce = 10
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_BULKY
	flags_1 = CONDUCT_1

/obj/item/storage/bag/tray/psy
	name = "tray"
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "tray_psy"
	desc = ""

/obj/item/storage/bag/tray/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.insert_preposition = "on"
	STR.max_w_class = WEIGHT_CLASS_NORMAL // changed to fit platters, take care if its abused
	update_icon()

/obj/item/storage/bag/tray/Moved()
	. = ..()
	update_icon()

/obj/item/storage/bag/tray/attack(mob/living/M, mob/living/user)
	..()
	// Drop all the things. All of them.
	var/list/obj/item/oldContents = contents.Copy()
	SEND_SIGNAL(src, COMSIG_TRY_STORAGE_QUICK_EMPTY)

	// Make each item scatter a bit
	for (var/obj/item/I in oldContents)
		if (I)
			do_scatter(I)

	if(prob(50))
		playsound(M, 'sound/blank.ogg', 50, TRUE)
	else
		playsound(M, 'sound/blank.ogg', 50, TRUE)

	if(ishuman(M) || ismonkey(M))
		if(prob(10))
			M.Paralyze(40)
	update_icon()

/obj/item/storage/bag/tray/proc/do_scatter(obj/item/I)
	if (I)
		for (var/i in 1 to rand(1, 2))
			var/xOffset = rand(-16, 16)  // Adjust the range as needed
			var/yOffset = rand(-16, 16)  // Adjust the range as needed

			I.x = xOffset
			I.y = yOffset


			sleep(rand(2, 4))

/obj/item/storage/bag/tray/update_icon()
	cut_overlays()
	for(var/obj/item/I in contents)
		add_overlay(new /mutable_appearance(I))
		var/mutable_appearance/I_copy = new(I)
		I_copy.plane = FLOAT_PLANE + 1
		I_copy.layer = FLOAT_LAYER
		add_overlay(I_copy)


/obj/item/storage/bag/tray/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	update_icon()

/obj/item/storage/bag/tray/Exited(atom/movable/gone, direction)
	. = ..()
	update_icon()
