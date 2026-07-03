/**
 * # mobs that can wear hats!
 */
/datum/element/hat_wearer
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	///offsets of hats we will wear
	var/list/offsets

/datum/element/hat_wearer/Attach(datum/target, offsets = list())
	. = ..()
	if (!isliving(target))
		return ELEMENT_INCOMPATIBLE
	src.offsets = offsets
	RegisterSignal(target, COMSIG_ATOM_UPDATE_OVERLAYS, PROC_REF(on_overlays_updated))
	RegisterSignal(target, COMSIG_ATOM_EXITED, PROC_REF(exited))
	RegisterSignal(target, COMSIG_ATOM_ENTERED, PROC_REF(on_entered))
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))
	RegisterSignal(target, COMSIG_ATOM_ITEM_INTERACTION, PROC_REF(on_item_interact))

/datum/element/hat_wearer/Detach(datum/target)
	var/obj/item/hat = (locate(/obj/item/clothing/head) in target)
	if(hat)
		hat.forceMove(get_turf(target))
	UnregisterSignal(target, list(
		COMSIG_ATOM_UPDATE_OVERLAYS,
		COMSIG_ATOM_EXITED,
		COMSIG_ATOM_ENTERED,
		COMSIG_ATOM_ITEM_INTERACTION,
	))
	return ..()

/datum/element/hat_wearer/proc/on_overlays_updated(atom/source, list/overlays)
	SIGNAL_HANDLER

	var/obj/item/hat = (locate(/obj/item/clothing/head) in source)
	if(isnull(hat))
		return

	var/mutable_appearance/hat_overlay = mutable_appearance('icons/roguetown/clothing/onmob/head.dmi', hat.icon_state)
	var/list/dir_offsets = offsets["[source.dir]"]
	hat_overlay.dir = source.dir
	hat_overlay.pixel_x = dir_offsets[1]
	hat_overlay.pixel_y = dir_offsets[2]
	overlays += hat_overlay

/datum/element/hat_wearer/proc/exited(atom/movable/source, atom/movable/exited)
	SIGNAL_HANDLER

	if(!istype(exited, /obj/item/clothing/head))
		return
	source.update_appearance(UPDATE_OVERLAYS)

/datum/element/hat_wearer/proc/on_entered(atom/movable/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER

	if(!istype(arrived, /obj/item/clothing/head))
		return

	for(var/obj/item/clothing/head/already_worn in source)
		if(already_worn == arrived)
			continue
		already_worn.forceMove(get_turf(source))

	source.update_appearance(UPDATE_OVERLAYS)

/datum/element/hat_wearer/proc/on_move(atom/movable/source)
	SIGNAL_HANDLER

	source.update_appearance(UPDATE_OVERLAYS)

/datum/element/hat_wearer/proc/on_item_interact(atom/movable/source, mob/living/user, obj/item/tool)
	SIGNAL_HANDLER

	if(user.cmode)
		return NONE

	if(!istype(tool, /obj/item/clothing/head))
		return NONE

	if(istype(source, /mob/living/simple_animal))
		var/mob/living/simple_animal/mob = source
		if(!mob.has_ally(user))
			return NONE

	INVOKE_ASYNC(src, PROC_REF(place_hat), source, user, tool)

	return ITEM_INTERACT_SUCCESS

/datum/element/hat_wearer/proc/place_hat(atom/movable/source, mob/living/user, obj/item/tool)
	if(!do_after(user, delay = 3 SECONDS, target = source))
		source.balloon_alert(user, "must stay still!")
		return

	tool.forceMove(source)
