//update_icon() may change the onmob icons
//Very good name, I know
/datum/element/update_icon_updates_onmob
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	///The ITEM_SLOT_X flags to update on the parent mob. (Ex: ITEM_SLOT_HANDS|ITEM_SLOT_FEET)
	var/update_flags = NONE

/datum/element/update_icon_updates_onmob/Attach(datum/target, flags, body = FALSE)
	. = ..()
	if(!istype(target, /obj/item))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_ATOM_UPDATED_ICON, PROC_REF(update_onmob))
	update_flags = flags

/datum/element/update_icon_updates_onmob/proc/update_onmob(obj/item/target)
	SIGNAL_HANDLER

	if(ismob(target.loc))
		var/mob/M = target.loc
		if(M.is_holding(target))
			M.update_inv_hands()
		else
			M.update_clothing((target.slot_flags | update_flags))

