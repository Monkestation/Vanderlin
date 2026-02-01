///The alpha mask used on mobs submerged in liquid turfs or standing on high ground
#define MOB_MOVING_EFFECT_MASK "mob_moving_effect_mask"

///mob_overlay_effect component. adds and removes
/datum/element/mob_overlay_effect
	element_flags = ELEMENT_BESPOKE | ELEMENT_DETACH
	id_arg_index = 2

	var/y_offset = 0
	var/mask_y_offset = 0
	var/effect_alpha = 0

/datum/element/mob_overlay_effect/Attach(datum/target, _y_offset = 0, _mask_y_offset = 0, _effect_alpha = 0)
	. = ..()
	if(!ismovable(target))
		return ELEMENT_INCOMPATIBLE
	y_offset = _y_offset
	mask_y_offset = _mask_y_offset
	effect_alpha = _effect_alpha

	RegisterSignal(get_turf(target), COMSIG_TURF_EXITED, PROC_REF(on_remove), override = TRUE)
	RegisterSignal(get_turf(target), COMSIG_TURF_ENTERED, PROC_REF(on_add), override = TRUE)
	RegisterSignal(target, COMSIG_MOB_OVERLAY_FORCE_REMOVE, PROC_REF(on_remove), override = TRUE)
	RegisterSignal(target, COMSIG_MOB_OVERLAY_FORCE_UPDATE, PROC_REF(on_add), override = TRUE)
	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(remove_all), override = TRUE)

/datum/element/mob_overlay_effect/Detach(datum/source)
	. = ..()
	UnregisterSignal(get_turf(source), list(
		COMSIG_TURF_EXITED,
		COMSIG_TURF_ENTERED,
		COMSIG_MOB_OVERLAY_FORCE_REMOVE,
		COMSIG_MOB_OVERLAY_FORCE_UPDATE,
		COMSIG_PARENT_QDELETING,
	))

/datum/element/mob_overlay_effect/proc/on_remove(datum/source, atom/movable/target)
	SIGNAL_HANDLER

	if(istype(target, /mob/living/simple_animal/hostile/retaliate/astral_projection))
		return
	target.remove_filter(MOB_MOVING_EFFECT_MASK)
	UnregisterSignal(target, COMSIG_ITEM_PICKUP)

/datum/element/mob_overlay_effect/proc/remove_all(datum/source)
	SIGNAL_HANDLER

	for(var/atom/movable/AM in get_turf(source))
		on_remove(src, AM)

/datum/element/mob_overlay_effect/proc/on_add(datum/source, atom/movable/target)
	SIGNAL_HANDLER

	if(istype(target, /mob/living/simple_animal/hostile/retaliate/astral_projection))
		return
	for(var/obj/structure/S in get_turf(target))
		if(S.obj_flags & BLOCK_Z_OUT_DOWN)
			return

	if(isitem(target))
		return ///this is ALOT of filters

	if(isobj(target))
		var/obj/obj = target
		if(obj.obj_flags & IGNORE_SINK)
			return

	if(istype(target, /obj/structure/hotspring))
		return

	if(istype(target, /mob/living/simple_animal/hostile/retaliate/gator))
		return

	var/offset = 0
	if(istype(target, /obj/structure/flora/tree))
		offset -= 24
	if(isitem(target))
		offset += 7
	if(effect_alpha)
		target.add_filter(MOB_MOVING_EFFECT_MASK, 1, alpha_mask_filter(0, mask_y_offset + offset, icon('icons/effects/icon_cutter.dmi', "icon_cutter"), null, MASK_INVERSE))
	RegisterSignal(target, COMSIG_ITEM_PICKUP, PROC_REF(on_remove_proxy), override = TRUE)

/datum/element/mob_overlay_effect/proc/on_remove_proxy(atom/source)
	SIGNAL_HANDLER

	on_remove(src, source)

#undef MOB_MOVING_EFFECT_MASK
